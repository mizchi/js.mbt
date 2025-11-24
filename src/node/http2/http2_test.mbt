///|
/// Test ServerOptions creation
test "ServerOptions::new creates options" {
  let options = ServerOptions::new()
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test SecureServerOptions creation
test "SecureServerOptions::new creates options" {
  let options = SecureServerOptions::new()
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test ServerOptions to_any conversion
test "ServerOptions to_any creates valid object" {
  let options = ServerOptions::new()
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test SecureServerOptions to_any conversion
test "SecureServerOptions to_any creates valid object" {
  let options = SecureServerOptions::new()
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj), content="object")
}
