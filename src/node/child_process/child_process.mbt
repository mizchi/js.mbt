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
/// Callback receives: data (@js.Js) - typically Buffer or String
pub fn ChildProcess::on_stderr_data(
  self : Self,
  callback : (@js.Js) -> Unit noraise,
) -> Unit {
  self.stderr.call2("on", "data", @js.from_fn1(callback)) |> ignore
}

///| ChildProcess Methods

///|
/// Send a signal to the child process
pub fn ChildProcess::kill(self : Self, signal? : String) -> Bool {
  match signal {
    Some(sig) => self.call("kill", [sig]) |> @js.unsafe_cast
    None => self.call0("kill") |> @js.unsafe_cast
  }
}

///|
/// Send a message to the child process (for IPC)
pub fn ChildProcess::send(self : Self, message : &@js.JsImpl) -> Bool {
  self.call("send", [message.to_js()]) |> @js.unsafe_cast
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
extern "js" fn ffi_require_child_process() -> @js.Js =
  #|() => require("node:child_process")

///|
/// spawn(command[, args][, options])
/// Spawns a new process using the given command
pub fn spawn(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : @js.Js,
  shell? : Bool,
  timeout? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("shell", shell.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("signal", signal.map(x => x.to_js())),
  ])
  match args {
    Some(a) =>
      cp.call("spawn", [command |> @js.js, a |> @js.from_array, options])
      |> @js.unsafe_cast
    None => cp.call2("spawn", command |> @js.js, options) |> @js.unsafe_cast
  }
}

///|
/// exec(command[, options][, callback])
/// Spawns a shell and executes a command, buffering the output
pub fn exec(
  command : String,
  callback : (@js.Js?, String, String) -> Unit noraise,
  cwd? : String,
  env? : @js.Js,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("shell", shell.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("maxBuffer", max_buffer.map(x => x)),
    ("signal", signal.map(x => x.to_js())),
  ])
  cp.call("exec", [command |> @js.js, options, @js.unsafe_cast(callback)])
  |> @js.unsafe_cast
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
#alias(exec_file)
pub fn execFile(
  file : String,
  args : Array[String],
  callback : (@js.Js?, String, String) -> Unit noraise,
  cwd? : String,
  env? : @js.Js,
  timeout? : Int,
  max_buffer? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("maxBuffer", max_buffer.map(x => x)),
    ("signal", signal.map(x => x.to_js())),
  ])
  cp.call("execFile", [
    file,
    args |> @js.from_array,
    options,
    @js.unsafe_cast(callback),
  ])
  |> @js.unsafe_cast
}

///|
/// fork(modulePath[, args][, options])
/// Spawns a new Node.js process with IPC communication channel
pub fn fork(
  module_path : String,
  args? : Array[String],
  cwd? : String,
  env? : @js.Js,
  silent? : Bool,
  timeout? : Int,
  signal? : @js.AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("silent", silent.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("signal", signal.map(x => x.to_js())),
  ])
  match args {
    Some(a) =>
      cp.call("fork", [module_path |> @js.js, a |> @js.from_array, options])
      |> @js.unsafe_cast
    None => cp.call2("fork", module_path |> @js.js, options) |> @js.unsafe_cast
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
  error : @js.Js
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
  env? : @js.Js,
  shell? : Bool,
  timeout? : Int,
  input? : String,
  stdio? : String,
) -> SpawnSyncResult raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @js.from_entries_option([
      ("cwd", cwd.map(x => x)),
      ("env", env.map(x => x)),
      ("shell", shell.map(x => x)),
      ("timeout", timeout.map(x => x)),
      ("input", input.map(x => x)),
      ("stdio", stdio.map(x => x)),
    ])
    match args {
      Some(a) =>
        cp.call("spawnSync", [command, a |> @js.from_array, options])
        |> @js.unsafe_cast
      None =>
        cp.call2("spawnSync", command |> @js.js, options) |> @js.unsafe_cast
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
  env? : @js.Js,
  shell? : String,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
  stdio? : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @js.from_entries_option([
      ("cwd", cwd.map(x => x)),
      ("env", env.map(x => x)),
      ("shell", shell.map(x => x)),
      ("timeout", timeout.map(x => x)),
      ("maxBuffer", maxBuffer.map(x => x)),
      ("input", input.map(x => x)),
      ("encoding", Some(encoding.unwrap_or("utf8"))),
      ("stdio", stdio.map(x => x)),
    ])
    cp.call2("execSync", command |> @js.js, options) |> @js.unsafe_cast
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
  env? : @js.Js,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let cp = ffi_require_child_process()
    let options = @js.from_entries_option([
      ("cwd", cwd.map(x => x)),
      ("env", env.map(x => x)),
      ("timeout", timeout.map(x => x)),
      ("maxBuffer", maxBuffer.map(x => x)),
      ("input", input.map(x => x)),
      ("encoding", Some(encoding.unwrap_or("utf8"))),
    ])
    match args {
      Some(a) =>
        cp.call("execFileSync", [file, a |> @js.from_array, options])
        |> @js.unsafe_cast
      None => cp.call2("execFileSync", file, options) |> @js.unsafe_cast
    }
  })
}
