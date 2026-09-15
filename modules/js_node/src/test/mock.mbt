///|
/// Mock API for node:test
/// https://nodejs.org/api/test.html#mocking

///|
/// MockTracker - provides mocking capabilities
#external
pub type MockTracker

///|
pub fn MockTracker::as_any(self : MockTracker) -> @core.Any = "%identity"

///|
/// MockFunctionContext - tracks mock function calls
#external
pub type MockFunctionContext

///|
pub fn MockFunctionContext::as_any(self : MockFunctionContext) -> @core.Any = "%identity"

///|
/// Get the global mock tracker
pub fn mock() -> MockTracker {
  @core.any(nodetest())["mock"].cast()
}

///|
/// Create a spy function
/// mock.fn([original[, implementation]][, options])
pub fn MockTracker::fn_(
  self : MockTracker,
  original? : @core.Any,
  implementation? : @core.Any,
) -> @core.Any {
  match (original, implementation) {
    (Some(orig), Some(imp)) =>
      self.as_any()._call("fn", [@core.any(orig), @core.any(imp)]).cast()
    (Some(orig), None) => self.as_any()._call("fn", [@core.any(orig)]).cast()
    (None, Some(imp)) => self.as_any()._call("fn", [@core.any(imp)]).cast()
    (None, None) => self.as_any()._call("fn", []).cast()
  }
}

///|
/// Mock an object method
/// mock.method(object, methodName[, implementation][, options])
pub fn MockTracker::method_(
  self : MockTracker,
  object : @core.Any,
  methodName : String,
  implementation? : @core.Any,
) -> @core.Any {
  match implementation {
    Some(imp) =>
      self
      .as_any()
      ._call("method", [
        @core.any(object),
        @core.any(methodName),
        @core.any(imp),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("method", [@core.any(object), @core.any(methodName)])
      .cast()
  }
}

///|
/// Mock a property getter
/// mock.getter(object, methodName[, implementation][, options])
pub fn MockTracker::getter_(
  self : MockTracker,
  object : @core.Any,
  methodName : String,
  implementation? : @core.Any,
) -> @core.Any {
  match implementation {
    Some(imp) =>
      self
      .as_any()
      ._call("getter", [
        @core.any(object),
        @core.any(methodName),
        @core.any(imp),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("getter", [@core.any(object), @core.any(methodName)])
      .cast()
  }
}

///|
/// Mock a property setter
/// mock.setter(object, methodName[, implementation][, options])
pub fn MockTracker::setter_(
  self : MockTracker,
  object : @core.Any,
  methodName : String,
  implementation? : @core.Any,
) -> @core.Any {
  match implementation {
    Some(imp) =>
      self
      .as_any()
      ._call("setter", [
        @core.any(object),
        @core.any(methodName),
        @core.any(imp),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("setter", [@core.any(object), @core.any(methodName)])
      .cast()
  }
}

///|
/// Mock a module import
/// mock.module(specifier[, options])
pub fn MockTracker::module_(
  self : MockTracker,
  specifier : String,
  defaultExport? : @core.Any,
  namedExports? : @core.Any,
) -> Unit {
  let options = @core.new_object()
  if defaultExport is Some(exp) {
    options._set("defaultExport", exp)
  }
  if namedExports is Some(exp) {
    options._set("namedExports", exp)
  }
  self.as_any()._call("module", [@core.any(specifier), @core.any(options)])
  |> ignore
}

///|
/// Mock a property value
/// mock.property(object, propertyName[, value])
pub fn MockTracker::property_(
  self : MockTracker,
  object : @core.Any,
  propertyName : String,
  value? : @core.Any,
) -> @core.Any {
  match value {
    Some(val) =>
      self
      .as_any()
      ._call("property", [
        @core.any(object),
        @core.any(propertyName),
        @core.any(val),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("property", [@core.any(object), @core.any(propertyName)])
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
) -> Array[@core.Any] {
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
  implementation : @core.Any,
) -> Unit {
  self.as_any()._call("mockImplementation", [@core.any(implementation)])
  |> ignore
}

///|
/// Set implementation for a single call
pub fn MockFunctionContext::mockImplementationOnce(
  self : MockFunctionContext,
  implementation : @core.Any,
  onCall? : Int,
) -> Unit {
  match onCall {
    Some(call) =>
      self
      .as_any()
      ._call("mockImplementationOnce", [
        @core.any(implementation),
        @core.any(call),
      ])
      |> ignore
    None =>
      self.as_any()._call("mockImplementationOnce", [@core.any(implementation)])
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
pub fn get_mock_context(func : @core.Any) -> MockFunctionContext {
  @core.any(func)["mock"].cast()
}
