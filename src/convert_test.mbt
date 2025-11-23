///|
test "JsImpl::to_js converts builtin Json to Js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : @js.Js = JsImpl::to_js(j)
  assert_eq(@js.unsafe_cast(v.get("items").get(0)), 1)
  assert_eq(@js.unsafe_cast(v.get("nested").get("key")), "value")
}

///|
test "is_builtin_trait detects MoonBit builtin traits" {
  let show : &Show = "hello"
  let v : @js.Js = @js.unsafe_cast(show)
  assert_true(is_builtin_trait(v))
}

///|
test "from_json converts MoonBit Json to Js object" {
  inspect(
    from_json({
      "value": null,
      "items": [1, 2, 3],
      "nested": { "key": "value" },
    }),
    content=(
      #|{"value":null,"items":[1,2,3],"nested":{"key":"value"}}
    ),
  )
  inspect(
    from_json({ "age": 30, "name": "Alice" }),
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

///|
extern "js" fn ffi_point_new(x : Int, y : Int) -> Js =
  #|(x, y) => ({ x: x, y: y })

///|
test "from builtin struct" {
  let p = Point::{ x: 10, y: 20 }
  let v : @js.Js = JsImpl::to_js(p)
  assert_eq(@js.unsafe_cast(v.get("x")), 10)
  assert_eq(@js.unsafe_cast(v.get("y")), 20)
  inspect(p, content="{x: 10, y: 20}")
}

///|
test "unsafe_cast to struct" {
  let v : @js.Js = ffi_point_new(5, 15)
  let p : Point = @js.unsafe_cast(v)
  assert_eq(p.x, 5)
  assert_eq(p.y, 15)
  assert_eq(p.x2(), 10)
  inspect(p, content="{x: 5, y: 15}")
}

///|
test "from_map converts MoonBit Map to Js object" {
  let map : Map[String, @js.Js] = { "name": js("Alice"), "age": js(30) }
  let obj : @js.Js = from_map(map)
  assert_eq(@js.unsafe_cast(obj.get("name")), "Alice")
  assert_eq(@js.unsafe_cast(obj.get("age")), 30)
}

///|
test "from_map and to_string" {
  let map : Map[String, @js.Js] = { "name": js("Alice"), "age": js(30) }
  let obj : @js.Js = from_map(map)
  inspect(
    obj.to_string(),
    content=(
      #|{"name":"Alice","age":30}
    ),
  )
}

///|
test "from_map" {
  let map : Map[String, @js.Js] = {
    "name": js("Alice"),
    "age": js(30),
    "active": js(true),
  }
  let obj = from_map(map)
  assert_eq(@js.unsafe_cast(obj.get("name")), "Alice")
  assert_eq(@js.unsafe_cast(obj.get("age")), 30)
  assert_eq(@js.unsafe_cast(obj.get("active")), true)
}

///|
test "from_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = from_array(arr)
  assert_true(@js.is_array(val))
  assert_eq(@js.unsafe_cast(val.get(0)), 1)
  assert_eq(@js.unsafe_cast(val.get(2)), 3)
  assert_eq(@js.unsafe_cast(val.get(4)), 5)
}

///|
test "from_fn2 converts 2-arg function to Js" {
  let add = fn(a : Int, b : Int) -> Int { a + b }
  let js_add : @js.Js = from_fn2(add)
  assert_eq(@js.typeof_(js_add), "function")
  let result = js_add.call_self([js(5), js(3)])
  assert_eq(@js.unsafe_cast(result), 8)
}

///|
test "from_entries converts tuple array to Js object" {
  let entries : Array[(String, &JsImpl)] = [
    ("name", "Alice"),
    ("age", 30),
    ("active", true),
  ]
  let obj = from_entries(entries)
  assert_eq(@js.unsafe_cast(obj.get("name")), "Alice")
  assert_eq(@js.unsafe_cast(obj.get("age")), 30)
  assert_eq(@js.unsafe_cast(obj.get("active")), true)
}

///|
test "from_entries with mixed types" {
  let entries : Array[(String, &JsImpl)] = [
    ("str", "hello"),
    ("num", 42),
    ("bool", false),
    ("float", 3.14),
  ]
  let obj = from_entries(entries)
  assert_eq(@js.unsafe_cast(obj.get("str")), "hello")
  assert_eq(@js.unsafe_cast(obj.get("num")), 42)
  assert_eq(@js.unsafe_cast(obj.get("bool")), false)
  assert_eq(@js.unsafe_cast(obj.get("float")), 3.14)
}

///|
test "from_entries with empty array" {
  let entries : Array[(String, &JsImpl)] = []
  let obj = from_entries(entries)
  inspect(obj.to_string(), content="{}")
}

///|
test "from_entries_option filters None values" {
  let entries : Array[(String, &JsImpl?)] = [
    ("name", Some("Alice")),
    ("age", Some(30)),
    ("email", None),
    ("active", Some(true)),
    ("address", None),
  ]
  let obj = from_entries_option(entries)
  assert_eq(@js.unsafe_cast(obj.get("name")), "Alice")
  assert_eq(@js.unsafe_cast(obj.get("age")), 30)
  assert_eq(@js.unsafe_cast(obj.get("active")), true)
  // None values should not be set
  assert_true(is_undefined(obj.get("email")))
  assert_true(is_undefined(obj.get("address")))
}

///|
test "from_entries_option with all Some" {
  let entries : Array[(String, &JsImpl?)] = [
    ("a", Some(1)),
    ("b", Some(2)),
    ("c", Some(3)),
  ]
  let obj = from_entries_option(entries)
  assert_eq(@js.unsafe_cast(obj.get("a")), 1)
  assert_eq(@js.unsafe_cast(obj.get("b")), 2)
  assert_eq(@js.unsafe_cast(obj.get("c")), 3)
}

///|
test "from_entries_option with all None" {
  let entries : Array[(String, &JsImpl?)] = [
    ("a", None),
    ("b", None),
    ("c", None),
  ]
  let obj = from_entries_option(entries)
  inspect(obj.to_string(), content="{}")
}

///|
test "from_entries_option with empty array" {
  let entries : Array[(String, &JsImpl?)] = []
  let obj = from_entries_option(entries)
  inspect(obj.to_string(), content="{}")
}

///|
test "from_entries with direct array (type inference)" {
  // 直接配列を渡した場合、型推論が効くかテスト
  let obj = from_entries([("name", "Bob"), ("age", 25)])
  assert_eq(@js.unsafe_cast(obj.get("name")), "Bob")
  assert_eq(@js.unsafe_cast(obj.get("age")), 25)
}

///|
test "from_entries_option with direct array (type inference)" {
  // 直接配列を渡した場合、型推論が効くかテスト
  let obj = from_entries_option([
    ("name", Some("Charlie")),
    ("age", Some(40)),
    ("email", None),
  ])
  assert_eq(@js.unsafe_cast(obj.get("name")), "Charlie")
  assert_eq(@js.unsafe_cast(obj.get("age")), 40)
  assert_true(is_undefined(obj.get("email")))
}

///| Global Objects

///|
test "globalThis" {
  let global = globalThis()
  assert_true(@js.is_object(global))
  assert_false(@js.is_null(global))
}

///| Type Checking

///|
test "global isNaN" {
  let nan_val = @js.js(0.0 / 0.0)
  assert_true(@js.isNaN(nan_val))
  assert_false(@js.isNaN(42))
  assert_false(@js.isNaN(3.14))
}

///| String Encoding (Base64)

///|
test "btoa encodes string to base64" {
  let encoded = btoa("Hello World")
  assert_eq(encoded, "SGVsbG8gV29ybGQ=")
}

///|
test "atob decodes base64 to string" {
  let decoded = atob("SGVsbG8gV29ybGQ=")
  assert_eq(decoded, "Hello World")
}

///|
test "btoa and atob round trip" {
  let original = "MoonBit is great!"
  let encoded = btoa(original)
  let decoded = atob(encoded)
  assert_eq(decoded, original)
}

///| URI Encoding

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

///| JSON

///|
test "JSON::stringify" {
  let arr : Array[Int] = [1] |> unsafe_cast
  arr |> inspect(content="[1]")
  JSON::stringify(arr |> from_array, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v = from_map({ "key1": 123 |> js, "key2": 456 |> js, "key3": 789 |> js })
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
  let js_greet : @js.Js = from_fn0(greet)
  assert_eq(@js.typeof_(js_greet), "function")
  let result = js_greet.call_self0()
  assert_eq(@js.unsafe_cast(result), "Hello")
}

///|
test "from_fn1 converts 1-arg function to Js" {
  let double = fn(x : Int) -> Int { x * 2 }
  let js_double : @js.Js = from_fn1(double)
  assert_eq(@js.typeof_(js_double), "function")
  let result = js_double.call_self([js(5)])
  assert_eq(@js.unsafe_cast(result), 10)
}

///|
test "from_fn3 converts 3-arg function to Js" {
  let add3 = fn(a : Int, b : Int, c : Int) -> Int { a + b + c }
  let js_add3 : @js.Js = from_fn3(add3)
  assert_eq(@js.typeof_(js_add3), "function")
  let result = js_add3.call_self([js(1), js(2), js(3)])
  assert_eq(@js.unsafe_cast(result), 6)
}

///|
test "from_entries_option_cast with Bool options" {
  let entries : Array[(String, Bool?)] = [
    ("open", Some(true)),
    ("readOnly", Some(false)),
    ("timeout", None),
  ]
  let obj = from_entries_option_cast(entries)
  assert_eq(@js.unsafe_cast(obj.get("open")), true)
  assert_eq(@js.unsafe_cast(obj.get("readOnly")), false)
  assert_true(is_undefined(obj.get("timeout")))
}

///|
test "from_entries_option_cast with Int options" {
  let entries : Array[(String, Int?)] = [
    ("width", Some(100)),
    ("height", Some(200)),
    ("depth", None),
  ]
  let obj = from_entries_option_cast(entries)
  assert_eq(@js.unsafe_cast(obj.get("width")), 100)
  assert_eq(@js.unsafe_cast(obj.get("height")), 200)
  assert_true(is_undefined(obj.get("depth")))
}

///|
test "JsImpl for Map[String, &JsImpl]" {
  let map : Map[String, &JsImpl] = { "name": "Bob", "age": 25, "active": true }
  let obj : @js.Js = JsImpl::to_js(map)
  assert_eq(@js.unsafe_cast(obj.get("name")), "Bob")
  assert_eq(@js.unsafe_cast(obj.get("age")), 25)
  assert_eq(@js.unsafe_cast(obj.get("active")), true)
}

///|
test "JsImpl for Array[&JsImpl]" {
  let arr : Array[&JsImpl] = [1, "hello", true, 3.14]
  let js_arr : @js.Js = JsImpl::to_js(arr)
  assert_true(@js.is_array(js_arr))
  assert_eq(@js.unsafe_cast(js_arr.get(0)), 1)
  assert_eq(@js.unsafe_cast(js_arr.get(1)), "hello")
  assert_eq(@js.unsafe_cast(js_arr.get(2)), true)
  assert_eq(@js.unsafe_cast(js_arr.get(3)), 3.14)
}

///|
test "JsImpl for Option types" {
  let some_val : Int? = Some(42)
  let none_val : Int? = None
  let js_some : @js.Js = JsImpl::to_js(some_val)
  let js_none : @js.Js = JsImpl::to_js(none_val)
  assert_eq(@js.unsafe_cast(js_some), 42)
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
    arr.set("length", js(-1)) |> ignore
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
    decodeURIComponent("%E0%A4%A") |> ignore
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
    globalThis().call("eval", [js(code)]) |> ignore
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
    let eval_error_cls = globalThis().get("EvalError")
    let err = new_(eval_error_cls, ["Eval error message"])
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
    let errors = JsArray::new()
    errors.push(JsError::new("Error 1"))
    errors.push(JsError::new("Error 2"))
    let agg_error_cls = globalThis().get("AggregateError")
    let agg_err = new_(agg_error_cls, [errors, "Multiple errors"])
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
    throw_(js("custom error string"))
  }) catch {
    ThrowError::Value(val) => {
      caught_value = true
      assert_eq(@js.unsafe_cast(val), "custom error string")
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
  throwable(fn() { throw_(js(42)) }) catch {
    err => {
      // Test ThrowError's to_string() implementation
      let msg = err.to_string()
      assert_eq(msg, "42")
    }
  }
}
