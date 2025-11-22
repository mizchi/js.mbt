///|
/// Test ServerOptions creation
test "ServerOptions::new creates options" {
  let options = ServerOptions::new()
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test SecureServerOptions creation
test "SecureServerOptions::new creates options" {
  let options = SecureServerOptions::new()
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test ServerOptions to_js conversion
test "ServerOptions to_js creates valid object" {
  let options = ServerOptions::new()
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test SecureServerOptions to_js conversion
test "SecureServerOptions to_js creates valid object" {
  let options = SecureServerOptions::new()
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj), content="object")
}
