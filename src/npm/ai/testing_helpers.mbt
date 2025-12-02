///| AI SDK Test Helpers
/// Provides utilities for testing AI SDK code without making real API calls

///|
/// Provides an incrementing integer ID starting from 0
pub(all) struct MockId {
  mut counter : Int
}

///|
/// Create a new MockId generator
pub fn MockId::new() -> MockId {
  { counter: 0 }
}

///|
/// Get the next ID
pub fn MockId::next(self : MockId) -> Int {
  let id = self.counter
  self.counter += 1
  id
}

///|
/// Get the next ID as a string
pub fn MockId::next_string(self : MockId) -> String {
  self.next().to_string()
}

///|
/// Reset the counter to 0
pub fn MockId::reset(self : MockId) -> Unit {
  self.counter = 0
}

///|
/// Iterates over an array of values with each call.
/// Returns the last value when the array is exhausted.
pub(all) struct MockValues[T] {
  values : Array[T]
  mut counter : Int
}

///|
/// Create a new MockValues iterator
pub fn[T] MockValues::new(values : Array[T]) -> MockValues[T] {
  { values, counter: 0 }
}

///|
/// Get the next value
pub fn[T] MockValues::next(self : MockValues[T]) -> T {
  let index = self.counter
  if index < self.values.length() {
    self.counter += 1
    self.values[index]
  } else {
    // Return the last value when exhausted
    self.values[self.values.length() - 1]
  }
}

///|
/// Reset the counter to 0
pub fn[T] MockValues::reset(self : MockValues[T]) -> Unit {
  self.counter = 0
}

///|
/// Load the test module from ai/test
pub fn require_test() -> @core.Any {
  @node.require("ai/test")
}

///|
/// Get mockId function from ai/test
pub fn mock_id() -> MockId {
  MockId::new()
}

///|
/// Get mockValues function from ai/test (JS version)
/// Returns a function that returns values in order, then the last value
pub fn mock_values_js(values : Array[@core.Any]) -> @core.Any {
  let test_module = require_test()
  let mock_values_fn : @core.Any = test_module._get("mockValues").cast()
  // Call mockValues(...values) using the spread pattern
  @reflect.apply(
    mock_values_fn,
    @core.null(),
    values.map(fn(v) -> @core.Any { v.cast() }),
  ).cast()
}

///|
/// Convert array to async iterable (JS)
pub fn convert_array_to_async_iterable(arr : Array[@core.Any]) -> @core.Any {
  let test_module = require_test()
  test_module._get("convertArrayToAsyncIterable")._invoke([arr |> @core.any])
}

///|
/// Convert array to readable stream (JS)
pub fn convert_array_to_readable_stream(arr : Array[@core.Any]) -> @core.Any {
  let test_module = require_test()
  test_module._get("convertArrayToReadableStream")._invoke([arr |> @core.any])
}

///|
/// Convert readable stream to array (JS)
pub async fn convert_readable_stream_to_array(
  stream : @core.Any,
) -> Array[@core.Any] {
  let test_module = require_test()
  let promise : @js.Promise[Array[@core.Any]] = test_module
    ._get("convertReadableStreamToArray")
    ._invoke([stream])
    |> @core.identity
  promise.wait()
}
