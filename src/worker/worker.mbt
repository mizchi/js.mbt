///|
using @js {type Val, trait Js, js, log}

///|
/// Transferable trait for objects that can be transferred via postMessage
pub(open) trait Transferable {
  to_transferable(Self) -> Val
}

///|
/// JavaScript Worker API
/// cast extern or prebuilt js
/// ```
/// fn _worker() -> Unit {
///   let worker = Worker::new("./worker_script.js", is_module=true)
///   // or: extern "js" fn get_my_worker() -> Worker = "() => new Worker('./worker_script.js', { type: 'module' })"
///   worker.post_message(@js.from_builtin_json({
///     "type": "greeting"
///   }))
///   worker.add_event_listener("message", event => {
///     @js.log("Received message from worker:")
///     @js.log(event.data)
///   })
///   worker.terminate()
/// }
/// ```
#external
pub type Worker

///|
pub impl Js for Worker with to_js(self) -> Val {
  self |> js
}

///|
extern "js" fn ffi_new_worker(script_url : String, option : Val) -> Worker =
  #| (script_url) => new Worker(script_url)

///|
pub fn Worker::new(script_url : String, is_module? : Bool = false) -> Worker {
  let option = if is_module {
    @js.from_builtin_map({ "type": js("module") })
  } else {
    @js.undefined()
  }
  ffi_new_worker(script_url, option)
}

///|
pub fn Worker::terminate(worker : Worker) -> Unit {
  worker.to_js().call_method("terminate", []) |> ignore
}

///|
extern "js" fn ffi_worker_post_message(
  worker : Worker,
  message : Val,
  transfer : Val,
) -> Unit =
  #| (worker, message, transfer) => worker.postMessage(message, transfer)

///|
#alias(postMessage)
pub fn Worker::post_message(worker : Worker, message : &Js) -> Unit {
  ffi_worker_post_message(worker, message.to_js(), @js.undefined())
}

///|
pub fn Worker::post_message_with_transfer(
  worker : Worker,
  message : &Js,
  transfer : Array[Val],
) -> Unit {
  let arr = @js.new_empty_array()
  let mut i = 0
  while i < transfer.length() {
    arr.call_method("push", [transfer[i]]) |> ignore
    i = i + 1
  }
  ffi_worker_post_message(worker, message.to_js(), arr)
}

///|
pub(all) struct MessageEvent {
  data : Val
  origin : String
  source : Val
}

///|
#alias(addEventListener)
pub fn Worker::add_event_listener(
  worker : Worker,
  event : String,
  listener : (MessageEvent) -> Unit,
) -> Unit {
  worker.to_js().call_method("addEventListener", [js(event), listener |> js])
  |> ignore
}
