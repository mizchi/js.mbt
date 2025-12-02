///|

///|
/// Transferable trait for objects that can be transferred via postMessage
pub(open) trait Transferable {
  to_transferable(Self) -> @core.Any
}

///|
/// JavaScript Worker API
/// https://developer.mozilla.org/ja/docs/Web/API/Worker
/// cast extern or prebuilt js
/// ```
/// fn _worker() -> Unit {
///   let worker = Worker::new("./worker_script.js", type_="module")
///   // or: extern "js" fn get_my_worker() -> Worker = "() => new Worker('./worker_script.js', { type: 'module' })"
///   worker.post_message(@mbtconv.from_json({
///     "type": "greeting"
///   }).cast())
///   worker.addEventListener("message", _event => {
///     @js.log("Received message from worker:")
///   })
///   worker.terminate()
/// }
/// ```
#external
pub type Worker

///|
pub fn Worker::to_any(self : Worker) -> @core.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn Worker::as_event_target(self : Worker) -> @event.EventTarget = "%identity"

///|
pub impl @event.EventTargetImpl for Worker with as_any(self) -> @core.Any {
  self.to_any()
}

///|
extern "js" fn ffi_new_worker(
  script_url : String,
  option : @core.Any,
) -> Worker =
  #| (script_url) => new Worker(script_url)

///|
pub fn Worker::new(script_url : String, type_? : String) -> Worker {
  let option : @core.Any = if type_ is Some(v) {
    @core.from_entries([("type", @core.any(v))]).cast()
  } else {
    @global.undefined()
  }
  ffi_new_worker(script_url, option)
}

///|
pub fn Worker::terminate(worker : Worker) -> Unit {
  worker.to_any()._call("terminate", []) |> ignore
}

///|
extern "js" fn ffi_worker_post_message(
  worker : Worker,
  message : @core.Any,
  transfer : @core.Any,
) -> Unit =
  #| (worker, message, transfer) => worker.postMessage(message, transfer)

///|
#alias(post_message)
pub fn Worker::postMessage(worker : Worker, message : @core.Any) -> Unit {
  ffi_worker_post_message(
    worker,
    message |> @core.identity,
    @global.undefined(),
  )
}

///|
#alias(post_message_with_transfer)
pub fn Worker::postMessageWithTransfer(
  worker : Worker,
  message : @core.Any,
  transfer : Array[@core.Any],
) -> Unit {
  ffi_worker_post_message(
    worker,
    message |> @core.identity,
    transfer |> @js.any,
  )
}

///|
/// MessageEvent structure for Worker message events
/// Access via Val from EventTarget trait's event listener
pub(all) struct MessageEvent {
  data : @core.Any
  origin : String
  source : @core.Any
}

///|
pub fn MessageEvent::to_any(self : MessageEvent) -> @core.Any = "%identity"
