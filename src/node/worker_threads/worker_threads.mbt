///|
/// Worker Threads API for Node.js
/// https://nodejs.org/api/worker_threads.html

///|
/// Worker class represents a worker thread
#external
pub type Worker

///|
pub fn Worker::as_any(self : Worker) -> @nostd.Any = "%identity"

///|
/// MessagePort represents a message port for communication
#external
pub type MessagePort

///|
pub fn MessagePort::as_any(self : MessagePort) -> @nostd.Any = "%identity"

///|
/// Module Functions
extern "js" fn ffi_require_worker_threads() -> @nostd.Any =
  #|() => require("node:worker_threads")

///|
extern "js" fn ffi_get_thread_id() -> Int =
  #|() => require("node:worker_threads").threadId

///|
/// Create a new Worker instance
/// https://nodejs.org/api/worker_threads.html#new-workerfilename-options
pub fn Worker::new(
  filename : String,
  workerData? : @nostd.Any,
  env? : @nostd.Any,
  stdin? : Bool,
  stdout? : Bool,
  stderr? : Bool,
  execArgv? : Array[String],
  resourceLimits? : @nostd.Any,
) -> Worker {
  let wt = ffi_require_worker_threads()
  let worker_class = wt._get("Worker")
  let js_opts = @mbtconv.from_option_map({
    "workerData": workerData.map(fn(x) { @nostd.identity(x) }),
    "env": env.map(fn(x) { @nostd.identity(x) }),
    "stdin": stdin.map(fn(x) { @nostd.any(x) }),
    "stdout": stdout.map(fn(x) { @nostd.any(x) }),
    "stderr": stderr.map(fn(x) { @nostd.any(x) }),
    "execArgv": execArgv.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
    "resourceLimits": resourceLimits.map(fn(x) { @nostd.identity(x) }),
  }).cast()
  @nostd.identity(@nostd.new_(worker_class, [@nostd.any(filename), js_opts]))
}

///|
/// Post a message to the worker
/// https://nodejs.org/api/worker_threads.html#workerpostmessagevalue-transferlist
pub fn Worker::postMessage(
  self : Worker,
  value : @nostd.Any,
  transferList? : Array[@nostd.Any],
) -> Unit {
  match transferList {
    Some(list) =>
      self.as_any().call2("postMessage", value, @js.from_array(list)) |> ignore
    None => self.as_any()._call("postMessage", [value]) |> ignore
  }
}

///|
/// Terminate the worker
/// https://nodejs.org/api/worker_threads.html#workerterminate
pub fn Worker::terminate(self : Worker) -> Unit {
  self.as_any().call0("terminate") |> ignore
}

///|
/// Prevent the worker from keeping the event loop active
pub fn Worker::unref(self : Worker) -> Unit {
  self.as_any().call0("unref") |> ignore
}

///|
/// Require the worker to keep the event loop active
pub fn Worker::ref_(self : Worker) -> Unit {
  self.as_any().call0("ref") |> ignore
}

///|
/// Get the threadId of the worker
pub fn Worker::threadId(self : Worker) -> Int {
  self.as_any()._get("threadId").cast()
}

///|
/// Get the stdin stream of the worker (if enabled)
pub fn Worker::stdin(self : Worker) -> @streams.WritableStream? {
  self.as_any()._get("stdin") |> @nostd.identity_option()
}

///|
/// Get the stdout stream of the worker (if enabled)
pub fn Worker::stdout(self : Worker) -> @streams.ReadableStream? {
  self.as_any()._get("stdout") |> @nostd.identity_option()
}

///|
/// Get the stderr stream of the worker (if enabled)
pub fn Worker::stderr(self : Worker) -> @streams.ReadableStream? {
  self.as_any()._get("stderr") |> @nostd.identity_option()
}

///|
/// MessagePort methods
pub fn MessagePort::postMessage(
  self : MessagePort,
  value : @nostd.Any,
  transferList? : Array[@nostd.Any],
) -> Unit {
  match transferList {
    Some(list) =>
      self.as_any().call2("postMessage", value, @js.from_array(list)) |> ignore
    None => self.as_any()._call("postMessage", [value]) |> ignore
  }
}

///|
/// Start receiving messages on this MessagePort
pub fn MessagePort::start(self : MessagePort) -> Unit {
  self.as_any().call0("start") |> ignore
}

///|
/// Close the MessagePort
pub fn MessagePort::close(self : MessagePort) -> Unit {
  self.as_any().call0("close") |> ignore
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
  ffi_require_worker_threads()._get("parentPort") |> @nostd.identity_option()
}

///|
/// Get the worker data passed to the worker
/// https://nodejs.org/api/worker_threads.html#workerworkerdata
pub fn workerData() -> @nostd.Any? {
  ffi_require_worker_threads()._get("workerData") |> @nostd.identity_option()
}

///|
/// Get the thread ID of the current thread
/// https://nodejs.org/api/worker_threads.html#workerthreadid
pub fn threadId() -> Int {
  ffi_get_thread_id()
}
