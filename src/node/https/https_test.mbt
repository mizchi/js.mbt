///|
/// Test HTTPS Agent creation
test "Agent::new creates an agent" {
  let options = AgentOptions::new()
  let agent = Agent::new(options)
  inspect(@js.typeof_(agent.to_any()), content="object")
}

///|
/// Test ServerOptions creation
test "ServerOptions::new creates options" {
  let options = ServerOptions::new()
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test RequestOptions creation
test "RequestOptions::new creates options" {
  let options = RequestOptions::new("https://example.com")
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test global agent
test "global_agent returns agent instance" {
  let agent = global_agent()
  inspect(@js.typeof_(agent.to_any()), content="object")
}
