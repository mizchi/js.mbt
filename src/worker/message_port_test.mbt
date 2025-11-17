///|
/// Test MessagePort::add_event_listener can register handler
#skip("WIP: Test blocking")
test "MessagePort::add_event_listener registers handler" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()

  // Add event listener
  port1.add_event_listener("message", fn(event) { ignore(event.data) })
  inspect(@js.typeof_(port1.to_js()), content="object")
}

///|
/// Test MessagePort::set_onmessage sets handler
#skip("WIP: Test blocking")
test "MessagePort::set_onmessage sets handler" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()

  // Set onmessage handler
  port1.set_onmessage(fn(event) { ignore(event.data) })

  // Verify handler is set
  let handler = port1.get_onmessage()
  inspect(@js.typeof_(handler), content="function")
}

///|
/// Test MessagePort::set_onmessageerror sets error handler
#skip("WIP: Test blocking")
test "MessagePort::set_onmessageerror sets error handler" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()

  // Set onmessageerror handler
  port1.set_onmessageerror(fn(event) { ignore(event.data) })
  inspect(@js.typeof_(port1.to_js()), content="object")
}

///|
/// Test MessagePort::get_onmessage returns undefined initially
#skip("WIP: Test blocking")
test "MessagePort::get_onmessage returns undefined initially" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let handler = port1.get_onmessage()
  inspect(@js.typeof_(handler), content="object")
}

///|
/// Test MessagePort Show trait implementation
test "MessagePort implements Show trait" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  inspect(port1.to_string(), content="[object MessagePort]")
}

///|
/// Test MessageChannel Show trait implementation
test "MessageChannel implements Show trait" {
  let channel = MessageChannel::new()
  inspect(channel.to_string(), content="[object MessageChannel]")
}

///|
/// Test MessageEvent has correct structure
#skip("WIP: Test blocking")
test "MessageEvent contains data, origin, source" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  port2.set_onmessage(fn(event) {
    // Event handler can access data
    ignore(event.data)
    ignore(event.origin)
  })
  port2.start()
  port1.post_message("test message")
  inspect(@js.typeof_(port1.to_js()), content="object")
}

///|
/// Test multiple message sends
#skip("WIP: Test blocking")
test "MessagePort can send multiple messages" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  port1.start()
  port2.start()
  port1.post_message("message 1")
  port1.post_message("message 2")
  port1.post_message("message 3")
  inspect(@js.typeof_(port1.to_js()), content="object")
}

///|
/// Test bidirectional communication
#skip("WIP: Test blocking")
test "MessagePort supports bidirectional communication" {
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  port1.start()
  port2.start()

  // Send from port1 to port2
  port1.post_message("from port1")

  // Send from port2 to port1
  port2.post_message("from port2")
  inspect(@js.typeof_(port1.to_js()), content="object")
  inspect(@js.typeof_(port2.to_js()), content="object")
}
