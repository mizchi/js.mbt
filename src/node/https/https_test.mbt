///|
/// Test HTTPS Agent creation
test "Agent::new creates an agent" {
  let agent = Agent::new()
  inspect(@js.typeof_(agent.to_any()), content="object")
}

///|
/// Test HTTPS Agent with options
test "Agent::new with options creates an agent" {
  let agent = Agent::new(keep_alive=true, timeout=5000)
  inspect(@js.typeof_(agent.to_any()), content="object")
}

///|
/// Test global agent
test "global_agent returns agent instance" {
  let agent = global_agent()
  inspect(@js.typeof_(agent.to_any()), content="object")
}
