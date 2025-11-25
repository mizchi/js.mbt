// https://nodejs.org/api/child_process.html
// Based on @types/node child_process definitions

///| ChildProcess Type

///|
/// The ChildProcess class extends EventEmitter and represents a spawned child process
pub(all) struct ChildProcess {
  pid : Int
  killed : Bool
  exitCode : Int
  signalCode : String
  stdin : @streams.WritableStream
  stdout : @streams.ReadableStream
  stderr : @streams.ReadableStream
}

///|
pub impl @js.JsImpl for ChildProcess

///|
pub impl @events.EventEmitterImpl for ChildProcess

///|
/// Listen for stderr 'data' event with typed callback
/// Callback receives: data (@js.Any) - typically Buffer or String
pub fn ChildProcess::on_stderr_data(
  self : Self,
  callback : (@js.Any) -> Unit noraise,
) -> Unit {
  self.stderr.call2("on", "data", @js.from_fn1(callback)) |> ignore
}

///| ChildProcess Methods

///|
/// Send a signal to the child process
pub fn ChildProcess::kill(self : Self, signal? : String) -> Bool {
  match signal {
    Some(sig) => self.call("kill", [sig]).cast()
    None => self.call0("kill").cast()
  }
}

///|
/// Send a message to the child process (for IPC)
pub fn ChildProcess::send(self : Self, message : &@js.JsImpl) -> Bool {
  self.call("send", [message.to_any()]).cast()
}

///|
/// Close the IPC channel between parent and child
pub fn ChildProcess::disconnect(self : Self) -> Unit {
  self.call0("disconnect") |> ignore
}

///|
/// Prevent the parent process from waiting for this child
pub fn ChildProcess::unref(self : Self) -> Unit {
  self.call0("unref") |> ignore
}

///|
/// Require the parent process to wait for this child
pub fn ChildProcess::ref_(self : Self) -> Unit {
  self.call0("ref") |> ignore
}

///|
/// Module Functions
extern "js" fn ffi_require_child_process() -> @js.Any =
  #|() => require("node:child_process")

///|
/// spawn(command[, args][, options])
/// Spawns a new process using the given command
pub fn spawn(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : @js.Any,
  shell? : Bool,
  timeout? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_option_map({
    "cwd": cwd.map(fn(x) { @js.any(x) }),
    "env": env,
    "shell": shell.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "signal": signal.map(fn(x) { x.to_any() }),
  })
  match args {
    Some(a) => cp.call("spawn", [command, a |> @js.from_array, options]).cast()
    None => cp.call2("spawn", command, options).cast()
  }
}

///|
/// exec(command[, options][, callback])
/// Spawns a shell and executes a command, buffering the output
pub fn exec(
  command : String,
  callback : (@js.Any?, String, String) -> Unit noraise,
  cwd? : String,
  env? : @js.Any,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_option_map({
    "cwd": cwd.map(fn(x) { @js.any(x) }),
    "env": env,
    "shell": shell.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "maxBuffer": max_buffer.map(fn(x) { @js.any(x) }),
    "signal": signal.map(fn(x) { x.to_any() }),
  })
  cp.call("exec", [command |> @js.any, options, @js.identity(callback)]).cast()
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
#alias(exec_file)
pub fn execFile(
  file : String,
  args : Array[String],
  callback : (@js.Any?, String, String) -> Unit noraise,
  cwd? : String,
  env? : @js.Any,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_option_map({
    "cwd": cwd.map(fn(x) { @js.any(x) }),
    "env": env,
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "maxBuffer": max_buffer.map(fn(x) { @js.any(x) }),
    "signal": signal.map(fn(x) { x.to_any() }),
  })
  cp
  .call("execFile", [
    file,
    args |> @js.from_array,
    options,
    @js.identity(callback),
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
  env? : @js.Any,
  silent? : Bool,
  timeout? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_option_map({
    "cwd": cwd.map(fn(x) { @js.any(x) }),
    "env": env,
    "silent": silent.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "signal": signal.map(fn(x) { x.to_any() }),
  })
  match args {
    Some(a) =>
      cp
      .call("fork", [module_path |> @js.any, a |> @js.from_array, options])
      .cast()
    None => cp.call2("fork", module_path |> @js.any, options).cast()
  }
}

///| Synchronous Functions

///|
/// SpawnSyncResult type for synchronous spawn operations
pub(all) struct SpawnSyncResult {
  pid : Int
  status : Int?
  signal : String?
  stdout : @streams.ReadableStream
  stderr : @streams.ReadableStream
  error : @js.Any
}

///|
pub impl @js.JsImpl for SpawnSyncResult

///|
/// spawnSync(command[, args][, options])
/// Synchronous version of spawn - blocks until process exits
#alias(spawn_sync)
pub fn spawnSync(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : @js.Any,
  shell? : Bool,
  timeout? : Int,
  input? : String,
  stdio? : String,
) -> SpawnSyncResult raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @js.from_option_map({
      "cwd": cwd.map(fn(x) { @js.any(x) }),
      "env": env,
      "shell": shell.map(fn(x) { @js.any(x) }),
      "timeout": timeout.map(fn(x) { @js.any(x) }),
      "input": input.map(fn(x) { @js.any(x) }),
      "stdio": stdio.map(fn(x) { @js.any(x) }),
    })
    match args {
      Some(a) =>
        cp.call("spawnSync", [command, a |> @js.from_array, options]).cast()
      None => cp.call2("spawnSync", command |> @js.any, options).cast()
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
  env? : @js.Any,
  shell? : String,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
  stdio? : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @js.from_option_map({
      "cwd": cwd.map(fn(x) { @js.any(x) }),
      "env": env,
      "shell": shell.map(fn(x) { @js.any(x) }),
      "timeout": timeout.map(fn(x) { @js.any(x) }),
      "maxBuffer": maxBuffer.map(fn(x) { @js.any(x) }),
      "input": input.map(fn(x) { @js.any(x) }),
      "encoding": Some(@js.any(encoding.unwrap_or("utf8"))),
      "stdio": stdio.map(fn(x) { @js.any(x) }),
    })
    cp.call2("execSync", command |> @js.any, options).cast()
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
  env? : @js.Any,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @js.from_option_map({
      "cwd": cwd.map(fn(x) { @js.any(x) }),
      "env": env,
      "timeout": timeout.map(fn(x) { @js.any(x) }),
      "maxBuffer": maxBuffer.map(fn(x) { @js.any(x) }),
      "input": input.map(fn(x) { @js.any(x) }),
      "encoding": Some(@js.any(encoding.unwrap_or("utf8"))),
    })
    match args {
      Some(a) =>
        cp.call("execFileSync", [file, a |> @js.from_array, options]).cast()
      None => cp.call2("execFileSync", file, options).cast()
    }
  })
}
