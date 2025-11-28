///|
/// Worker Threads API for Node.js
/// https://nodejs.org/api/worker_threads.html

///|
/// Worker class represents a worker thread
#external
pub type Worker

///|
pub impl @js.JsImpl for Worker

///|
pub impl @events.EventEmitterImpl for Worker

///|
/// MessagePort represents a message port for communication
#external
pub type MessagePort

///|
pub impl @js.JsImpl for MessagePort

///|
pub impl @events.EventEmitterImpl for MessagePort

///|
/// Module Functions
extern "js" fn ffi_require_worker_threads() -> @js.Any =
  #|() => require("node:worker_threads")

///|
extern "js" fn ffi_get_thread_id() -> Int =
  #|() => require("node:worker_threads").threadId

///|
/// Create a new Worker instance
/// https://nodejs.org/api/worker_threads.html#new-workerfilename-options
pub fn Worker::new(
  filename : String,
  workerData? : @js.Any,
  env? : @js.Any,
  stdin? : Bool,
  stdout? : Bool,
  stderr? : Bool,
  execArgv? : Array[String],
  resourceLimits? : @js.Any,
) -> Worker {
  let wt = ffi_require_worker_threads()
  let worker_class = wt.get("Worker")
  let js_opts = @js.from_option_map({
    "workerData": workerData,
    "env": env,
    "stdin": stdin.map(fn(x) { @js.any(x) }),
    "stdout": stdout.map(fn(x) { @js.any(x) }),
    "stderr": stderr.map(fn(x) { @js.any(x) }),
    "execArgv": execArgv.map(fn(x) { @js.from_array(x) }),
    "resourceLimits": resourceLimits,
  })
  @js.identity(@js.new_(worker_class, [filename, js_opts]))
}

///|
/// Post a message to the worker
/// https://nodejs.org/api/worker_threads.html#workerpostmessagevalue-transferlist
pub fn Worker::postMessage(
  self : Worker,
  value : &@js.JsImpl,
  transferList? : Array[&@js.JsImpl],
) -> Unit {
  match transferList {
    Some(list) =>
      self.call2("postMessage", value.to_any(), @js.from_array(list)) |> ignore
    None => self.call("postMessage", [value.to_any()]) |> ignore
  }
}

///|
/// Terminate the worker
/// https://nodejs.org/api/worker_threads.html#workerterminate
pub fn Worker::terminate(self : Worker) -> Unit {
  self.call0("terminate") |> ignore
}

///|
/// Prevent the worker from keeping the event loop active
pub fn Worker::unref(self : Worker) -> Unit {
  self.call0("unref") |> ignore
}

///|
/// Require the worker to keep the event loop active
pub fn Worker::ref_(self : Worker) -> Unit {
  self.call0("ref") |> ignore
}

///|
/// Get the threadId of the worker
pub fn Worker::threadId(self : Worker) -> Int {
  self.get("threadId").cast()
}

///|
/// Get the stdin stream of the worker (if enabled)
pub fn Worker::stdin(self : Worker) -> @streams.WritableStream? {
  self.get("stdin") |> @js.identity_option()
}

///|
/// Get the stdout stream of the worker (if enabled)
pub fn Worker::stdout(self : Worker) -> @streams.ReadableStream? {
  self.get("stdout") |> @js.identity_option()
}

///|
/// Get the stderr stream of the worker (if enabled)
pub fn Worker::stderr(self : Worker) -> @streams.ReadableStream? {
  self.get("stderr") |> @js.identity_option()
}

///|
/// MessagePort methods
pub fn MessagePort::postMessage(
  self : MessagePort,
  value : &@js.JsImpl,
  transferList? : Array[&@js.JsImpl],
) -> Unit {
  match transferList {
    Some(list) =>
      self.call2("postMessage", value.to_any(), @js.from_array(list)) |> ignore
    None => self.call("postMessage", [value.to_any()]) |> ignore
  }
}

///|
/// Start receiving messages on this MessagePort
pub fn MessagePort::start(self : MessagePort) -> Unit {
  self.call0("start") |> ignore
}

///|
/// Close the MessagePort
pub fn MessagePort::close(self : MessagePort) -> Unit {
  self.call0("close") |> ignore
}

///|
/// Check if running in the main thread
/// https://nodejs.org/api/worker_threads.html#workerismainthread
pub fn isMainThread() -> Bool {
  ffi_require_worker_threads().get("isMainThread").cast()
}

///|
/// Get the parent port (null in main thread)
/// https://nodejs.org/api/worker_threads.html#workerparentport
pub fn parentPort() -> MessagePort? {
  ffi_require_worker_threads().get("parentPort") |> @js.identity_option()
}

///|
/// Get the worker data passed to the worker
/// https://nodejs.org/api/worker_threads.html#workerworkerdata
pub fn workerData() -> @js.Any? {
  ffi_require_worker_threads().get("workerData") |> @js.identity_option()
}

///|
/// Get the thread ID of the current thread
/// https://nodejs.org/api/worker_threads.html#workerthreadid
pub fn threadId() -> Int {
  ffi_get_thread_id()
}
