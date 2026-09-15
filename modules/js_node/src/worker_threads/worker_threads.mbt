///|
/// Worker Threads API for Node.js
/// https://nodejs.org/api/worker_threads.html

///|
/// Worker class represents a worker thread
#external
pub type Worker

///|
pub fn Worker::as_any(self : Worker) -> @core.Any = "%identity"

///|
/// MessagePort represents a message port for communication
#external
pub type MessagePort

///|
pub fn MessagePort::as_any(self : MessagePort) -> @core.Any = "%identity"

///|
/// Module Functions
extern "js" fn ffi_require_worker_threads() -> @core.Any =
  #|() => require("node:worker_threads")

///|
/// Create a new Worker instance
/// https://nodejs.org/api/worker_threads.html#new-workerfilename-options
pub fn Worker::new(
  filename : String,
  workerData? : @core.Any,
  env? : @core.Any,
  stdin? : Bool,
  stdout? : Bool,
  stderr? : Bool,
  execArgv? : Array[String],
  resourceLimits? : @core.Any,
) -> Worker {
  let wt = ffi_require_worker_threads()
  let worker_class = wt._get("Worker")
  let entries : Array[(String, @core.Any)] = []
  if workerData is Some(v) {
    entries.push(("workerData", @core.identity(v)))
  }
  if env is Some(v) {
    entries.push(("env", @core.identity(v)))
  }
  if stdin is Some(v) {
    entries.push(("stdin", @core.any(v)))
  }
  if stdout is Some(v) {
    entries.push(("stdout", @core.any(v)))
  }
  if stderr is Some(v) {
    entries.push(("stderr", @core.any(v)))
  }
  if execArgv is Some(v) {
    entries.push(("execArgv", @core.identity(@core.any(v))))
  }
  if resourceLimits is Some(v) {
    entries.push(("resourceLimits", @core.identity(v)))
  }
  let js_opts = @core.from_entries(entries)
  @core.identity(@core.new(worker_class, [@core.any(filename), js_opts]))
}

///|
/// Post a message to the worker
/// https://nodejs.org/api/worker_threads.html#workerpostmessagevalue-transferlist
pub fn Worker::postMessage(
  self : Worker,
  value : @core.Any,
  transferList? : Array[@core.Any],
) -> Unit {
  match transferList {
    Some(list) =>
      self.as_any()._call("postMessage", [value, @core.any(list)]) |> ignore
    None => self.as_any()._call("postMessage", [value]) |> ignore
  }
}

///|
/// Terminate the worker
/// https://nodejs.org/api/worker_threads.html#workerterminate
pub extern "js" fn Worker::terminate(self : Worker) -> Unit =
  #|(self) => self.terminate()

///|
/// Prevent the worker from keeping the event loop active
pub extern "js" fn Worker::unref(self : Worker) -> Unit =
  #|(self) => self.unref()

///|
/// Require the worker to keep the event loop active
pub extern "js" fn Worker::ref_(self : Worker) -> Unit =
  #|(self) => self.ref()

///|
/// Get the threadId of the worker
pub extern "js" fn Worker::threadId(self : Worker) -> Int =
  #|(self) => self.threadId

///|
extern "js" fn Worker::ffi_stdin(
  self : Worker,
) -> @core.Nullish[@streams.WritableStream] =
  #|(self) => self.stdin

///|
/// Get the stdin stream of the worker (if enabled)
pub fn Worker::stdin(self : Worker) -> @streams.WritableStream? {
  self.ffi_stdin().to_option()
}

///|
extern "js" fn Worker::ffi_stdout(
  self : Worker,
) -> @core.Nullish[@streams.ReadableStream] =
  #|(self) => self.stdout

///|
/// Get the stdout stream of the worker (if enabled)
pub fn Worker::stdout(self : Worker) -> @streams.ReadableStream? {
  self.ffi_stdout().to_option()
}

///|
extern "js" fn Worker::ffi_stderr(
  self : Worker,
) -> @core.Nullish[@streams.ReadableStream] =
  #|(self) => self.stderr

///|
/// Get the stderr stream of the worker (if enabled)
pub fn Worker::stderr(self : Worker) -> @streams.ReadableStream? {
  self.ffi_stderr().to_option()
}

///|
/// MessagePort methods
pub fn MessagePort::postMessage(
  self : MessagePort,
  value : @core.Any,
  transferList? : Array[@core.Any],
) -> Unit {
  match transferList {
    Some(list) =>
      self.as_any()._call("postMessage", [value, @core.any(list)]) |> ignore
    None => self.as_any()._call("postMessage", [value]) |> ignore
  }
}

///|
/// Start receiving messages on this MessagePort
pub extern "js" fn MessagePort::start(self : MessagePort) -> Unit =
  #|(self) => self.start()

///|
/// Close the MessagePort
pub extern "js" fn MessagePort::close(self : MessagePort) -> Unit =
  #|(self) => self.close()

///|
/// Check if running in the main thread
/// https://nodejs.org/api/worker_threads.html#workerismainthread
pub extern "js" fn isMainThread() -> Bool =
  #|() => require("node:worker_threads").isMainThread

///|
extern "js" fn ffi_parent_port() -> @core.Nullish[MessagePort] =
  #|() => require("node:worker_threads").parentPort

///|
/// Get the parent port (null in main thread)
/// https://nodejs.org/api/worker_threads.html#workerparentport
pub fn parentPort() -> MessagePort? {
  ffi_parent_port().to_option()
}

///|
extern "js" fn ffi_worker_data() -> @core.Nullish[@core.Any] =
  #|() => require("node:worker_threads").workerData

///|
/// Get the worker data passed to the worker
/// https://nodejs.org/api/worker_threads.html#workerworkerdata
pub fn workerData() -> @core.Any? {
  ffi_worker_data().to_option()
}

///|
/// Get the thread ID of the current thread
/// https://nodejs.org/api/worker_threads.html#workerthreadid
pub extern "js" fn threadId() -> Int =
  #|() => require("node:worker_threads").threadId
