///|
test "JsImpl::as_any converts builtin Json to Js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : @js.Any = JsImpl::as_any(j)
  assert_eq(@js.identity(v.get("items").get(0)), 1)
  assert_eq(@js.identity(v.get("nested").get("key")), "value")
}

///|
test "is_builtin_trait detects MoonBit builtin traits" {
  let show : &Show = "hello"
  let v : @js.Any = @js.identity(show)
  assert_true(is_builtin_trait(v))
}

///|
test "from_json converts MoonBit Json to Any object" {
  inspect(
    @nostd.json_stringify(
      @mbtconv.from_json({
        "value": null,
        "items": [1, 2, 3],
        "nested": { "key": "value" },
      }),
    ),
    content=(
      #|{"value":null,"items":[1,2,3],"nested":{"key":"value"}}
    ),
  )
  inspect(
    @nostd.json_stringify(@mbtconv.from_json({ "age": 30, "name": "Alice" })),
    content=(
      #|{"age":30,"name":"Alice"}
    ),
  )
}

///|
priv struct Point {
  x : Int
  y : Int
} derive(Show)

///|
fn Point::x2(self : Self) -> Int {
  self.x * 2
}

///|
impl JsImpl for Point

// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// This FFI function creates a JavaScript object with x/y properties for testing
// the identity cast from JS objects to MoonBit structs.
// =============================================================================

///|
/// [Test Helper] Creates a plain JS object with x and y properties.
/// Used to test @js.identity casting JS objects to MoonBit structs.
extern "js" fn test_ffi_point_new(x : Int, y : Int) -> Any =
  #|(x, y) => ({ x: x, y: y })

///|
test "from builtin struct" {
  let p = Point::{ x: 10, y: 20 }
  let v : @js.Any = JsImpl::as_any(p)
  assert_eq(@js.identity(v.get("x")), 10)
  assert_eq(@js.identity(v.get("y")), 20)
  inspect(p, content="{x: 10, y: 20}")
}

///|
test "identity to struct" {
  let v : @js.Any = test_ffi_point_new(5, 15)
  let p : Point = @js.identity(v)
  assert_eq(p.x, 5)
  assert_eq(p.y, 15)
  assert_eq(p.x2(), 10)
  inspect(p, content="{x: 5, y: 15}")
}

///|
test "from_entries converts Array to Any object" {
  let obj : @js.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
  ]).cast()
  assert_eq(@js.identity(obj.get("name")), "Alice")
  assert_eq(@js.identity(obj.get("age")), 30)
}

///|
test "from_entries and to_string" {
  let obj : @js.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
  ]).cast()
  inspect(
    obj.to_string(),
    content=(
      #|{"name":"Alice","age":30}
    ),
  )
}

///|
test "from_entries" {
  let obj : @js.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
    ("active", @nostd.any(true)),
  ]).cast()
  assert_eq(@js.identity(obj.get("name")), "Alice")
  assert_eq(@js.identity(obj.get("age")), 30)
  assert_eq(@js.identity(obj.get("active")), true)
}

///|
test "from_option_map filters None and nullish values" {
  let map : Map[String, @js.Any?] = {
    "name": Some(@js.any("Alice")),
    "age": Some(@js.any(30)),
    "email": None,
    "nullValue": Some(@js.null_()),
  }
  let obj = from_option_map(map)
  assert_eq(@js.identity(obj.get("name")), "Alice")
  assert_eq(@js.identity(obj.get("age")), 30)
  assert_eq(obj.hasOwnProperty("email"), false)
  assert_eq(obj.hasOwnProperty("nullValue"), false)
}

///|
/// from_map vs from_option_map: from_map sets all keys (including null/undefined values),
/// from_option_map skips None and nullish values (key does not exist)
test "from_map sets null values as property" {
  let map : Map[String, @js.Any] = {
    "name": @js.any("Alice"),
    "email": @js.null_(),
    "bio": @global.undefined(),
  }
  let obj = from_map(map)
  // from_map: all keys exist, even if value is null/undefined
  assert_eq(obj.hasOwnProperty("name"), true)
  assert_eq(obj.hasOwnProperty("email"), true)
  assert_eq(obj.hasOwnProperty("bio"), true)
  assert_eq(@js.is_null(obj.get("email")), true)
  assert_eq(@js.is_undefined(obj.get("bio")), true)
}

///|
/// from_option_map skips None and nullish, so the key does not exist
test "from_option_map skips keys for None values" {
  let map : Map[String, @js.Any?] = {
    "name": Some(@js.any("Alice")),
    "email": None,
    "bio": Some(@js.null_()),
  }
  let obj = from_option_map(map)
  // from_option_map: None values are skipped (key does not exist)
  assert_eq(obj.hasOwnProperty("name"), true)
  assert_eq(obj.hasOwnProperty("email"), false)
  // nullish values in Some are also skipped
  assert_eq(obj.hasOwnProperty("bio"), false)
}

///|
/// from_option_map_or_undefined returns undefined when all properties are None
test "from_option_map_or_undefined returns undefined when all None" {
  let map : Map[String, @js.Any?] = { "name": None, "age": None }
  let result = from_option_map_or_undefined(map)
  assert_eq(@js.is_undefined(result), true)
}

///|
test "from_option_map_or_undefined returns object when some values exist" {
  let map : Map[String, @js.Any?] = {
    "name": Some(@js.any("Alice")),
    "age": None,
  }
  let result = from_option_map_or_undefined(map)
  assert_eq(@js.is_undefined(result), false)
  assert_eq(result.hasOwnProperty("name"), true)
  assert_eq(result.hasOwnProperty("age"), false)
}

///|
test "from_option_map_or_undefined returns undefined for empty map" {
  let map : Map[String, @js.Any?] = {}
  let result = from_option_map_or_undefined(map)
  assert_eq(@js.is_undefined(result), true)
}

///|
test "from_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = from_array(arr)
  assert_true(@js.is_array(val))
  assert_eq(@js.identity(val.get(0)), 1)
  assert_eq(@js.identity(val.get(2)), 3)
  assert_eq(@js.identity(val.get(4)), 5)
}

///|
test "from_fn2 converts 2-arg function to Js" {
  let add = fn(a : Int, b : Int) -> Int { a + b }
  let js_add : @js.Any = from_fn2(add)
  assert_eq(@js.typeof_(js_add), "function")
  let result = js_add.call_self([@js.any(5), @js.any(3)])
  assert_eq(@js.identity(result), 8)
}

///| Global Objects

///|
test "globalThis" {
  let global = @global.global_this()
  assert_true(@js.is_object(global))
  assert_false(@js.is_null(global))
}

///| Type Checking

///|
test "global isNaN" {
  let nan_val = @js.any(0.0 / 0.0)
  assert_true(@global.is_nan(nan_val))
  assert_false(@global.is_nan(@js.any(42)))
  assert_false(@global.is_nan(@js.any(3.14)))
}

///| String Encoding (Base64)

///|
test "btoa encodes string to base64" {
  let encoded = @global.btoa("Hello World")
  assert_eq(encoded, "SGVsbG8gV29ybGQ=")
}

///|
test "atob decodes base64 to string" {
  let decoded = @global.atob("SGVsbG8gV29ybGQ=")
  assert_eq(decoded, "Hello World")
}

///|
test "btoa and atob round trip" {
  let original = "MoonBit is great!"
  let encoded = @global.btoa(original)
  let decoded = @global.atob(encoded)
  assert_eq(decoded, original)
}

///| URI Encoding

///|
test "encode_uri and decode_uri" {
  // Encode complete URI
  let uri = @global.encode_uri("https://example.com/path?name=John Doe")
  assert_eq(uri, "https://example.com/path?name=John%20Doe")

  // Decode URI
  let decoded = @global.decode_uri("https://example.com/path?name=John%20Doe")
  assert_eq(decoded, "https://example.com/path?name=John Doe")

  // Round trip
  let original_uri = "https://example.com/path with spaces?query=value"
  let encoded_uri = @global.encode_uri(original_uri)
  let decoded_uri = @global.decode_uri(encoded_uri)
  assert_eq(decoded_uri, original_uri)
}

///|
test "encode_uri_component and decode_uri_component" {
  // Encode URI component
  let encoded = @global.encode_uri_component("Hello World & Friends")
  assert_eq(encoded, "Hello%20World%20%26%20Friends")

  // Decode URI component
  let decoded = @global.decode_uri_component("Hello%20World%20%26%20Friends")
  assert_eq(decoded, "Hello World & Friends")

  // Special characters
  let special = @global.encode_uri_component("key=value&foo=bar")
  assert_eq(special, "key%3Dvalue%26foo%3Dbar")
  let decoded_special = @global.decode_uri_component("key%3Dvalue%26foo%3Dbar")
  assert_eq(decoded_special, "key=value&foo=bar")

  // Round trip with various characters
  let original = "Test: @#$%^&*()+={}[]|\\:;\"'<>,.?/"
  let encoded_component = @global.encode_uri_component(original)
  let decoded_component = @global.decode_uri_component(encoded_component)
  assert_eq(decoded_component, original)
}

///| JSON

///|
test "JSON::stringify" {
  let arr : Array[Int] = [1] |> identity
  arr |> inspect(content="[1]")
  JSON::stringify(arr |> from_array, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v : @js.Any = @nostd.from_entries([
    ("key1", @nostd.any(123)),
    ("key2", @nostd.any(456)),
    ("key3", @nostd.any(789)),
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
  let js_greet : @js.Any = from_fn0(greet)
  assert_eq(@js.typeof_(js_greet), "function")
  let result = js_greet.call_self0()
  assert_eq(@js.identity(result), "Hello")
}

///|
test "from_fn1 converts 1-arg function to Js" {
  let double = fn(x : Int) -> Int { x * 2 }
  let js_double : @js.Any = from_fn1(double)
  assert_eq(@js.typeof_(js_double), "function")
  let result = js_double.call_self([@js.any(5)])
  assert_eq(@js.identity(result), 10)
}

///|
test "from_fn3 converts 3-arg function to Js" {
  let add3 = fn(a : Int, b : Int, c : Int) -> Int { a + b + c }
  let js_add3 : @js.Any = from_fn3(add3)
  assert_eq(@js.typeof_(js_add3), "function")
  let result = js_add3.call_self([@js.any(1), @js.any(2), @js.any(3)])
  assert_eq(@js.identity(result), 6)
}

///|
test "JsImpl for Map[String, &JsImpl]" {
  let map : Map[String, &JsImpl] = { "name": "Bob", "age": 25, "active": true }
  let obj : @js.Any = JsImpl::as_any(map)
  assert_eq(@js.identity(obj.get("name")), "Bob")
  assert_eq(@js.identity(obj.get("age")), 25)
  assert_eq(@js.identity(obj.get("active")), true)
}

///|
test "JsImpl for Array[&JsImpl]" {
  let arr : Array[&JsImpl] = [1, "hello", true, 3.14]
  let js_arr : @js.Any = JsImpl::as_any(arr)
  assert_true(@js.is_array(js_arr))
  assert_eq(@js.identity(js_arr.get(0)), 1)
  assert_eq(@js.identity(js_arr.get(1)), "hello")
  assert_eq(@js.identity(js_arr.get(2)), true)
  assert_eq(@js.identity(js_arr.get(3)), 3.14)
}

///|
test "JsImpl for Option types" {
  let some_val : Int? = Some(42)
  let none_val : Int? = None
  let js_some : @js.Any = JsImpl::as_any(some_val)
  let js_none : @js.Any = JsImpl::as_any(none_val)
  assert_eq(@js.identity(js_some), 42)
  assert_true(is_undefined(js_none))
}

///| ThrowError Tests - JavaScript Built-in Error Types

///|
/// Test TypeError is caught correctly
test "throwable catches TypeError" {
  let mut caught_type_error = false
  throwable(fn() {
    let null_val = null_()
    // Calling a method on null will throw TypeError
    null_val.call0("toString") |> ignore
  }) catch {
    ThrowError::TypeError(_) => caught_type_error = true
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_type_error)
}

///|
/// Test RangeError is caught correctly
test "throwable catches RangeError" {
  let mut caught_range_error = false
  throwable(fn() {
    // Creating array with invalid length throws RangeError
    let arr = JsArray::new()
    arr.set("length", @js.any(-1)) |> ignore
  }) catch {
    ThrowError::RangeError(_) => caught_range_error = true
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_range_error)
}

///|
/// Test SyntaxError is caught correctly with JSON.parse
test "throwable catches SyntaxError from JSON.parse" {
  let mut caught_syntax_error = false
  try {
    // Invalid JSON will throw SyntaxError
    let _ = JSON::parse("{invalid json}")

  } catch {
    ThrowError::SyntaxError(_) => caught_syntax_error = true
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_syntax_error)
}

///|
/// Test URIError is caught correctly
test "throwable catches URIError" {
  let mut caught_uri_error = false
  throwable(fn() {
    // Invalid URI encoding throws URIError
    @global.decode_uri_component("%E0%A4%A") |> ignore
  }) catch {
    ThrowError::URIError(_) => caught_uri_error = true
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_uri_error)
}

///|
/// Test ReferenceError is caught correctly
test "throwable catches ReferenceError" {
  let mut caught_reference_error = false
  throwable(fn() {
    // Accessing undefined variable throws ReferenceError
    let code = "nonExistentVariable"
    @global.global_this().call1("eval", @js.any(code)) |> ignore
  }) catch {
    ThrowError::ReferenceError(_) => caught_reference_error = true
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_reference_error)
}

///|
/// Test EvalError can be created (eval errors are rare in modern JS)
test "throwable catches EvalError" {
  let mut caught_eval_error = false
  throwable(fn() {
    // Create EvalError manually since it's rarely thrown naturally
    let eval_error_cls = @global.global_this().get("EvalError")
    let err = new_(eval_error_cls, [any("Eval error message")])
    throw_(err)
  }) catch {
    ThrowError::EvalError(_) => caught_eval_error = true
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_eval_error)
}

///|
/// Test AggregateError is caught correctly
test "throwable catches AggregateError" {
  let mut caught_aggregate_error = false
  throwable(fn() {
    // Create AggregateError with multiple errors
    let errors = from_array([
      JsError::new("Error 1").as_any(),
      JsError::new("Error 2").as_any(),
    ])
    let agg_error_cls = @global.global_this().get("AggregateError")
    let agg_err = new_(agg_error_cls, [errors, any("Multiple errors")])
    throw_(agg_err)
  }) catch {
    ThrowError::AggregateError(_) => caught_aggregate_error = true
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_aggregate_error)
}

///|
/// Test generic Error is caught when type doesn't match specific types
test "throwable catches generic Error" {
  let mut caught_error = false
  throwable(fn() {
    // Create and throw a generic Error
    let err = JsError::new("Generic error message")
    throw_(err)
  }) catch {
    ThrowError::Error(err) => {
      caught_error = true
      assert_eq(err.message, "Generic error message")
    }
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_error)
}

///|
/// Test non-error value thrown as ThrowError::Value
test "throwable catches non-error value" {
  let mut caught_value = false
  throwable(fn() {
    // Throw a non-Error value (string)
    throw_(@js.any("custom error string"))
  }) catch {
    ThrowError::Value(val) => {
      caught_value = true
      assert_eq(@js.identity(val), "custom error string")
    }
    _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_value)
}

///|
/// Test error message is preserved in ThrowError
test "ThrowError preserves error message" {
  try {
    let _ = JSON::parse("{bad json}")

  } catch {
    ThrowError::SyntaxError(err) =>
      // Error message should contain information about the syntax error
      assert_true(err.message.length() > 0)
    _ => assert_true(false) // Should not reach here
  }
}

///|
/// Test ThrowError Show trait implementation
test "ThrowError Show trait works for all variants" {
  // Test TypeError
  throwable(fn() { null_().call0("toString") |> ignore }) catch {
    ThrowError::TypeError(err) => {
      let msg = err.to_string()
      assert_true(msg.length() > 0)
    }
    _ => assert_true(false) // Should not catch other error types
  }

  // Test SyntaxError
  try {
    let _ = JSON::parse("{invalid}")

  } catch {
    ThrowError::SyntaxError(err) => {
      let msg = err.to_string()
      assert_true(msg.length() > 0)
    }
    _ => assert_true(false) // Should not catch other error types
  }

  // Test Value variant - direct to_string on ThrowError
  throwable(fn() { throw_(@js.any(42)) }) catch {
    err => {
      // Test ThrowError's to_string() implementation
      let msg = err.to_string()
      assert_eq(msg, "42")
    }
  }
}

///| Any.to_json tests

///|
test "Any.to_json with null" {
  let null_val = null_()
  let json = null_val.to_json()
  assert_eq(json, Json::null())
}

///|
test "Any.to_json with boolean" {
  let true_val = @js.any(true)
  let json_true = true_val.to_json()
  assert_true(json_true is True)
  let false_val = @js.any(false)
  let json_false = false_val.to_json()
  assert_true(json_false is False)
}

///|
test "Any.to_json with number" {
  let num_val = @js.any(42.5)
  let json = num_val.to_json()
  match json {
    Number(n, ..) => assert_eq(n, 42.5)
    _ => fail("Expected Number")
  }
}

///|
test "Any.to_json with string" {
  let str_val = @js.any("hello")
  let json = str_val.to_json()
  match json {
    String(s) => assert_eq(s, "hello")
    _ => fail("Expected String")
  }
}

///|
test "Any.to_json with array" {
  let arr = from_array([@js.any(1), @js.any(2), @js.any(3)])
  let json = arr.to_json()
  match json {
    Array(items) => assert_eq(items.length(), 3)
    _ => fail("Expected Array")
  }
}

///|
test "Any.to_json with object" {
  let obj : @js.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
  ]).cast()
  let json = obj.to_json()
  match json {
    Object(map) => {
      assert_true(map.contains("name"))
      assert_true(map.contains("age"))
    }
    _ => fail("Expected Object")
  }
}

///| Json to Any conversion tests

///|
test "Json::True to Any" {
  let json_true : Json = true
  let any_val : @js.Any = JsImpl::as_any(json_true)
  let result : Bool = @js.identity(any_val)
  assert_eq(result, true)
}

///|
test "Json::False to Any" {
  let json_false : Json = false
  let any_val : @js.Any = JsImpl::as_any(json_false)
  let result : Bool = @js.identity(any_val)
  assert_eq(result, false)
}

///| call_self_throwable tests

///|
test "call_self_throwable success" {
  let parse_int = @global.global_this().get("parseInt")
  let result = parse_int.call_self_throwable([@js.any("42")])
  let num : Int = @js.identity(result)
  assert_eq(num, 42)
}

///|
test "call_self_throwable with error" {
  // Create a function that throws
  let throw_fn = @global.global_this().call1(
    "eval",
    @js.any("(function() { throw new Error('test'); })"),
  )
  let result = try? throw_fn.call_self_throwable([])
  assert_true(result is Err(_))
}

///| SuppressedError tests

///|
test "SuppressedError instanceof check" {
  let suppressed_error_cls = @global.global_this().get("SuppressedError")
  let err1 = JsError::new("Error 1")
  let err2 = JsError::new("Error 2")
  let suppressed_err = new_(suppressed_error_cls, [
    err1.as_any(),
    err2.as_any(),
    @js.any("Suppressed error message"),
  ])
  // Check instanceof
  assert_true(@js.instanceof_(suppressed_err, suppressed_error_cls))
  // Check ThrowError::from_js
  let throw_err = ThrowError::from_js(suppressed_err)
  inspect(throw_err, content="Suppressed error message")
}
