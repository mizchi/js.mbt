// https://nodejs.org/api/child_process.html
// Based on @types/node child_process definitions

///| ChildProcess Type

///|
/// The ChildProcess class extends EventEmitter and represents a spawned child process
#external
pub type ChildProcess

///|
pub impl Js for ChildProcess

///|
pub impl EventEmitterImpl for ChildProcess

///|
/// Listen for stderr 'data' event with typed callback
/// Callback receives: data (Val) - typically Buffer or String
pub fn ChildProcess::on_stderr_data(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  match self.stderr() {
    Some(stream) =>
      stream.invoke("on", ["data", @js.from_fn1(callback)]) |> ignore
    None => ()
  }
}

///| ChildProcess Properties

///|
/// The process identifier (PID)
pub fn ChildProcess::pid(self : Self) -> Int {
  unsafe_cast(self.get("pid"))
}

///|
/// Whether the process has been killed
pub fn ChildProcess::killed(self : Self) -> Bool {
  unsafe_cast(self.get("killed"))
}

///|
/// The exit code of the child process, or null if still running
pub fn ChildProcess::exitCode(self : Self) -> Int? {
  self.get("exitCode") |> unsafe_option()
}

///|
/// The signal that terminated the child process, or null
pub fn ChildProcess::signalCode(self : Self) -> String? {
  self.get("signalCode") |> unsafe_option()
}

///|
/// A readable stream representing the child process's stdin
pub fn ChildProcess::stdin(self : Self) -> WritableStream? {
  self.get("stdin") |> unsafe_option()
}

///|
/// A writable stream representing the child process's stdout
pub fn ChildProcess::stdout(self : Self) -> ReadableStream? {
  self.get("stdout") |> unsafe_option()
}

///|
/// A writable stream representing the child process's stderr
pub fn ChildProcess::stderr(self : Self) -> ReadableStream? {
  self.get("stderr") |> unsafe_option()
}

///| ChildProcess Methods

///|
/// Send a signal to the child process
pub fn ChildProcess::kill(self : Self, signal? : String) -> Bool {
  match signal {
    Some(sig) => self.invoke("kill", [sig]) |> unsafe_cast
    None => self.invoke("kill", []) |> unsafe_cast
  }
}

///|
/// Send a message to the child process (for IPC)
pub fn ChildProcess::send(self : Self, message : &Js) -> Bool {
  self.invoke("send", [message.to_js()]) |> unsafe_cast
}

///|
/// Close the IPC channel between parent and child
pub fn ChildProcess::disconnect(self : Self) -> Unit {
  self.invoke("disconnect", []) |> ignore
}

///|
/// Prevent the parent process from waiting for this child
pub fn ChildProcess::unref(self : Self) -> Unit {
  self.invoke("unref", []) |> ignore
}

///|
/// Require the parent process to wait for this child
pub fn ChildProcess::ref_(self : Self) -> Unit {
  self.invoke("ref", []) |> ignore
}

///|
/// Module Functions
extern "js" fn ffi_require_child_process() -> Val =
  #|() => require("node:child_process")

///|
/// spawn(command[, args][, options])
/// Spawns a new process using the given command
pub fn spawn(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : Val,
  shell? : Bool,
  timeout? : Int,
  signal? : AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.Object::new()
  if args is Some(_) {
    // args will be passed separately
  }
  if cwd is Some(c) {
    options.set("cwd", c)
  }
  if env is Some(e) {
    options.set("env", e)
  }
  if shell is Some(s) {
    options.set("shell", s)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  if signal is Some(sig) {
    options.set("signal", sig.to_js())
  }
  match args {
    Some(a) =>
      unsafe_cast(
        cp.invoke("spawn", [command |> safe_js, a |> @js.from_array, options]),
      )
    None => unsafe_cast(cp.invoke("spawn", [command |> safe_js, options]))
  }
}

///|
/// exec(command[, options][, callback])
/// Spawns a shell and executes a command, buffering the output
pub fn exec(
  command : String,
  callback : (Val, String, String) -> Unit noraise,
  cwd? : String,
  env? : Val,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  signal? : AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.Object::new()
  if cwd is Some(c) {
    options.set("cwd", c)
  }
  if env is Some(e) {
    options.set("env", e)
  }
  if shell is Some(s) {
    options.set("shell", s)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  if max_buffer is Some(mb) {
    options.set("maxBuffer", mb)
  }
  if signal is Some(sig) {
    options.set("signal", sig.to_js())
  }
  unsafe_cast(
    cp.invoke("exec", [command |> safe_js, options, unsafe_cast(callback)]),
  )
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
#alias(exec_file)
pub fn execFile(
  file : String,
  args : Array[String],
  callback : (Val, String, String) -> Unit noraise,
  cwd? : String,
  env? : Val,
  timeout? : Int,
  max_buffer? : Int,
  signal? : AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.Object::new()
  if cwd is Some(c) {
    options.set("cwd", c)
  }
  if env is Some(e) {
    options.set("env", e)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  if max_buffer is Some(mb) {
    options.set("maxBuffer", mb)
  }
  if signal is Some(sig) {
    options.set("signal", sig.to_js())
  }
  unsafe_cast(
    cp.invoke("execFile", [
      file |> js,
      args |> js,
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
  env? : Val,
  silent? : Bool,
  timeout? : Int,
  signal? : AbortSignal,
) -> ChildProcess {
  let cp = ffi_require_child_process()
  let options = @js.Object::new()
  if cwd is Some(c) {
    options.set("cwd", c)
  }
  if env is Some(e) {
    options.set("env", e)
  }
  if silent is Some(s) {
    options.set("silent", s)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  if signal is Some(sig) {
    options.set("signal", sig.to_js())
  }
  match args {
    Some(a) =>
      unsafe_cast(
        cp.invoke("fork", [module_path |> safe_js, a |> @js.from_array, options]),
      )
    None => unsafe_cast(cp.invoke("fork", [module_path |> safe_js, options]))
  }
}

///| Synchronous Functions

///|
/// SpawnSyncResult type for synchronous spawn operations
#external
pub type SpawnSyncResult

///|
pub impl Js for SpawnSyncResult

///|
pub fn SpawnSyncResult::pid(self : Self) -> Int {
  unsafe_cast(self.get("pid"))
}

///|
pub fn SpawnSyncResult::status(self : Self) -> Int? {
  self.get("status") |> unsafe_option()
}

///|
pub fn SpawnSyncResult::signal(self : Self) -> String? {
  self.get("signal") |> unsafe_option()
}

///|
pub fn SpawnSyncResult::stdout(self : Self) -> @stream.ReadableStream {
  self.get("stdout") |> unsafe_cast
}

///|
pub fn SpawnSyncResult::stderr(self : Self) -> @stream.ReadableStream {
  self.get("stderr") |> unsafe_cast
}

///|
pub fn SpawnSyncResult::error(self : Self) -> Val? {
  self.get("error") |> unsafe_option()
}

///|
/// spawnSync(command[, args][, options])
/// Synchronous version of spawn - blocks until process exits
#alias(spawn_sync)
pub fn spawnSync(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : Val,
  shell? : Bool,
  timeout? : Int,
  input? : String,
) -> SpawnSyncResult {
  let cp = ffi_require_child_process()
  let options = @js.Object::new()
  if cwd is Some(c) {
    options.set("cwd", c)
  }
  if env is Some(e) {
    options.set("env", e)
  }
  if shell is Some(s) {
    options.set("shell", s)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  if input is Some(i) {
    options.set("input", i)
  }
  match args {
    Some(a) =>
      unsafe_cast(
        cp.invoke("spawnSync", [command |> safe_js, a |> js, options]),
      )
    None => unsafe_cast(cp.invoke("spawnSync", [command |> safe_js, options]))
  }
}

///|
/// execSync(command[, options])
/// Synchronous version of exec - blocks until completion
#alias(exec_sync)
pub fn execSync(
  command : String,
  cwd? : String,
  env? : Val,
  shell? : String,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String {
  let cp = ffi_require_child_process()
  let options = @js.Object::new()
  if cwd is Some(c) {
    options.set("cwd", c)
  }
  if env is Some(e) {
    options.set("env", e)
  }
  if shell is Some(s) {
    options.set("shell", s)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  if maxBuffer is Some(mb) {
    options.set("maxBuffer", mb)
  }
  if input is Some(i) {
    options.set("input", i)
  }
  if encoding is Some(enc) {
    options.set("encoding", enc)
  } else {
    options.set("encoding", "utf8")
  }
  unsafe_cast(cp.invoke("execSync", [command |> safe_js, options]))
}

///|
/// execFileSync(file[, args][, options])
/// Synchronous version of execFile
#alias(exec_file_sync)
pub fn execFileSync(
  file : String,
  args? : Array[String],
  cwd? : String,
  env? : Val,
  timeout? : Int,
  maxBuffer? : Int,
  input? : String,
  encoding? : String,
) -> String {
  let cp = ffi_require_child_process()
  let options = @js.Object::new()
  if cwd is Some(c) {
    options.set("cwd", c)
  }
  if env is Some(e) {
    options.set("env", e)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  if maxBuffer is Some(mb) {
    options.set("maxBuffer", mb)
  }
  if input is Some(i) {
    options.set("input", i)
  }
  if encoding is Some(enc) {
    options.set("encoding", enc)
  } else {
    options.set("encoding", "utf8")
  }
  match args {
    Some(a) =>
      unsafe_cast(
        cp.invoke("execFileSync", [file, a |> @js.from_array, options]),
      )
    None => unsafe_cast(cp.invoke("execFileSync", [file, options]))
  }
}
