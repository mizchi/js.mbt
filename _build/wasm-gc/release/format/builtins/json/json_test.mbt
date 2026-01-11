///| JSON tests

///|
test "JSON::stringify for different types" {
  // Numbers
  let num = @core.any(123)
  assert_eq(num.to_string(), "123")

  // Strings
  let str = @core.any("test")
  assert_eq(str.to_string(), "test")

  // Booleans
  let bool_val = @core.any(true)
  assert_eq(bool_val.to_string(), "true")

  // Arrays
  let arr = @core.any([1, 2])
  let arr_str = JSON::stringify(arr)
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Objects
  let obj = @core.new_object()
  obj._set("key", "value" |> @core.any)
  let obj_str = JSON::stringify(obj)
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}

///|
test "JSON::stringify with various objects" {
  let obj = @core.new_object()
  obj._set("name", "Alice" |> @core.any)
  obj._set("age", 30 |> @core.any)
  let obj_typed = @core.identity(obj)
  let str = obj_typed |> JSON::stringify
  assert_true(str.contains("name"))
  assert_true(str.contains("Alice"))
  assert_true(str.contains("age"))
  assert_true(str.contains("30"))
}
