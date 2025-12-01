///|
/// Mock API for node:test
/// https://nodejs.org/api/test.html#mocking

///|
/// MockTracker - provides mocking capabilities
#external
pub type MockTracker

///|
pub fn MockTracker::as_any(self : MockTracker) -> @nostd.Any = "%identity"

///|
/// MockFunctionContext - tracks mock function calls
#external
pub type MockFunctionContext

///|
pub fn MockFunctionContext::as_any(self : MockFunctionContext) -> @nostd.Any = "%identity"

///|
/// Get the global mock tracker
pub fn mock() -> MockTracker {
  @nostd.any(nodetest())["mock"].cast()
}

///|
/// Create a spy function
/// mock.fn([original[, implementation]][, options])
pub fn MockTracker::fn_(
  self : MockTracker,
  original? : @nostd.Any,
  implementation? : @nostd.Any,
) -> @nostd.Any {
  match (original, implementation) {
    (Some(orig), Some(imp)) =>
      self.as_any()._call("fn", [@nostd.any(orig), @nostd.any(imp)]).cast()
    (Some(orig), None) => self.as_any()._call("fn", [@nostd.any(orig)]).cast()
    (None, Some(imp)) => self.as_any()._call("fn", [@nostd.any(imp)]).cast()
    (None, None) => self.as_any()._call("fn", []).cast()
  }
}

///|
/// Mock an object method
/// mock.method(object, methodName[, implementation][, options])
pub fn MockTracker::method_(
  self : MockTracker,
  object : @nostd.Any,
  methodName : String,
  implementation? : @nostd.Any,
) -> @nostd.Any {
  match implementation {
    Some(imp) =>
      self
      .as_any()
      ._call("method", [
        @nostd.any(object),
        @nostd.any(methodName),
        @nostd.any(imp),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("method", [@nostd.any(object), @nostd.any(methodName)])
      .cast()
  }
}

///|
/// Mock a property getter
/// mock.getter(object, methodName[, implementation][, options])
pub fn MockTracker::getter_(
  self : MockTracker,
  object : @nostd.Any,
  methodName : String,
  implementation? : @nostd.Any,
) -> @nostd.Any {
  match implementation {
    Some(imp) =>
      self
      .as_any()
      ._call("getter", [
        @nostd.any(object),
        @nostd.any(methodName),
        @nostd.any(imp),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("getter", [@nostd.any(object), @nostd.any(methodName)])
      .cast()
  }
}

///|
/// Mock a property setter
/// mock.setter(object, methodName[, implementation][, options])
pub fn MockTracker::setter_(
  self : MockTracker,
  object : @nostd.Any,
  methodName : String,
  implementation? : @nostd.Any,
) -> @nostd.Any {
  match implementation {
    Some(imp) =>
      self
      .as_any()
      ._call("setter", [
        @nostd.any(object),
        @nostd.any(methodName),
        @nostd.any(imp),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("setter", [@nostd.any(object), @nostd.any(methodName)])
      .cast()
  }
}

///|
/// Mock a module import
/// mock.module(specifier[, options])
pub fn MockTracker::module_(
  self : MockTracker,
  specifier : String,
  defaultExport? : @nostd.Any,
  namedExports? : @nostd.Any,
) -> Unit {
  let options = @nostd.Object::new()
  if defaultExport is Some(exp) {
    options.set("defaultExport", exp)
  }
  if namedExports is Some(exp) {
    options.set("namedExports", exp)
  }
  self.as_any()._call("module", [@nostd.any(specifier), @nostd.any(options)])
  |> ignore
}

///|
/// Mock a property value
/// mock.property(object, propertyName[, value])
pub fn MockTracker::property_(
  self : MockTracker,
  object : @nostd.Any,
  propertyName : String,
  value? : @nostd.Any,
) -> @nostd.Any {
  match value {
    Some(val) =>
      self
      .as_any()
      ._call("property", [
        @nostd.any(object),
        @nostd.any(propertyName),
        @nostd.any(val),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("property", [@nostd.any(object), @nostd.any(propertyName)])
      .cast()
  }
}

///|
/// Reset all mocks (clear call tracking without restoration)
pub fn MockTracker::reset(self : MockTracker) -> Unit {
  self.as_any()._call("reset", []) |> ignore
}

///|
/// Restore all mocked functionality
pub fn MockTracker::restoreAll(self : MockTracker) -> Unit {
  self.as_any()._call("restoreAll", []) |> ignore
}

///|
/// MockFunctionContext methods

///|
/// Get the calls array
pub fn MockFunctionContext::calls(
  self : MockFunctionContext,
) -> Array[@nostd.Any] {
  self.as_any()["calls"].cast()
}

///|
/// Get the call count
pub fn MockFunctionContext::callCount(self : MockFunctionContext) -> Int {
  self.as_any()._call("callCount", []).cast()
}

///|
/// Change mock implementation
pub fn MockFunctionContext::mockImplementation(
  self : MockFunctionContext,
  implementation : @nostd.Any,
) -> Unit {
  self.as_any()._call("mockImplementation", [@nostd.any(implementation)])
  |> ignore
}

///|
/// Set implementation for a single call
pub fn MockFunctionContext::mockImplementationOnce(
  self : MockFunctionContext,
  implementation : @nostd.Any,
  onCall? : Int,
) -> Unit {
  match onCall {
    Some(call) =>
      self
      .as_any()
      ._call("mockImplementationOnce", [
        @nostd.any(implementation),
        @nostd.any(call),
      ])
      |> ignore
    None =>
      self
      .as_any()
      ._call("mockImplementationOnce", [@nostd.any(implementation)])
      |> ignore
  }
}

///|
/// Reset call history
pub fn MockFunctionContext::resetCalls(self : MockFunctionContext) -> Unit {
  self.as_any()._call("resetCalls", []) |> ignore
}

///|
/// Restore the original function
pub fn MockFunctionContext::restore(self : MockFunctionContext) -> Unit {
  self.as_any()._call("restore", []) |> ignore
}

///|
/// Get the mock context from a mocked function
pub fn get_mock_context(func : @nostd.Any) -> MockFunctionContext {
  @nostd.any(func)["mock"].cast()
}
