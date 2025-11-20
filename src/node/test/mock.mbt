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
    (Some(orig), Some(imp)) => self.call2("fn", orig, imp)
    (Some(orig), None) => self.call("fn", [orig])
    (None, Some(imp)) => self.call("fn", [imp])
    (None, None) => self.call0("fn")
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
    None => self.call2("method", object, methodName)
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
    None => self.call2("getter", object, methodName)
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
    None => self.call2("setter", object, methodName)
  }
}

///|
/// Mock a module import
/// mock.module(specifier[, options])
pub fn MockTracker::module_(
  self : MockTracker,
  specifier : String,
  defaultExport? : Js,
  namedExports? : Js,
) -> Unit {
  let options = @js.Object::new()
  if defaultExport is Some(exp) {
    options.set("defaultExport", exp)
  }
  if namedExports is Some(exp) {
    options.set("namedExports", exp)
  }
  self.call2("module", @js.js(specifier), options) |> ignore
}

///|
/// Mock a property value
/// mock.property(object, propertyName[, value])
pub fn MockTracker::property_(
  self : MockTracker,
  object : Js,
  propertyName : String,
  value? : Js,
) -> Js {
  match value {
    Some(val) => self.call("property", [object, propertyName, val])
    None => self.call2("property", object, propertyName)
  }
}

///|
/// Reset all mocks (clear call tracking without restoration)
pub fn MockTracker::reset(self : MockTracker) -> Unit {
  self.call0("reset") |> ignore
}

///|
/// Restore all mocked functionality
pub fn MockTracker::restoreAll(self : MockTracker) -> Unit {
  self.call0("restoreAll") |> ignore
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
  self.call0("callCount") |> unsafe_cast
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
      self.call2("mockImplementationOnce", implementation, call) |> ignore
    None => self.call("mockImplementationOnce", [implementation]) |> ignore
  }
}

///|
/// Reset call history
pub fn MockFunctionContext::resetCalls(self : MockFunctionContext) -> Unit {
  self.call0("resetCalls") |> ignore
}

///|
/// Restore the original function
pub fn MockFunctionContext::restore(self : MockFunctionContext) -> Unit {
  self.call0("restore") |> ignore
}

///|
/// Get the mock context from a mocked function
pub fn get_mock_context(func : Js) -> MockFunctionContext {
  func.get("mock") |> unsafe_cast
}
