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
/// Error from failed process execution
#external
pub type ExecaError

///|
/// Subprocess instance (for advanced control)
#external
pub type Subprocess

///| ExecaResult accessors

///|
extern "js" fn ExecaResult::to_any(self : ExecaResult) -> @nostd.Any =
  #| (x) => x

///|
/// Get stdout as string
pub fn ExecaResult::stdout(self : ExecaResult) -> String {
  self.to_any()["stdout"].cast()
}

///|
/// Get stderr as string
pub fn ExecaResult::stderr(self : ExecaResult) -> String {
  self.to_any()["stderr"].cast()
}

///|
/// Get exit code
pub fn ExecaResult::exitCode(self : ExecaResult) -> Int {
  self.to_any()["exitCode"].cast()
}

///|
/// Get the executed command
pub fn ExecaResult::command(self : ExecaResult) -> String {
  self.to_any()["command"].cast()
}

///|
/// Get escaped command (safe to copy/paste)
pub fn ExecaResult::escapedCommand(self : ExecaResult) -> String {
  self.to_any()["escapedCommand"].cast()
}

///|
/// Check if process failed
pub fn ExecaResult::failed(self : ExecaResult) -> Bool {
  self.to_any()["failed"].cast()
}

///|
/// Check if process timed out
pub fn ExecaResult::timedOut(self : ExecaResult) -> Bool {
  self.to_any()["timedOut"].cast()
}

///|
/// Check if process was killed
pub fn ExecaResult::killed(self : ExecaResult) -> Bool {
  self.to_any()["killed"].cast()
}

///|
/// Get signal name if killed by signal
pub fn ExecaResult::signal(self : ExecaResult) -> String? {
  let v = self.to_any()["signal"]
  if @nostd.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get signal description
pub fn ExecaResult::signalDescription(self : ExecaResult) -> String? {
  let v = self.to_any()["signalDescription"]
  if @nostd.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get combined stdout and stderr (if all option was true)
pub fn ExecaResult::all(self : ExecaResult) -> String? {
  let v = self.to_any()["all"]
  if @nostd.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get stdout as lines array (if lines option was true)
pub fn ExecaResult::stdoutLines(self : ExecaResult) -> Array[String] {
  let stdout = self.to_any()["stdout"]
  if @nostd.is_array(stdout) {
    @nostd.identity(stdout)
  } else {
    []
  }
}

///|
/// Get stderr as lines array (if lines option was true)
pub fn ExecaResult::stderrLines(self : ExecaResult) -> Array[String] {
  let stderr = self.to_any()["stderr"]
  if @nostd.is_array(stderr) {
    @nostd.identity(stderr)
  } else {
    []
  }
}

///|
/// Get process ID
pub fn ExecaResult::pid(self : ExecaResult) -> Int? {
  let pid = self.to_any()["pid"]
  if @nostd.is_nullish(pid) {
    None
  } else {
    Some(pid.cast())
  }
}

///| ExecaError accessors

///|
extern "js" fn ExecaError::to_any(self : ExecaError) -> @nostd.Any =
  #| (x) => x

///|
/// Get error message
pub fn ExecaError::message(self : ExecaError) -> String {
  self.to_any()["message"].cast()
}

///|
/// Get short error message
pub fn ExecaError::shortMessage(self : ExecaError) -> String {
  self.to_any()["shortMessage"].cast()
}

///|
/// Get original error (if any)
pub fn ExecaError::originalMessage(self : ExecaError) -> String? {
  let v = self.to_any()["originalMessage"]
  if @nostd.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get stdout from error
pub fn ExecaError::stdout(self : ExecaError) -> String {
  self.to_any()["stdout"].cast()
}

///|
/// Get stderr from error
pub fn ExecaError::stderr(self : ExecaError) -> String {
  self.to_any()["stderr"].cast()
}

///|
/// Get exit code from error
pub fn ExecaError::exitCode(self : ExecaError) -> Int? {
  let code = self.to_any()["exitCode"]
  if @nostd.is_nullish(code) {
    None
  } else {
    Some(code.cast())
  }
}

///|
/// Get the executed command from error
pub fn ExecaError::command(self : ExecaError) -> String {
  self.to_any()["command"].cast()
}

///| Options builder

///|
/// Build options object for execa
pub fn options(
  cwd? : String,
  env? : @nostd.Any,
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
) -> @nostd.Any {
  let opts = @nostd.Object::new()
  if cwd is Some(v) {
    opts["cwd"] = @nostd.any(v)
  }
  if env is Some(v) {
    opts["env"] = v
  }
  if input is Some(v) {
    opts["input"] = @nostd.any(v)
  }
  if stdin is Some(v) {
    opts["stdin"] = @nostd.any(v)
  }
  if stdout is Some(v) {
    opts["stdout"] = @nostd.any(v)
  }
  if stderr is Some(v) {
    opts["stderr"] = @nostd.any(v)
  }
  if all is Some(v) {
    opts["all"] = @nostd.any(v)
  }
  if lines is Some(v) {
    opts["lines"] = @nostd.any(v)
  }
  if shell is Some(v) {
    opts["shell"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    opts["timeout"] = @nostd.any(v)
  }
  if maxBuffer is Some(v) {
    opts["maxBuffer"] = @nostd.any(v)
  }
  if killSignal is Some(v) {
    opts["killSignal"] = @nostd.any(v)
  }
  if preferLocal is Some(v) {
    opts["preferLocal"] = @nostd.any(v)
  }
  if reject is Some(v) {
    opts["reject"] = @nostd.any(v)
  }
  if cleanup is Some(v) {
    opts["cleanup"] = @nostd.any(v)
  }
  if detached is Some(v) {
    opts["detached"] = @nostd.any(v)
  }
  if encoding is Some(v) {
    opts["encoding"] = @nostd.any(v)
  }
  if stripFinalNewline is Some(v) {
    opts["stripFinalNewline"] = @nostd.any(v)
  }
  if windowsHide is Some(v) {
    opts["windowsHide"] = @nostd.any(v)
  }
  opts
}

///| FFI Functions

///|
extern "js" fn ffi_execa(
  file : String,
  args : @nostd.Any,
) -> @nostd.Promise[ExecaResult] =
  #| async (file, args) => {
  #|   const { execa } = await import('execa');
  #|   return execa(file, args);
  #| }

///|
extern "js" fn ffi_execa_with_options(
  file : String,
  args : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Promise[ExecaResult] =
  #| async (file, args, options) => {
  #|   const { execa } = await import('execa');
  #|   return execa(file, args, options);
  #| }

///|
extern "js" fn ffi_execa_command(
  command : String,
) -> @nostd.Promise[ExecaResult] =
  #| async (command) => {
  #|   const { execaCommand } = await import('execa');
  #|   return execaCommand(command);
  #| }

///|
extern "js" fn ffi_execa_command_with_options(
  command : String,
  options : @nostd.Any,
) -> @nostd.Promise[ExecaResult] =
  #| async (command, options) => {
  #|   const { execaCommand } = await import('execa');
  #|   return execaCommand(command, options);
  #| }

///|
extern "js" fn ffi_execa_sync(file : String, args : @nostd.Any) -> ExecaResult =
  #| (file, args) => {
  #|   const { execaSync } = require('execa');
  #|   return execaSync(file, args);
  #| }

///|
extern "js" fn ffi_execa_sync_with_options(
  file : String,
  args : @nostd.Any,
  options : @nostd.Any,
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
  options : @nostd.Any,
) -> ExecaResult =
  #| (command, options) => {
  #|   const { execaCommandSync } = require('execa');
  #|   return execaCommandSync(command, options);
  #| }

///|
extern "js" fn ffi_execa_node(
  script_path : String,
  args : @nostd.Any,
) -> @nostd.Promise[ExecaResult] =
  #| async (script_path, args) => {
  #|   const { execaNode } = await import('execa');
  #|   return execaNode(script_path, args);
  #| }

///|
extern "js" fn ffi_execa_node_with_options(
  script_path : String,
  args : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Promise[ExecaResult] =
  #| async (script_path, args, options) => {
  #|   const { execaNode } = await import('execa');
  #|   return execaNode(script_path, args, options);
  #| }

///|
extern "js" fn ffi_dollar(command : String) -> @nostd.Promise[ExecaResult] =
  #| async (command) => {
  #|   const { $ } = await import('execa');
  #|   return $({ shell: true })`${command}`;
  #| }

///|
extern "js" fn ffi_dollar_with_options(
  command : String,
  options : @nostd.Any,
) -> @nostd.Promise[ExecaResult] =
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
  env? : @nostd.Any,
  shell? : Bool,
  options? : @nostd.Any,
) -> @nostd.Any? {
  // If extra options provided, merge with it
  if options is Some(base_opts) {
    let obj : @nostd.Any = base_opts
    if cwd is Some(v) {
      obj["cwd"] = @nostd.any(v)
    }
    if input is Some(v) {
      obj["input"] = @nostd.any(v)
    }
    if timeout is Some(v) {
      obj["timeout"] = @nostd.any(v)
    }
    if env is Some(v) {
      obj["env"] = v
    }
    if shell is Some(v) {
      obj["shell"] = @nostd.any(v)
    }
    return Some(obj)
  }
  // Build new options if any label arg provided
  if cwd is Some(_) ||
    input is Some(_) ||
    timeout is Some(_) ||
    env is Some(_) ||
    shell is Some(_) {
    let obj = @nostd.Object::new()
    if cwd is Some(v) {
      obj["cwd"] = @nostd.any(v)
    }
    if input is Some(v) {
      obj["input"] = @nostd.any(v)
    }
    if timeout is Some(v) {
      obj["timeout"] = @nostd.any(v)
    }
    if env is Some(v) {
      obj["env"] = v
    }
    if shell is Some(v) {
      obj["shell"] = @nostd.any(v)
    }
    return Some(obj)
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
  env? : @nostd.Any,
  shell? : Bool,
  options? : @nostd.Any,
) -> ExecaResult {
  let js_args : @nostd.Any = args.map(fn(s) { @nostd.any(s) })
    |> @nostd.identity
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
  env? : @nostd.Any,
  options? : @nostd.Any,
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
  env? : @nostd.Any,
  shell? : Bool,
  options? : @nostd.Any,
) -> ExecaResult {
  let js_args : @nostd.Any = args.map(fn(s) { @nostd.any(s) })
    |> @nostd.identity
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
  env? : @nostd.Any,
  options? : @nostd.Any,
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
  env? : @nostd.Any,
  options? : @nostd.Any,
) -> ExecaResult {
  let js_args : @nostd.Any = args.map(fn(s) { @nostd.any(s) })
    |> @nostd.identity
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
  env? : @nostd.Any,
  options? : @nostd.Any,
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
extern "js" fn Subprocess::to_any(self : Subprocess) -> @nostd.Any =
  #| (x) => x

///|
extern "js" fn ffi_execa_subprocess(
  file : String,
  args : @nostd.Any,
  options : @nostd.Any,
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
  options? : @nostd.Any,
) -> Subprocess {
  let js_args : @nostd.Any = args.map(fn(s) { @nostd.any(s) })
    |> @nostd.identity
  let opts = options.unwrap_or(@nostd.Object::new())
  ffi_execa_subprocess(file, js_args, opts)
}

///|
/// Get subprocess PID
pub fn Subprocess::pid(self : Subprocess) -> Int {
  self.to_any()["pid"].cast()
}

///|
extern "js" fn ffi_subprocess_kill(
  subprocess : Subprocess,
  signal : @nostd.Any,
) -> Unit =
  #| (subprocess, signal) => subprocess.kill(signal)

///|
/// Kill the subprocess
pub fn Subprocess::kill(self : Subprocess, signal? : String) -> Unit {
  if signal is Some(sig) {
    ffi_subprocess_kill(self, @nostd.any(sig))
  } else {
    ffi_subprocess_kill(self, @nostd.undefined())
  }
}

///|
extern "js" fn ffi_subprocess_to_promise(
  subprocess : Subprocess,
) -> @nostd.Promise[ExecaResult] =
  #| (subprocess) => subprocess

///|
/// Wait for subprocess to complete
pub async fn Subprocess::wait(self : Subprocess) -> ExecaResult {
  ffi_subprocess_to_promise(self).wait()
}

///|
/// Get subprocess stdin stream
pub fn Subprocess::stdin(self : Subprocess) -> @nostd.Any {
  self.to_any()["stdin"]
}

///|
/// Get subprocess stdout stream
pub fn Subprocess::stdout(self : Subprocess) -> @nostd.Any {
  self.to_any()["stdout"]
}

///|
/// Get subprocess stderr stream
pub fn Subprocess::stderr(self : Subprocess) -> @nostd.Any {
  self.to_any()["stderr"]
}
