///|
test "get and set property" {
  let global = global_this()
  let obj = global["Object"]
  // Object.create(null) to create empty object
  let empty_obj = obj._call("create", [null()])
  empty_obj["foo"] = any("bar")
  let value = empty_obj["foo"]
  // value should be "bar" but we can't easily assert without std lib
  // just verify no runtime error
  let _ = value

}

///|
test "call method with Array[Any]" {
  let global = global_this()
  let console = global["console"]
  console._call("log", [any("test message from nostd")]) |> ignore
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
  let n = any(42)
  let _ = n
  // verify no runtime error
}

///|
test "invoke" {
  let global = global_this()
  let parse_int = global["parseInt"]
  let result = parse_int._invoke([any("42")])
  let _ = result
  // verify no runtime error
}

// Type conversion tests using %identity (zero-cost)

///|
test "any and cast - Int" {
  // Int -> Any -> Int (zero-cost conversion)
  let n : Int = 42
  let js_val : Any = any(n)
  let back : Int = js_val.cast()
  assert_eq(back, 42)
}

///|
test "any and cast - Double" {
  // Double -> Any -> Double (zero-cost conversion)
  let d : Double = 3.14
  let js_val : Any = any(d)
  let back : Double = js_val.cast()
  assert_true(back > 3.13 && back < 3.15)
}

///|
test "any and cast - Bool" {
  // Bool -> Any -> Bool (zero-cost conversion)
  let b : Bool = true
  let js_val : Any = any(b)
  let back : Bool = js_val.cast()
  assert_eq(back, true)
}

///|
test "any and cast - String" {
  // String -> Any -> String (zero-cost conversion)
  let s : String = "hello"
  let js_val : Any = any(s)
  let back : String = js_val.cast()
  assert_eq(back, "hello")
}

///|
test "parseInt with any" {
  // Use any instead of str() for zero-cost conversion
  let global = global_this()
  let parse_int = global["parseInt"]
  let result = parse_int._invoke([any("123")])
  let n : Int = result.cast()
  assert_eq(n, 123)
}

///|
test "Math operations with cast" {
  let global = global_this()
  let math = global["Math"]
  let result = math._call("sqrt", [any(16.0)])
  let n : Double = result.cast()
  assert_eq(n, 4.0)
}

// Property access syntax tests (obj["key"])

///|
test "Any::_get with bracket syntax" {
  let global = global_this()
  // Using bracket syntax: global["console"]
  let console = global["console"]
  assert_true(is_nullish(console) == false)
}

///|
test "Any::_set with bracket syntax" {
  let global = global_this()
  let obj = global["Object"]
  let empty_obj = obj._call("create", [null()])
  // Using bracket syntax: empty_obj["foo"] = value
  empty_obj["foo"] = any("bar")
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
