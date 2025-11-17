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
pub impl Js for Worker

///|
extern "js" fn ffi_new_worker(script_url : String, option : Val) -> Worker =
  #| (script_url) => new Worker(script_url)

///|
pub fn Worker::new(script_url : String, is_module? : Bool = false) -> Worker {
  let option = if is_module {
    @js.from_map({ "type": js("module") })
  } else {
    @js.undefined()
  }
  ffi_new_worker(script_url, option)
}

///|
pub fn Worker::terminate(worker : Worker) -> Unit {
  worker.invoke("terminate", []) |> ignore
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
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < transfer.length() {
    arr.invoke("push", [transfer[i]]) |> ignore
    i = i + 1
  }
  ffi_worker_post_message(worker, message.to_js(), arr.to_js())
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
  worker.invoke("addEventListener", [js(event), listener |> js]) |> ignore
}

///|
/// MessagePort represents one end of a message channel
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort
#external
pub type MessagePort

///|
pub impl Js for MessagePort

///|
pub impl Show for MessagePort with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for MessagePort with to_string(self) {
  "[object MessagePort]"
}

///|
/// Sends a message through the port
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/postMessage
#alias(postMessage)
pub fn MessagePort::post_message(port : MessagePort, message : &Js) -> Unit {
  port.invoke("postMessage", [message.to_js()]) |> ignore
}

///|
/// Sends a message with transferable objects through the port
pub fn MessagePort::post_message_with_transfer(
  port : MessagePort,
  message : &Js,
  transfer : Array[Val],
) -> Unit {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < transfer.length() {
    arr.invoke("push", [transfer[i]]) |> ignore
    i = i + 1
  }
  port.invoke("postMessage", [message.to_js(), arr.to_js()]) |> ignore
}

///|
/// Starts the sending of messages queued on the port
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/start
pub fn MessagePort::start(port : MessagePort) -> Unit {
  port.invoke("start", []) |> ignore
}

///|
/// Disconnects the port, so it is no longer active
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/close
pub fn MessagePort::close(port : MessagePort) -> Unit {
  port.invoke("close", []) |> ignore
}

///|
/// Adds an event listener for the message event
#alias(addEventListener)
pub fn MessagePort::add_event_listener(
  port : MessagePort,
  event : String,
  listener : (MessageEvent) -> Unit,
) -> Unit {
  port.invoke("addEventListener", [js(event), listener |> js]) |> ignore
}

///|
/// Sets the onmessage event handler
pub fn MessagePort::set_onmessage(
  port : MessagePort,
  handler : (MessageEvent) -> Unit,
) -> Unit {
  port.set("onmessage", handler |> js)
}

///|
/// Gets the onmessage event handler
pub fn MessagePort::get_onmessage(port : MessagePort) -> Val {
  port.get("onmessage")
}

///|
/// Sets the onmessageerror event handler
pub fn MessagePort::set_onmessageerror(
  port : MessagePort,
  handler : (MessageEvent) -> Unit,
) -> Unit {
  port.set("onmessageerror", handler |> js)
}

///|
/// MessageChannel creates a new message channel and returns it with two MessagePort objects
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel
#external
pub type MessageChannel

///|
pub impl Js for MessageChannel

///|
pub impl Show for MessageChannel with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for MessageChannel with to_string(self) {
  "[object MessageChannel]"
}

///|
extern "js" fn ffi_new_message_channel() -> MessageChannel =
  #| () => new MessageChannel()

///|
/// Creates a new MessageChannel object
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel/MessageChannel
pub fn MessageChannel::new() -> MessageChannel {
  ffi_new_message_channel()
}

///|
/// Returns the first port of the channel
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel/port1
pub fn MessageChannel::port1(channel : MessageChannel) -> MessagePort {
  @js.unsafe_cast(channel.get("port1"))
}

///|
/// Returns the second port of the channel
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel/port2
pub fn MessageChannel::port2(channel : MessageChannel) -> MessagePort {
  @js.unsafe_cast(channel.get("port2"))
}
