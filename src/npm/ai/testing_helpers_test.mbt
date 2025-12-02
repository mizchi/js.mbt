///| Test helpers tests

///|
test "MockId generates incrementing IDs" {
  let id = MockId::new()
  assert_eq(id.next(), 0)
  assert_eq(id.next(), 1)
  assert_eq(id.next(), 2)
}

///|
test "MockId next_string returns string" {
  let id = MockId::new()
  assert_eq(id.next_string(), "0")
  assert_eq(id.next_string(), "1")
}

///|
test "MockId reset resets counter" {
  let id = MockId::new()
  assert_eq(id.next(), 0)
  assert_eq(id.next(), 1)
  id.reset()
  assert_eq(id.next(), 0)
}

///|
test "MockValues returns values in order" {
  let values = MockValues::new(["a", "b", "c"])
  assert_eq(values.next(), "a")
  assert_eq(values.next(), "b")
  assert_eq(values.next(), "c")
}

///|
test "MockValues returns last value when exhausted" {
  let values = MockValues::new(["a", "b"])
  assert_eq(values.next(), "a")
  assert_eq(values.next(), "b")
  assert_eq(values.next(), "b") // Returns last value
  assert_eq(values.next(), "b") // Still returns last value
}

///|
test "MockValues reset resets counter" {
  let values = MockValues::new(["a", "b"])
  assert_eq(values.next(), "a")
  assert_eq(values.next(), "b")
  values.reset()
  assert_eq(values.next(), "a")
}

///|
test "require_test loads ai/test module" {
  let test_module = require_test()
  // Check that MockLanguageModelV3 exists
  let mock_class = test_module._get("MockLanguageModelV3")
  assert_false(@nostd.is_undefined(mock_class))
}

///|
test "mock_values_js works with JS values" {
  let mock_fn = mock_values_js(["first" |> @js.any, "second" |> @js.any])
  let first : String = mock_fn._invoke([]).cast()
  let second : String = mock_fn._invoke([]).cast()
  let third : String = mock_fn._invoke([]).cast() // Should return last
  assert_eq(first, "first")
  assert_eq(second, "second")
  assert_eq(third, "second")
}
