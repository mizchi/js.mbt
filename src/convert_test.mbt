///|
test "JsImpl::as_any converts builtin Json to Js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : @nostd.Any = @mbtconv.from_json(j)
  assert_eq(@nostd.identity(v._get("items")._get_by_index(0)), 1)
  assert_eq(@nostd.identity(v._get("nested")._get("key")), "value")
}

///|
test "is_builtin_trait detects MoonBit builtin traits" {
  let show : &Show = "hello"
  let v : @nostd.Any = @nostd.identity(show)
  assert_true(is_builtin_trait(v))
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

// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// This FFI function creates a JavaScript object with x/y properties for testing
// the identity cast from JS objects to MoonBit structs.
// =============================================================================

///|
/// [Test Helper] Creates a plain JS object with x and y properties.
/// Used to test @nostd.identity casting JS objects to MoonBit structs.
extern "js" fn test_ffi_point_new(x : Int, y : Int) -> @nostd.Any =
  #|(x, y) => ({ x: x, y: y })

///|
test "from builtin struct" {
  let p = Point::{ x: 10, y: 20 }
  let v : @nostd.Any = @nostd.any(p)
  assert_eq(@nostd.identity(v._get("x")), 10)
  assert_eq(@nostd.identity(v._get("y")), 20)
  inspect(p, content="{x: 10, y: 20}")
}

///|
test "identity to struct" {
  let v : @nostd.Any = test_ffi_point_new(5, 15)
  let p : Point = @nostd.identity(v)
  assert_eq(p.x, 5)
  assert_eq(p.y, 15)
  assert_eq(p.x2(), 10)
  inspect(p, content="{x: 5, y: 15}")
}

///|
test "from_entries converts Array to Any object" {
  let obj : @nostd.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
  ]).cast()
  assert_eq(@nostd.identity(obj._get("name")), "Alice")
  assert_eq(@nostd.identity(obj._get("age")), 30)
}

///|
test "from_entries and to_string" {
  let obj : @nostd.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
  ]).cast()
  inspect(
    JSON::stringify(obj),
    content=(
      #|{
      #|  "name": "Alice",
      #|  "age": 30
      #|}
    ),
  )
}

///|
test "from_entries" {
  let obj : @nostd.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
    ("active", @nostd.any(true)),
  ]).cast()
  assert_eq(@nostd.identity(obj._get("name")), "Alice")
  assert_eq(@nostd.identity(obj._get("age")), 30)
  assert_eq(@nostd.identity(obj._get("active")), true)
}

///|
test "from_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = @nostd.any(arr)
  assert_true(@js.is_array(val))
  assert_eq(@nostd.identity(val._get("0")), 1)
  assert_eq(@nostd.identity(val._get("2")), 3)
  assert_eq(@nostd.identity(val._get("4")), 5)
}

///|
test "from_fn2 converts 2-arg function to Js" {
  let add = fn(a : Int, b : Int) -> Int { a + b }
  let js_add : @nostd.Any = @nostd.from_fn2(add)
  assert_eq(@nostd.typeof_(js_add), "function")
  let result = js_add._invoke([@nostd.any(5), @nostd.any(3)])
  assert_eq(@nostd.identity(result), 8)
}

///| Global Objects

///|
test "globalThis" {
  let global = @global.global_this()
  assert_true(@nostd.is_object(global))
  assert_false(@nostd.is_null(global))
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
  JSON::stringify(arr |> @nostd.any, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v : @nostd.Any = @nostd.from_entries([
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
  let js_greet : @nostd.Any = @nostd.from_fn0(greet)
  assert_eq(@nostd.typeof_(js_greet), "function")
  let result = js_greet._invoke([])
  assert_eq(@nostd.identity(result), "Hello")
}

///|
test "from_fn1 converts 1-arg function to Js" {
  let double = fn(x : Int) -> Int { x * 2 }
  let js_double : @nostd.Any = @nostd.from_fn1(double)
  assert_eq(@nostd.typeof_(js_double), "function")
  let result = js_double._invoke([@nostd.any(5)])
  assert_eq(@nostd.identity(result), 10)
}

///|
test "from_fn3 converts 3-arg function to Js" {
  let add3 = fn(a : Int, b : Int, c : Int) -> Int { a + b + c }
  let js_add3 : @nostd.Any = @nostd.from_fn3(add3)
  assert_eq(@nostd.typeof_(js_add3), "function")
  let result = js_add3._invoke([@nostd.any(1), @nostd.any(2), @nostd.any(3)])
  assert_eq(@nostd.identity(result), 6)
}

// ///|
// test "JsImpl for Map[String, &JsImpl]" {
//   let map : Map[String, &JsImpl] = { "name": "Bob", "age": 25, "active": true }
//   let obj : @nostd.Any = @nostd.any(map)
//   assert_eq(@nostd.identity(obj._get("name")), "Bob")
//   assert_eq(@nostd.identity(obj._get("age")), 25)
//   assert_eq(@nostd.identity(obj._get("active")), true)
// }

///|
// test "JsImpl for Array[&JsImpl]" {
//   let arr : Array[&JsImpl] = [1, "hello", true, 3.14]
//   let js_arr : @nostd.Any = JsImpl::as_any(arr)
//   assert_true(@js.is_array(js_arr))
//   assert_eq(@nostd.identity(js_arr._get(0)), 1)
//   assert_eq(@nostd.identity(js_arr._get(1)), "hello")
//   assert_eq(@nostd.identity(js_arr._get(2)), true)
//   assert_eq(@nostd.identity(js_arr._get(3)), 3.14)
// }

///|
test "JsImpl for Option types" {
  let some_val : Int? = Some(42)
  let none_val : Int? = None
  let js_some : @nostd.Any = @nostd.any(some_val)
  let js_none : @nostd.Any = @nostd.any(none_val)
  assert_eq(@nostd.identity(js_some), 42)
  assert_true(@nostd.is_undefined(js_none))
}

///| ThrowError Tests - JavaScript Built-in Error Types

///|
/// Test TypeError is caught correctly
test "throwable catches TypeError" {
  let mut caught_type_error = false
  throwable(fn() {
    let null_val = @nostd.null()
    // Calling a method on null will throw TypeError
    null_val._call("toString", []) |> ignore
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
    let arr = @nostd.any(([] : Array[Int]))
    arr.set("length", -1)
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
    @global.global_this().call1("eval", @nostd.any(code)) |> ignore
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
    let eval_error_cls = @global.global_this()._get("EvalError")
    let err = @nostd.new(eval_error_cls, [@nostd.any("Eval error message")])
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
    let agg_error_cls = @global.global_this()._get("AggregateError")
    let agg_err = @nostd.new(agg_error_cls, [errors, any("Multiple errors")])
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
    throw_(err.to_any())
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
    throw_(@nostd.any("custom error string"))
  }) catch {
    ThrowError::Value(val) => {
      caught_value = true
      assert_eq(@nostd.identity(val), "custom error string")
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
  throwable(fn() { @nostd.null()._call("toString", []) |> ignore }) catch {
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
  throwable(fn() { throw_(@nostd.any(42)) }) catch {
    err => {
      // Test ThrowError's to_string() implementation
      let msg = err.to_string()
      assert_eq(msg, "42")
    }
  }
}

///| call_self_throwable tests

///|
test "call_self_throwable success" {
  let parse_int = @global.global_this()._get("parseInt")
  let result = throwable(fn() { parse_int._invoke([@nostd.any("42")]) })
  let num : Int = @nostd.identity(result)
  assert_eq(num, 42)
}

///|
test "call_self_throwable with error" {
  // Create a function that throws
  let throw_fn = @global.global_this()._call("eval", [
    @nostd.any("(function() { throw new Error('test'); })"),
  ])
  let result = try? throwable(fn() { throw_fn._invoke([]) })
  assert_true(result is Err(_))
}

///| SuppressedError tests

///|
test "SuppressedError instanceof check" {
  let suppressed_error_cls = @global.global_this()._get("SuppressedError")
  let err1 = JsError::new("Error 1")
  let err2 = JsError::new("Error 2")
  let suppressed_err = @nostd.new(suppressed_error_cls, [
    err1 |> @nostd.any,
    err2 |> @nostd.any,
    @nostd.any("Suppressed error message"),
  ])
  // Check instanceof
  assert_true(@nostd.instanceof_(suppressed_err, suppressed_error_cls))
  // Check ThrowError::from
  let throw_err = ThrowError::from(suppressed_err)
  inspect(throw_err, content="Suppressed error message")
}
