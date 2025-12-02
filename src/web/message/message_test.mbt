///|
/// MessageChannel async messaging tests

///|
async test "MessageChannel: send and receive message between ports" {
  let resolver : @core.PromiseResolvers[String] = @core.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)

  // Setup receiver on port2
  port2.addEventListener("message", fn(event : @core.Any) {
    let e : @core.Any = event |> @core.any
    let data : String = e["data"] |> @core.identity
    resolver.resolve(data)
  })

  // Start listening
  MessagePort::start(port2)

  // Send message from port1
  MessagePort::post_message(port1, @core.any("Hello from port1"))

  // Wait for message
  let received = resolver.promise.wait()
  assert_eq(received, "Hello from port1")
}

///|
async test "MessageChannel: bidirectional messaging" {
  let resolver1 : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  let resolver2 : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)

  // Setup receivers
  port1.addEventListener("message", fn(event : @core.Any) {
    let e : @core.Any = event |> @core.any
    let data : Int = e["data"].cast()
    resolver1.resolve(data)
  })
  port2.addEventListener("message", fn(event : @core.Any) {
    let e : @core.Any = event |> @core.any
    let data : Int = e["data"].cast()
    resolver2.resolve(data)
  })

  // Start both ports
  MessagePort::start(port1)
  MessagePort::start(port2)

  // Send messages in both directions
  MessagePort::post_message(port1, @core.any(42))
  MessagePort::post_message(port2, @core.any(99))

  // Wait for both messages
  let msg1 = resolver1.promise.wait()
  let msg2 = resolver2.promise.wait()
  assert_eq(msg1, 99) // port1 receives from port2
  assert_eq(msg2, 42) // port2 receives from port1
}

///|
async test "MessageChannel: multiple messages in sequence" {
  let messages : Array[String] = []
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)
  let mut count = 0
  port2.addEventListener("message", fn(event : @core.Any) {
    let e : @core.Any = event |> @core.any
    let data : String = e["data"].cast()
    messages.push(data)
    count = count + 1
    if count == 3 {
      resolver.resolve(count)
    }
  })
  MessagePort::start(port2)

  // Send multiple messages
  MessagePort::post_message(port1, @core.any("first"))
  MessagePort::post_message(port1, @core.any("second"))
  MessagePort::post_message(port1, @core.any("third"))

  // Wait for all messages
  let received_count = resolver.promise.wait()
  assert_eq(received_count, 3)
  assert_eq(messages.length(), 3)
  assert_eq(messages[0], "first")
  assert_eq(messages[1], "second")
  assert_eq(messages[2], "third")
}

///|
async test "MessageChannel: port closes properly" {
  let resolver : @core.PromiseResolvers[Bool] = @core.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  port2.addEventListener("message", fn(_event : @core.Any) {
    resolver.resolve(true)
  })
  MessagePort::start(port2)
  MessagePort::post_message(port1, @core.any("test"))
  let received = resolver.promise.wait()
  assert_eq(received, true)

  // Close ports
  MessagePort::close(port1)
  MessagePort::close(port2)

  // After closing, sending should not crash (though message won't be received)
  MessagePort::post_message(port1, @core.any("should not receive"))
  @core.sleep(16)
}

///|
async test "MessageChannel: message event properties" {
  let resolver : @core.PromiseResolvers[@core.Any] = @core.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)
  port2.addEventListener("message", fn(event : @core.Any) {
    resolver.resolve(event)
  })
  MessagePort::start(port2)
  let obj : @core.Any = @core.from_entries([("key", @core.any("value"))])
  MessagePort::post_message(port1, obj)
  let event = resolver.promise.wait()
  let e : @core.Any = event |> @core.any
  let data : @core.Any = e["data"]
  let key_value : String = data["key"].cast()
  assert_eq(key_value, "value")
}
