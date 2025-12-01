///|
/// MessageEvent represents a message received by a target object
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
pub(all) struct MessageEvent {
  /// The data sent by the message emitter
  data : @js.Any
  /// The origin of the message emitter
  origin : String
  /// The last event ID
  lastEventId : String
  /// The MessagePort array sent with the message
  ports : Array[MessagePort]
} derive(Show)

///|
pub fn MessageEvent::as_any(self : MessageEvent) -> @nostd.Any = "%identity"

///|
pub fn MessageEvent::as_event_target(self : MessageEvent) -> @event.EventTarget = "%identity"

///|
pub impl @event.EventTargetImpl for MessageEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// MessagePort represents one end of a message channel
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort
///
/// MessagePort implements the EventTarget trait for event handling.
#external
pub type MessagePort

///|
pub fn MessagePort::as_any(self : MessagePort) -> @nostd.Any = "%identity"

///|
pub fn MessagePort::as_event_target(self : MessagePort) -> @event.EventTarget = "%identity"

///|
pub impl @event.EventTargetImpl for MessagePort with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
pub impl Show for MessagePort with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for MessagePort with to_string(_self) {
  "[object MessagePort]"
}

///|
/// Sends a message through the port
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/postMessage
#alias(post_message)
pub fn MessagePort::postMessage(
  port : MessagePort,
  message : &@js.JsImpl,
) -> Unit {
  port.as_any()._call("postMessage", [@nostd.any(message.as_any())]) |> ignore
}

///|
/// Sends a message with transferable objects through the port
#alias(post_message_with_transfer)
pub fn MessagePort::postMessageWithTransfer(
  port : MessagePort,
  message : &@js.JsImpl,
  transfer : Array[@js.Any],
) -> Unit {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < transfer.length() {
    arr.call("push", [transfer[i]]) |> ignore
    i = i + 1
  }
  port
  .as_any()
  ._call("postMessage", [@nostd.any(message.as_any()), @nostd.any(arr.as_any())])
  |> ignore
}

///|
/// Starts the sending of messages queued on the port
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/start
pub fn MessagePort::start(port : MessagePort) -> Unit {
  port.as_any()._call("start", []) |> ignore
}

///|
/// Disconnects the port, so it is no longer active
/// https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/close
pub fn MessagePort::close(port : MessagePort) -> Unit {
  port.as_any()._call("close", []) |> ignore
}

///|
/// MessageChannel creates a new message channel and returns it with two MessagePort objects
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel
#external
pub type MessageChannel

///|
pub fn MessageChannel::as_any(self : MessageChannel) -> @nostd.Any = "%identity"

///|
pub impl Show for MessageChannel with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for MessageChannel with to_string(_self) {
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
  channel.as_any()["port1"].cast()
}

///|
/// Returns the second port of the channel
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel/port2
pub fn MessageChannel::port2(channel : MessageChannel) -> MessagePort {
  channel.as_any()["port2"].cast()
}
