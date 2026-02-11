// https://nodejs.org/api/child_process.html
// Based on @types/node child_process definitions

///| ChildProcess Type

///|
/// The ChildProcess class extends EventEmitter and represents a spawned child process
#external
pub type ChildProcess

///|
pub fn ChildProcess::as_any(self : ChildProcess) -> @core.Any = "%identity"

///|
pub fn ChildProcess::to_any(self : ChildProcess) -> @core.Any = "%identity"

///|
pub fn ChildProcess::to_event_emitter(
  self : ChildProcess,
) -> @events.EventEmitter = "%identity"

///|
pub fn ChildProcess::as_event_emitter(
  self : ChildProcess,
) -> @events.EventEmitter = "%identity"

///|
/// Get pid
pub fn ChildProcess::pid(self : ChildProcess) -> Int {
  self.as_any()["pid"].cast()
}

///|
/// Get killed
pub fn ChildProcess::killed(self : ChildProcess) -> Bool {
  self.as_any()["killed"].cast()
}

///|
/// Get exitCode
pub fn ChildProcess::exitCode(self : ChildProcess) -> Int {
  self.as_any()["exitCode"].cast()
}

///|
/// Get signalCode
pub fn ChildProcess::signalCode(self : ChildProcess) -> String {
  self.as_any()["signalCode"].cast()
}

///|
/// Get stdin
pub fn ChildProcess::stdin(self : ChildProcess) -> @streams.WritableStream {
  self.as_any()["stdin"].cast()
}

///|
/// Get stdout
pub fn ChildProcess::stdout(self : ChildProcess) -> @streams.ReadableStream {
  self.as_any()["stdout"].cast()
}

///|
/// Get stderr
pub fn ChildProcess::stderr(self : ChildProcess) -> @streams.ReadableStream {
  self.as_any()["stderr"].cast()
}

///|
/// Listen for stderr 'data' event with typed callback
/// Callback receives: data (@core.Any) - typically Buffer or String
pub fn ChildProcess::on_stderr_data(
  self : ChildProcess,
  callback : (@core.Any) -> Unit,
) -> Unit {
  @core.any(self.stderr())._call("on", [@core.any("data"), @core.any(callback)])
  |> ignore
}

///| ChildProcess Methods

///|
/// Send a signal to the child process
pub fn ChildProcess::kill(self : ChildProcess, signal? : String) -> Bool {
  match signal {
    Some(sig) => self.as_any()._call("kill", [@core.any(sig)]).cast()
    None => self.as_any()._call("kill", []).cast()
  }
}

///|
/// Send a message to the child process (for IPC)
pub extern "js" fn ChildProcess::send(
  self : ChildProcess,
  message : @core.Any,
) -> Bool =
  #| (self, message) => self.send(message)

///|
/// Close the IPC channel between parent and child
pub extern "js" fn ChildProcess::disconnect(self : ChildProcess) -> Unit =
  #| (self) => self.disconnect()

///|
/// Prevent the parent process from waiting for this child
pub extern "js" fn ChildProcess::unref(self : ChildProcess) -> Unit =
  #| (self) => self.unref()

///|
/// Require the parent process to wait for this child
pub extern "js" fn ChildProcess::ref_(self : ChildProcess) -> Unit =
  #| (self) => self.ref()

///| FFI with #module

///|
#module("node:child_process")
extern "js" fn ffi_spawn(
  command : String,
  args : Array[String],
  options : @core.Any,
) -> ChildProcess = "spawn"

///|
#module("node:child_process")
extern "js" fn ffi_spawn_no_args(
  command : String,
  options : @core.Any,
) -> ChildProcess = "spawn"

///|
#module("node:child_process")
extern "js" fn ffi_exec(
  command : String,
  options : @core.Any,
  callback : @core.Any,
) -> ChildProcess = "exec"

///|
#module("node:child_process")
extern "js" fn ffi_execFile(
  file : String,
  args : Array[String],
  options : @core.Any,
  callback : @core.Any,
) -> ChildProcess = "execFile"

///|
#module("node:child_process")
extern "js" fn ffi_fork(
  modulePath : String,
  args : Array[String],
  options : @core.Any,
) -> ChildProcess = "fork"

///|
#module("node:child_process")
extern "js" fn ffi_fork_no_args(
  modulePath : String,
  options : @core.Any,
) -> ChildProcess = "fork"

///|
#module("node:child_process")
extern "js" fn ffi_spawnSync(
  command : String,
  args : Array[String],
  options : @core.Any,
) -> SpawnSyncResult = "spawnSync"

///|
#module("node:child_process")
extern "js" fn ffi_spawnSync_no_args(
  command : String,
  options : @core.Any,
) -> SpawnSyncResult = "spawnSync"

///|
#module("node:child_process")
extern "js" fn ffi_execSync(command : String, options : @core.Any) -> @core.Any = "execSync"

///|
#module("node:child_process")
extern "js" fn ffi_execFileSync(
  file : String,
  args : Array[String],
  options : @core.Any,
) -> @core.Any = "execFileSync"

///|
#module("node:child_process")
extern "js" fn ffi_execFileSync_no_args(
  file : String,
  options : @core.Any,
) -> @core.Any = "execFileSync"

///| Public API

///|
/// spawn(command[, args][, options])
/// Spawns a new process using the given command
pub fn spawn(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : @core.Any,
  shell? : Bool,
  timeout? : Int,
  signal? : @js_async.AbortSignal,
) -> ChildProcess {
  let options = @core.new_object()
  if cwd is Some(v) {
    options["cwd"] = @core.any(v)
  }
  if env is Some(v) {
    options["env"] = v
  }
  if shell is Some(v) {
    options["shell"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if signal is Some(v) {
    options["signal"] = @core.any(v)
  }
  match args {
    Some(a) => ffi_spawn(command, a, options)
    None => ffi_spawn_no_args(command, options)
  }
}

///|
/// exec(command[, options][, callback])
/// Spawns a shell and executes a command, buffering the output
pub fn exec(
  command : String,
  callback : (@core.Nullish[@error.JsError], String, String) -> Unit,
  cwd? : String,
  env? : @core.Any,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js_async.AbortSignal,
) -> ChildProcess {
  let options = @core.new_object()
  if cwd is Some(v) {
    options["cwd"] = @core.any(v)
  }
  if env is Some(v) {
    options["env"] = v
  }
  if shell is Some(v) {
    options["shell"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if max_buffer is Some(v) {
    options["maxBuffer"] = @core.any(v)
  }
  if signal is Some(v) {
    options["signal"] = @core.any(v)
  }
  ffi_exec(command, options, @core.any(callback))
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
#alias(exec_file)
pub fn execFile(
  file : String,
  args : Array[String],
  callback : (@core.Nullish[@error.JsError], String, String) -> Unit,
  cwd? : String,
  env? : @core.Any,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js_async.AbortSignal,
) -> ChildProcess {
  let options = @core.new_object()
  if cwd is Some(v) {
    options["cwd"] = @core.any(v)
  }
  if env is Some(v) {
    options["env"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if max_buffer is Some(v) {
    options["maxBuffer"] = @core.any(v)
  }
  if signal is Some(v) {
    options["signal"] = @core.any(v)
  }
  ffi_execFile(file, args, options, @core.any(callback))
}

///|
/// fork(modulePath[, args][, options])
/// Spawns a new Node.js process with IPC communication channel
pub fn fork(
  module_path : String,
  args? : Array[String],
  cwd? : String,
  env? : @core.Any,
  silent? : Bool,
  timeout? : Int,
  signal? : @js_async.AbortSignal,
) -> ChildProcess {
  let options = @core.new_object()
  if cwd is Some(v) {
    options["cwd"] = @core.any(v)
  }
  if env is Some(v) {
    options["env"] = v
  }
  if silent is Some(v) {
    options["silent"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if signal is Some(v) {
    options["signal"] = @core.any(v)
  }
  match args {
    Some(a) => ffi_fork(module_path, a, options)
    None => ffi_fork_no_args(module_path, options)
  }
}

///| Synchronous Functions

///|
/// SpawnSyncResult type for synchronous spawn operations
#external
pub type SpawnSyncResult

///|
pub fn SpawnSyncResult::as_any(self : SpawnSyncResult) -> @core.Any = "%identity"

///|
/// Get pid
pub fn SpawnSyncResult::pid(self : SpawnSyncResult) -> Int {
  self.as_any()["pid"].cast()
}

///|
/// Get status
pub fn SpawnSyncResult::status(self : SpawnSyncResult) -> Int? {
  let v = self.as_any()["status"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get signal
pub fn SpawnSyncResult::signal(self : SpawnSyncResult) -> String? {
  let v = self.as_any()["signal"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get stdout
pub fn SpawnSyncResult::stdout(
  self : SpawnSyncResult,
) -> @streams.ReadableStream {
  self.as_any()["stdout"].cast()
}

///|
/// Get stderr
pub fn SpawnSyncResult::stderr(
  self : SpawnSyncResult,
) -> @streams.ReadableStream {
  self.as_any()["stderr"].cast()
}

///|
/// Get error
pub fn SpawnSyncResult::error(self : SpawnSyncResult) -> @core.Any {
  self.as_any()["error"]
}

///|
/// spawnSync(command[, args][, options])
/// Synchronous version of spawn - blocks until process exits
#alias(spawn_sync)
pub fn spawnSync(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : @core.Any,
  shell? : Bool,
  timeout? : Int,
  input? : String,
  stdio? : String,
) -> SpawnSyncResult raise @core.ThrowError {
  @core.throwable(fn() {
    let options = @core.new_object()
    if cwd is Some(v) {
      options["cwd"] = @core.any(v)
    }
    if env is Some(v) {
      options["env"] = v
    }
    if shell is Some(v) {
      options["shell"] = @core.any(v)
    }
    if timeout is Some(v) {
      options["timeout"] = @core.any(v)
    }
    if input is Some(v) {
      options["input"] = @core.any(v)
    }
    if stdio is Some(v) {
      options["stdio"] = @core.any(v)
    }
    let use_shell = match shell {
      Some(v) => v
      None => false
    }
    match args {
      Some(a) =>
        // Avoid Node.js DEP0190 warning when combining `shell: true` with `args`.
        if use_shell {
          let args_text = a.join(" ")
          let command_with_args = if args_text == "" {
            command
          } else {
            "\{command} \{args_text}"
          }
          ffi_spawnSync_no_args(command_with_args, options)
        } else {
          ffi_spawnSync(command, a, options)
        }
      None => ffi_spawnSync_no_args(command, options)
    }
  })
}

///|
/// execSync(command[, options])
/// Synchronous version of exec - blocks until completion
#alias(exec_sync)
pub fn execSync(
  command : String,
  cwd? : String,
  env? : @core.Any,
  shell? : String,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
  stdio? : String,
) -> String raise @core.ThrowError {
  @core.throwable(fn() {
    let options = @core.new_object()
    if cwd is Some(v) {
      options["cwd"] = @core.any(v)
    }
    if env is Some(v) {
      options["env"] = v
    }
    if shell is Some(v) {
      options["shell"] = @core.any(v)
    }
    if timeout is Some(v) {
      options["timeout"] = @core.any(v)
    }
    if maxBuffer is Some(v) {
      options["maxBuffer"] = @core.any(v)
    }
    if input is Some(v) {
      options["input"] = @core.any(v)
    }
    options["encoding"] = @core.any(encoding.unwrap_or("utf8"))
    if stdio is Some(v) {
      options["stdio"] = @core.any(v)
    }
    ffi_execSync(command, options).cast()
  })
}

///|
/// execFileSync(file[, args][, options])
/// Synchronous version of execFile
#alias(exec_file_sync)
pub fn execFileSync(
  file : String,
  args? : Array[String],
  cwd? : String,
  env? : @core.Any,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String raise @core.ThrowError {
  @core.throwable(fn() {
    let options = @core.new_object()
    if cwd is Some(v) {
      options["cwd"] = @core.any(v)
    }
    if env is Some(v) {
      options["env"] = v
    }
    if timeout is Some(v) {
      options["timeout"] = @core.any(v)
    }
    if maxBuffer is Some(v) {
      options["maxBuffer"] = @core.any(v)
    }
    if input is Some(v) {
      options["input"] = @core.any(v)
    }
    options["encoding"] = @core.any(encoding.unwrap_or("utf8"))
    match args {
      Some(a) => ffi_execFileSync(file, a, options).cast()
      None => ffi_execFileSync_no_args(file, options).cast()
    }
  })
}
