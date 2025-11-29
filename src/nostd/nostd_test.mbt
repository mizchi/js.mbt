///|
test "get and set property" {
  let global = global_this()
  let obj = global["Object"]
  // Object.create(null) to create empty object
  let args = array_new()
  array_push(args, null())
  let empty_obj = obj._call("create", args)
  empty_obj["foo"] = JsValue::from("bar")
  let value = empty_obj["foo"]
  // value should be "bar" but we can't easily assert without std lib
  // just verify no runtime error
  let _ = value

}

///|
test "call method with JsArray" {
  let global = global_this()
  let console = global["console"]
  let args = array_new()
  array_push(args, JsValue::from("test message from nostd"))
  let _ = console._call("log", args)

}

///|
test "is_nullish" {
  let global = global_this()
  let undef = global["nonexistent_property_xyz"]
  assert_true(is_nullish(undef))
  let console = global["console"]
  assert_true(is_nullish(console) == false)
}

///|
test "undefined" {
  let undef = undefined()
  assert_true(is_nullish(undef))
}

///|
test "int conversion" {
  let n = JsValue::from(42)
  let _ = n
  // verify no runtime error
}

///|
test "invoke" {
  let global = global_this()
  let parse_int = global["parseInt"]
  let args = array_new()
  array_push(args, JsValue::from("42"))
  let result = parse_int.invoke(args)
  let _ = result
  // verify no runtime error
}

// Type conversion tests using %identity (zero-cost)

///|
test "JsValue::from and cast - Int" {
  // Int -> JsValue -> Int (zero-cost conversion)
  let n : Int = 42
  let js_val : JsValue = JsValue::from(n)
  let back : Int = js_val.cast()
  assert_eq(back, 42)
}

///|
test "JsValue::from and cast - Double" {
  // Double -> JsValue -> Double (zero-cost conversion)
  let d : Double = 3.14
  let js_val : JsValue = JsValue::from(d)
  let back : Double = js_val.cast()
  assert_true(back > 3.13 && back < 3.15)
}

///|
test "JsValue::from and cast - Bool" {
  // Bool -> JsValue -> Bool (zero-cost conversion)
  let b : Bool = true
  let js_val : JsValue = JsValue::from(b)
  let back : Bool = js_val.cast()
  assert_eq(back, true)
}

///|
test "JsValue::from and cast - String" {
  // String -> JsValue -> String (zero-cost conversion)
  let s : String = "hello"
  let js_val : JsValue = JsValue::from(s)
  let back : String = js_val.cast()
  assert_eq(back, "hello")
}

///|
test "parseInt with JsValue::from" {
  // Use JsValue::from instead of str() for zero-cost conversion
  let global = global_this()
  let parse_int = global["parseInt"]
  let args = array_new()
  array_push(args, JsValue::from("123"))
  let result = parse_int.invoke(args)
  let n : Int = result.cast()
  assert_eq(n, 123)
}

///|
test "Math operations with cast" {
  let global = global_this()
  let math = global["Math"]
  let args = array_new()
  array_push(args, JsValue::from(16.0))
  let result = math._call("sqrt", args)
  let n : Double = result.cast()
  assert_eq(n, 4.0)
}

// Property access syntax tests (obj["key"])

///|
test "JsValue::_get with bracket syntax" {
  let global = global_this()
  // Using bracket syntax: global["console"]
  let console = global["console"]
  assert_true(is_nullish(console) == false)
}

///|
test "JsValue::_set with bracket syntax" {
  let global = global_this()
  let obj = global["Object"]
  let args = array_new()
  array_push(args, null())
  let empty_obj = obj._call("create", args)
  // Using bracket syntax: empty_obj["foo"] = value
  empty_obj["foo"] = JsValue::from("bar")
  let value = empty_obj["foo"]
  let s : String = value.cast()
  assert_eq(s, "bar")
}

///|
test "nested property access with bracket syntax" {
  let global = global_this()
  let math = global["Math"]
  let pi = math["PI"]
  let n : Double = pi.cast()
  assert_true(n > 3.14 && n < 3.15)
}
