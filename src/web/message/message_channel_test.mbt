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
/// Test MessageEvent can be created and accessed
test "MessageEvent struct" {
  let event : MessageEvent = {
    data: @nostd.any("test data"),
    origin: "https://example.com",
    lastEventId: "123",
    ports: [],
  }
  assert_eq(event.origin, "https://example.com")
  assert_eq(event.lastEventId, "123")
  assert_eq(event.ports.length(), 0)
}
