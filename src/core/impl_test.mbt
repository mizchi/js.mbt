///|
priv enum TestConstantEnum {
  NotFound = 404
}

///|
test "identity converts between Any and MoonBit types" {
  assert_true(@core.equal(@core.any(42), @core.any(42)))
  let v1 = @core.any(42)
  let v2 = @core.any(42)
  assert_true(@core.equal(v1, v2))
  assert_true(
    @core.equal(@core.identity(TestConstantEnum::NotFound), @core.any(404)),
  )
  let s1 : String? = @core.any("hello") |> @core.identity_option()
  assert_eq(s1, Some("hello"))
  let s2 : String? = @core.undefined() |> @core.identity_option()
  assert_eq(s2, None)
}

///|
test "identity converts struct to Any object" {
  struct Point {
    x : Int
    y : Int
  } derive(Eq, Show)
  let p = Point::{ x: 10, y: 20 }
  let v : @core.Any = @core.identity(p)
  assert_eq(@core.identity(v._get("x")), 10)
  assert_eq(@core.identity(v._get("y")), 20)
  let casted : Point = @core.identity(v)
  assert_eq(casted, p)
}

///|
test "JsImpl::to_string" {
  assert_eq(@core.any(42).to_string(), "42")
  assert_eq(@core.null().to_string(), "null")
  assert_eq(@core.any(true).to_string(), "true")
  assert_eq(@core.any("hello").to_string(), "hello")
  assert_true(@core.is_undefined(@core.undefined()))
  assert_true(@core.is_null(@core.null()))
  assert_eq(@core.new_object().to_string(), "[object Object]")
  // assert_eq(@core.new_array().to_string(), "[object Object]")
  @core.any([1, 2, 3]).to_string() |> assert_eq("1,2,3")
}

///|
test "type checking" {
  // Test is_array
  let arr = new_array()
  assert_true(@core.is_array(arr))
  assert_false(@core.is_array(42 |> @core.any))

  // Test is_object
  let obj = new_object()
  assert_true(@core.is_object(obj))
  assert_false(@core.is_object(42 |> @core.any))
  assert_false(@core.is_object(@core.null()))

  // Test is_null
  assert_true(@core.is_null(@core.null()))
  assert_false(@core.is_null(@core.undefined()))
  assert_false(@core.is_null(@core.any(42)))

  // Test is_undefined
  assert_true(@core.is_undefined(@core.undefined()))
  assert_false(@core.is_undefined(@core.null()))
  assert_false(@core.is_undefined(@core.any(42)))

  // Test is_some and is_none
  assert_false(@core.any(42) |> @core.is_nullish())
  assert_true(@core.undefined() |> @core.is_nullish())
  assert_false(@core.any(42) |> @core.is_nullish())
  assert_true(@core.undefined() |> @core.is_nullish())
  assert_true(@core.null() |> @core.is_nullish())
}

///|
test "Js typeof_" {
  assert_eq(@core.typeof_(@core.any(42)), "number")
  assert_eq(@core.typeof_(@core.any(3.14)), "number")
  assert_eq(@core.typeof_(@core.any("hello")), "string")
  assert_eq(@core.typeof_(@core.any(true)), "boolean")
  assert_eq(@core.typeof_(@core.undefined()), "undefined")
  assert_eq(@core.typeof_(@core.new_object()), "object")
  assert_eq(@core.typeof_(@core.new_array()), "object")
  assert_eq(@core.typeof_(@core.null()), "object") // JavaScript quirk
}

///|
test "JsImpl get/set" {
  let obj = @core.new_object()
  obj._set("name", "Alice" |> @core.any)
  obj._set("age", 30 |> @core.any)
  obj._set("active", true |> @core.any)
  assert_eq(@core.identity(obj._get("name")), "Alice")
  assert_eq(@core.identity(obj._get("age")), 30)
  assert_eq(@core.identity(obj._get("active")), true)

  // Test nested objects
  let nested = @core.new_object()
  nested._set("inner", "value" |> @core.any)
  obj._set("nested", nested)
  assert_eq(@core.identity(obj._get("nested")._get("inner")), "value")
}

///|
test "JsImpl::delete and hasOwnProperty" {
  let obj = @core.new_object()
  obj._set("key1", "value1" |> @core.any)
  obj._set("key2", "value2" |> @core.any)
  assert_true(@core.object_has_own(obj, "key1"))
  assert_true(@core.object_has_own(obj, "key2"))
  assert_false(@core.object_has_own(obj, "key3"))
  // obj._delete("key1")
  // assert_false(@core.object_has_own(obj, "key1"))
  // assert_true(@core.object_has_own(obj, "key2"))
}

///|
test "JsImpl::equal" {
  // Same values should be equal
  assert_eq(@core.any(42), @core.any(42))
  assert_eq(@core.any("hello"), @core.any("hello"))
  assert_eq(@core.any(true), @core.any(true))

  // Different values should not be equal
  assert_false(@core.any(42) == @core.any(43))
  assert_false(@core.any("hello") == @core.any("world"))

  // Special values
  assert_eq(@core.null(), @core.null())
  assert_eq(@core.undefined(), @core.undefined())
  assert_false(@core.null() == @core.undefined())
}

///|
test "Js with arrays" {
  let arr = @core.any([1, 2, 3])
  assert_true(@core.is_array(arr))
  assert_eq(@core.identity(arr._get("0")), 1)
  assert_eq(@core.identity(arr._get("1")), 2)
  assert_eq(@core.identity(arr._get("2")), 3)
  // Modify array
  arr._set("1", 10 |> @core.any)
  assert_eq(@core.identity(arr._get("1")), 10)
}

///|
test "Js with nested structures" {
  let root = @core.new_object()
  let user = @core.new_object()
  user._set("name", "Alice" |> @core.any)
  user._set("age", 30 |> @core.any)
  let address = @core.new_object()
  address._set("city", "Tokyo" |> @core.any)
  address._set("country", "Japan" |> @core.any)
  user._set("address", address)
  root._set("user", user)

  // Access nested values
  assert_eq(@core.identity(root._get("user")._get("name")), "Alice")
  assert_eq(@core.identity(root._get("user")._get("age")), 30)
  assert_eq(
    @core.identity(root._get("user")._get("address")._get("city")),
    "Tokyo",
  )
  assert_eq(
    @core.identity(root._get("user")._get("address")._get("country")),
    "Japan",
  )
}

///|
test "Val Show trait" {
  assert_eq(@core.any(42).to_string(), "42")
  assert_eq(@core.any(3.14).to_string(), "3.14")
  assert_eq(@core.any("hello").to_string(), "hello")
  assert_eq(@core.any(true).to_string(), "true")
  assert_eq(@core.any(false).to_string(), "false")
  assert_eq(@core.null().to_string(), "null")
  assert_eq(new_object().to_string(), "[object Object]")
  assert_eq(new_array().to_string(), "")
}

///|
test "Val with mixed types in object" {
  let obj = @core.new_object()
  obj._set("string", "text" |> @core.any)
  obj._set("number", 42 |> @core.any)
  obj._set("float", 3.14 |> @core.any)
  obj._set("boolean", true |> @core.any)
  obj._set("null", @core.null())
  obj._set("array", @core.any([1, 2, 3]))
  obj._set("object", @core.new_object())
  assert_eq(@core.typeof_(obj._get("string")), "string")
  assert_eq(@core.typeof_(obj._get("number")), "number")
  assert_eq(@core.typeof_(obj._get("float")), "number")
  assert_eq(@core.typeof_(obj._get("boolean")), "boolean")
  assert_eq(@core.typeof_(obj._get("null")), "object")
  assert_true(@core.is_array(obj._get("array")))
  assert_true(@core.is_object(obj._get("object")))
}

///|
test "Js trait for primitives" {
  // String
  let str_js : @core.Any = @core.any("hello")
  assert_eq(@core.identity(str_js), "hello")

  // Int
  let int_js : @core.Any = @core.any(42)
  assert_eq(@core.identity(int_js), 42)

  // Double
  let double_js : @core.Any = @core.any(3.14)
  assert_eq(@core.identity(double_js), 3.14)

  // Bool
  let bool_js : @core.Any = @core.any(true)
  assert_eq(@core.identity(bool_js), true)

  // Val (identity)
  let val = @core.any(100)
  let val_js : @core.Any = val
  assert_eq(val_js, val)
}

///|
test "JsImpl for Array[&JsImpl]" {
  let arr : Array[@core.Any] = [
    @core.any("hello"),
    @core.any(42),
    @core.any(3.14),
    @core.any(true),
  ]
  let val = @core.any(arr)
  assert_true(@core.is_array(val))
  assert_eq(@core.identity(val._get("0")), "hello")
  assert_eq(@core.identity(val._get("1")), 42)
  assert_eq(@core.identity(val._get("2")), 3.14)
  assert_eq(@core.identity(val._get("3")), true)
}

///|
test "JsImpl for Option[T]" {
  // Some value
  let some_val : Int? = Some(42)
  let some_js = @core.nullable(some_val)
  assert_eq(@core.identity(some_js), 42)

  // None value - represented as undefined in MoonBit
  let none_val : Int? = None
  let none_js = @core.nullable(none_val)
  assert_true(@core.is_undefined(none_js))
}

///|
test "Js numeric edge cases" {
  // Large integers
  let large = @core.any(1000000)
  assert_eq(@core.identity(large), 1000000)

  // Negative numbers
  let negative = @core.any(-42)
  assert_eq(@core.identity(negative), -42)

  // Very small float
  let small = @core.any(0.0001)
  assert_eq(@core.identity(small), 0.0001)
}

///| Global Functions Tests

///| Show implementations and to_string methods
