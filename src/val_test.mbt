// Constant Enum

///|
priv enum TestConstantEnum {
  NotFound = 404
}

///|
test "cast" {
  assert_eq(js(42), js(42))
  let v1 = js(42)
  let v2 = js(42)
  assert_eq(v1, v2)
  assert_eq(js(TestConstantEnum::NotFound), js(404))
  let s1 : String? = js("hello") |> to_option()
  assert_eq(s1, Some("hello"))
  let s2 : String? = undefined() |> to_option()
  assert_eq(s2, None)
}

///|
test "from struct" {
  struct Point {
    x : Int
    y : Int
  } derive(Eq, Show)
  let p = Point::{ x: 10, y: 20 }
  let v : Val = unsafe_cast(p)
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
fn TestEnum::from_js(v : Val) -> Self raise {
  let tag : String = unsafe_cast(v.get("tag"))
  match tag {
    "A" => {
      let value = v.get("value")
      guard value.type_of() == "number"
      A(value=unsafe_cast(value))
    }
    _ => fail("unknown tag: " + tag)
  }
}

///|
impl Js for TestEnum with to_js(self) {
  match self {
    A(value~) => {
      let obj = new_empty_object()
      obj.set("tag", "A")
      obj.set("value", value)
      obj
    }
  }
}

///|
test "from trait" {
  let v : TestEnum = A(value=123)
  let v : Val = v.to_js()
  assert_eq(unsafe_cast(v.get("tag")), "A")
  assert_eq(unsafe_cast(v.get("value")), 123)
  let recovered : TestEnum = TestEnum::from_js(v)
  assert_eq(recovered, A(value=123))
}

///|
test "to_string" {
  assert_eq(js(42).to_string(), "42")
  assert_eq(null_().to_string(), "null")
  assert_eq(js(true).to_string(), "true")
  assert_eq(js("hello").to_string(), "hello")
  assert_true(undefined().is_undefined())
  assert_true(null_().is_null())
  assert_eq(new_empty_object().to_string(), "{}")
  assert_eq(new_empty_array().to_string(), "[]")
  from_builtin_array([1, 2, 3]).to_string() |> assert_eq("[1,2,3]")
  let expected =
    #|{"a":1,"b":2}
  from_builtin_map({ "a": 1 |> js, "b": 2 |> js }).to_string()
  |> assert_eq(expected)
}

///|
test "Val type checking" {
  // Test is_array
  let arr = new_empty_array()
  assert_true(arr.is_array())
  assert_false(js(42).is_array())

  // Test is_object
  let obj = new_empty_object()
  assert_true(obj.is_object())
  assert_false(js(42).is_object())
  assert_false(null_().is_object())

  // Test is_null
  assert_true(null_().is_null())
  assert_false(undefined().is_null())
  assert_false(js(42).is_null())

  // Test is_undefined
  assert_true(undefined().is_undefined())
  assert_false(null_().is_undefined())
  assert_false(js(42).is_undefined())

  // Test is_some and is_none
  assert_true(js(42).is_some())
  assert_false(undefined().is_some())
  assert_false(null_().is_some())
  assert_false(js(42).is_none())
  assert_true(undefined().is_none())
  assert_true(null_().is_none())
}

///|
test "Val type_of" {
  assert_eq(js(42).type_of(), "number")
  assert_eq(js(3.14).type_of(), "number")
  assert_eq(js("hello").type_of(), "string")
  assert_eq(js(true).type_of(), "boolean")
  assert_eq(undefined().type_of(), "undefined")
  assert_eq(new_empty_object().type_of(), "object")
  assert_eq(new_empty_array().type_of(), "object")
  assert_eq(null_().type_of(), "object") // JavaScript quirk
}

///|
test "Val get and set" {
  let obj = new_empty_object()
  obj.set("name", "Alice")
  obj.set("age", 30)
  obj.set("active", true)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_eq(unsafe_cast(obj.get("active")), true)

  // Test nested objects
  let nested = new_empty_object()
  nested.set("inner", "value")
  obj.set("nested", nested)
  assert_eq(unsafe_cast(obj.get("nested").get("inner")), "value")
}

///|
test "Val set_if_exists" {
  let obj = new_empty_object()

  // Set with Some value
  obj.set_if_exists("key1", Some("value1"))
  assert_eq(unsafe_cast(obj.get("key1")), "value1")

  // Set with None should not add property
  let v : Int? = None
  obj.set_if_exists("key2", v)
  assert_true(obj.get("key2").is_undefined())

  // Set with undefined value should not add property
  obj.set_if_exists("key3", Some(undefined()))
  assert_true(obj.get("key3").is_undefined())
}

///|
test "Val delete and has_own_property" {
  let obj = new_empty_object()
  obj.set("key1", "value1")
  obj.set("key2", "value2")
  assert_true(obj.has_own_property("key1"))
  assert_true(obj.has_own_property("key2"))
  assert_false(obj.has_own_property("key3"))
  obj.delete("key1")
  assert_false(obj.has_own_property("key1"))
  assert_true(obj.has_own_property("key2"))
}

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
  let some_str : String? = js("hello") |> to_option()
  assert_eq(some_str, Some("hello"))
  let some_int : Int? = js(42) |> to_option()
  assert_eq(some_int, Some(42))

  // None cases
  let none_str : String? = undefined() |> to_option()
  assert_eq(none_str, None)
  let none_int : Int? = null_() |> to_option()
  assert_eq(none_int, None)
}

///|
test "Val equality" {
  // Same values should be equal
  assert_eq(js(42), js(42))
  assert_eq(js("hello"), js("hello"))
  assert_eq(js(true), js(true))

  // Different values should not be equal
  assert_false(js(42) == js(43))
  assert_false(js("hello") == js("world"))

  // Special values
  assert_eq(null_(), null_())
  assert_eq(undefined(), undefined())
  assert_false(null_() == undefined())
}

///|
test "Val is_nan" {
  let nan_val = js(0.0 / 0.0)
  assert_true(nan_val.is_nan())
  assert_false(js(42).is_nan())
  assert_false(js(3.14).is_nan())
}

///|
test "object_keys" {
  let obj = new_empty_object()
  obj.set("name", "Alice")
  obj.set("age", 30)
  obj.set("city", "Tokyo")
  let keys = object_keys(obj)
  assert_eq(keys.length(), 3)
  assert_true(keys.contains("name"))
  assert_true(keys.contains("age"))
  assert_true(keys.contains("city"))
}

///|
test "object_values" {
  let obj = new_empty_object()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  let values = object_values(obj)
  assert_eq(values.length(), 3)
  // Values should be present (order not guaranteed)
  let sum : Int = unsafe_cast(values[0]) +
    unsafe_cast(values[1]) +
    unsafe_cast(values[2])
  assert_eq(sum, 6)
}

///|
test "object_entries" {
  let obj = new_empty_object()
  obj.set("name", "Alice")
  obj.set("age", 30)
  let entries = object_entries(obj)
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
  let target = new_empty_object()
  target.set("a", 1)
  target.set("b", 2)
  let source = new_empty_object()
  source.set("b", 3)
  source.set("c", 4)
  let result = object_assign(target, source)

  // b should be overwritten, c should be added
  assert_eq(unsafe_cast(result.get("a")), 1)
  assert_eq(unsafe_cast(result.get("b")), 3)
  assert_eq(unsafe_cast(result.get("c")), 4)
}

///|
test "from_builtin_map" {
  let map : Map[String, Val] = {
    "name": js("Alice"),
    "age": js(30),
    "active": js(true),
  }
  let obj = from_builtin_map(map)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_eq(unsafe_cast(obj.get("active")), true)
}

///|
test "from_builtin_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = from_builtin_array(arr)
  assert_true(val.is_array())
  assert_eq(unsafe_cast(val.get(0)), 1)
  assert_eq(unsafe_cast(val.get(2)), 3)
  assert_eq(unsafe_cast(val.get(4)), 5)
}

///|
test "new_empty_array" {
  let arr = new_empty_array()
  assert_true(arr.is_array())
  assert_true(arr.is_object())
}

///|
test "global_this" {
  let global = global_this()
  assert_true(global.is_object())
  assert_false(global.is_null())
}

///|
test "symbols" {
  let sym = symbol("test")
  let iter_sym = symbol_iterator()
  let dispose_sym = symbol_dispose()
  let async_dispose_sym = symbol_async_dispose()

  // Symbols should have symbol type
  let sym_val : Val = unsafe_cast(sym)
  let iter_val : Val = unsafe_cast(iter_sym)
  let dispose_val : Val = unsafe_cast(dispose_sym)
  let async_dispose_val : Val = unsafe_cast(async_dispose_sym)
  assert_eq(sym_val.type_of(), "symbol")
  assert_eq(iter_val.type_of(), "symbol")
  assert_eq(dispose_val.type_of(), "symbol")
  assert_eq(async_dispose_val.type_of(), "symbol")
}

///|
test "new collections" {
  // Map
  let map = new_map()
  assert_true(map.is_object())

  // Set
  let set = new_set()
  assert_true(set.is_object())
}

///|
test "new_error" {
  let error = new_error("Test error")
  let error_val : Val = unsafe_cast(error)
  assert_true(error_val.is_object())
  assert_eq(unsafe_cast(error_val.get("message")), "Test error")

  // Error with cause
  let cause_error = new_error("Cause error")
  let error_with_cause = new_error("Main error", cause=cause_error)
  let error_with_cause_val : Val = unsafe_cast(error_with_cause)
  assert_eq(unsafe_cast(error_with_cause_val.get("message")), "Main error")
}

///|
test "object_create" {
  let obj = object_create()
  assert_true(obj.is_object())
}

///|
test "Val with arrays" {
  let arr = from_builtin_array([1, 2, 3])
  assert_true(arr.is_array())
  assert_eq(unsafe_cast(arr.get(0)), 1)
  assert_eq(unsafe_cast(arr.get(1)), 2)
  assert_eq(unsafe_cast(arr.get(2)), 3)

  // Modify array
  arr.set(1, 10)
  assert_eq(unsafe_cast(arr.get(1)), 10)
}

///|
test "Val with nested structures" {
  let root = new_empty_object()
  let user = new_empty_object()
  user.set("name", "Alice")
  user.set("age", 30)
  let address = new_empty_object()
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
  assert_eq(js(42).to_string(), "42")
  assert_eq(js(3.14).to_string(), "3.14")
  assert_eq(js("hello").to_string(), "hello")
  assert_eq(js(true).to_string(), "true")
  assert_eq(js(false).to_string(), "false")
  assert_eq(null_().to_string(), "null")
  assert_eq(new_empty_object().to_string(), "{}")
  assert_eq(new_empty_array().to_string(), "[]")
}

///|
test "Val with mixed types in object" {
  let obj = new_empty_object()
  obj.set("string", "text")
  obj.set("number", 42)
  obj.set("float", 3.14)
  obj.set("boolean", true)
  obj.set("null", null_())
  obj.set("array", from_builtin_array([1, 2, 3]))
  obj.set("object", new_empty_object())
  assert_eq(obj.get("string").type_of(), "string")
  assert_eq(obj.get("number").type_of(), "number")
  assert_eq(obj.get("float").type_of(), "number")
  assert_eq(obj.get("boolean").type_of(), "boolean")
  assert_eq(obj.get("null").type_of(), "object")
  assert_true(obj.get("array").is_array())
  assert_true(obj.get("object").is_object())
}

///|
test "Val property_is_enumerable" {
  let obj = new_empty_object()
  obj.set("enumerable", "value")
  assert_true(obj.property_is_enumerable("enumerable"))
  assert_false(obj.property_is_enumerable("nonexistent"))
}

///|
test "Js trait for primitives" {
  // String
  let str_js : Val = Js::to_js("hello")
  assert_eq(unsafe_cast(str_js), "hello")

  // Int
  let int_js : Val = Js::to_js(42)
  assert_eq(unsafe_cast(int_js), 42)

  // Double
  let double_js : Val = Js::to_js(3.14)
  assert_eq(unsafe_cast(double_js), 3.14)

  // Bool
  let bool_js : Val = Js::to_js(true)
  assert_eq(unsafe_cast(bool_js), true)

  // Val (identity)
  let val = js(100)
  let val_js : Val = Js::to_js(val)
  assert_eq(val_js, val)
}

///|
test "Js trait for Array[&Js]" {
  let arr : Array[&Js] = ["hello", 42, 3.14, true]
  let val = Js::to_js(arr)
  assert_true(val.is_array())
  assert_eq(unsafe_cast(val.get(0)), "hello")
  assert_eq(unsafe_cast(val.get(1)), 42)
  assert_eq(unsafe_cast(val.get(2)), 3.14)
  assert_eq(unsafe_cast(val.get(3)), true)
}

///|
test "Js trait for Option" {
  // Some value
  let some_val : Int? = Some(42)
  let some_js = Js::to_js(some_val)
  assert_eq(unsafe_cast(some_js), 42)

  // None value - represented as undefined in MoonBit
  let none_val : Int? = None
  let none_js = Js::to_js(none_val)
  assert_true(none_js.is_undefined())
}

///|
test "Val with empty strings" {
  let obj = new_empty_object()
  obj.set("empty", "")
  assert_eq(unsafe_cast(obj.get("empty")), "")
  assert_true(obj.has_own_property("empty"))
}

///|
test "Val with zero values" {
  let obj = new_empty_object()
  obj.set("zero", 0)
  obj.set("zero_float", 0.0)
  assert_eq(unsafe_cast(obj.get("zero")), 0)
  assert_eq(unsafe_cast(obj.get("zero_float")), 0.0)
  assert_true(obj.has_own_property("zero"))
}

///|
test "Val with false boolean" {
  let obj = new_empty_object()
  obj.set("flag", false)
  assert_eq(unsafe_cast(obj.get("flag")), false)
  assert_true(obj.has_own_property("flag"))
}

///|
test "Val numeric edge cases" {
  // Large integers
  let large = js(1000000)
  assert_eq(unsafe_cast(large), 1000000)

  // Negative numbers
  let negative = js(-42)
  assert_eq(unsafe_cast(negative), -42)

  // Very small float
  let small = js(0.0001)
  assert_eq(unsafe_cast(small), 0.0001)
}

///|
test "encode_uri and decode_uri" {
  // Encode complete URI
  let uri = encode_uri("https://example.com/path?name=John Doe")
  assert_eq(uri, "https://example.com/path?name=John%20Doe")

  // Decode URI
  let decoded = decode_uri("https://example.com/path?name=John%20Doe")
  assert_eq(decoded, "https://example.com/path?name=John Doe")

  // Round trip
  let original_uri = "https://example.com/path with spaces?query=value"
  let encoded_uri = encode_uri(original_uri)
  let decoded_uri = decode_uri(encoded_uri)
  assert_eq(decoded_uri, original_uri)
}

///|
test "encode_uri_component and decode_uri_component" {
  // Encode URI component
  let encoded = encode_uri_component("Hello World & Friends")
  assert_eq(encoded, "Hello%20World%20%26%20Friends")

  // Decode URI component
  let decoded = decode_uri_component("Hello%20World%20%26%20Friends")
  assert_eq(decoded, "Hello World & Friends")

  // Special characters
  let special = encode_uri_component("key=value&foo=bar")
  assert_eq(special, "key%3Dvalue%26foo%3Dbar")
  let decoded_special = decode_uri_component("key%3Dvalue%26foo%3Dbar")
  assert_eq(decoded_special, "key=value&foo=bar")

  // Round trip with various characters
  let original = "Test: @#$%^&*()+={}[]|\\:;\"'<>,.?/"
  let encoded_component = encode_uri_component(original)
  let decoded_component = decode_uri_component(encoded_component)
  assert_eq(decoded_component, original)
}

///|
test {
  let obj = new_empty_object()
  let undef : Val? = Some(undefined())
  obj.set_if_exists("a", undef)
  let none_val : Val? = None
  obj.set_if_exists("b", none_val)
  obj.set_if_exists("c", Some(js(42)))
  assert_true(obj.get("a").is_undefined())
  // assert_eq(unsafe_cast(obj.get("a")), 42)
  // obj.set_if_exists("b", None)
  // assert_true(obj.get("b").is_undefined())
  // obj.set_if_exists("c", Some(undefined()))
  // assert_true(obj.get("c").is_undefined())
}
