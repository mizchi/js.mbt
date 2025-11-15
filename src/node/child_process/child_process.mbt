// https://nodejs.org/api/child_process.html
// Based on @types/node child_process definitions

///|
using @js {js, unsafe_cast, type Val, trait Js}

///|
using @async {type AbortSignal}

///|
using @events {trait EventEmitter}

///|
using @stream {type ReadableStream, type WritableStream}

///| ChildProcess Type

///|
/// The ChildProcess class extends EventEmitter and represents a spawned child process
#external
pub type ChildProcess

///|
pub impl Js for ChildProcess with to_js(self) -> Val {
  self |> js
}

///|
/// Implement EventEmitter trait for ChildProcess
pub impl EventEmitter for ChildProcess with on(
  self : ChildProcess,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("on", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for ChildProcess with once(
  self : ChildProcess,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("once", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for ChildProcess with off(
  self : ChildProcess,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("off", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for ChildProcess with emit(
  self : ChildProcess,
  name : String,
  payload : Val,
) -> Unit {
  self.invoke("emit", [name, payload]) |> unsafe_cast
}

///| ChildProcess Typed Event Handlers

///|
/// Listen for 'exit' event with typed callback
/// Callback receives: code (Int?), signal (String?)
pub fn ChildProcess::on_exit(
  self : Self,
  callback : (Int?, String?) -> Unit noraise,
) -> Unit {
  self
  .to_js()
  .invoke("on", [
    "exit",
    unsafe_cast(fn(code : Val, signal : Val) {
      callback(code.cast_option(), signal.cast_option())
    }),
  ])
  |> ignore
}

///|
/// Listen for 'close' event with typed callback
/// Callback receives: code (Int?), signal (String?)
pub fn ChildProcess::on_close(
  self : Self,
  callback : (Int?, String?) -> Unit noraise,
) -> Unit {
  self
  .to_js()
  .invoke("on", [
    "close",
    unsafe_cast(fn(code : Val, signal : Val) {
      callback(code.cast_option(), signal.cast_option())
    }),
  ])
  |> ignore
}

///|
/// Listen for 'error' event with typed callback
/// Callback receives: error (Val)
pub fn ChildProcess::on_error(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.to_js().invoke("on", ["error", unsafe_cast(callback)]) |> ignore
}

///|
/// Listen for 'message' event with typed callback
/// Callback receives: message (Val), sendHandle (Val?)
pub fn ChildProcess::on_message(
  self : Self,
  callback : (Val, Val?) -> Unit noraise,
) -> Unit {
  self
  .to_js()
  .invoke("on", [
    "message",
    unsafe_cast(fn(message : Val, sendHandle : Val) {
      callback(message, sendHandle.cast_option())
    }),
  ])
  |> ignore
}

///|
/// Listen for 'disconnect' event with typed callback
/// No parameters
pub fn ChildProcess::on_disconnect(
  self : Self,
  callback : () -> Unit noraise,
) -> Unit {
  self.to_js().invoke("on", ["disconnect", unsafe_cast(callback)]) |> ignore
}

///|
/// Listen for 'spawn' event with typed callback
/// No parameters
pub fn ChildProcess::on_spawn(
  self : Self,
  callback : () -> Unit noraise,
) -> Unit {
  self.to_js().invoke("on", ["spawn", unsafe_cast(callback)]) |> ignore
}

///|
/// Listen for stdout 'data' event with typed callback
/// Callback receives: data (Val) - typically Buffer or String
pub fn ChildProcess::on_stdout_data(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  match self.stdout() {
    Some(stream) =>
      stream.to_js().invoke("on", ["data", unsafe_cast(callback)]) |> ignore
    None => ()
  }
}

///|
/// Listen for stderr 'data' event with typed callback
/// Callback receives: data (Val) - typically Buffer or String
pub fn ChildProcess::on_stderr_data(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  match self.stderr() {
    Some(stream) =>
      stream.to_js().invoke("on", ["data", unsafe_cast(callback)]) |> ignore
    None => ()
  }
}

///| ChildProcess Properties

///|
/// The process identifier (PID)
pub fn ChildProcess::pid(self : Self) -> Int {
  unsafe_cast(self.to_js().get("pid"))
}

///|
/// Whether the process has been killed
pub fn ChildProcess::killed(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("killed"))
}

///|
/// The exit code of the child process, or null if still running
pub fn ChildProcess::exit_code(self : Self) -> Int? {
  self.to_js().get("exitCode").cast_option()
}

///|
/// The signal that terminated the child process, or null
pub fn ChildProcess::signal_code(self : Self) -> String? {
  self.to_js().get("signalCode").cast_option()
}

///|
/// A readable stream representing the child process's stdin
pub fn ChildProcess::stdin(self : Self) -> WritableStream? {
  self.to_js().get("stdin").cast_option()
}

///|
/// A writable stream representing the child process's stdout
pub fn ChildProcess::stdout(self : Self) -> ReadableStream? {
  self.to_js().get("stdout").cast_option()
}

///|
/// A writable stream representing the child process's stderr
pub fn ChildProcess::stderr(self : Self) -> ReadableStream? {
  self.to_js().get("stderr").cast_option()
}

///| ChildProcess Methods

///|
/// Send a signal to the child process
pub fn ChildProcess::kill(self : Self, signal? : String) -> Bool {
  match signal {
    Some(sig) => self.invoke("kill", [sig |> js]) |> unsafe_cast
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
  self.to_js().invoke("disconnect", []) |> ignore
}

///|
/// Prevent the parent process from waiting for this child
pub fn ChildProcess::unref(self : Self) -> Unit {
  self.to_js().invoke("unref", []) |> ignore
}

///|
/// Require the parent process to wait for this child
pub fn ChildProcess::ref_(self : Self) -> Unit {
  self.to_js().invoke("ref", []) |> ignore
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
  let options = @js.new_empty_object()
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
      unsafe_cast(cp.invoke("spawn", [command |> js, a |> js, options]))
    None => unsafe_cast(cp.invoke("spawn", [command |> js, options]))
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
  let options = @js.new_empty_object()
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
    cp.invoke("exec", [command |> js, options, unsafe_cast(callback)]),
  )
}

///|
/// execFile(file[, args][, options][, callback])
/// Executes a file directly without spawning a shell
pub fn exec_file(
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
  let options = @js.new_empty_object()
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
  let options = @js.new_empty_object()
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
      unsafe_cast(cp.invoke("fork", [module_path |> js, a |> js, options]))
    None => unsafe_cast(cp.invoke("fork", [module_path |> js, options]))
  }
}

///| Synchronous Functions

///|
/// SpawnSyncResult type for synchronous spawn operations
#external
pub type SpawnSyncResult

///|
pub impl Js for SpawnSyncResult with to_js(self) -> Val {
  self |> js
}

///|
pub fn SpawnSyncResult::pid(self : Self) -> Int {
  unsafe_cast(self.to_js().get("pid"))
}

///|
pub fn SpawnSyncResult::status(self : Self) -> Int? {
  self.to_js().get("status").cast_option()
}

///|
pub fn SpawnSyncResult::signal(self : Self) -> String? {
  self.to_js().get("signal").cast_option()
}

///|
pub fn SpawnSyncResult::stdout(self : Self) -> Val {
  self.to_js().get("stdout")
}

///|
pub fn SpawnSyncResult::stderr(self : Self) -> Val {
  self.to_js().get("stderr")
}

///|
pub fn SpawnSyncResult::error(self : Self) -> Val? {
  self.to_js().get("error").cast_option()
}

///|
/// spawnSync(command[, args][, options])
/// Synchronous version of spawn - blocks until process exits
pub fn spawn_sync(
  command : String,
  args? : Array[String],
  cwd? : String,
  env? : Val,
  shell? : Bool,
  timeout? : Int,
  input? : String,
) -> SpawnSyncResult {
  let cp = ffi_require_child_process()
  let options = @js.new_empty_object()
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
      unsafe_cast(cp.invoke("spawnSync", [command |> js, a |> js, options]))
    None => unsafe_cast(cp.invoke("spawnSync", [command |> js, options]))
  }
}

///|
/// execSync(command[, options])
/// Synchronous version of exec - blocks until completion
pub fn exec_sync(
  command : String,
  cwd? : String,
  env? : Val,
  shell? : String,
  timeout? : Int,
  max_buffer? : Int,
  input? : String,
  encoding? : String,
) -> String {
  let cp = ffi_require_child_process()
  let options = @js.new_empty_object()
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
  if input is Some(i) {
    options.set("input", i)
  }
  if encoding is Some(enc) {
    options.set("encoding", enc)
  } else {
    options.set("encoding", "utf8")
  }
  unsafe_cast(cp.invoke("execSync", [command |> js, options]))
}

///|
/// execFileSync(file[, args][, options])
/// Synchronous version of execFile
pub fn exec_file_sync(
  file : String,
  args? : Array[String],
  cwd? : String,
  env? : Val,
  timeout? : Int,
  max_buffer? : Int,
  input? : String,
  encoding? : String,
) -> String {
  let cp = ffi_require_child_process()
  let options = @js.new_empty_object()
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
      unsafe_cast(cp.invoke("execFileSync", [file |> js, a |> js, options]))
    None => unsafe_cast(cp.invoke("execFileSync", [file |> js, options]))
  }
}
