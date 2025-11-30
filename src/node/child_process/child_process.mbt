// https://nodejs.org/api/child_process.html
// Based on @types/node child_process definitions

///| ChildProcess Type

///|
/// The ChildProcess class extends EventEmitter and represents a spawned child process
#external
pub type ChildProcess

///|
pub impl @js.JsImpl for ChildProcess

///|
pub impl @events.EventEmitterImpl for ChildProcess

///|
/// Get pid
pub fn ChildProcess::pid(self : ChildProcess) -> Int {
  @nostd.any(self)["pid"].cast()
}

///|
/// Get killed
pub fn ChildProcess::killed(self : ChildProcess) -> Bool {
  @nostd.any(self)["killed"].cast()
}

///|
/// Get exitCode
pub fn ChildProcess::exitCode(self : ChildProcess) -> Int {
  @nostd.any(self)["exitCode"].cast()
}

///|
/// Get signalCode
pub fn ChildProcess::signalCode(self : ChildProcess) -> String {
  @nostd.any(self)["signalCode"].cast()
}

///|
/// Get stdin
pub fn ChildProcess::stdin(self : ChildProcess) -> @streams.WritableStream {
  @nostd.any(self)["stdin"].cast()
}

///|
/// Get stdout
pub fn ChildProcess::stdout(self : ChildProcess) -> @streams.ReadableStream {
  @nostd.any(self)["stdout"].cast()
}

///|
/// Get stderr
pub fn ChildProcess::stderr(self : ChildProcess) -> @streams.ReadableStream {
  @nostd.any(self)["stderr"].cast()
}

///|
/// Listen for stderr 'data' event with typed callback
/// Callback receives: data (@nostd.Any) - typically Buffer or String
pub fn ChildProcess::on_stderr_data(
  self : ChildProcess,
  callback : (@nostd.Any) -> Unit,
) -> Unit {
  @nostd.any(self.stderr())._call("on", [@nostd.any("data"), @nostd.any(callback)])
  |> ignore
}

///| ChildProcess Methods

///|
/// Send a signal to the child process
pub fn ChildProcess::kill(self : ChildProcess, signal? : String) -> Bool {
  match signal {
    Some(sig) => @nostd.any(self)._call("kill", [@nostd.any(sig)]).cast()
    None => @nostd.any(self)._call("kill", []).cast()
  }
}

///|
/// Send a message to the child process (for IPC)
pub fn ChildProcess::send(self : ChildProcess, message : @nostd.Any) -> Bool {
  @nostd.any(self)._call("send", [message]).cast()
}

///|
/// Close the IPC channel between parent and child
pub fn ChildProcess::disconnect(self : ChildProcess) -> Unit {
  @nostd.any(self)._call("disconnect", []) |> ignore
}

///|
/// Prevent the parent process from waiting for this child
pub fn ChildProcess::unref(self : ChildProcess) -> Unit {
  @nostd.any(self)._call("unref", []) |> ignore
}

///|
/// Require the parent process to wait for this child
pub fn ChildProcess::ref_(self : ChildProcess) -> Unit {
  @nostd.any(self)._call("ref", []) |> ignore
}

///|
/// Module Functions
extern "js" fn ffi_require_child_process() -> @nostd.Any =
  #|() => require("node:child_process")

///|
/// spawn(command[, args][, options])
/// Spawns a new process using the given command
pub fn spawn(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : @nostd.Any,
  shell? : Bool,
  timeout? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @mbtconv.from_option_map({
    "cwd": cwd.map(fn(x) { @nostd.any(x) }),
    "env": env,
    "shell": shell.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "signal": signal.map(fn(x) { @nostd.any(x) }),
  })
  match args {
    Some(a) =>
      cp._call("spawn", [@nostd.any(command), @nostd.any(a), options]).cast()
    None => cp._call("spawn", [@nostd.any(command), options]).cast()
  }
}

///|
/// exec(command[, options][, callback])
/// Spawns a shell and executes a command, buffering the output
pub fn exec(
  command : String,
  callback : (@js.Nullish[@js.JsError], String, String) -> Unit,
  cwd? : String,
  env? : @nostd.Any,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @mbtconv.from_option_map({
    "cwd": cwd.map(fn(x) { @nostd.any(x) }),
    "env": env,
    "shell": shell.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "maxBuffer": max_buffer.map(fn(x) { @nostd.any(x) }),
    "signal": signal.map(fn(x) { @nostd.any(x) }),
  })
  cp._call("exec", [@nostd.any(command), options, @nostd.any(callback)]).cast()
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
#alias(exec_file)
pub fn execFile(
  file : String,
  args : Array[String],
  callback : (@js.Nullish[@js.JsError], String, String) -> Unit,
  cwd? : String,
  env? : @nostd.Any,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @mbtconv.from_option_map({
    "cwd": cwd.map(fn(x) { @nostd.any(x) }),
    "env": env,
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "maxBuffer": max_buffer.map(fn(x) { @nostd.any(x) }),
    "signal": signal.map(fn(x) { @nostd.any(x) }),
  })
  cp
  ._call("execFile", [
    @nostd.any(file),
    @nostd.any(args),
    options,
    @nostd.any(callback),
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
  env? : @nostd.Any,
  silent? : Bool,
  timeout? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @mbtconv.from_option_map({
    "cwd": cwd.map(fn(x) { @nostd.any(x) }),
    "env": env,
    "silent": silent.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "signal": signal.map(fn(x) { @nostd.any(x) }),
  })
  match args {
    Some(a) =>
      cp._call("fork", [@nostd.any(module_path), @nostd.any(a), options]).cast()
    None => cp._call("fork", [@nostd.any(module_path), options]).cast()
  }
}

///| Synchronous Functions

///|
/// SpawnSyncResult type for synchronous spawn operations
#external
pub type SpawnSyncResult

///|
pub impl @js.JsImpl for SpawnSyncResult

///|
/// Get pid
pub fn SpawnSyncResult::pid(self : SpawnSyncResult) -> Int {
  @nostd.any(self)["pid"].cast()
}

///|
/// Get status
pub fn SpawnSyncResult::status(self : SpawnSyncResult) -> Int? {
  let v = @nostd.any(self)["status"]
  if @nostd.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get signal
pub fn SpawnSyncResult::signal(self : SpawnSyncResult) -> String? {
  let v = @nostd.any(self)["signal"]
  if @nostd.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get stdout
pub fn SpawnSyncResult::stdout(self : SpawnSyncResult) -> @streams.ReadableStream {
  @nostd.any(self)["stdout"].cast()
}

///|
/// Get stderr
pub fn SpawnSyncResult::stderr(self : SpawnSyncResult) -> @streams.ReadableStream {
  @nostd.any(self)["stderr"].cast()
}

///|
/// Get error
pub fn SpawnSyncResult::error(self : SpawnSyncResult) -> @nostd.Any {
  @nostd.any(self)["error"]
}

///|
/// spawnSync(command[, args][, options])
/// Synchronous version of spawn - blocks until process exits
#alias(spawn_sync)
pub fn spawnSync(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : @nostd.Any,
  shell? : Bool,
  timeout? : Int,
  input? : String,
  stdio? : String,
) -> SpawnSyncResult raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @mbtconv.from_option_map({
      "cwd": cwd.map(fn(x) { @nostd.any(x) }),
      "env": env,
      "shell": shell.map(fn(x) { @nostd.any(x) }),
      "timeout": timeout.map(fn(x) { @nostd.any(x) }),
      "input": input.map(fn(x) { @nostd.any(x) }),
      "stdio": stdio.map(fn(x) { @nostd.any(x) }),
    })
    match args {
      Some(a) =>
        cp._call("spawnSync", [@nostd.any(command), @nostd.any(a), options]).cast()
      None => cp._call("spawnSync", [@nostd.any(command), options]).cast()
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
  env? : @nostd.Any,
  shell? : String,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
  stdio? : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @mbtconv.from_option_map({
      "cwd": cwd.map(fn(x) { @nostd.any(x) }),
      "env": env,
      "shell": shell.map(fn(x) { @nostd.any(x) }),
      "timeout": timeout.map(fn(x) { @nostd.any(x) }),
      "maxBuffer": maxBuffer.map(fn(x) { @nostd.any(x) }),
      "input": input.map(fn(x) { @nostd.any(x) }),
      "encoding": Some(@nostd.any(encoding.unwrap_or("utf8"))),
      "stdio": stdio.map(fn(x) { @nostd.any(x) }),
    })
    cp._call("execSync", [@nostd.any(command), options]).cast()
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
  env? : @nostd.Any,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @mbtconv.from_option_map({
      "cwd": cwd.map(fn(x) { @nostd.any(x) }),
      "env": env,
      "timeout": timeout.map(fn(x) { @nostd.any(x) }),
      "maxBuffer": maxBuffer.map(fn(x) { @nostd.any(x) }),
      "input": input.map(fn(x) { @nostd.any(x) }),
      "encoding": Some(@nostd.any(encoding.unwrap_or("utf8"))),
    })
    match args {
      Some(a) =>
        cp._call("execFileSync", [@nostd.any(file), @nostd.any(a), options]).cast()
      None => cp._call("execFileSync", [@nostd.any(file), options]).cast()
    }
  })
}
