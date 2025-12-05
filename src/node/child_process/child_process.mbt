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
// pub impl @events.EventEmitterImpl for ChildProcess with to_any(self) -> @core.Any {
//   self.to_any()
// }

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
pub fn ChildProcess::send(self : ChildProcess, message : @core.Any) -> Bool {
  self.as_any()._call("send", [message]).cast()
}

///|
/// Close the IPC channel between parent and child
pub fn ChildProcess::disconnect(self : ChildProcess) -> Unit {
  self.as_any()._call("disconnect", []) |> ignore
}

///|
/// Prevent the parent process from waiting for this child
pub fn ChildProcess::unref(self : ChildProcess) -> Unit {
  self.as_any()._call("unref", []) |> ignore
}

///|
/// Require the parent process to wait for this child
pub fn ChildProcess::ref_(self : ChildProcess) -> Unit {
  self.as_any()._call("ref", []) |> ignore
}

///|
/// Module Functions
extern "js" fn ffi_require_child_process() -> @core.Any =
  #|() => require("node:child_process")

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
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let entries : Array[(String, @core.Any)] = []
  if cwd is Some(v) {
    entries.push(("cwd", @core.any(v)))
  }
  if env is Some(v) {
    entries.push(("env", v))
  }
  if shell is Some(v) {
    entries.push(("shell", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if signal is Some(v) {
    entries.push(("signal", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  match args {
    Some(a) =>
      cp._call("spawn", [@core.any(command), @core.any(a), options]).cast()
    None => cp._call("spawn", [@core.any(command), options]).cast()
  }
}

///|
/// exec(command[, options][, callback])
/// Spawns a shell and executes a command, buffering the output
pub fn exec(
  command : String,
  callback : (@js.Nullish[@error.JsError], String, String) -> Unit,
  cwd? : String,
  env? : @core.Any,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let entries : Array[(String, @core.Any)] = []
  if cwd is Some(v) {
    entries.push(("cwd", @core.any(v)))
  }
  if env is Some(v) {
    entries.push(("env", v))
  }
  if shell is Some(v) {
    entries.push(("shell", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if max_buffer is Some(v) {
    entries.push(("maxBuffer", @core.any(v)))
  }
  if signal is Some(v) {
    entries.push(("signal", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  cp._call("exec", [@core.any(command), options, @core.any(callback)]).cast()
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
#alias(exec_file)
pub fn execFile(
  file : String,
  args : Array[String],
  callback : (@js.Nullish[@error.JsError], String, String) -> Unit,
  cwd? : String,
  env? : @core.Any,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let entries : Array[(String, @core.Any)] = []
  if cwd is Some(v) {
    entries.push(("cwd", @core.any(v)))
  }
  if env is Some(v) {
    entries.push(("env", v))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if max_buffer is Some(v) {
    entries.push(("maxBuffer", @core.any(v)))
  }
  if signal is Some(v) {
    entries.push(("signal", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  cp
  ._call("execFile", [
    @core.any(file),
    @core.any(args),
    options,
    @core.any(callback),
  ])
  .cast()
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
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let entries : Array[(String, @core.Any)] = []
  if cwd is Some(v) {
    entries.push(("cwd", @core.any(v)))
  }
  if env is Some(v) {
    entries.push(("env", v))
  }
  if silent is Some(v) {
    entries.push(("silent", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if signal is Some(v) {
    entries.push(("signal", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  match args {
    Some(a) =>
      cp._call("fork", [@core.any(module_path), @core.any(a), options]).cast()
    None => cp._call("fork", [@core.any(module_path), options]).cast()
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
    let cp = ffi_require_child_process()
    let entries : Array[(String, @core.Any)] = []
    if cwd is Some(v) {
      entries.push(("cwd", @core.any(v)))
    }
    if env is Some(v) {
      entries.push(("env", v))
    }
    if shell is Some(v) {
      entries.push(("shell", @core.any(v)))
    }
    if timeout is Some(v) {
      entries.push(("timeout", @core.any(v)))
    }
    if input is Some(v) {
      entries.push(("input", @core.any(v)))
    }
    if stdio is Some(v) {
      entries.push(("stdio", @core.any(v)))
    }
    let options = @core.from_entries(entries)
    match args {
      Some(a) =>
        cp
        ._call("spawnSync", [@core.any(command), @core.any(a), options])
        .cast()
      None => cp._call("spawnSync", [@core.any(command), options]).cast()
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
    let cp = ffi_require_child_process()
    let entries : Array[(String, @core.Any)] = []
    if cwd is Some(v) {
      entries.push(("cwd", @core.any(v)))
    }
    if env is Some(v) {
      entries.push(("env", v))
    }
    if shell is Some(v) {
      entries.push(("shell", @core.any(v)))
    }
    if timeout is Some(v) {
      entries.push(("timeout", @core.any(v)))
    }
    if maxBuffer is Some(v) {
      entries.push(("maxBuffer", @core.any(v)))
    }
    if input is Some(v) {
      entries.push(("input", @core.any(v)))
    }
    entries.push(("encoding", @core.any(encoding.unwrap_or("utf8"))))
    if stdio is Some(v) {
      entries.push(("stdio", @core.any(v)))
    }
    let options = @core.from_entries(entries)
    cp._call("execSync", [@core.any(command), options]).cast()
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
    let cp = ffi_require_child_process()
    let entries : Array[(String, @core.Any)] = []
    if cwd is Some(v) {
      entries.push(("cwd", @core.any(v)))
    }
    if env is Some(v) {
      entries.push(("env", v))
    }
    if timeout is Some(v) {
      entries.push(("timeout", @core.any(v)))
    }
    if maxBuffer is Some(v) {
      entries.push(("maxBuffer", @core.any(v)))
    }
    if input is Some(v) {
      entries.push(("input", @core.any(v)))
    }
    entries.push(("encoding", @core.any(encoding.unwrap_or("utf8"))))
    let options = @core.from_entries(entries)
    match args {
      Some(a) =>
        cp
        ._call("execFileSync", [@core.any(file), @core.any(a), options])
        .cast()
      None => cp._call("execFileSync", [@core.any(file), options]).cast()
    }
  })
}
