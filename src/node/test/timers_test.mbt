///|
// Tests for Node.js test mock timers

///|
using @test {mock_timers}

///|
test "MockTimers functionality" {
  let timers = mock_timers()

  // Test enable with apis
  timers.enable(apis=["setTimeout", "setInterval"])
  inspect(true, content="true")

  // Test tick
  timers.tick(100)
  inspect(true, content="true")

  // Reset for next test
  timers.reset()

  // Test enable with now
  timers.enable(now=1000)
  inspect(true, content="true")
}
