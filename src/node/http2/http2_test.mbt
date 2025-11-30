///|
/// Test connect creates session
test "connect creates session" {
  let session = connect("https://example.com")
  let session_js : @js.Any = session.as_any().cast()
  inspect(@js.typeof_(session_js), content="object")
  session.close()
}
