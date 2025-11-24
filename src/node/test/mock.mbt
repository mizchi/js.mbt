///|
/// Mock API for node:test
/// https://nodejs.org/api/test.html#mocking

///|
/// MockTracker - provides mocking capabilities
#external
pub type MockTracker

///|
pub impl @js.JsImpl for MockTracker

///|
/// MockFunctionContext - tracks mock function calls
#external
pub type MockFunctionContext

///|
pub impl @js.JsImpl for MockFunctionContext

///|
/// Get the global mock tracker
pub fn mock() -> MockTracker {
  nodetest().get("mock").cast()
}

///|
/// Create a spy function
/// mock.fn([original[, implementation]][, options])
pub fn MockTracker::fn_(
  self : MockTracker,
  original? : @js.Js,
  implementation? : @js.Js,
) -> @js.Js {
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
  object : @js.Js,
  methodName : String,
  implementation? : @js.Js,
) -> @js.Js {
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
  object : @js.Js,
  methodName : String,
  implementation? : @js.Js,
) -> @js.Js {
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
  object : @js.Js,
  methodName : String,
  implementation? : @js.Js,
) -> @js.Js {
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
  defaultExport? : @js.Js,
  namedExports? : @js.Js,
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
  object : @js.Js,
  propertyName : String,
  value? : @js.Js,
) -> @js.Js {
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
pub fn MockFunctionContext::calls(self : MockFunctionContext) -> Array[@js.Js] {
  self.get("calls").cast()
}

///|
/// Get the call count
pub fn MockFunctionContext::callCount(self : MockFunctionContext) -> Int {
  self.call0("callCount").cast()
}

///|
/// Change mock implementation
pub fn MockFunctionContext::mockImplementation(
  self : MockFunctionContext,
  implementation : @js.Js,
) -> Unit {
  self.call("mockImplementation", [implementation]) |> ignore
}

///|
/// Set implementation for a single call
pub fn MockFunctionContext::mockImplementationOnce(
  self : MockFunctionContext,
  implementation : @js.Js,
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
pub fn get_mock_context(func : @js.Js) -> MockFunctionContext {
  func.get("mock").cast()
}
