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
extern "js" fn ExecaResult::as_any(self : ExecaResult) -> @core.Any =
  #| (x) => x

///|
/// Get stdout as string
pub fn ExecaResult::stdout(self : ExecaResult) -> String {
  self.as_any()["stdout"].cast()
}

///|
/// Get stderr as string
pub fn ExecaResult::stderr(self : ExecaResult) -> String {
  self.as_any()["stderr"].cast()
}

///|
/// Get exit code
pub fn ExecaResult::exitCode(self : ExecaResult) -> Int {
  self.as_any()["exitCode"].cast()
}

///|
/// Get the executed command
pub fn ExecaResult::command(self : ExecaResult) -> String {
  self.as_any()["command"].cast()
}

///|
/// Get escaped command (safe to copy/paste)
pub fn ExecaResult::escapedCommand(self : ExecaResult) -> String {
  self.as_any()["escapedCommand"].cast()
}

///|
/// Check if process failed
pub fn ExecaResult::failed(self : ExecaResult) -> Bool {
  self.as_any()["failed"].cast()
}

///|
/// Check if process timed out
pub fn ExecaResult::timedOut(self : ExecaResult) -> Bool {
  self.as_any()["timedOut"].cast()
}

///|
/// Check if process was killed
pub fn ExecaResult::killed(self : ExecaResult) -> Bool {
  self.as_any()["killed"].cast()
}

///|
/// Get signal name if killed by signal
pub fn ExecaResult::signal(self : ExecaResult) -> String? {
  let v = self.as_any()["signal"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get signal description
pub fn ExecaResult::signalDescription(self : ExecaResult) -> String? {
  let v = self.as_any()["signalDescription"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get combined stdout and stderr (if all option was true)
pub fn ExecaResult::all(self : ExecaResult) -> String? {
  let v = self.as_any()["all"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get stdout as lines array (if lines option was true)
pub fn ExecaResult::stdoutLines(self : ExecaResult) -> Array[String] {
  let stdout = self.as_any()["stdout"]
  if @core.is_array(stdout) {
    @core.identity(stdout)
  } else {
    []
  }
}

///|
/// Get stderr as lines array (if lines option was true)
pub fn ExecaResult::stderrLines(self : ExecaResult) -> Array[String] {
  let stderr = self.as_any()["stderr"]
  if @core.is_array(stderr) {
    @core.identity(stderr)
  } else {
    []
  }
}

///|
/// Get process ID
pub fn ExecaResult::pid(self : ExecaResult) -> Int? {
  let pid = self.as_any()["pid"]
  if @core.is_nullish(pid) {
    None
  } else {
    Some(pid.cast())
  }
}

///| ExecaError accessors

///|
extern "js" fn ExecaError::as_any(self : ExecaError) -> @core.Any =
  #| (x) => x

///|
/// Get error message
pub fn ExecaError::message(self : ExecaError) -> String {
  self.as_any()["message"].cast()
}

///|
/// Get short error message
pub fn ExecaError::shortMessage(self : ExecaError) -> String {
  self.as_any()["shortMessage"].cast()
}

///|
/// Get original error (if any)
pub fn ExecaError::originalMessage(self : ExecaError) -> String? {
  let v = self.as_any()["originalMessage"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get stdout from error
pub fn ExecaError::stdout(self : ExecaError) -> String {
  self.as_any()["stdout"].cast()
}

///|
/// Get stderr from error
pub fn ExecaError::stderr(self : ExecaError) -> String {
  self.as_any()["stderr"].cast()
}

///|
/// Get exit code from error
pub fn ExecaError::exitCode(self : ExecaError) -> Int? {
  let code = self.as_any()["exitCode"]
  if @core.is_nullish(code) {
    None
  } else {
    Some(code.cast())
  }
}

///|
/// Get the executed command from error
pub fn ExecaError::command(self : ExecaError) -> String {
  self.as_any()["command"].cast()
}

///| Options builder

///|
/// Build options object for execa
pub fn options(
  cwd? : String,
  env? : @core.Any,
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
) -> @core.Any {
  let opts = @core.Object::new()
  if cwd is Some(v) {
    opts["cwd"] = @core.any(v)
  }
  if env is Some(v) {
    opts["env"] = v
  }
  if input is Some(v) {
    opts["input"] = @core.any(v)
  }
  if stdin is Some(v) {
    opts["stdin"] = @core.any(v)
  }
  if stdout is Some(v) {
    opts["stdout"] = @core.any(v)
  }
  if stderr is Some(v) {
    opts["stderr"] = @core.any(v)
  }
  if all is Some(v) {
    opts["all"] = @core.any(v)
  }
  if lines is Some(v) {
    opts["lines"] = @core.any(v)
  }
  if shell is Some(v) {
    opts["shell"] = @core.any(v)
  }
  if timeout is Some(v) {
    opts["timeout"] = @core.any(v)
  }
  if maxBuffer is Some(v) {
    opts["maxBuffer"] = @core.any(v)
  }
  if killSignal is Some(v) {
    opts["killSignal"] = @core.any(v)
  }
  if preferLocal is Some(v) {
    opts["preferLocal"] = @core.any(v)
  }
  if reject is Some(v) {
    opts["reject"] = @core.any(v)
  }
  if cleanup is Some(v) {
    opts["cleanup"] = @core.any(v)
  }
  if detached is Some(v) {
    opts["detached"] = @core.any(v)
  }
  if encoding is Some(v) {
    opts["encoding"] = @core.any(v)
  }
  if stripFinalNewline is Some(v) {
    opts["stripFinalNewline"] = @core.any(v)
  }
  if windowsHide is Some(v) {
    opts["windowsHide"] = @core.any(v)
  }
  opts
}

///| FFI Functions

///|
extern "js" fn ffi_execa(
  file : String,
  args : @core.Any,
) -> @core.Promise[ExecaResult] =
  #| async (file, args) => {
  #|   const { execa } = await import('execa');
  #|   return execa(file, args);
  #| }

///|
extern "js" fn ffi_execa_with_options(
  file : String,
  args : @core.Any,
  options : @core.Any,
) -> @core.Promise[ExecaResult] =
  #| async (file, args, options) => {
  #|   const { execa } = await import('execa');
  #|   return execa(file, args, options);
  #| }

///|
extern "js" fn ffi_execa_command(
  command : String,
) -> @core.Promise[ExecaResult] =
  #| async (command) => {
  #|   const { execaCommand } = await import('execa');
  #|   return execaCommand(command);
  #| }

///|
extern "js" fn ffi_execa_command_with_options(
  command : String,
  options : @core.Any,
) -> @core.Promise[ExecaResult] =
  #| async (command, options) => {
  #|   const { execaCommand } = await import('execa');
  #|   return execaCommand(command, options);
  #| }

///|
extern "js" fn ffi_execa_sync(file : String, args : @core.Any) -> ExecaResult =
  #| (file, args) => {
  #|   const { execaSync } = require('execa');
  #|   return execaSync(file, args);
  #| }

///|
extern "js" fn ffi_execa_sync_with_options(
  file : String,
  args : @core.Any,
  options : @core.Any,
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
  options : @core.Any,
) -> ExecaResult =
  #| (command, options) => {
  #|   const { execaCommandSync } = require('execa');
  #|   return execaCommandSync(command, options);
  #| }

///|
extern "js" fn ffi_execa_node(
  script_path : String,
  args : @core.Any,
) -> @core.Promise[ExecaResult] =
  #| async (script_path, args) => {
  #|   const { execaNode } = await import('execa');
  #|   return execaNode(script_path, args);
  #| }

///|
extern "js" fn ffi_execa_node_with_options(
  script_path : String,
  args : @core.Any,
  options : @core.Any,
) -> @core.Promise[ExecaResult] =
  #| async (script_path, args, options) => {
  #|   const { execaNode } = await import('execa');
  #|   return execaNode(script_path, args, options);
  #| }

///|
extern "js" fn ffi_dollar(command : String) -> @core.Promise[ExecaResult] =
  #| async (command) => {
  #|   const { $ } = await import('execa');
  #|   return $({ shell: true })`${command}`;
  #| }

///|
extern "js" fn ffi_dollar_with_options(
  command : String,
  options : @core.Any,
) -> @core.Promise[ExecaResult] =
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
  env? : @core.Any,
  shell? : Bool,
  options? : @core.Any,
) -> @core.Any? {
  // If extra options provided, merge with it
  if options is Some(base_opts) {
    let obj : @core.Any = base_opts
    if cwd is Some(v) {
      obj["cwd"] = @core.any(v)
    }
    if input is Some(v) {
      obj["input"] = @core.any(v)
    }
    if timeout is Some(v) {
      obj["timeout"] = @core.any(v)
    }
    if env is Some(v) {
      obj["env"] = v
    }
    if shell is Some(v) {
      obj["shell"] = @core.any(v)
    }
    return Some(obj)
  }
  // Build new options if any label arg provided
  if cwd is Some(_) ||
    input is Some(_) ||
    timeout is Some(_) ||
    env is Some(_) ||
    shell is Some(_) {
    let obj = @core.Object::new()
    if cwd is Some(v) {
      obj["cwd"] = @core.any(v)
    }
    if input is Some(v) {
      obj["input"] = @core.any(v)
    }
    if timeout is Some(v) {
      obj["timeout"] = @core.any(v)
    }
    if env is Some(v) {
      obj["env"] = v
    }
    if shell is Some(v) {
      obj["shell"] = @core.any(v)
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
  env? : @core.Any,
  shell? : Bool,
  options? : @core.Any,
) -> ExecaResult {
  let js_args : @core.Any = args.map(fn(s) { @core.any(s) }) |> @core.identity
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
  env? : @core.Any,
  options? : @core.Any,
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
  env? : @core.Any,
  shell? : Bool,
  options? : @core.Any,
) -> ExecaResult {
  let js_args : @core.Any = args.map(fn(s) { @core.any(s) }) |> @core.identity
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
  env? : @core.Any,
  options? : @core.Any,
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
  env? : @core.Any,
  options? : @core.Any,
) -> ExecaResult {
  let js_args : @core.Any = args.map(fn(s) { @core.any(s) }) |> @core.identity
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
  env? : @core.Any,
  options? : @core.Any,
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
extern "js" fn Subprocess::as_any(self : Subprocess) -> @core.Any =
  #| (x) => x

///|
extern "js" fn ffi_execa_subprocess(
  file : String,
  args : @core.Any,
  options : @core.Any,
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
  options? : @core.Any,
) -> Subprocess {
  let js_args : @core.Any = args.map(fn(s) { @core.any(s) }) |> @core.identity
  let opts = options.unwrap_or(@core.Object::new())
  ffi_execa_subprocess(file, js_args, opts)
}

///|
/// Get subprocess PID
pub fn Subprocess::pid(self : Subprocess) -> Int {
  self.as_any()["pid"].cast()
}

///|
extern "js" fn ffi_subprocess_kill(
  subprocess : Subprocess,
  signal : @core.Any,
) -> Unit =
  #| (subprocess, signal) => subprocess.kill(signal)

///|
/// Kill the subprocess
pub fn Subprocess::kill(self : Subprocess, signal? : String) -> Unit {
  if signal is Some(sig) {
    ffi_subprocess_kill(self, @core.any(sig))
  } else {
    ffi_subprocess_kill(self, @core.undefined())
  }
}

///|
extern "js" fn ffi_subprocess_to_promise(
  subprocess : Subprocess,
) -> @core.Promise[ExecaResult] =
  #| (subprocess) => subprocess

///|
/// Wait for subprocess to complete
pub async fn Subprocess::wait(self : Subprocess) -> ExecaResult {
  ffi_subprocess_to_promise(self).wait()
}

///|
/// Get subprocess stdin stream
pub fn Subprocess::stdin(self : Subprocess) -> @core.Any {
  self.as_any()["stdin"]
}

///|
/// Get subprocess stdout stream
pub fn Subprocess::stdout(self : Subprocess) -> @core.Any {
  self.as_any()["stdout"]
}

///|
/// Get subprocess stderr stream
pub fn Subprocess::stderr(self : Subprocess) -> @core.Any {
  self.as_any()["stderr"]
}
