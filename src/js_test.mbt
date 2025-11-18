// Constant Enum

///|
priv enum TestConstantEnum {
  NotFound = 404
}

///|
test "cast" {
  assert_eq(safe_js(42), safe_js(42))
  let v1 = safe_js(42)
  let v2 = safe_js(42)
  assert_eq(v1, v2)
  assert_eq(unsafe_cast(TestConstantEnum::NotFound), safe_js(404))
  let s1 : String? = safe_js("hello") |> unsafe_option()
  assert_eq(s1, Some("hello"))
  let s2 : String? = undefined() |> unsafe_option()
  assert_eq(s2, None)
}

///|
test "from struct" {
  struct Point {
    x : Int
    y : Int
  } derive(Eq, Show)
  let p = Point::{ x: 10, y: 20 }
  let v : Js = unsafe_cast(p)
  assert_eq(unsafe_cast(v.get("x")), 10)
  assert_eq(unsafe_cast(v.get("y")), 20)
  let casted : Point = unsafe_cast(v)
  assert_eq(casted, p)
}

///|
priv enum TestEnum {
  A(value~ : Int)
} derive(Eq, Show)

///|
fn TestEnum::from_js(v : Js) -> Self raise {
  let tag : String = unsafe_cast(v.get("tag"))
  match tag {
    "A" => {
      let value = v.get("value")
      guard @js.typeof_(value) == "number"
      A(value=unsafe_cast(value))
    }
    _ => fail("unknown tag: " + tag)
  }
}

///|
impl JsImpl for TestEnum with to_js(self) {
  match self {
    A(value~) => {
      let obj = @js.Object::new()
      obj.set("tag", "A")
      obj.set("value", value)
      obj.to_js()
    }
  }
}

///|
test "from trait" {
  let v : TestEnum = A(value=123)
  let v : Js = v.to_js()
  assert_eq(unsafe_cast(v.get("tag")), "A")
  assert_eq(unsafe_cast(v.get("value")), 123)
  let recovered : TestEnum = TestEnum::from_js(v)
  assert_eq(recovered, A(value=123))
}

///|
test "to_string" {
  assert_eq(safe_js(42).to_string(), "42")
  assert_eq(null_().to_string(), "null")
  assert_eq(safe_js(true).to_string(), "true")
  assert_eq(safe_js("hello").to_string(), "hello")
  assert_true(@js.is_undefined(undefined()))
  assert_true(@js.is_null(null_()))
  assert_eq(@js.Object::new().to_string(), "{}")
  assert_eq(@js.JsArray::new().to_string(), "[]")
  from_array([1, 2, 3]).to_string() |> assert_eq("[1,2,3]")
  let expected =
    #|{"a":1,"b":2}
  from_map({ "a": 1 |> safe_js, "b": 2 |> safe_js }).to_string()
  |> assert_eq(expected)
}

///|
test "Val type checking" {
  // Test is_array
  let arr = JsArray::new()
  assert_true(@js.is_array(arr))
  assert_false(@js.is_array(42))

  // Test is_object
  let obj = Object::new()
  assert_true(@js.is_object(obj))
  assert_false(@js.is_object(42))
  assert_false(@js.is_object(null_()))

  // Test is_null
  assert_true(@js.is_null(null_()))
  assert_false(@js.is_null(undefined()))
  assert_false(@js.is_null(safe_js(42)))

  // Test is_undefined
  assert_true(@js.is_undefined(undefined()))
  assert_false(@js.is_undefined(null_()))
  assert_false(@js.is_undefined(safe_js(42)))

  // Test is_some and is_none
  assert_true(safe_js(42).is_some())
  assert_false(undefined().is_some())
  assert_false(null_().is_some())
  assert_false(safe_js(42).is_none())
  assert_true(undefined().is_none())
  assert_true(null_().is_none())
}

///|
test "Val type_of" {
  assert_eq(@js.typeof_(safe_js(42)), "number")
  assert_eq(@js.typeof_(safe_js(3.14)), "number")
  assert_eq(@js.typeof_(safe_js("hello")), "string")
  assert_eq(@js.typeof_(safe_js(true)), "boolean")
  assert_eq(@js.typeof_(undefined()), "undefined")
  assert_eq(@js.typeof_(Object::new()), "object")
  assert_eq(@js.typeof_(JsArray::new()), "object")
  assert_eq(@js.typeof_(null_()), "object") // JavaScript quirk
}

///|
test "Val get and set" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  obj.set("active", true)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_eq(unsafe_cast(obj.get("active")), true)

  // Test nested objects
  let nested = @js.Object::new()
  nested.set("inner", "value")
  obj.set("nested", nested)
  assert_eq(unsafe_cast(obj.get("nested").get("inner")), "value")
}

///|
test "Val set_if_exists" {
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

///|
test "Val delete and has_own_property" {
  let obj = @js.Object::new()
  obj.set("key1", "value1")
  obj.set("key2", "value2")
  assert_true(obj.hasOwnProperty("key1"))
  assert_true(obj.hasOwnProperty("key2"))
  assert_false(obj.hasOwnProperty("key3"))
  obj.delete("key1")
  assert_false(obj.hasOwnProperty("key1"))
  assert_true(obj.hasOwnProperty("key2"))
}

///|
test "Val cast primitive types" {
  // Integer
  let int_val = safe_js(42)
  let int_result : Int = unsafe_cast(int_val)
  assert_eq(int_result, 42)

  // Double
  let double_val = safe_js(3.14)
  let double_result : Double = unsafe_cast(double_val)
  assert_eq(double_result, 3.14)

  // String
  let str_val = safe_js("hello")
  let str_result : String = unsafe_cast(str_val)
  assert_eq(str_result, "hello")

  // Boolean
  let bool_val = safe_js(true)
  let bool_result : Bool = unsafe_cast(bool_val)
  assert_eq(bool_result, true)
}

///|
test "Val cast_option" {
  // Some cases
  let some_str : String? = safe_js("hello") |> unsafe_option()
  assert_eq(some_str, Some("hello"))
  let some_int : Int? = safe_js(42) |> unsafe_option()
  assert_eq(some_int, Some(42))

  // None cases
  let none_str : String? = undefined() |> unsafe_option()
  assert_eq(none_str, None)
  let none_int : Int? = null_() |> unsafe_option()
  assert_eq(none_int, None)
}

///|
test "Val equality" {
  // Same values should be equal
  assert_eq(safe_js(42), safe_js(42))
  assert_eq(safe_js("hello"), safe_js("hello"))
  assert_eq(safe_js(true), safe_js(true))

  // Different values should not be equal
  assert_false(safe_js(42) == safe_js(43))
  assert_false(safe_js("hello") == safe_js("world"))

  // Special values
  assert_eq(null_(), null_())
  assert_eq(undefined(), undefined())
  assert_false(null_() == undefined())
}

///|
test "Val is_nan" {
  let nan_val = @js.safe_js(0.0 / 0.0)
  assert_true(@js.isNaN(nan_val))
  assert_false(@js.isNaN(42))
  assert_false(@js.isNaN(3.14))
}

///|
test "object_keys" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  obj.set("city", "Tokyo")
  let keys = Object::keys(obj.to_js())
  assert_eq(keys.length(), 3)
  assert_true(keys.contains("name"))
  assert_true(keys.contains("age"))
  assert_true(keys.contains("city"))
}

///|
test "object_values" {
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  let values = Object::values(obj)
  assert_eq(values.length(), 3)
  // Values should be present (order not guaranteed)
  let sum : Int = unsafe_cast(values[0]) +
    unsafe_cast(values[1]) +
    unsafe_cast(values[2])
  assert_eq(sum, 6)
}

///|
test "object_entries" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  let entries = Object::entries(obj)
  assert_eq(entries.length(), 2)
  let mut found_name = false
  let mut found_age = false
  for entry in entries {
    let (key, value) = entry
    if key == "name" {
      assert_eq(unsafe_cast(value), "Alice")
      found_name = true
    } else if key == "age" {
      assert_eq(unsafe_cast(value), 30)
      found_age = true
    }
  }
  assert_true(found_name)
  assert_true(found_age)
}

///|
test "object_assign" {
  let target = @js.Object::new()
  target.set("a", 1)
  target.set("b", 2)
  let source = @js.Object::new()
  source.set("b", 3)
  source.set("c", 4)
  let result = Object::assign(target, source)

  // b should be overwritten, c should be added
  assert_eq(unsafe_cast(result.get("a")), 1)
  assert_eq(unsafe_cast(result.get("b")), 3)
  assert_eq(unsafe_cast(result.get("c")), 4)
}

///|
test "from_builtin_map" {
  let map : Map[String, Js] = {
    "name": safe_js("Alice"),
    "age": safe_js(30),
    "active": safe_js(true),
  }
  let obj = from_map(map)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_eq(unsafe_cast(obj.get("active")), true)
}

///|
test "from_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = from_array(arr)
  assert_true(@js.is_array(val))
  assert_eq(unsafe_cast(val.get(0)), 1)
  assert_eq(unsafe_cast(val.get(2)), 3)
  assert_eq(unsafe_cast(val.get(4)), 5)
}

///|
test "JsArray::new" {
  let arr = JsArray::new()
  assert_true(@js.is_array(arr))
  assert_true(@js.is_object(arr))
  // native array is also js array
  assert_true(@js.is_array([1] |> @js.from_array))
}

///|
test "global_this" {
  let global = globalThis()
  assert_true(@js.is_object(global))
  assert_false(@js.is_null(global))
}

///|
test "symbols" {
  let sym = symbol("test")
  let iter_sym = Symbol::iterator()
  let dispose_sym = Symbol::dispose()
  let async_dispose_sym = Symbol::asyncDispose()

  // Symbols should have symbol type
  let sym_val : Js = unsafe_cast(sym)
  let iter_val : Js = unsafe_cast(iter_sym)
  let dispose_val : Js = unsafe_cast(dispose_sym)
  let async_dispose_val : Js = unsafe_cast(async_dispose_sym)
  assert_eq(@js.typeof_(sym_val), "symbol")
  assert_eq(@js.typeof_(iter_val), "symbol")
  assert_eq(@js.typeof_(dispose_val), "symbol")
  assert_eq(@js.typeof_(async_dispose_val), "symbol")
}

///|
test "new_error" {
  let error = new_error("Test error")
  let error_val : Js = unsafe_cast(error)
  assert_true(@js.is_object(error_val))
  assert_eq(unsafe_cast(error_val.get("message")), "Test error")

  // Error with cause
  let cause_error = new_error("Cause error")
  let error_with_cause = new_error("Main error", cause=cause_error)
  let error_with_cause_val : Js = unsafe_cast(error_with_cause)
  assert_eq(unsafe_cast(error_with_cause_val.get("message")), "Main error")
}

///|
test "Object::create" {
  let obj = Object::create()
  assert_true(@js.is_object(obj))
}

///|
test "Val with arrays" {
  let arr = from_array([1, 2, 3])
  assert_true(@js.is_array(arr))
  assert_eq(unsafe_cast(arr.get(0)), 1)
  assert_eq(unsafe_cast(arr.get(1)), 2)
  assert_eq(unsafe_cast(arr.get(2)), 3)

  // Modify array
  arr.set(1, 10)
  assert_eq(unsafe_cast(arr.get(1)), 10)
}

///|
test "Val with nested structures" {
  let root = @js.Object::new()
  let user = @js.Object::new()
  user.set("name", "Alice")
  user.set("age", 30)
  let address = @js.Object::new()
  address.set("city", "Tokyo")
  address.set("country", "Japan")
  user.set("address", address)
  root.set("user", user)

  // Access nested values
  assert_eq(unsafe_cast(root.get("user").get("name")), "Alice")
  assert_eq(unsafe_cast(root.get("user").get("age")), 30)
  assert_eq(unsafe_cast(root.get("user").get("address").get("city")), "Tokyo")
  assert_eq(
    unsafe_cast(root.get("user").get("address").get("country")),
    "Japan",
  )
}

///|
test "Val Show trait" {
  assert_eq(safe_js(42).to_string(), "42")
  assert_eq(safe_js(3.14).to_string(), "3.14")
  assert_eq(safe_js("hello").to_string(), "hello")
  assert_eq(safe_js(true).to_string(), "true")
  assert_eq(safe_js(false).to_string(), "false")
  assert_eq(null_().to_string(), "null")
  assert_eq(@js.Object::new().to_js().to_string(), "{}")
  assert_eq(@js.JsArray::new().to_js().to_string(), "[]")
}

///|
test "Val with mixed types in object" {
  let obj = @js.Object::new()
  obj.set("string", "text")
  obj.set("number", 42)
  obj.set("float", 3.14)
  obj.set("boolean", true)
  obj.set("null", null_())
  obj.set("array", from_array([1, 2, 3]))
  obj.set("object", @js.Object::new())
  assert_eq(@js.typeof_(obj.get("string")), "string")
  assert_eq(@js.typeof_(obj.get("number")), "number")
  assert_eq(@js.typeof_(obj.get("float")), "number")
  assert_eq(@js.typeof_(obj.get("boolean")), "boolean")
  assert_eq(@js.typeof_(obj.get("null")), "object")
  assert_true(@js.is_array(obj.get("array")))
  assert_true(@js.is_object(obj.get("object")))
}

///|
test "PropertyIsEnumerable" {
  let obj = @js.Object::new()
  obj.set("enumerable", "value")
  assert_true(@js.propertyIsEnumerable(obj, "enumerable"))
  assert_false(@js.propertyIsEnumerable(obj, "nonexistent"))
}

///|
test "Js trait for primitives" {
  // String
  let str_js : Js = JsImpl::to_js("hello")
  assert_eq(unsafe_cast(str_js), "hello")

  // Int
  let int_js : Js = JsImpl::to_js(42)
  assert_eq(unsafe_cast(int_js), 42)

  // Double
  let double_js : Js = JsImpl::to_js(3.14)
  assert_eq(unsafe_cast(double_js), 3.14)

  // Bool
  let bool_js : Js = JsImpl::to_js(true)
  assert_eq(unsafe_cast(bool_js), true)

  // Val (identity)
  let val = @js.safe_js(100)
  let val_js : Js = JsImpl::to_js(val)
  assert_eq(val_js, val)
}

///|
test "Js trait for Array[&JsImpl]" {
  let arr : Array[&JsImpl] = ["hello", 42, 3.14, true]
  let val = JsImpl::to_js(arr)
  assert_true(@js.is_array(val))
  assert_eq(unsafe_cast(val.get(0)), "hello")
  assert_eq(unsafe_cast(val.get(1)), 42)
  assert_eq(unsafe_cast(val.get(2)), 3.14)
  assert_eq(unsafe_cast(val.get(3)), true)
}

///|
test "Js trait for Option" {
  // Some value
  let some_val : Int? = Some(42)
  let some_js = JsImpl::to_js(some_val)
  assert_eq(unsafe_cast(some_js), 42)

  // None value - represented as undefined in MoonBit
  let none_val : Int? = None
  let none_js = JsImpl::to_js(none_val)
  assert_true(@js.is_undefined(none_js))
}

///|
test "Val with empty strings" {
  let obj = @js.Object::new()
  obj.set("empty", "")
  assert_eq(unsafe_cast(obj.get("empty")), "")
  assert_true(obj.hasOwnProperty("empty"))
}

///|
test "Val with zero values" {
  let obj = @js.Object::new()
  obj.set("zero", 0)
  obj.set("zero_float", 0.0)
  assert_eq(unsafe_cast(obj.get("zero")), 0)
  assert_eq(unsafe_cast(obj.get("zero_float")), 0.0)
  assert_true(obj.hasOwnProperty("zero"))
}

///|
test "Val with false boolean" {
  let obj = @js.Object::new()
  obj.set("flag", false)
  assert_eq(unsafe_cast(obj.get("flag")), false)
  assert_true(obj.hasOwnProperty("flag"))
}

///|
test "Val numeric edge cases" {
  // Large integers
  let large = safe_js(1000000)
  assert_eq(unsafe_cast(large), 1000000)

  // Negative numbers
  let negative = safe_js(-42)
  assert_eq(unsafe_cast(negative), -42)

  // Very small float
  let small = safe_js(0.0001)
  assert_eq(unsafe_cast(small), 0.0001)
}

///|
test "encode_uri and decode_uri" {
  // Encode complete URI
  let uri = encodeURI("https://example.com/path?name=John Doe")
  assert_eq(uri, "https://example.com/path?name=John%20Doe")

  // Decode URI
  let decoded = decodeURI("https://example.com/path?name=John%20Doe")
  assert_eq(decoded, "https://example.com/path?name=John Doe")

  // Round trip
  let original_uri = "https://example.com/path with spaces?query=value"
  let encoded_uri = encodeURI(original_uri)
  let decoded_uri = decodeURI(encoded_uri)
  assert_eq(decoded_uri, original_uri)
}

///|
test "encode_uri_component and decode_uri_component" {
  // Encode URI component
  let encoded = encodeURIComponent("Hello World & Friends")
  assert_eq(encoded, "Hello%20World%20%26%20Friends")

  // Decode URI component
  let decoded = decodeURIComponent("Hello%20World%20%26%20Friends")
  assert_eq(decoded, "Hello World & Friends")

  // Special characters
  let special = encodeURIComponent("key=value&foo=bar")
  assert_eq(special, "key%3Dvalue%26foo%3Dbar")
  let decoded_special = decodeURIComponent("key%3Dvalue%26foo%3Dbar")
  assert_eq(decoded_special, "key=value&foo=bar")

  // Round trip with various characters
  let original = "Test: @#$%^&*()+={}[]|\\:;\"'<>,.?/"
  let encoded_component = encodeURIComponent(original)
  let decoded_component = decodeURIComponent(encoded_component)
  assert_eq(decoded_component, original)
}

///|
test {
  let obj = @js.Object::new().to_js()
  let undef : Js? = Some(undefined())
  set_if_exists(obj, "a", undef)
  let none_val : Js? = None
  set_if_exists(obj, "b", none_val)
  set_if_exists(obj, "c", Some(42))
  assert_true(@js.is_undefined(obj.get("a")))
  // assert_eq(unsafe_cast(obj.get("a")), 42)
  // obj.set_if_exists("b", None)
  // assert_true(obj.get("b").is_undefined())
  // obj.set_if_exists("c", Some(undefined()))
  // assert_true(obj.get("c").is_undefined())
}
