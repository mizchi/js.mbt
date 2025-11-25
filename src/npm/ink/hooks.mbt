///| Ink Hooks
/// React hooks for Ink CLI applications

// ============================================================
// useApp Hook
// ============================================================

///|
/// App context returned by useApp hook
pub(all) struct UseAppResult {
  exit_fn : @js.Any
}

///|
/// Exit the app with optional error
pub fn UseAppResult::exit(self : UseAppResult, error? : @js.Any) -> Unit {
  match error {
    Some(e) => self.exit_fn.call_self([e]) |> ignore
    None => self.exit_fn.call_self([]) |> ignore
  }
}

///|
/// useApp hook - provides exit functionality
pub fn Ink::useApp(self : Ink) -> UseAppResult {
  let use_app = self.to_any().get("useApp")
  let result = use_app.call_self([])
  let exit_fn = result.get("exit")
  { exit_fn, }
}

// ============================================================
// useInput Hook
// ============================================================

///|
/// Key information for input handler
pub(all) struct KeyInfo {
  /// Up arrow key
  up_arrow : Bool
  /// Down arrow key
  down_arrow : Bool
  /// Left arrow key
  left_arrow : Bool
  /// Right arrow key
  right_arrow : Bool
  /// Page down key
  page_down : Bool
  /// Page up key
  page_up : Bool
  /// Return/Enter key
  return_ : Bool
  /// Escape key
  escape : Bool
  /// Ctrl key modifier
  ctrl : Bool
  /// Shift key modifier
  shift : Bool
  /// Tab key
  tab : Bool
  /// Backspace key
  backspace : Bool
  /// Delete key
  delete : Bool
  /// Meta key modifier (Cmd on Mac)
  meta : Bool
}

///|
fn KeyInfo::from_any(raw : @js.Any) -> KeyInfo {
  {
    up_arrow: raw.get("upArrow") |> @js.identity,
    down_arrow: raw.get("downArrow") |> @js.identity,
    left_arrow: raw.get("leftArrow") |> @js.identity,
    right_arrow: raw.get("rightArrow") |> @js.identity,
    page_down: raw.get("pageDown") |> @js.identity,
    page_up: raw.get("pageUp") |> @js.identity,
    return_: raw.get("return") |> @js.identity,
    escape: raw.get("escape") |> @js.identity,
    ctrl: raw.get("ctrl") |> @js.identity,
    shift: raw.get("shift") |> @js.identity,
    tab: raw.get("tab") |> @js.identity,
    backspace: raw.get("backspace") |> @js.identity,
    delete: raw.get("delete") |> @js.identity,
    meta: raw.get("meta") |> @js.identity,
  }
}

///|
/// Input handler options
pub(all) struct UseInputOptions {
  /// Whether to listen for input (default: true)
  is_active : Bool?
}

///|
/// useInput hook - captures keyboard input
/// Handler receives input character and key information
pub fn Ink::useInput(
  self : Ink,
  handler : (String, KeyInfo) -> Unit,
  options? : UseInputOptions,
) -> Unit {
  let use_input = self.to_any().get("useInput")
  let wrapped_handler = ffi_wrap_input_handler(fn(
    input : @js.Any,
    key : @js.Any,
  ) {
    let input_str : String = @js.identity(input)
    let key_info = KeyInfo::from_any(key)
    handler(input_str, key_info)
  })
  match options {
    Some(opts) => {
      let opts_obj = @js.Object::new()
      if opts.is_active is Some(active) {
        opts_obj.set("isActive", active)
      }
      use_input.call_self([wrapped_handler, opts_obj.to_any()]) |> ignore
    }
    None => use_input.call_self([wrapped_handler]) |> ignore
  }
}

///|
extern "js" fn ffi_wrap_input_handler(
  f : (@js.Any, @js.Any) -> Unit,
) -> @js.Any =
  #|(f) => f

// ============================================================
// useFocus Hook
// ============================================================

///|
/// Focus result returned by useFocus hook
pub(all) struct UseFocusResult {
  /// Whether the component is focused
  is_focused : Bool
}

///|
/// Focus options
pub(all) struct UseFocusOptions {
  /// Auto focus on mount
  auto_focus : Bool?
  /// Whether to participate in focus navigation
  is_active : Bool?
  /// Focus ID for programmatic focus
  id : String?
}

///|
/// useFocus hook - manages focus state for interactive components
pub fn Ink::useFocus(self : Ink, options? : UseFocusOptions) -> UseFocusResult {
  let use_focus = self.to_any().get("useFocus")
  let result = match options {
    Some(opts) => {
      let opts_obj = @js.Object::new()
      if opts.auto_focus is Some(af) {
        opts_obj.set("autoFocus", af)
      }
      if opts.is_active is Some(active) {
        opts_obj.set("isActive", active)
      }
      if opts.id is Some(id) {
        opts_obj.set("id", id)
      }
      use_focus.call_self([opts_obj.to_any()])
    }
    None => use_focus.call_self([])
  }
  { is_focused: result.get("isFocused") |> @js.identity }
}

// ============================================================
// useFocusManager Hook
// ============================================================

///|
/// Focus manager for programmatic focus control
pub(all) struct UseFocusManagerResult {
  raw : @js.Any
}

///|
/// Enable focus for the focused component
pub fn UseFocusManagerResult::enableFocus(self : UseFocusManagerResult) -> Unit {
  self.raw.get("enableFocus").call_self([]) |> ignore
}

///|
/// Disable focus for all components
pub fn UseFocusManagerResult::disableFocus(
  self : UseFocusManagerResult,
) -> Unit {
  self.raw.get("disableFocus").call_self([]) |> ignore
}

///|
/// Focus next focusable component
pub fn UseFocusManagerResult::focusNext(self : UseFocusManagerResult) -> Unit {
  self.raw.get("focusNext").call_self([]) |> ignore
}

///|
/// Focus previous focusable component
pub fn UseFocusManagerResult::focusPrevious(
  self : UseFocusManagerResult,
) -> Unit {
  self.raw.get("focusPrevious").call_self([]) |> ignore
}

///|
/// Focus a specific component by ID
pub fn UseFocusManagerResult::focus(
  self : UseFocusManagerResult,
  id : String,
) -> Unit {
  self.raw.get("focus").call_self([id |> @js.any]) |> ignore
}

///|
/// useFocusManager hook - programmatically manage focus
pub fn Ink::useFocusManager(self : Ink) -> UseFocusManagerResult {
  let use_focus_manager = self.to_any().get("useFocusManager")
  let result = use_focus_manager.call_self([])
  { raw: result }
}

// ============================================================
// useStdin Hook
// ============================================================

///|
/// Stdin result returned by useStdin hook
pub(all) struct UseStdinResult {
  /// Standard input stream
  stdin : @js.Any
  /// Whether stdin is in raw mode
  is_raw_mode_supported : Bool
  /// Set raw mode
  set_raw_mode_fn : @js.Any
}

///|
/// Set raw mode on stdin
pub fn UseStdinResult::setRawMode(self : UseStdinResult, value : Bool) -> Unit {
  self.set_raw_mode_fn.call_self([value |> @js.any]) |> ignore
}

///|
/// useStdin hook - access stdin stream
pub fn Ink::useStdin(self : Ink) -> UseStdinResult {
  let use_stdin = self.to_any().get("useStdin")
  let result = use_stdin.call_self([])
  {
    stdin: result.get("stdin"),
    is_raw_mode_supported: result.get("isRawModeSupported") |> @js.identity,
    set_raw_mode_fn: result.get("setRawMode"),
  }
}

// ============================================================
// useStdout Hook
// ============================================================

///|
/// Stdout result returned by useStdout hook
pub(all) struct UseStdoutResult {
  /// Standard output stream
  stdout : @js.Any
  /// Write to stdout
  write_fn : @js.Any
}

///|
/// Write to stdout
pub fn UseStdoutResult::write(self : UseStdoutResult, data : String) -> Unit {
  self.write_fn.call_self([data |> @js.any]) |> ignore
}

///|
/// useStdout hook - access stdout stream
pub fn Ink::useStdout(self : Ink) -> UseStdoutResult {
  let use_stdout = self.to_any().get("useStdout")
  let result = use_stdout.call_self([])
  { stdout: result.get("stdout"), write_fn: result.get("write") }
}

// ============================================================
// useStderr Hook
// ============================================================

///|
/// Stderr result returned by useStderr hook
pub(all) struct UseStderrResult {
  /// Standard error stream
  stderr : @js.Any
  /// Write to stderr
  write_fn : @js.Any
}

///|
/// Write to stderr
pub fn UseStderrResult::write(self : UseStderrResult, data : String) -> Unit {
  self.write_fn.call_self([data |> @js.any]) |> ignore
}

///|
/// useStderr hook - access stderr stream
pub fn Ink::useStderr(self : Ink) -> UseStderrResult {
  let use_stderr = self.to_any().get("useStderr")
  let result = use_stderr.call_self([])
  { stderr: result.get("stderr"), write_fn: result.get("write") }
}
