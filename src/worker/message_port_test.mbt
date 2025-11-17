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
