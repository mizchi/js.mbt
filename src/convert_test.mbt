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
test "from_fn0 converts 0-arg function to Js" {
  let greet = fn() -> String { "Hello" }
  let js_greet : @core.Any = @core.from_fn0(greet)
  assert_eq(@core.typeof_(js_greet), "function")
  let result = js_greet._invoke([])
  assert_eq(@core.identity(result), "Hello")
}

///|
test "from_fn1 converts 1-arg function to Js" {
  let double = fn(x : Int) -> Int { x * 2 }
  let js_double : @core.Any = @core.from_fn1(double)
  assert_eq(@core.typeof_(js_double), "function")
  let result = js_double._invoke([@core.any(5)])
  assert_eq(@core.identity(result), 10)
}

///|
test "from_fn3 converts 3-arg function to Js" {
  let add3 = fn(a : Int, b : Int, c : Int) -> Int { a + b + c }
  let js_add3 : @core.Any = @core.from_fn3(add3)
  assert_eq(@core.typeof_(js_add3), "function")
  let result = js_add3._invoke([@core.any(1), @core.any(2), @core.any(3)])
  assert_eq(@core.identity(result), 6)
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

// ///|
// test "from_entries and to_string" {
//   let obj : @core.Any = @core.from_entries([
//     ("name", @core.any("Alice")),
//     ("age", @core.any(30)),
//   ]).cast()
//   inspect(
//     JSON::stringify(obj),
//     content=(
//       #|{
//       #|  "name": "Alice",
//       #|  "age": 30
//       #|}
//     ),
//   )
// }
