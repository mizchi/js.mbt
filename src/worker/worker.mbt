///|
using @js {type Js, trait JsImpl, js}

///|
/// Transferable trait for objects that can be transferred via postMessage
pub(open) trait Transferable {
  to_transferable(Self) -> Js
}

///|
/// JavaScript Worker API
/// https://developer.mozilla.org/ja/docs/Web/API/Worker
/// cast extern or prebuilt js
/// ```
/// fn _worker() -> Unit {
///   let worker = Worker::new("./worker_script.js", type_="module")
///   // or: extern "js" fn get_my_worker() -> Worker = "() => new Worker('./worker_script.js', { type: 'module' })"
///   worker.post_message(@js.from_builtin_json({
///     "type": "greeting"
///   }))
///   worker.addEventListener("message", _event => {
///     @js.log("Received message from worker:")
///   })
///   worker.terminate()
/// }
/// ```
#external
pub type Worker

///|
pub impl JsImpl for Worker

///|
pub impl @event.EventTargetImpl for Worker

///|
extern "js" fn ffi_new_worker(script_url : String, option : Js) -> Worker =
  #| (script_url) => new Worker(script_url)

///|
pub fn Worker::new(script_url : String, type_? : String) -> Worker {
  let option = if type_ is Some(v) {
    @js.from_map({ "type": js(v) })
  } else {
    @js.undefined()
  }
  ffi_new_worker(script_url, option)
}

///|
pub fn Worker::terminate(worker : Worker) -> Unit {
  worker.call0("terminate") |> ignore
}

///|
extern "js" fn ffi_worker_post_message(
  worker : Worker,
  message : Js,
  transfer : Js,
) -> Unit =
  #| (worker, message, transfer) => worker.postMessage(message, transfer)

///|
#alias(post_message)
pub fn Worker::postMessage(worker : Worker, message : &JsImpl) -> Unit {
  ffi_worker_post_message(worker, message.to_js(), @js.undefined())
}

///|
pub fn Worker::post_message_with_transfer(
  worker : Worker,
  message : &JsImpl,
  transfer : Array[Js],
) -> Unit {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < transfer.length() {
    arr.call("push", [transfer[i]]) |> ignore
    i = i + 1
  }
  ffi_worker_post_message(worker, message.to_js(), arr.to_js())
}

///|
/// MessageEvent structure for Worker message events
/// Access via Val from EventTarget trait's event listener
pub(all) struct MessageEvent {
  data : Js
  origin : String
  source : Js
}
