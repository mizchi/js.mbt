///|
/// MessageChannel async messaging tests

///|
async test "MessageChannel: send and receive message between ports" {
  let resolver : @js.Resolvers[String] = @js.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)

  // Setup receiver on port2
  port2.addEventListener("message", fn(event : @nostd.Any) {
    let e : @nostd.Any = event |> @nostd.any
    let data : String = e["data"] |> @nostd.identity
    resolver.resolve(data)
  })

  // Start listening
  MessagePort::start(port2)

  // Send message from port1
  MessagePort::post_message(port1, @nostd.any("Hello from port1"))

  // Wait for message
  let received = resolver.promise.wait()
  assert_eq(received, "Hello from port1")
}

///|
async test "MessageChannel: bidirectional messaging" {
  let resolver1 : @js.Resolvers[Int] = @js.Promise::withResolvers()
  let resolver2 : @js.Resolvers[Int] = @js.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)

  // Setup receivers
  port1.addEventListener("message", fn(event : @nostd.Any) {
    let e : @nostd.Any = event |> @nostd.any
    let data : Int = e["data"].cast()
    resolver1.resolve(data)
  })
  port2.addEventListener("message", fn(event : @nostd.Any) {
    let e : @nostd.Any = event |> @nostd.any
    let data : Int = e["data"].cast()
    resolver2.resolve(data)
  })

  // Start both ports
  MessagePort::start(port1)
  MessagePort::start(port2)

  // Send messages in both directions
  MessagePort::post_message(port1, @nostd.any(42))
  MessagePort::post_message(port2, @nostd.any(99))

  // Wait for both messages
  let msg1 = resolver1.promise.wait()
  let msg2 = resolver2.promise.wait()
  assert_eq(msg1, 99) // port1 receives from port2
  assert_eq(msg2, 42) // port2 receives from port1
}

///|
async test "MessageChannel: multiple messages in sequence" {
  let messages : Array[String] = []
  let resolver : @js.Resolvers[Int] = @js.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)
  let mut count = 0
  port2.addEventListener("message", fn(event : @nostd.Any) {
    let e : @nostd.Any = event |> @nostd.any
    let data : String = e["data"].cast()
    messages.push(data)
    count = count + 1
    if count == 3 {
      resolver.resolve(count)
    }
  })
  MessagePort::start(port2)

  // Send multiple messages
  MessagePort::post_message(port1, @nostd.any("first"))
  MessagePort::post_message(port1, @nostd.any("second"))
  MessagePort::post_message(port1, @nostd.any("third"))

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
  let resolver : @js.Resolvers[Bool] = @js.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  port2.addEventListener("message", fn(_event : @nostd.Any) {
    resolver.resolve(true)
  })
  MessagePort::start(port2)
  MessagePort::post_message(port1, @nostd.any("test"))
  let received = resolver.promise.wait()
  assert_eq(received, true)

  // Close ports
  MessagePort::close(port1)
  MessagePort::close(port2)

  // After closing, sending should not crash (though message won't be received)
  MessagePort::post_message(port1, @nostd.any("should not receive"))
  @js.sleep(16)
}

///|
async test "MessageChannel: message event properties" {
  let resolver : @js.Resolvers[@nostd.Any] = @js.Promise::withResolvers()
  let channel = MessageChannel::new()
  let port1 = channel.port1()
  let port2 = channel.port2()
  defer MessagePort::close(port1)
  defer MessagePort::close(port2)
  port2.addEventListener("message", fn(event : @nostd.Any) {
    resolver.resolve(event)
  })
  MessagePort::start(port2)
  let obj : @nostd.Any = @nostd.from_entries([("key", @nostd.any("value"))])
  MessagePort::post_message(port1, obj)
  let event = resolver.promise.wait()
  let e : @nostd.Any = event |> @nostd.any
  let data : @nostd.Any = e["data"]
  let key_value : String = data["key"].cast()
  assert_eq(key_value, "value")
}
