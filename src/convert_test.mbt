///| JSON

///|
test "JSON::stringify" {
  let arr : Array[Int] = [1] |> identity
  arr |> inspect(content="[1]")
  JSON::stringify(arr |> @core.any, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v : @core.Any = @core.from_entries([
    ("key1", @core.any(123)),
    ("key2", @core.any(456)),
    ("key3", @core.any(789)),
  ]).cast()
  JSON::stringify(v, space=2)
  |> inspect(
    content=(
      #|{
      #|  "key1": 123,
      #|  "key2": 456,
      #|  "key3": 789
      #|}
    ),
  )
}

///|
test "JsImpl for Option types" {
  let some_val : Int? = Some(42)
  let none_val : Int? = None
  let js_some : @core.Any = @core.any(some_val)
  let js_none : @core.Any = @core.any(none_val)
  assert_eq(@core.identity(js_some), 42)
  assert_true(@core.is_undefined(js_none))
}

///| ThrowError Tests - JavaScript Built-in Error Types

///|
/// Test TypeError is caught correctly
test "throwable catches TypeError" {
  let mut caught_type_error = false
  throwable(fn() {
    let null_val = @core.null()
    // Calling a method on null will throw TypeError
    null_val._call("toString", []) |> ignore
  }) catch {
    _ => caught_type_error = true
    // _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_type_error)
}
