///|
/// Vite command with TUI dashboard using ink

///|
/// Menu item for cursor selection
enum MenuItem {
  Build
  Vite
  Test
}

///|
/// Status of a command execution
enum CommandStatus {
  Ready // Initial state for Test
  Idle
  Running(Int) // start timestamp in ms
  Success
  Failed(String) // error message
}

///|
/// Parse vite command args
fn parse_vite_args(args : Array[String]) -> Bool {
  for i = 0; i < args.length(); i = i + 1 {
    if args[i] == "--tui" {
      return true
    }
  }
  false
}

///|
/// Vite command - runs moon build && npx vite build, or --tui for TUI mode
async fn cmd_vite(args : Array[String]) -> Unit {
  let is_tui = parse_vite_args(args)
  if is_tui {
    cmd_vite_tui()
  } else {
    // Default: moon build && npx vite build
    println(@chalk.cyan("Building MoonBit..."))
    let build_result = @moon_api.build(target=@moon_api.JS)
    if not(build_result.success) {
      println(@chalk.red("MoonBit build failed"))
      @process.exit(1)
    }
    println(@chalk.green("MoonBit build succeeded"))
    println("")
    println(@chalk.cyan("Running vite build..."))
    let vite_result = ffi_exec_sync("npx vite build")
    @process.exit(vite_result.exit_code)
  }
}

///|
extern "js" fn ffi_exec_sync(cmd : String) -> @moon_api.CommandResult =
  #|(cmd) => {
  #|  const { spawnSync } = require('node:child_process');
  #|  const result = spawnSync(cmd, { shell: true, stdio: 'inherit' });
  #|  return {
  #|    exit_code: result.status || 0,
  #|    stdout: '',
  #|    stderr: '',
  #|    success: result.status === 0
  #|  };
  #|}

///|
/// TUI mode for vite command
async fn cmd_vite_tui() -> Unit {
  // Import ink dynamically
  let ink = @ink.dynamic_import()
  let ink_ui = @ink_ui.dynamic_import()
  // Get terminal dimensions
  let term_width = ffi_get_terminal_width()
  let term_height = ffi_get_terminal_height()
  let content_width = if term_width > 20 { term_width - 4 } else { 76 }
  let left_width = 30
  let right_width = if content_width > left_width + 10 {
    content_width - left_width - 3
  } else {
    40
  }
  let log_height = if term_height > 15 { term_height - 10 } else { 10 }
  // State
  let build_status : Ref[CommandStatus] = { val: Idle }
  let vite_status : Ref[CommandStatus] = { val: Idle }
  let test_status : Ref[CommandStatus] = { val: Ready } // Test starts as Ready
  let build_output : Ref[String] = { val: "" }
  let vite_output : Ref[String] = { val: "" }
  let test_output : Ref[String] = { val: "" }
  let mut build_process : @child_process.ChildProcess? = None
  let mut vite_process : @child_process.ChildProcess? = None
  // Test timing
  let last_test_duration : Ref[Int] = { val: 0 } // ms
  let test_start_time : Ref[Int] = { val: 0 }
  let current_time : Ref[Int] = { val: ffi_now() }
  // Current selected menu item (for log display)
  let current_item : Ref[MenuItem] = { val: Build }
  // Log scroll offset (0 = show latest, positive = scroll up)
  let log_scroll_offset : Ref[Int] = { val: 0 }
  // Forward declarations for run functions
  let run_test_ref : Ref[() -> Unit] = { val: fn() { () } }
  // Helper: get status badge
  fn get_badge(
    status : CommandStatus,
    last_duration : Int,
    start_time : Int,
  ) -> @react.Element {
    match status {
      Ready => ink_ui.badge(["READY"], color=@ink_ui.Cyan)
      Idle => ink_ui.badge(["IDLE"], color=@ink_ui.Gray)
      Running(ts) =>
        if last_duration > 0 && start_time > 0 {
          let elapsed = current_time.val - start_time
          let progress = if last_duration > 0 {
            elapsed * 100 / last_duration
          } else {
            0
          }
          let clamped = if progress > 100 { 100 } else { progress }
          ink_ui.progress_bar(clamped)
        } else {
          ignore(ts)
          ink_ui.spinner(label="...")
        }
      Success => ink_ui.badge(["OK"], color=@ink_ui.Green)
      Failed(_msg) => ink_ui.badge(["FAIL"], color=@ink_ui.Red)
    }
  }
  // Render function
  fn render_app() -> @react.Element {
    // Left panel: status indicators with cursor
    let build_badge = get_badge(build_status.val, 0, 0)
    let vite_badge = get_badge(vite_status.val, 0, 0)
    let test_badge = get_badge(
      test_status.val,
      last_test_duration.val,
      test_start_time.val,
    )
    let test_time_str = if last_test_duration.val > 0 {
      " " + (last_test_duration.val / 1000).to_string() + "s"
    } else {
      ""
    }
    // Cursor indicator
    let build_cursor = match current_item.val {
      Build => @chalk.cyan("> ")
      _ => "  "
    }
    let vite_cursor = match current_item.val {
      Vite => @chalk.cyan("> ")
      _ => "  "
    }
    let test_cursor = match current_item.val {
      Test => @chalk.cyan("> ")
      _ => "  "
    }
    // Left panel
    let left_panel = ink.box_(
      [
        ink.text([@chalk.bold("Tasks")]),
        ink.box_(
          [
            // Build row
            ink.box_([ink.text([build_cursor + "Build "]), build_badge]),
            // Vite row
            ink.box_([ink.text([vite_cursor + "Vite  "]), vite_badge]),
            // Test row
            ink.box_([
              ink.text([test_cursor + "Test  "]),
              test_badge,
              ink.text([test_time_str], dim_color=true),
            ]),
          ],
          flex_direction=@ink.Column,
          margin_top=1,
        ),
      ],
      flex_direction=@ink.Column,
      width=left_width,
      border_style=@ink.Single,
      padding=1,
    )
    // Right panel: show log of selected item only
    let selected_output = match current_item.val {
      Build => build_output.val
      Vite => vite_output.val
      Test => test_output.val
    }
    let selected_name = match current_item.val {
      Build => "Build"
      Vite => "Vite"
      Test => "Test"
    }
    let scroll_indicator = if log_scroll_offset.val > 0 {
      " [scroll: " + log_scroll_offset.val.to_string() + "]"
    } else {
      ""
    }
    let right_panel = ink.box_(
      [
        ink.box_([
          ink.text([@chalk.bold(selected_name + " Output")]),
          ink.text([scroll_indicator], dim_color=true),
        ]),
        ink.box_(
          [
            ink.text([
              truncate_multiline_with_offset(
                selected_output,
                log_height,
                right_width - 4,
                log_scroll_offset.val,
              ),
            ]),
          ],
          margin_top=1,
        ),
      ],
      flex_direction=@ink.Column,
      width=right_width,
      height=log_height + 4,
      border_style=@ink.Single,
      padding=1,
    )
    // Main layout: header + horizontal split
    let header = ink.box_(
      [
        ink.text([@chalk.bold(@chalk.cyan("moonjs vite --tui"))]),
        ink.text([" | "], dim_color=true),
        ink.text([@chalk.bold("t")], dim_color=true),
        ink.text(["=test "], dim_color=true),
        ink.text([@chalk.bold("j/k")], dim_color=true),
        ink.text(["=select "], dim_color=true),
        ink.text([@chalk.bold("g/G")], dim_color=true),
        ink.text(["=scroll "], dim_color=true),
        ink.text([@chalk.bold("q")], dim_color=true),
        ink.text(["=quit"], dim_color=true),
      ],
      border_style=@ink.Single,
      padding_x=1,
    )
    let content = ink.box_(
      [left_panel, ink.text([" "]), right_panel],
      margin_top=1,
    )
    ink.box_([header, content], flex_direction=@ink.Column, padding=1)
  }
  // Render the app
  let instance = ink.render(render_app())
  // Helper to update UI
  fn update_ui() {
    current_time.val = ffi_now()
    instance.rerender(render_app())
  }
  // Timer for progress updates during test
  let timer_id : Ref[Int] = { val: 0 }
  fn start_progress_timer() {
    timer_id.val = ffi_set_interval(fn() { update_ui() }, 100)
  }

  fn stop_progress_timer() {
    if timer_id.val != 0 {
      ffi_clear_interval(timer_id.val)
      timer_id.val = 0
    }
  }
  // Run build command (moon build --watch)
  fn run_build() {
    // Kill existing process if running
    match build_process {
      Some(proc) => {
        proc.kill() |> ignore
        build_process = None
      }
      None => ()
    }
    build_status.val = Running(ffi_now())
    build_output.val = ""
    update_ui()
    let proc = @child_process.spawn("moon", args=[
      "build", "--watch", "--target", "js",
    ])
    build_process = Some(proc)
    proc.on_stdout_data(fn(data) {
      let text = ffi_to_string(data)
      // Check for clear screen sequences - reset log on rebuild
      if ffi_has_clear_screen(text) {
        build_output.val = ""
        build_status.val = Running(ffi_now())
      } else {
        build_output.val = build_output.val + text // Keep ANSI colors
      }
      // Check for success indicator
      if text.contains("Success, waiting") {
        build_status.val = Success
      }
      // Check for error count pattern "X errors)"
      if text.contains("errors)") || text.contains("error)") {
        build_status.val = Failed("Build error")
      }
      update_ui()
    })
    proc.on_stderr_data(fn(data) {
      let text = ffi_to_string(data)
      // Check for clear screen sequences
      if ffi_has_clear_screen(text) {
        build_output.val = ""
        build_status.val = Running(ffi_now())
      } else {
        build_output.val = build_output.val + text // Keep ANSI colors
      }
      // Check for error pattern
      if text.contains("errors)") || text.contains("error)") {
        build_status.val = Failed("Build error")
      }
      update_ui()
    })
    proc.on_close(fn(code, _signal) {
      match code {
        Some(0) => build_status.val = Success
        _ => build_status.val = Failed("exit code: " + code.to_string())
      }
      build_process = None
      update_ui()
    })
  }

  // Run test command
  fn run_test() {
    let start = ffi_now()
    test_start_time.val = start
    test_status.val = Running(start)
    test_output.val = ""
    update_ui()
    start_progress_timer()
    let result = @moon_api.run_test(target=@moon_api.JS, stdio=@moon_api.Pipe)
    stop_progress_timer()
    let elapsed = ffi_now() - start
    last_test_duration.val = elapsed
    if result.success {
      test_status.val = Success
      test_output.val = result.stdout + "\nTests passed."
    } else {
      test_status.val = Failed(result.stderr)
      test_output.val = result.stderr
    }
    update_ui()
  }

  run_test_ref.val = run_test
  // Run vite command (npx vite dev)
  fn run_vite() {
    // Kill existing process if running
    match vite_process {
      Some(proc) => {
        proc.kill() |> ignore
        vite_process = None
      }
      None => ()
    }
    vite_status.val = Running(ffi_now())
    vite_output.val = ""
    update_ui()
    let proc = @child_process.spawn("npx", args=["vite", "dev"], shell=true)
    vite_process = Some(proc)
    proc.on_stdout_data(fn(data) {
      let text = ffi_to_string(data)
      // Check for clear screen sequences - reset log on rebuild
      if ffi_has_clear_screen(text) {
        vite_output.val = ""
        vite_status.val = Running(ffi_now())
      } else {
        vite_output.val = vite_output.val + text // Keep ANSI colors
      }
      // Check for vite success indicator
      if text.contains("built in") || text.contains("ready in") {
        vite_status.val = Success
      }
      update_ui()
    })
    proc.on_stderr_data(fn(data) {
      let text = ffi_to_string(data)
      // Check for clear screen sequences
      if ffi_has_clear_screen(text) {
        vite_output.val = ""
        vite_status.val = Running(ffi_now())
      } else {
        vite_output.val = vite_output.val + text // Keep ANSI colors
      }
      // Check for vite success indicator - vite outputs to stderr
      if text.contains("built in") || text.contains("ready in") {
        vite_status.val = Success
      }
      update_ui()
    })
    proc.on_close(fn(code, _signal) {
      match code {
        Some(0) => vite_status.val = Success
        _ => vite_status.val = Failed("exit code: " + code.to_string())
      }
      vite_process = None
      update_ui()
    })
  }

  // Helper: cleanup and exit
  fn cleanup_and_exit() {
    stop_progress_timer()
    // Kill build process
    match build_process {
      Some(proc) => {
        println(@chalk.yellow("Stopping build process..."))
        proc.kill() |> ignore
      }
      None => ()
    }
    // Kill vite process
    match vite_process {
      Some(proc) => {
        println(@chalk.yellow("Stopping vite process..."))
        proc.kill() |> ignore
      }
      None => ()
    }
    println(@chalk.green("Cleanup complete."))
    instance.unmount()
    @process.exit(0)
  }

  // Helper: move cursor down
  fn move_cursor_down() {
    current_item.val = match current_item.val {
      Build => Vite
      Vite => Test
      Test => Test // stay at bottom
    }
    log_scroll_offset.val = 0 // reset scroll on item change
    update_ui()
  }

  // Helper: move cursor up
  fn move_cursor_up() {
    current_item.val = match current_item.val {
      Build => Build // stay at top
      Vite => Build
      Test => Vite
    }
    log_scroll_offset.val = 0 // reset scroll on item change
    update_ui()
  }

  // Setup keyboard input
  setup_keyboard_input_extended(fn(key, key_name) {
    match key {
      "t" => run_test() // Only test can be manually triggered
      "q" => cleanup_and_exit()
      "j" => move_cursor_down() // Move cursor down (vim style)
      "k" => move_cursor_up() // Move cursor up (vim style)
      "g" => {
        // Scroll log to bottom (show latest)
        log_scroll_offset.val = 0
        update_ui()
      }
      "G" => {
        // Scroll log up (show older) with bound check
        let selected_output = match current_item.val {
          Build => build_output.val
          Vite => vite_output.val
          Test => test_output.val
        }
        let total_lines = count_lines(selected_output)
        let max_scroll = if total_lines > log_height {
          total_lines - log_height
        } else {
          0
        }
        let new_offset = log_scroll_offset.val + 5
        log_scroll_offset.val = if new_offset > max_scroll {
          max_scroll
        } else {
          new_offset
        }
        update_ui()
      }
      _ =>
        match key_name {
          "up" => move_cursor_up()
          "down" => move_cursor_down()
          _ => ()
        }
    }
  })
  // Initial: start build and vite automatically
  run_build()
  run_vite()
  // Wait forever (until quit)
  instance.waitUntilExit()
}

///|
fn truncate_str(s : String, max_len : Int) -> String {
  if max_len <= 3 {
    return s
  }
  if s.length() > max_len {
    ffi_substring_range(s, 0, max_len - 3) + "..."
  } else {
    s
  }
}

///|
fn truncate_multiline_with_offset(
  s : String,
  max_lines : Int,
  max_width : Int,
  scroll_offset : Int,
) -> String {
  let lines = ffi_split_lines(s)
  let result : Array[String] = []
  // Calculate visible range with scroll offset
  // scroll_offset=0 shows the latest (bottom), positive values scroll up
  // Clamp scroll_offset to valid range
  let max_scroll = if lines.length() > max_lines {
    lines.length() - max_lines
  } else {
    0
  }
  let clamped_offset = if scroll_offset > max_scroll {
    max_scroll
  } else {
    scroll_offset
  }
  let end_idx = if lines.length() > clamped_offset {
    lines.length() - clamped_offset
  } else {
    0
  }
  let start_idx = if end_idx > max_lines { end_idx - max_lines } else { 0 }
  for i = start_idx; i < end_idx; i = i + 1 {
    result.push(truncate_str(lines[i], max_width))
  }
  if result.length() == 0 {
    "(no output)"
  } else {
    result.join("\n")
  }
}

///|
/// Get number of lines in a string
fn count_lines(s : String) -> Int {
  ffi_split_lines(s).length()
}

///|
extern "js" fn ffi_to_string(data : @js.Any) -> String =
  #|(data) => typeof data === 'string' ? data : data.toString()

///|
/// Check if text contains ANSI clear screen or cursor home sequences
extern "js" fn ffi_has_clear_screen(text : String) -> Bool =
  #|(text) => {
  #|  // Clear screen: \x1b[2J, cursor home: \x1b[H, or combination
  #|  return /\x1b\[2J|\x1b\[H|\x1b\[\?25[lh]/.test(text);
  #|}

///|
extern "js" fn ffi_split_lines(s : String) -> Array[String] =
  #|(s) => s.split('\n').filter(line => line.trim().length > 0)

///|
extern "js" fn ffi_substring_range(
  s : String,
  start : Int,
  end : Int,
) -> String =
  #|(s, start, end) => s.slice(start, end)

///|
extern "js" fn ffi_get_terminal_width() -> Int =
  #|() => process.stdout.columns || 80

///|
extern "js" fn ffi_get_terminal_height() -> Int =
  #|() => process.stdout.rows || 24

///|
extern "js" fn ffi_now() -> Int =
  #|() => Date.now()

///|
extern "js" fn ffi_set_interval(f : () -> Unit, ms : Int) -> Int =
  #|(f, ms) => setInterval(f, ms)

///|
extern "js" fn ffi_clear_interval(id : Int) -> Unit =
  #|(id) => clearInterval(id)

///|
fn setup_keyboard_input_extended(handler : (String, String) -> Unit) -> Unit {
  ffi_setup_keyboard_extended(handler)
}

///|
extern "js" fn ffi_setup_keyboard_extended(
  handler : (String, String) -> Unit,
) -> Unit =
  #|(handler) => {
  #|  const readline = require('readline');
  #|  readline.emitKeypressEvents(process.stdin);
  #|  if (process.stdin.isTTY) {
  #|    process.stdin.setRawMode(true);
  #|  }
  #|  process.stdin.on('keypress', (str, key) => {
  #|    if (key && key.ctrl && key.name === 'c') {
  #|      handler('q', 'q');
  #|    } else {
  #|      handler(str || '', key?.name || '');
  #|    }
  #|  });
  #|}
