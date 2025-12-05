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
extern "js" fn ffi_get_thread_id() -> Int =
  #|() => require("node:worker_threads").threadId

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
pub fn Worker::terminate(self : Worker) -> Unit {
  self.as_any()._call("terminate", []) |> ignore
}

///|
/// Prevent the worker from keeping the event loop active
pub fn Worker::unref(self : Worker) -> Unit {
  self.as_any()._call("unref", []) |> ignore
}

///|
/// Require the worker to keep the event loop active
pub fn Worker::ref_(self : Worker) -> Unit {
  self.as_any()._call("ref", []) |> ignore
}

///|
/// Get the threadId of the worker
pub fn Worker::threadId(self : Worker) -> Int {
  self.as_any()._get("threadId").cast()
}

///|
/// Get the stdin stream of the worker (if enabled)
pub fn Worker::stdin(self : Worker) -> @streams.WritableStream? {
  self.as_any()._get("stdin") |> @core.identity_option()
}

///|
/// Get the stdout stream of the worker (if enabled)
pub fn Worker::stdout(self : Worker) -> @streams.ReadableStream? {
  self.as_any()._get("stdout") |> @core.identity_option()
}

///|
/// Get the stderr stream of the worker (if enabled)
pub fn Worker::stderr(self : Worker) -> @streams.ReadableStream? {
  self.as_any()._get("stderr") |> @core.identity_option()
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
pub fn MessagePort::start(self : MessagePort) -> Unit {
  self.as_any()._call("start", []) |> ignore
}

///|
/// Close the MessagePort
pub fn MessagePort::close(self : MessagePort) -> Unit {
  self.as_any()._call("close", []) |> ignore
}

///|
/// Check if running in the main thread
/// https://nodejs.org/api/worker_threads.html#workerismainthread
pub fn isMainThread() -> Bool {
  ffi_require_worker_threads()._get("isMainThread").cast()
}

///|
/// Get the parent port (null in main thread)
/// https://nodejs.org/api/worker_threads.html#workerparentport
pub fn parentPort() -> MessagePort? {
  ffi_require_worker_threads()._get("parentPort") |> @core.identity_option()
}

///|
/// Get the worker data passed to the worker
/// https://nodejs.org/api/worker_threads.html#workerworkerdata
pub fn workerData() -> @core.Any? {
  ffi_require_worker_threads()._get("workerData") |> @core.identity_option()
}

///|
/// Get the thread ID of the current thread
/// https://nodejs.org/api/worker_threads.html#workerthreadid
pub fn threadId() -> Int {
  ffi_get_thread_id()
}
