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
test "conditional property setting" {
  let obj = @js.Object::new()

  // Set with Some value
  match Some("value1") {
    Some(v) => obj.set("key1", v)
    None => ()
  }
  assert_eq(unsafe_cast(obj.get("key1")), "value1")

  // Set with None should not add property
  let v : Int? = None
  match v {
    Some(val) => obj.set("key2", val)
    None => ()
  }
  assert_true(@js.is_undefined(obj.get("key2")))

  // Set with undefined value - check before setting
  match Some(undefined()) {
    Some(val) if not(@js.is_undefined(val)) => obj.set("key3", val)
    _ => ()
  }
  assert_true(@js.is_undefined(obj.get("key3")))
}

///|
test "option_js returns None for nullish values" {
  let obj = @js.Object::new()
  let result = option_js(obj)
  assert_false(result is None)

  // Test with null/undefined values
  let null_obj : @js.Object = @js.unsafe_cast(@js.null_())
  let null_result = option_js(null_obj)
  assert_true(null_result is None)
  let undef_obj : @js.Object = @js.unsafe_cast(@js.undefined())
  let undef_result = option_js(undef_obj)
  assert_true(undef_result is None)
}

///|
test "unsafe_cast_option with Show types" {
  // Test that unsafe_cast_option properly handles types with Show trait
  let num_val = @js.js(42)
  let num_opt : Int? = @js.unsafe_cast_option(num_val)
  assert_eq(num_opt, Some(42))
  let str_val = @js.js("hello")
  let str_opt : String? = @js.unsafe_cast_option(str_val)
  assert_eq(str_opt, Some("hello"))

  // Test with null - should not cause infinite loop
  let null_val = @js.null_()
  let null_opt : String? = @js.unsafe_cast_option(null_val)
  assert_eq(null_opt, None)

  // Test with undefined - should not cause infinite loop
  let undef_val = @js.undefined()
  let undef_opt : String? = @js.unsafe_cast_option(undef_val)
  assert_eq(undef_opt, None)
}

///|
test "Js Show trait with different types" {
  // Test Show trait for numbers
  let num = @js.js(123)
  let num_str = num.to_string()
  assert_eq(num_str, "123")

  // Test Show trait for strings
  let str = @js.js("test")
  let str_str = str.to_string()
  assert_eq(str_str, "test")

  // Test Show trait for booleans
  let bool_val = @js.js(true)
  let bool_str = bool_val.to_string()
  assert_eq(bool_str, "true")

  // Test Show trait for arrays
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  let arr_str = arr.to_js().to_string()
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Test Show trait for objects
  let obj = @js.Object::new()
  obj.set("key", "value")
  let obj_str = obj.to_js().to_string()
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}
