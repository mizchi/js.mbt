///|
test "Val cast primitive types" {
  // Integer
  let int_val = js(42)
  let int_result : Int = unsafe_cast(int_val)
  assert_eq(int_result, 42)

  // Double
  let double_val = js(3.14)
  let double_result : Double = unsafe_cast(double_val)
  assert_eq(double_result, 3.14)

  // String
  let str_val = js("hello")
  let str_result : String = unsafe_cast(str_val)
  assert_eq(str_result, "hello")

  // Boolean
  let bool_val = js(true)
  let bool_result : Bool = unsafe_cast(bool_val)
  assert_eq(bool_result, true)
}

///|
test "Val cast_option" {
  // Some cases
  let some_str : String? = js("hello") |> @js.unsafe_cast_option()
  assert_eq(some_str, Some("hello"))
  let some_int : Int? = js(42) |> @js.unsafe_cast_option()
  assert_eq(some_int, Some(42))

  // None cases
  let none_str : String? = undefined() |> @js.unsafe_cast_option()
  assert_eq(none_str, None)
  let none_int : Int? = null_() |> @js.unsafe_cast_option()
  assert_eq(none_int, None)
}

///|
test "set_if_exists" {
  let obj = @js.Object::new()

  // Set with Some value
  set_if_exists(obj, "key1", Some("value1"))
  assert_eq(unsafe_cast(obj.get("key1")), "value1")

  // Set with None should not add property
  let v : Int? = None
  set_if_exists(obj, "key2", v)
  assert_true(@js.is_undefined(obj.get("key2")))

  // Set with undefined value should not add property
  set_if_exists(obj, "key3", Some(undefined()))
  assert_true(@js.is_undefined(obj.get("key3")))
}
