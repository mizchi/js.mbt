///|
/// Mock API for node:test
/// https://nodejs.org/api/test.html#mocking

///|
/// MockTracker - provides mocking capabilities
#external
pub type MockTracker

///|
pub impl JsImpl for MockTracker

///|
/// MockFunctionContext - tracks mock function calls
#external
pub type MockFunctionContext

///|
pub impl JsImpl for MockFunctionContext

///|
/// Get the global mock tracker
pub fn mock() -> MockTracker {
  nodetest().get("mock") |> unsafe_cast
}

///|
/// Create a spy function
/// mock.fn([original[, implementation]][, options])
pub fn MockTracker::fn_(
  self : MockTracker,
  original? : Js,
  implementation? : Js,
) -> Js {
  match (original, implementation) {
    (Some(orig), Some(imp)) => self.call("fn", [orig, imp])
    (Some(orig), None) => self.call("fn", [orig])
    (None, Some(imp)) => self.call("fn", [imp])
    (None, None) => self.call("fn", [])
  }
}

///|
/// Mock an object method
/// mock.method(object, methodName[, implementation][, options])
pub fn MockTracker::method_(
  self : MockTracker,
  object : Js,
  methodName : String,
  implementation? : Js,
) -> Js {
  match implementation {
    Some(imp) => self.call("method", [object, methodName, imp])
    None => self.call("method", [object, methodName])
  }
}

///|
/// Mock a property getter
/// mock.getter(object, methodName[, implementation][, options])
pub fn MockTracker::getter_(
  self : MockTracker,
  object : Js,
  methodName : String,
  implementation? : Js,
) -> Js {
  match implementation {
    Some(imp) => self.call("getter", [object, methodName, imp])
    None => self.call("getter", [object, methodName])
  }
}

///|
/// Mock a property setter
/// mock.setter(object, methodName[, implementation][, options])
pub fn MockTracker::setter_(
  self : MockTracker,
  object : Js,
  methodName : String,
  implementation? : Js,
) -> Js {
  match implementation {
    Some(imp) => self.call("setter", [object, methodName, imp])
    None => self.call("setter", [object, methodName])
  }
}

///|
/// Reset all mocks (clear call tracking without restoration)
pub fn MockTracker::reset(self : MockTracker) -> Unit {
  self.call("reset", []) |> ignore
}

///|
/// Restore all mocked functionality
pub fn MockTracker::restoreAll(self : MockTracker) -> Unit {
  self.call("restoreAll", []) |> ignore
}

///|
/// MockFunctionContext methods

///|
/// Get the calls array
pub fn MockFunctionContext::calls(self : MockFunctionContext) -> Array[Js] {
  self.get("calls") |> unsafe_cast
}

///|
/// Get the call count
pub fn MockFunctionContext::callCount(self : MockFunctionContext) -> Int {
  self.call("callCount", []) |> unsafe_cast
}

///|
/// Change mock implementation
pub fn MockFunctionContext::mockImplementation(
  self : MockFunctionContext,
  implementation : Js,
) -> Unit {
  self.call("mockImplementation", [implementation]) |> ignore
}

///|
/// Set implementation for a single call
pub fn MockFunctionContext::mockImplementationOnce(
  self : MockFunctionContext,
  implementation : Js,
  onCall? : Int,
) -> Unit {
  match onCall {
    Some(call) =>
      self.call("mockImplementationOnce", [implementation, call]) |> ignore
    None => self.call("mockImplementationOnce", [implementation]) |> ignore
  }
}

///|
/// Reset call history
pub fn MockFunctionContext::resetCalls(self : MockFunctionContext) -> Unit {
  self.call("resetCalls", []) |> ignore
}

///|
/// Restore the original function
pub fn MockFunctionContext::restore(self : MockFunctionContext) -> Unit {
  self.call("restore", []) |> ignore
}

///|
/// Get the mock context from a mocked function
pub fn get_mock_context(func : Js) -> MockFunctionContext {
  func.get("mock") |> unsafe_cast
}
