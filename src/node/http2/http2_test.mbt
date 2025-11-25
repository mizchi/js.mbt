///|
/// Test connect creates session
test "connect creates session" {
  let session = connect("https://example.com")
  inspect(@js.typeof_(session.to_any()), content="object")
  session.close()
}
