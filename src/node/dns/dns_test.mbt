///|
/// Test LookupOptions creation
test "LookupOptions::new creates options" {
  let options = LookupOptions::new()
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test get_servers returns array
test "get_servers returns array" {
  let servers = get_servers()
  inspect(@js.typeof_(servers.to_js()), content="object")
}
