///|
/// Moon CLI wrapper for MoonBit toolchain commands
/// Provides type-safe API for moon fmt, build, info, check, test, run, etc.

///|
/// Result of a CLI command execution
pub struct CommandResult {
  /// Exit code (0 = success)
  exit_code : Int
  /// Standard output
  stdout : String
  /// Standard error
  stderr : String
  /// Whether the command succeeded
  success : Bool
}

///|
/// Target platform for compilation
pub(all) enum Target {
  JS
  Wasm
  WasmGC
  Native
  All
}

///|
pub impl Show for Target with output(self, logger) {
  match self {
    JS => logger.write_string("js")
    Wasm => logger.write_string("wasm")
    WasmGC => logger.write_string("wasm-gc")
    Native => logger.write_string("native")
    All => logger.write_string("all")
  }
}

///|
fn target_to_string(target : Target) -> String {
  match target {
    JS => "js"
    Wasm => "wasm"
    WasmGC => "wasm-gc"
    Native => "native"
    All => "all"
  }
}

///|
/// Build mode
pub(all) enum BuildMode {
  Debug
  Release
}

///|
pub impl Show for BuildMode with output(self, logger) {
  match self {
    Debug => logger.write_string("debug")
    Release => logger.write_string("release")
  }
}

///|
fn build_mode_to_string(mode : BuildMode) -> String {
  match mode {
    Debug => "debug"
    Release => "release"
  }
}

///|
/// JavaScript runtime runner
pub(all) enum Runner {
  Node
  Deno
  Bun
}

///|
pub impl Show for Runner with output(self, logger) {
  match self {
    Node => logger.write_string("node")
    Deno => logger.write_string("deno")
    Bun => logger.write_string("bun")
  }
}

///|
fn runner_to_command(runner : Runner) -> String {
  match runner {
    Node => "node"
    Deno => "deno run -A"
    Bun => "bun"
  }
}

///|
/// Standard I/O handling mode
pub(all) enum Stdio {
  /// Inherit parent process stdio (real-time output)
  Inherit
  /// Capture stdout/stderr in CommandResult
  Pipe
}

///|
pub impl Show for Stdio with output(self, logger) {
  match self {
    Inherit => logger.write_string("inherit")
    Pipe => logger.write_string("pipe")
  }
}

///|
/// Execute a moon command and return the result
fn exec_moon_command(
  args : Array[String],
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  match stdio {
    Inherit => {
      let result = ffi_spawn_sync_inherit("moon", args, cwd)
      let exit_code : Int = result._get("status").cast()
      { exit_code, stdout: "", stderr: "", success: exit_code == 0 }
    }
    Pipe => {
      let command = "moon " + args.join(" ")
      let result = ffi_exec_sync_with_result(command, cwd)
      let exit_code : Int = result._get("exitCode").cast()
      {
        exit_code,
        stdout: result._get("stdout").cast(),
        stderr: result._get("stderr").cast(),
        success: exit_code == 0,
      }
    }
  }
}

///|
extern "js" fn ffi_spawn_sync_inherit(
  command : String,
  args : Array[String],
  cwd : String?,
) -> @core.Any =
  #|(command, args, cwd) => {
  #|  const { spawnSync } = require('node:child_process');
  #|  const result = spawnSync(command, args, {
  #|    cwd: cwd || process.cwd(),
  #|    stdio: 'inherit'
  #|  });
  #|  return { status: result.status || 0 };
  #|}

///|
extern "js" fn ffi_exec_sync_with_result(
  command : String,
  cwd : String?,
) -> @core.Any =
  #|(command, cwd) => {
  #|  const { execSync } = require('node:child_process');
  #|  try {
  #|    const stdout = execSync(command, {
  #|      encoding: 'utf8',
  #|      cwd: cwd || process.cwd(),
  #|      stdio: ['pipe', 'pipe', 'pipe']
  #|    });
  #|    return { exitCode: 0, stdout: stdout || '', stderr: '' };
  #|  } catch (e) {
  #|    return {
  #|      exitCode: e.status || 1,
  #|      stdout: e.stdout ? e.stdout.toString() : '',
  #|      stderr: e.stderr ? e.stderr.toString() : ''
  #|    };
  #|  }
  #|}

///|
/// moon fmt - Format MoonBit source files
/// If files is provided, only those files will be formatted
pub fn fmt(
  check? : Bool,
  files? : Array[String],
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["fmt"]
  if check == Some(true) {
    args.push("--check")
  }
  match files {
    Some(f) =>
      for file in f {
        args.push(file)
      }
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon build - Build the project
pub fn build(
  target? : Target,
  mode? : BuildMode,
  output_wat? : Bool,
  debug? : Bool,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["build"]
  match target {
    Some(t) => args.push("--target=" + target_to_string(t))
    None => ()
  }
  match mode {
    Some(m) => args.push("--" + build_mode_to_string(m))
    None => ()
  }
  if output_wat == Some(true) {
    args.push("--output-wat")
  }
  if debug == Some(true) {
    args.push("-g")
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon check - Type check the project
pub fn check(
  target? : Target,
  package_path? : String,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["check"]
  match target {
    Some(t) => args.push("--target=" + target_to_string(t))
    None => ()
  }
  match package_path {
    Some(pkg) => args.push("-p=" + pkg)
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon info - Update package interface files
pub fn info(
  target? : Target,
  pkg? : String,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["info"]
  match target {
    Some(t) => args.push("--target=" + target_to_string(t))
    None => ()
  }
  match pkg {
    Some(p) => args.push("-p=" + p)
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon test - Run tests
pub fn run_test(
  target? : Target,
  mode? : BuildMode,
  pkg? : String,
  file? : String,
  index? : Int,
  update? : Bool,
  limit? : Int,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["test"]
  match target {
    Some(t) => args.push("--target=" + target_to_string(t))
    None => ()
  }
  match mode {
    Some(m) => args.push("--" + build_mode_to_string(m))
    None => ()
  }
  match pkg {
    Some(p) => args.push("-p=" + p)
    None => ()
  }
  match file {
    Some(f) => args.push("-f=" + f)
    None => ()
  }
  match index {
    Some(i) => args.push("-i=" + i.to_string())
    None => ()
  }
  if update == Some(true) {
    args.push("--update")
  }
  match limit {
    Some(n) => args.push("--limit=" + n.to_string())
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon run - Run a package
/// If runner is specified, builds with moon and runs with the specified JS runtime
pub fn run(
  pkg : String,
  target? : Target,
  mode? : BuildMode,
  debug? : Bool,
  runner? : Runner,
  args? : Array[String],
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  // If runner is specified, build and run with custom runner
  match runner {
    Some(r) =>
      run_with_runner(pkg, r, target?, mode?, debug?, args?, cwd?, stdio~)
    None => {
      // Default: use moon run
      let cmd_args : Array[String] = ["run", pkg]
      match target {
        Some(t) => cmd_args.push("--target=" + target_to_string(t))
        None => ()
      }
      match mode {
        Some(m) => cmd_args.push("--" + build_mode_to_string(m))
        None => ()
      }
      if debug == Some(true) {
        cmd_args.push("-g")
      }
      match args {
        Some(a) => {
          cmd_args.push("--")
          for arg in a {
            cmd_args.push(arg)
          }
        }
        None => ()
      }
      exec_moon_command(cmd_args, cwd?, stdio~)
    }
  }
}

///|
/// Run a package with a specific JS runtime (deno, bun, etc.)
fn run_with_runner(
  pkg : String,
  runner : Runner,
  target? : Target,
  mode? : BuildMode,
  debug? : Bool,
  args? : Array[String],
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  // First build with --build-only
  let cmd_args : Array[String] = ["run", pkg, "--build-only"]
  match target {
    Some(t) => cmd_args.push("--target=" + target_to_string(t))
    None => cmd_args.push("--target=js") // Default to JS for non-node runners
  }
  match mode {
    Some(m) => cmd_args.push("--" + build_mode_to_string(m))
    None => ()
  }
  if debug == Some(true) {
    cmd_args.push("-g")
  }
  let build_result = exec_moon_command(cmd_args, cwd?, stdio~)
  if not(build_result.success) {
    return build_result
  }
  // Find the built JS file
  let mode_str = match mode {
    Some(Release) => "release"
    _ => "debug"
  }
  // Package name like "src/examples/hono_app" -> "examples/hono_app"
  let pkg_path = if pkg.has_prefix("src/") {
    ffi_safe_substring(pkg, 4)
  } else {
    pkg
  }
  let js_file = "target/js/" +
    mode_str +
    "/build/" +
    pkg_path +
    "/" +
    get_basename(pkg_path) +
    ".js"
  // Run with the specified runner
  let runner_cmd = runner_to_command(runner)
  let run_cmd = runner_cmd + " " + js_file
  let full_cmd = match args {
    Some(a) => run_cmd + " " + a.join(" ")
    None => run_cmd
  }
  ffi_exec_command(full_cmd, cwd, stdio~)
}

///|
fn get_basename(path : String) -> String {
  ffi_get_basename(path)
}

///|
extern "js" fn ffi_get_basename(path : String) -> String =
  #|(path) => path.split('/').pop() || path

///|
extern "js" fn ffi_safe_substring(s : String, start : Int) -> String =
  #|(s, start) => s.slice(start)

///|
fn ffi_exec_command(
  command : String,
  cwd : String?,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  match stdio {
    Inherit => {
      let result = ffi_spawn_sync_shell(command, cwd)
      let exit_code : Int = result._get("status").cast()
      { exit_code, stdout: "", stderr: "", success: exit_code == 0 }
    }
    Pipe => {
      let result = ffi_exec_sync_with_result(command, cwd)
      let exit_code : Int = result._get("exitCode").cast()
      {
        exit_code,
        stdout: result._get("stdout").cast(),
        stderr: result._get("stderr").cast(),
        success: exit_code == 0,
      }
    }
  }
}

///|
extern "js" fn ffi_spawn_sync_shell(
  command : String,
  cwd : String?,
) -> @core.Any =
  #|(command, cwd) => {
  #|  const { spawnSync } = require('node:child_process');
  #|  const result = spawnSync(command, {
  #|    cwd: cwd || process.cwd(),
  #|    stdio: 'inherit',
  #|    shell: true
  #|  });
  #|  return { status: result.status || 0 };
  #|}

///|
/// moon clean - Clean build artifacts
pub fn clean(cwd? : String, stdio? : Stdio = Inherit) -> CommandResult {
  exec_moon_command(["clean"], cwd?, stdio~)
}

///|
/// moon coverage report - Generate coverage report
pub fn coverage_report(
  format? : String,
  output? : String,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["coverage", "report"]
  match format {
    Some(f) => args.push("--format=" + f)
    None => ()
  }
  match output {
    Some(o) => args.push("--output=" + o)
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon coverage analyze - Analyze coverage
pub fn coverage_analyze(
  pkg? : String,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["coverage", "analyze"]
  match pkg {
    Some(p) => args.push("-p=" + p)
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon doc - Generate documentation
pub fn doc(
  serve? : Bool,
  port? : Int,
  bind? : String,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["doc"]
  if serve == Some(true) {
    args.push("--serve")
  }
  match port {
    Some(p) => args.push("--port=" + p.to_string())
    None => ()
  }
  match bind {
    Some(b) => args.push("--bind=" + b)
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon bundle - Bundle the project
pub fn bundle(
  target? : Target,
  mode? : BuildMode,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let args : Array[String] = ["bundle"]
  match target {
    Some(t) => args.push("--target=" + target_to_string(t))
    None => ()
  }
  match mode {
    Some(m) => args.push("--" + build_mode_to_string(m))
    None => ()
  }
  exec_moon_command(args, cwd?, stdio~)
}

///|
/// moon upgrade - Upgrade moon toolchain
pub fn upgrade(cwd? : String, stdio? : Stdio = Inherit) -> CommandResult {
  exec_moon_command(["upgrade"], cwd?, stdio~)
}

///|
/// moon version - Get moon version
/// Always uses Pipe mode to capture output
pub fn version(all? : Bool, cwd? : String) -> CommandResult {
  let args : Array[String] = ["version"]
  if all == Some(true) {
    args.push("--all")
  }
  exec_moon_command(args, cwd?, stdio=Pipe)
}

///|
/// Get the moon version string
pub fn get_version() -> String {
  let result = version()
  if result.success {
    result.stdout.trim(chars=" \n\r\t").to_string()
  } else {
    ""
  }
}

///|
/// Check if moon is available
pub fn is_available() -> Bool {
  let result = version()
  result.success
}

///|
/// Run moon fmt && moon info (common workflow)
pub fn fmt_and_info(cwd? : String, stdio? : Stdio = Inherit) -> CommandResult {
  let fmt_result = fmt(cwd?, stdio~)
  if not(fmt_result.success) {
    return fmt_result
  }
  info(cwd?, stdio~)
}

///|
/// Run moon check && moon test (common workflow)
pub fn check_and_test(
  target? : Target,
  pkg? : String,
  cwd? : String,
  stdio? : Stdio = Inherit,
) -> CommandResult {
  let check_result = check(target?, cwd?, stdio~)
  if not(check_result.success) {
    return check_result
  }
  run_test(target?, pkg?, cwd?, stdio~)
}
