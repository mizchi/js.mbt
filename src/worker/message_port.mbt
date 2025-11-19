///|
/// MessagePort represents one end of a message channel
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort
///
/// MessagePort implements the EventTarget trait for event handling.
#external
pub type MessagePort

///|
pub impl JsImpl for MessagePort

///|
pub impl @event.EventTargetImpl for MessagePort

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
pub fn MessagePort::post_message(port : MessagePort, message : &JsImpl) -> Unit {
  port.invoke("postMessage", [message.to_js()]) |> ignore
}

///|
/// Sends a message with transferable objects through the port
pub fn MessagePort::post_message_with_transfer(
  port : MessagePort,
  message : &JsImpl,
  transfer : Array[Js],
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
/// MessageChannel creates a new message channel and returns it with two MessagePort objects
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel
#external
pub type MessageChannel

///|
pub impl JsImpl for MessageChannel

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
