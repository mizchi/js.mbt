///|
/// Timer mocking APIs
/// https://nodejs.org/api/test.html#mocking-timers

///|
#external
pub type MockTimers

///|
pub fn MockTimers::as_any(self : MockTimers) -> @nostd.Any = "%identity"

///|
/// Get the mock.timers object
pub fn mock_timers() -> MockTimers {
  mock().as_any()["timers"].cast()
}

///|
/// Enable timer mocking
/// mock.timers.enable([options])
pub fn MockTimers::enable(
  self : MockTimers,
  apis? : Array[String],
  now? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if apis is Some(apis) {
    options.set("apis", @js.from_array(apis))
  }
  if now is Some(now) {
    options.set("now", now)
  }
  self.as_any()._call("enable", [@nostd.any(options)]) |> ignore
}

///|
/// Advance mocked time by milliseconds
/// mock.timers.tick(milliseconds)
pub fn MockTimers::tick(self : MockTimers, milliseconds : Int) -> Unit {
  self.as_any()._call("tick", [@nostd.any(milliseconds)]) |> ignore
}

///|
/// Execute all queued timers
/// mock.timers.runAll()
pub fn MockTimers::runAll(self : MockTimers) -> Unit {
  self.as_any()._call("runAll", []) |> ignore
}

///|
/// Clear timer queue
/// mock.timers.reset()
pub fn MockTimers::reset(self : MockTimers) -> Unit {
  self.as_any()._call("reset", []) |> ignore
}

///|
/// Set absolute time
/// mock.timers.setTime(milliseconds)
pub fn MockTimers::setTime(self : MockTimers, milliseconds : Int) -> Unit {
  self.as_any()._call("setTime", [@nostd.any(milliseconds)]) |> ignore
}
