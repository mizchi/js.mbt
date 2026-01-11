///|
/// Test connect creates session
test "connect creates session" {
  let session = connect("https://example.com")
  let session_js : @core.Any = session.as_any().cast()
  inspect(@core.typeof_(session_js), content="object")
  session.close()
}
