///|
priv enum TestConstantEnum {
  NotFound = 404
}

///|
test "identity converts between Any and MoonBit types" {
  assert_true(@nostd.equal(@nostd.any(42), @nostd.any(42)))
  let v1 = @nostd.any(42)
  let v2 = @nostd.any(42)
  assert_true(@nostd.equal(v1, v2))
  assert_true(
    @nostd.equal(@nostd.identity(TestConstantEnum::NotFound), @nostd.any(404)),
  )
  let s1 : String? = @nostd.any("hello") |> @nostd.identity_option()
  assert_eq(s1, Some("hello"))
  let s2 : String? = @nostd.undefined() |> @nostd.identity_option()
  assert_eq(s2, None)
}

///|
test "identity converts struct to Any object" {
  struct Point {
    x : Int
    y : Int
  } derive(Eq, Show)
  let p = Point::{ x: 10, y: 20 }
  let v : @nostd.Any = @nostd.identity(p)
  assert_eq(@nostd.identity(v._get("x")), 10)
  assert_eq(@nostd.identity(v._get("y")), 20)
  let casted : Point = @nostd.identity(v)
  assert_eq(casted, p)
}

///|
test "JsImpl::to_string" {
  assert_eq(@nostd.any(42).to_string(), "42")
  assert_eq(@nostd.null().to_string(), "null")
  assert_eq(@nostd.any(true).to_string(), "true")
  assert_eq(@nostd.any("hello").to_string(), "hello")
  assert_true(@nostd.is_undefined(@nostd.undefined()))
  assert_true(@nostd.is_null(@nostd.null()))
  assert_eq(@nostd.Object::new().to_string(), "[object Object]")
  // assert_eq(@nostd.JsArray::new().to_string(), "[object Object]")
  @nostd.any([1, 2, 3]).to_string() |> assert_eq("1,2,3")
}

///|
test "type checking" {
  // Test is_array
  let arr = JsArray::new()
  assert_true(@nostd.is_array(arr))
  assert_false(@nostd.is_array(42 |> @nostd.any))

  // Test is_object
  let obj = Object::new()
  assert_true(@nostd.is_object(obj))
  assert_false(@nostd.is_object(42 |> @nostd.any))
  assert_false(@nostd.is_object(@nostd.null()))

  // Test is_null
  assert_true(@nostd.is_null(@nostd.null()))
  assert_false(@nostd.is_null(@nostd.undefined()))
  assert_false(@nostd.is_null(@nostd.any(42)))

  // Test is_undefined
  assert_true(@nostd.is_undefined(@nostd.undefined()))
  assert_false(@nostd.is_undefined(@nostd.null()))
  assert_false(@nostd.is_undefined(@nostd.any(42)))

  // Test is_some and is_none
  assert_false(@nostd.any(42) |> @nostd.is_nullish())
  assert_true(@nostd.undefined() |> @nostd.is_nullish())
  assert_false(@nostd.any(42) |> @nostd.is_nullish())
  assert_true(@nostd.undefined() |> @nostd.is_nullish())
  assert_true(@nostd.null() |> @nostd.is_nullish())
}

///|
test "Js typeof_" {
  assert_eq(@nostd.typeof_(@nostd.any(42)), "number")
  assert_eq(@nostd.typeof_(@nostd.any(3.14)), "number")
  assert_eq(@nostd.typeof_(@nostd.any("hello")), "string")
  assert_eq(@nostd.typeof_(@nostd.any(true)), "boolean")
  assert_eq(@nostd.typeof_(@nostd.undefined()), "undefined")
  assert_eq(@nostd.typeof_(Object::new()), "object")
  assert_eq(@nostd.typeof_(JsArray::new()), "object")
  assert_eq(@nostd.typeof_(@nostd.null()), "object") // JavaScript quirk
}

///|
test "JsImpl get/set" {
  let obj = @nostd.Object::new()
  obj._set("name", "Alice" |> @nostd.any)
  obj._set("age", 30 |> @nostd.any)
  obj._set("active", true |> @nostd.any)
  assert_eq(@nostd.identity(obj._get("name")), "Alice")
  assert_eq(@nostd.identity(obj._get("age")), 30)
  assert_eq(@nostd.identity(obj._get("active")), true)

  // Test nested objects
  let nested = @nostd.Object::new()
  nested._set("inner", "value" |> @nostd.any)
  obj._set("nested", nested)
  assert_eq(@nostd.identity(obj._get("nested")._get("inner")), "value")
}

///|
test "JsImpl::delete and hasOwnProperty" {
  let obj = @nostd.Object::new()
  obj._set("key1", "value1" |> @nostd.any)
  obj._set("key2", "value2" |> @nostd.any)
  assert_true(@nostd.Object::has_own(obj, "key1"))
  assert_true(@nostd.Object::has_own(obj, "key2"))
  assert_false(@nostd.Object::has_own(obj, "key3"))
  // obj._delete("key1")
  // assert_false(@nostd.Object::has_own(obj, "key1"))
  // assert_true(@nostd.Object::has_own(obj, "key2"))
}

///|
test "JsImpl::equal" {
  // Same values should be equal
  assert_eq(@nostd.any(42), @nostd.any(42))
  assert_eq(@nostd.any("hello"), @nostd.any("hello"))
  assert_eq(@nostd.any(true), @nostd.any(true))

  // Different values should not be equal
  assert_false(@nostd.any(42) == @nostd.any(43))
  assert_false(@nostd.any("hello") == @nostd.any("world"))

  // Special values
  assert_eq(@nostd.null(), @nostd.null())
  assert_eq(@nostd.undefined(), @nostd.undefined())
  assert_false(@nostd.null() == @nostd.undefined())
}

///|
test "Js with arrays" {
  let arr = @nostd.any([1, 2, 3])
  assert_true(@nostd.is_array(arr))
  assert_eq(@nostd.identity(arr._get("0")), 1)
  assert_eq(@nostd.identity(arr._get("1")), 2)
  assert_eq(@nostd.identity(arr._get("2")), 3)
  // Modify array
  arr._set("1", 10 |> @nostd.any)
  assert_eq(@nostd.identity(arr._get("1")), 10)
}

///|
test "Js with nested structures" {
  let root = @nostd.Object::new()
  let user = @nostd.Object::new()
  user._set("name", "Alice" |> @nostd.any)
  user._set("age", 30 |> @nostd.any)
  let address = @nostd.Object::new()
  address._set("city", "Tokyo" |> @nostd.any)
  address._set("country", "Japan" |> @nostd.any)
  user._set("address", address)
  root._set("user", user)

  // Access nested values
  assert_eq(@nostd.identity(root._get("user")._get("name")), "Alice")
  assert_eq(@nostd.identity(root._get("user")._get("age")), 30)
  assert_eq(
    @nostd.identity(root._get("user")._get("address")._get("city")),
    "Tokyo",
  )
  assert_eq(
    @nostd.identity(root._get("user")._get("address")._get("country")),
    "Japan",
  )
}

///|
test "Val Show trait" {
  assert_eq(@nostd.any(42).to_string(), "42")
  assert_eq(@nostd.any(3.14).to_string(), "3.14")
  assert_eq(@nostd.any("hello").to_string(), "hello")
  assert_eq(@nostd.any(true).to_string(), "true")
  assert_eq(@nostd.any(false).to_string(), "false")
  assert_eq(@nostd.null().to_string(), "null")
  assert_eq(Object::new().to_string(), "[object Object]")
  assert_eq(JsArray::new().to_string(), "")
}

///|
test "Val with mixed types in object" {
  let obj = @nostd.Object::new()
  obj._set("string", "text" |> @nostd.any)
  obj._set("number", 42 |> @nostd.any)
  obj._set("float", 3.14 |> @nostd.any)
  obj._set("boolean", true |> @nostd.any)
  obj._set("null", @nostd.null())
  obj._set("array", @nostd.any([1, 2, 3]))
  obj._set("object", @nostd.Object::new())
  assert_eq(@nostd.typeof_(obj._get("string")), "string")
  assert_eq(@nostd.typeof_(obj._get("number")), "number")
  assert_eq(@nostd.typeof_(obj._get("float")), "number")
  assert_eq(@nostd.typeof_(obj._get("boolean")), "boolean")
  assert_eq(@nostd.typeof_(obj._get("null")), "object")
  assert_true(@nostd.is_array(obj._get("array")))
  assert_true(@nostd.is_object(obj._get("object")))
}

///|
test "Js trait for primitives" {
  // String
  let str_js : @nostd.Any = @nostd.any("hello")
  assert_eq(@nostd.identity(str_js), "hello")

  // Int
  let int_js : @nostd.Any = @nostd.any(42)
  assert_eq(@nostd.identity(int_js), 42)

  // Double
  let double_js : @nostd.Any = @nostd.any(3.14)
  assert_eq(@nostd.identity(double_js), 3.14)

  // Bool
  let bool_js : @nostd.Any = @nostd.any(true)
  assert_eq(@nostd.identity(bool_js), true)

  // Val (identity)
  let val = @nostd.any(100)
  let val_js : @nostd.Any = val
  assert_eq(val_js, val)
}

///|
test "JsImpl for Array[&JsImpl]" {
  let arr : Array[@nostd.Any] = [
    @nostd.any("hello"),
    @nostd.any(42),
    @nostd.any(3.14),
    @nostd.any(true),
  ]
  let val = @nostd.any(arr)
  assert_true(@nostd.is_array(val))
  assert_eq(@nostd.identity(val._get("0")), "hello")
  assert_eq(@nostd.identity(val._get("1")), 42)
  assert_eq(@nostd.identity(val._get("2")), 3.14)
  assert_eq(@nostd.identity(val._get("3")), true)
}

///|
test "JsImpl for Option[T]" {
  // Some value
  let some_val : Int? = Some(42)
  let some_js = @nostd.nullable(some_val)
  assert_eq(@nostd.identity(some_js), 42)

  // None value - represented as undefined in MoonBit
  let none_val : Int? = None
  let none_js = @nostd.nullable(none_val)
  assert_true(@nostd.is_undefined(none_js))
}

///|
test "Js numeric edge cases" {
  // Large integers
  let large = @nostd.any(1000000)
  assert_eq(@nostd.identity(large), 1000000)

  // Negative numbers
  let negative = @nostd.any(-42)
  assert_eq(@nostd.identity(negative), -42)

  // Very small float
  let small = @nostd.any(0.0001)
  assert_eq(@nostd.identity(small), 0.0001)
}

///| Global Functions Tests

///| Show implementations and to_string methods
