///|
/// Test ServerOptions creation
test "ServerOptions::new creates options" {
  let options = ServerOptions::new()
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test ConnectOptions creation
test "ConnectOptions::new creates options" {
  let options = ConnectOptions::new(443, "example.com")
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
/// Test ConnectOptions to_js conversion
test "ConnectOptions to_js creates valid object" {
  let options = ConnectOptions::new(8443, "localhost")
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj), content="object")
}
