///|
/// Test MessageChannel::new creates a channel
test "MessageChannel::new creates a channel" {
  let channel = @message.MessageChannel::new()
  inspect(@js.typeof_(channel.as_any()), content="object")
}

///|
/// Test MessageChannel has port1 and port2
test "MessageChannel::port1 and port2 return MessagePort" {
  let channel = @message.MessageChannel::new()
  let port1 = @message.MessageChannel::port1(channel)
  let port2 = @message.MessageChannel::port2(channel)
  inspect(@js.typeof_(port1.as_any()), content="object")
  inspect(@js.typeof_(port2.as_any()), content="object")
}

///|
/// Test MessagePort::start can be called
test "MessagePort::start can be called" {
  let channel = @message.MessageChannel::new()
  let port1 = @message.MessageChannel::port1(channel)
  @message.MessagePort::start(port1)
  inspect(@js.typeof_(port1.as_any()), content="object")
}

///|
/// Test MessagePort::close can be called
test "MessagePort::close disconnects the port" {
  let channel = @message.MessageChannel::new()
  let port1 = @message.MessageChannel::port1(channel)
  @message.MessagePort::close(port1)
  inspect(@js.typeof_(port1.as_any()), content="object")
}

// ///|
// /// Test MessagePort::post_message can send a string
// test "MessagePort::post_message sends a string" {
//   let channel = MessageChannel::new()
//   let port1 = channel.port1()
//   let port2 = channel.port2()
//   port1.start()
//   port2.start()
//   port1.post_message("Hello from port1")
//   inspect(@js.typeof_(port1.as_any()), content="object")
// }

// ///|

///|
/// Test MessagePort::post_message can send a number
test "MessagePort::post_message sends a number" {
  let channel = @message.MessageChannel::new()
  let port1 = @message.MessageChannel::port1(channel)
  @message.MessagePort::post_message(port1, 42)
  inspect(@js.typeof_(port1.as_any()), content="object")
}

// ///|
// /// Test MessagePort::post_message can send an object
// test "MessagePort::post_message sends an object" {
//   let channel = MessageChannel::new()
//   let port1 = channel.port1()
//   let data = @js.from_json({ "type": "test", "value": 123 })
//   port1.post_message(data)
//   inspect(@js.typeof_(port1.as_any()), content="object")
// }

// ///|
// /// Test MessagePort::post_message_with_transfer
// test "MessagePort::post_message_with_transfer sends with transferables" {
//   let channel = MessageChannel::new()
//   let port1 = channel.port1()

//   // Create another channel to transfer
//   let transfer_channel = MessageChannel::new()
//   let transfer_port = transfer_channel.port1()

//   // Send message with transfer
//   port1.post_message_with_transfer("Transfer test", [transfer_port.as_any()])
//   inspect(@js.typeof_(port1.as_any()), content="object")
// }
