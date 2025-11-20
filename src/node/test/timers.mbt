///|
/// Timer mocking APIs
/// https://nodejs.org/api/test.html#mocking-timers

///|
#external
pub type MockTimers

///|
pub impl JsImpl for MockTimers

///|
/// Get the mock.timers object
pub fn mock_timers() -> MockTimers {
  mock().get("timers") |> unsafe_cast
}

///|
/// Enable timer mocking
/// mock.timers.enable([options])
pub fn MockTimers::enable(
  self : MockTimers,
  apis? : Array[String],
  now? : Int,
) -> Unit {
  let options = @js.Object::new()
  if apis is Some(apis) {
    options.set("apis", @js.from_array(apis))
  }
  if now is Some(now) {
    options.set("now", now)
  }
  self.call("enable", [options]) |> ignore
}

///|
/// Advance mocked time by milliseconds
/// mock.timers.tick(milliseconds)
pub fn MockTimers::tick(self : MockTimers, milliseconds : Int) -> Unit {
  self.call("tick", [@js.js(milliseconds)]) |> ignore
}

///|
/// Execute all queued timers
/// mock.timers.runAll()
pub fn MockTimers::runAll(self : MockTimers) -> Unit {
  self.call0("runAll") |> ignore
}

///|
/// Clear timer queue
/// mock.timers.reset()
pub fn MockTimers::reset(self : MockTimers) -> Unit {
  self.call0("reset") |> ignore
}

///|
/// Set absolute time
/// mock.timers.setTime(milliseconds)
pub fn MockTimers::setTime(self : MockTimers, milliseconds : Int) -> Unit {
  self.call("setTime", [@js.js(milliseconds)]) |> ignore
}
