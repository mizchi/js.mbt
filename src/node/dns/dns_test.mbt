///|
/// Test get_servers returns array
test "get_servers returns array" {
  let servers = get_servers()
  inspect(@core.typeof_(servers |> @js.any), content="object")
}
