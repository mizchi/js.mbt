// https://nodejs.org/api/child_process.html
// Based on @types/node child_process definitions

///| ChildProcess Type

///|
/// The ChildProcess class extends EventEmitter and represents a spawned child process
#external
pub type ChildProcess

///|
pub impl JsImpl for ChildProcess

///|
pub impl EventEmitterImpl for ChildProcess

///|
/// Listen for stderr 'data' event with typed callback
/// Callback receives: data (Js) - typically Buffer or String
pub fn ChildProcess::on_stderr_data(
  self : Self,
  callback : (Js) -> Unit noraise,
) -> Unit {
  match self.stderr() {
    Some(stream) => stream.call2("on", "data", @js.from_fn1(callback)) |> ignore
    None => ()
  }
}

///| ChildProcess Properties

///|
/// The process identifier (PID)
pub fn ChildProcess::pid(self : Self) -> Int {
  self.get("pid") |> unsafe_cast
}

///|
/// Whether the process has been killed
pub fn ChildProcess::killed(self : Self) -> Bool {
  self.get("killed") |> unsafe_cast
}

///|
/// The exit code of the child process, or null if still running
pub fn ChildProcess::exitCode(self : Self) -> Int? {
  self.get("exitCode") |> @js.unsafe_cast_option()
}

///|
/// The signal that terminated the child process, or null
pub fn ChildProcess::signalCode(self : Self) -> String? {
  self.get("signalCode") |> @js.unsafe_cast_option()
}

///|
/// A readable stream representing the child process's stdin
pub fn ChildProcess::stdin(self : Self) -> WritableStream? {
  self.get("stdin") |> @js.unsafe_cast_option()
}

///|
/// A writable stream representing the child process's stdout
pub fn ChildProcess::stdout(self : Self) -> ReadableStream? {
  self.get("stdout") |> @js.unsafe_cast_option()
}

///|
/// A writable stream representing the child process's stderr
pub fn ChildProcess::stderr(self : Self) -> ReadableStream? {
  self.get("stderr") |> @js.unsafe_cast_option()
}

///| ChildProcess Methods

///|
/// Send a signal to the child process
pub fn ChildProcess::kill(self : Self, signal? : String) -> Bool {
  match signal {
    Some(sig) => self.call("kill", [sig]) |> unsafe_cast
    None => self.call0("kill") |> unsafe_cast
  }
}

///|
/// Send a message to the child process (for IPC)
pub fn ChildProcess::send(self : Self, message : &JsImpl) -> Bool {
  self.call("send", [message.to_js()]) |> unsafe_cast
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
extern "js" fn ffi_require_child_process() -> Js =
  #|() => require("node:child_process")

///|
/// spawn(command[, args][, options])
/// Spawns a new process using the given command
pub fn spawn(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : Js,
  shell? : Bool,
  timeout? : Int,
  signal? : AbortSignal,
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
      unsafe_cast(
        cp.call("spawn", [command |> js, a |> @js.from_array, options]),
      )
    None => cp.call2("spawn", command |> js, options) |> unsafe_cast
  }
}

///|
/// exec(command[, options][, callback])
/// Spawns a shell and executes a command, buffering the output
pub fn exec(
  command : String,
  callback : (Js?, String, String) -> Unit noraise,
  cwd? : String,
  env? : Js,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  signal? : AbortSignal,
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
  unsafe_cast(cp.call("exec", [command |> js, options, unsafe_cast(callback)]))
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
#alias(exec_file)
pub fn execFile(
  file : String,
  args : Array[String],
  callback : (Js?, String, String) -> Unit noraise,
  cwd? : String,
  env? : Js,
  timeout? : Int,
  max_buffer? : Int,
  signal? : AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("maxBuffer", max_buffer.map(x => x)),
    ("signal", signal.map(x => x.to_js())),
  ])
  unsafe_cast(
    cp.call("execFile", [
      file,
      args |> @js.from_array,
      options,
      unsafe_cast(callback),
    ]),
  )
}

///|
/// fork(modulePath[, args][, options])
/// Spawns a new Node.js process with IPC communication channel
pub fn fork(
  module_path : String,
  args? : Array[String],
  cwd? : String,
  env? : Js,
  silent? : Bool,
  timeout? : Int,
  signal? : AbortSignal,
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
      unsafe_cast(
        cp.call("fork", [module_path |> js, a |> @js.from_array, options]),
      )
    None => cp.call2("fork", module_path |> js, options) |> unsafe_cast
  }
}

///| Synchronous Functions

///|
/// SpawnSyncResult type for synchronous spawn operations
#external
pub type SpawnSyncResult

///|
pub impl JsImpl for SpawnSyncResult

///|
pub fn SpawnSyncResult::pid(self : Self) -> Int {
  self.get("pid") |> unsafe_cast
}

///|
pub fn SpawnSyncResult::status(self : Self) -> Int? {
  self.get("status") |> @js.unsafe_cast_option()
}

///|
pub fn SpawnSyncResult::signal(self : Self) -> String? {
  self.get("signal") |> @js.unsafe_cast_option()
}

///|
pub fn SpawnSyncResult::stdout(self : Self) -> @streams.ReadableStream {
  self.get("stdout") |> unsafe_cast
}

///|
pub fn SpawnSyncResult::stderr(self : Self) -> @streams.ReadableStream {
  self.get("stderr") |> unsafe_cast
}

///|
pub fn SpawnSyncResult::error(self : Self) -> Js? {
  self.get("error") |> @js.unsafe_cast_option()
}

///|
/// spawnSync(command[, args][, options])
/// Synchronous version of spawn - blocks until process exits
#alias(spawn_sync)
pub fn spawnSync(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : Js,
  shell? : Bool,
  timeout? : Int,
  input? : String,
) -> SpawnSyncResult {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("shell", shell.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("input", input.map(x => x)),
  ])
  match args {
    Some(a) =>
      unsafe_cast(cp.call("spawnSync", [command, a |> @js.from_array, options]))
    None => cp.call2("spawnSync", command |> js, options) |> unsafe_cast
  }
}

///|
/// execSync(command[, options])
/// Synchronous version of exec - blocks until completion
#alias(exec_sync)
pub fn execSync(
  command : String,
  cwd? : String,
  env? : Js,
  shell? : String,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("shell", shell.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("maxBuffer", maxBuffer.map(x => x)),
    ("input", input.map(x => x)),
    ("encoding", Some(encoding.or("utf8"))),
  ])
  cp.call2("execSync", command |> js, options) |> unsafe_cast
}

///|
/// execFileSync(file[, args][, options])
/// Synchronous version of execFile
#alias(exec_file_sync)
pub fn execFileSync(
  file : String,
  args? : Array[String],
  cwd? : String,
  env? : Js,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String {
  let cp = ffi_require_child_process()
  let options = @js.from_entries_option([
    ("cwd", cwd.map(x => x)),
    ("env", env.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("maxBuffer", maxBuffer.map(x => x)),
    ("input", input.map(x => x)),
    ("encoding", Some(encoding.or("utf8"))),
  ])
  match args {
    Some(a) =>
      unsafe_cast(cp.call("execFileSync", [file, a |> @js.from_array, options]))
    None => cp.call2("execFileSync", file, options) |> unsafe_cast
  }
}
