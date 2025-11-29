///|
/// execa bindings for MoonBit
/// https://github.com/sindresorhus/execa
///
/// Process execution for humans - a modern replacement for child_process.

///| Types

///|
/// Result from process execution
#external
pub type ExecaResult

///|
pub impl @js.JsImpl for ExecaResult

///|
/// Error from failed process execution
#external
pub type ExecaError

///|
pub impl @js.JsImpl for ExecaError

///|
/// Subprocess instance (for advanced control)
#external
pub type Subprocess

///|
pub impl @js.JsImpl for Subprocess

///| ExecaResult accessors

///|
/// Get stdout as string
pub fn ExecaResult::stdout(self : ExecaResult) -> String {
  self.get("stdout").cast()
}

///|
/// Get stderr as string
pub fn ExecaResult::stderr(self : ExecaResult) -> String {
  self.get("stderr").cast()
}

///|
/// Get exit code
pub fn ExecaResult::exitCode(self : ExecaResult) -> Int {
  self.get("exitCode").cast()
}

///|
/// Get the executed command
pub fn ExecaResult::command(self : ExecaResult) -> String {
  self.get("command").cast()
}

///|
/// Get escaped command (safe to copy/paste)
pub fn ExecaResult::escapedCommand(self : ExecaResult) -> String {
  self.get("escapedCommand").cast()
}

///|
/// Check if process failed
pub fn ExecaResult::failed(self : ExecaResult) -> Bool {
  self.get("failed").cast()
}

///|
/// Check if process timed out
pub fn ExecaResult::timedOut(self : ExecaResult) -> Bool {
  self.get("timedOut").cast()
}

///|
/// Check if process was killed
pub fn ExecaResult::killed(self : ExecaResult) -> Bool {
  self.get("killed").cast()
}

///|
/// Get signal name if killed by signal
pub fn ExecaResult::signal(self : ExecaResult) -> String? {
  @js.identity_option(self.get("signal"))
}

///|
/// Get signal description
pub fn ExecaResult::signalDescription(self : ExecaResult) -> String? {
  @js.identity_option(self.get("signalDescription"))
}

///|
/// Get combined stdout and stderr (if all option was true)
pub fn ExecaResult::all(self : ExecaResult) -> String? {
  @js.identity_option(self.get("all"))
}

///|
/// Get stdout as lines array (if lines option was true)
pub fn ExecaResult::stdoutLines(self : ExecaResult) -> Array[String] {
  let stdout = self.get("stdout")
  if @js.is_array(stdout) {
    @js.identity(stdout)
  } else {
    []
  }
}

///|
/// Get stderr as lines array (if lines option was true)
pub fn ExecaResult::stderrLines(self : ExecaResult) -> Array[String] {
  let stderr = self.get("stderr")
  if @js.is_array(stderr) {
    @js.identity(stderr)
  } else {
    []
  }
}

///|
/// Get process ID
pub fn ExecaResult::pid(self : ExecaResult) -> Int? {
  let pid = self.get("pid")
  if @js.is_nullish(pid) {
    None
  } else {
    Some(pid.cast())
  }
}

///| ExecaError accessors

///|
/// Get error message
pub fn ExecaError::message(self : ExecaError) -> String {
  self.get("message").cast()
}

///|
/// Get short error message
pub fn ExecaError::shortMessage(self : ExecaError) -> String {
  self.get("shortMessage").cast()
}

///|
/// Get original error (if any)
pub fn ExecaError::originalMessage(self : ExecaError) -> String? {
  @js.identity_option(self.get("originalMessage"))
}

///|
/// Get stdout from error
pub fn ExecaError::stdout(self : ExecaError) -> String {
  self.get("stdout").cast()
}

///|
/// Get stderr from error
pub fn ExecaError::stderr(self : ExecaError) -> String {
  self.get("stderr").cast()
}

///|
/// Get exit code from error
pub fn ExecaError::exitCode(self : ExecaError) -> Int? {
  let code = self.get("exitCode")
  if @js.is_nullish(code) {
    None
  } else {
    Some(code.cast())
  }
}

///|
/// Get the executed command from error
pub fn ExecaError::command(self : ExecaError) -> String {
  self.get("command").cast()
}

///| Options builder

///|
/// Build options object for execa
pub fn options(
  cwd? : String,
  env? : @js.Any,
  input? : String,
  stdin? : String,
  stdout? : String,
  stderr? : String,
  all? : Bool,
  lines? : Bool,
  shell? : Bool,
  timeout? : Int,
  maxBuffer? : Int,
  killSignal? : String,
  preferLocal? : Bool,
  reject? : Bool,
  cleanup? : Bool,
  detached? : Bool,
  encoding? : String,
  stripFinalNewline? : Bool,
  windowsHide? : Bool,
) -> @js.Any {
  let opts = @js.Object::new()
  if cwd is Some(v) {
    opts.set("cwd", v)
  }
  if env is Some(v) {
    opts.set("env", v)
  }
  if input is Some(v) {
    opts.set("input", v)
  }
  if stdin is Some(v) {
    opts.set("stdin", v)
  }
  if stdout is Some(v) {
    opts.set("stdout", v)
  }
  if stderr is Some(v) {
    opts.set("stderr", v)
  }
  if all is Some(v) {
    opts.set("all", v)
  }
  if lines is Some(v) {
    opts.set("lines", v)
  }
  if shell is Some(v) {
    opts.set("shell", v)
  }
  if timeout is Some(v) {
    opts.set("timeout", v)
  }
  if maxBuffer is Some(v) {
    opts.set("maxBuffer", v)
  }
  if killSignal is Some(v) {
    opts.set("killSignal", v)
  }
  if preferLocal is Some(v) {
    opts.set("preferLocal", v)
  }
  if reject is Some(v) {
    opts.set("reject", v)
  }
  if cleanup is Some(v) {
    opts.set("cleanup", v)
  }
  if detached is Some(v) {
    opts.set("detached", v)
  }
  if encoding is Some(v) {
    opts.set("encoding", v)
  }
  if stripFinalNewline is Some(v) {
    opts.set("stripFinalNewline", v)
  }
  if windowsHide is Some(v) {
    opts.set("windowsHide", v)
  }
  opts.to_any()
}

///| FFI Functions

///|
extern "js" fn ffi_execa(
  file : String,
  args : @js.Any,
) -> @js.Promise[ExecaResult] =
  #| async (file, args) => {
  #|   const { execa } = await import('execa');
  #|   return execa(file, args);
  #| }

///|
extern "js" fn ffi_execa_with_options(
  file : String,
  args : @js.Any,
  options : @js.Any,
) -> @js.Promise[ExecaResult] =
  #| async (file, args, options) => {
  #|   const { execa } = await import('execa');
  #|   return execa(file, args, options);
  #| }

///|
extern "js" fn ffi_execa_command(command : String) -> @js.Promise[ExecaResult] =
  #| async (command) => {
  #|   const { execaCommand } = await import('execa');
  #|   return execaCommand(command);
  #| }

///|
extern "js" fn ffi_execa_command_with_options(
  command : String,
  options : @js.Any,
) -> @js.Promise[ExecaResult] =
  #| async (command, options) => {
  #|   const { execaCommand } = await import('execa');
  #|   return execaCommand(command, options);
  #| }

///|
extern "js" fn ffi_execa_sync(file : String, args : @js.Any) -> ExecaResult =
  #| (file, args) => {
  #|   const { execaSync } = require('execa');
  #|   return execaSync(file, args);
  #| }

///|
extern "js" fn ffi_execa_sync_with_options(
  file : String,
  args : @js.Any,
  options : @js.Any,
) -> ExecaResult =
  #| (file, args, options) => {
  #|   const { execaSync } = require('execa');
  #|   return execaSync(file, args, options);
  #| }

///|
extern "js" fn ffi_execa_command_sync(command : String) -> ExecaResult =
  #| (command) => {
  #|   const { execaCommandSync } = require('execa');
  #|   return execaCommandSync(command);
  #| }

///|
extern "js" fn ffi_execa_command_sync_with_options(
  command : String,
  options : @js.Any,
) -> ExecaResult =
  #| (command, options) => {
  #|   const { execaCommandSync } = require('execa');
  #|   return execaCommandSync(command, options);
  #| }

///|
extern "js" fn ffi_execa_node(
  script_path : String,
  args : @js.Any,
) -> @js.Promise[ExecaResult] =
  #| async (script_path, args) => {
  #|   const { execaNode } = await import('execa');
  #|   return execaNode(script_path, args);
  #| }

///|
extern "js" fn ffi_execa_node_with_options(
  script_path : String,
  args : @js.Any,
  options : @js.Any,
) -> @js.Promise[ExecaResult] =
  #| async (script_path, args, options) => {
  #|   const { execaNode } = await import('execa');
  #|   return execaNode(script_path, args, options);
  #| }

///|
extern "js" fn ffi_dollar(command : String) -> @js.Promise[ExecaResult] =
  #| async (command) => {
  #|   const { $ } = await import('execa');
  #|   return $({ shell: true })`${command}`;
  #| }

///|
extern "js" fn ffi_dollar_with_options(
  command : String,
  options : @js.Any,
) -> @js.Promise[ExecaResult] =
  #| async (command, options) => {
  #|   const { $ } = await import('execa');
  #|   const $$ = $(options);
  #|   return $$({ shell: true })`${command}`;
  #| }

///| Internal helpers

///|
fn build_options(
  cwd? : String,
  input? : String,
  timeout? : Int,
  env? : @js.Any,
  shell? : Bool,
  options? : @js.Any,
) -> @js.Any? {
  // If extra options provided, merge with it
  if options is Some(base_opts) {
    let obj : @js.Any = base_opts
    if cwd is Some(v) {
      obj.set("cwd", v)
    }
    if input is Some(v) {
      obj.set("input", v)
    }
    if timeout is Some(v) {
      obj.set("timeout", v)
    }
    if env is Some(v) {
      obj.set("env", v)
    }
    if shell is Some(v) {
      obj.set("shell", v)
    }
    return Some(obj)
  }
  // Build new options if any label arg provided
  if cwd is Some(_) ||
    input is Some(_) ||
    timeout is Some(_) ||
    env is Some(_) ||
    shell is Some(_) {
    let obj = @js.Object::new()
    if cwd is Some(v) {
      obj.set("cwd", v)
    }
    if input is Some(v) {
      obj.set("input", v)
    }
    if timeout is Some(v) {
      obj.set("timeout", v)
    }
    if env is Some(v) {
      obj.set("env", v)
    }
    if shell is Some(v) {
      obj.set("shell", v)
    }
    return Some(obj.to_any())
  }
  None
}

///| Public API

///|
/// Execute a command with arguments
///
/// Example:
/// ```text
/// let result = execa("ls", ["-la"])
/// let result = execa("pwd", cwd="/tmp")
/// let result = execa("cat", input="hello")
/// ```
pub async fn execa(
  file : String,
  args? : Array[String] = [],
  cwd? : String,
  input? : String,
  timeout? : Int,
  env? : @js.Any,
  shell? : Bool,
  options? : @js.Any,
) -> ExecaResult {
  let js_args = @js.from_array(args.map(fn(s) { @js.any(s) }))
  let opts = build_options(cwd?, input?, timeout?, env?, shell?, options?)
  if opts is Some(o) {
    ffi_execa_with_options(file, js_args, o).wait()
  } else {
    ffi_execa(file, js_args).wait()
  }
}

///|
/// Execute a command string (parsed by shell rules)
///
/// Example:
/// ```text
/// let result = execaCommand("echo hello world")
/// let result = execaCommand("pwd", cwd="/tmp")
/// ```
pub async fn execaCommand(
  command : String,
  cwd? : String,
  input? : String,
  timeout? : Int,
  env? : @js.Any,
  options? : @js.Any,
) -> ExecaResult {
  let opts = build_options(cwd?, input?, timeout?, env?, options?)
  if opts is Some(o) {
    ffi_execa_command_with_options(command, o).wait()
  } else {
    ffi_execa_command(command).wait()
  }
}

///|
/// Execute a command synchronously
///
/// Example:
/// ```text
/// let result = execaSync("echo", ["hello"])
/// let result = execaSync("pwd", cwd="/tmp")
/// ```
pub fn execaSync(
  file : String,
  args? : Array[String] = [],
  cwd? : String,
  input? : String,
  timeout? : Int,
  env? : @js.Any,
  shell? : Bool,
  options? : @js.Any,
) -> ExecaResult {
  let js_args = @js.from_array(args.map(fn(s) { @js.any(s) }))
  let opts = build_options(cwd?, input?, timeout?, env?, shell?, options?)
  if opts is Some(o) {
    ffi_execa_sync_with_options(file, js_args, o)
  } else {
    ffi_execa_sync(file, js_args)
  }
}

///|
/// Execute a command string synchronously
///
/// Example:
/// ```text
/// let result = execaCommandSync("echo hello world")
/// let result = execaCommandSync("pwd", cwd="/tmp")
/// ```
pub fn execaCommandSync(
  command : String,
  cwd? : String,
  input? : String,
  timeout? : Int,
  env? : @js.Any,
  options? : @js.Any,
) -> ExecaResult {
  let opts = build_options(cwd?, input?, timeout?, env?, options?)
  if opts is Some(o) {
    ffi_execa_command_sync_with_options(command, o)
  } else {
    ffi_execa_command_sync(command)
  }
}

///|
/// Execute a Node.js script
///
/// Example:
/// ```text
/// let result = execaNode("script.js", ["arg1", "arg2"])
/// let result = execaNode("script.js", cwd="/tmp")
/// ```
pub async fn execaNode(
  script_path : String,
  args? : Array[String] = [],
  cwd? : String,
  input? : String,
  timeout? : Int,
  env? : @js.Any,
  options? : @js.Any,
) -> ExecaResult {
  let js_args = @js.from_array(args.map(fn(s) { @js.any(s) }))
  let opts = build_options(cwd?, input?, timeout?, env?, options?)
  if opts is Some(o) {
    ffi_execa_node_with_options(script_path, js_args, o).wait()
  } else {
    ffi_execa_node(script_path, js_args).wait()
  }
}

///|
/// Execute a shell command ($ style)
/// More flexible than execa for shell operations
///
/// Example:
/// ```text
/// let result = shell("ls -la | grep .txt")
/// let result = shell("pwd", cwd="/tmp")
/// ```
pub async fn shell(
  command : String,
  cwd? : String,
  input? : String,
  timeout? : Int,
  env? : @js.Any,
  options? : @js.Any,
) -> ExecaResult {
  let opts = build_options(cwd?, input?, timeout?, env?, options?)
  if opts is Some(o) {
    ffi_dollar_with_options(command, o).wait()
  } else {
    ffi_dollar(command).wait()
  }
}

///| Subprocess control (advanced)

///|
extern "js" fn ffi_execa_subprocess(
  file : String,
  args : @js.Any,
  options : @js.Any,
) -> Subprocess =
  #| (file, args, options) => {
  #|   const { execa } = require('execa');
  #|   return execa(file, args, options);
  #| }

///|
/// Create a subprocess without waiting (for streaming/control)
pub fn subprocess(
  file : String,
  args : Array[String],
  options? : @js.Any,
) -> Subprocess {
  let js_args = @js.from_array(args.map(fn(s) { @js.any(s) }))
  let opts = options.unwrap_or(@js.Object::new().to_any())
  ffi_execa_subprocess(file, js_args, opts)
}

///|
/// Get subprocess PID
pub fn Subprocess::pid(self : Subprocess) -> Int {
  self.get("pid").cast()
}

///|
/// Kill the subprocess
pub fn Subprocess::kill(self : Subprocess, signal? : String) -> Unit {
  if signal is Some(sig) {
    ignore(self.get("kill").call_self([@js.any(sig)]))
  } else {
    ignore(self.get("kill").call_self([]))
  }
}

///|
extern "js" fn ffi_subprocess_to_promise(
  subprocess : Subprocess,
) -> @js.Promise[ExecaResult] =
  #| (subprocess) => subprocess

///|
/// Wait for subprocess to complete
pub async fn Subprocess::wait(self : Subprocess) -> ExecaResult {
  ffi_subprocess_to_promise(self).wait()
}

///|
/// Get subprocess stdin stream
pub fn Subprocess::stdin(self : Subprocess) -> @js.Any {
  self.get("stdin")
}

///|
/// Get subprocess stdout stream
pub fn Subprocess::stdout(self : Subprocess) -> @js.Any {
  self.get("stdout")
}

///|
/// Get subprocess stderr stream
pub fn Subprocess::stderr(self : Subprocess) -> @js.Any {
  self.get("stderr")
}
