///|
/// Test get_servers returns array
test "get_servers returns array" {
  let servers = get_servers()
  inspect(@js.typeof_(servers.as_any()), content="object")
}
