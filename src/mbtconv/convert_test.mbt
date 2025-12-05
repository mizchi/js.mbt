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
/// Used to test @core.identity casting JS objects to MoonBit structs.
extern "js" fn test_ffi_point_new(x : Int, y : Int) -> @core.Any =
  #|(x, y) => ({ x: x, y: y })

///|
test "from builtin struct" {
  let p = Point::{ x: 10, y: 20 }
  let v : @core.Any = @core.any(p)
  assert_eq(@core.identity(v._get("x")), 10)
  assert_eq(@core.identity(v._get("y")), 20)
  inspect(p, content="{x: 10, y: 20}")
}

///|
test "identity to struct" {
  let v : @core.Any = test_ffi_point_new(5, 15)
  let p : Point = @core.identity(v)
  assert_eq(p.x, 5)
  assert_eq(p.y, 15)
  assert_eq(p.x2(), 10)
  inspect(p, content="{x: 5, y: 15}")
}

///|
test "from_fn2 converts 2-arg function to Js" {
  let add = fn(a : Int, b : Int) -> Int { a + b }
  let js_add : @core.Any = @core.from_fn2(add)
  assert_eq(@core.typeof_(js_add), "function")
  let result = js_add._invoke([@core.any(5), @core.any(3)])
  assert_eq(@core.identity(result), 8)
}

///| Global Objects

// ///|
// test "globalThis" {
//   let global = @global.global_this()
//   assert_true(@core.is_object(global))
//   assert_false(@core.is_null(global))
// }

// ///| URI Encoding

// ///|
// test "encode_uri and decode_uri" {
//   // Encode complete URI
//   let uri = @global.encode_uri("https://example.com/path?name=John Doe")
//   assert_eq(uri, "https://example.com/path?name=John%20Doe")

//   // Decode URI
//   let decoded = @global.decode_uri("https://example.com/path?name=John%20Doe")
//   assert_eq(decoded, "https://example.com/path?name=John Doe")

//   // Round trip
//   let original_uri = "https://example.com/path with spaces?query=value"
//   let encoded_uri = @global.encode_uri(original_uri)
//   let decoded_uri = @global.decode_uri(encoded_uri)
//   assert_eq(decoded_uri, original_uri)
// }

// ///|
// test "encode_uri_component and decode_uri_component" {
//   // Encode URI component
//   let encoded = @global.encode_uri_component("Hello World & Friends")
//   assert_eq(encoded, "Hello%20World%20%26%20Friends")

//   // Decode URI component
//   let decoded = @global.decode_uri_component("Hello%20World%20%26%20Friends")
//   assert_eq(decoded, "Hello World & Friends")

//   // Special characters
//   let special = @global.encode_uri_component("key=value&foo=bar")
//   assert_eq(special, "key%3Dvalue%26foo%3Dbar")
//   let decoded_special = @global.decode_uri_component("key%3Dvalue%26foo%3Dbar")
//   assert_eq(decoded_special, "key=value&foo=bar")

//   // Round trip with various characters
//   let original = "Test: @#$%^&*()+={}[]|\\:;\"'<>,.?/"
//   let encoded_component = @global.encode_uri_component(original)
//   let decoded_component = @global.decode_uri_component(encoded_component)
//   assert_eq(decoded_component, original)
// }

///| JSON

///|
test "from_fn0 converts 0-arg function to Js" {
  let greet = fn() -> String { "Hello" }
  let js_greet : @core.Any = @core.from_fn0(greet)
  assert_eq(@core.typeof_(js_greet), "function")
  let result = js_greet._invoke([])
  assert_eq(@core.identity(result), "Hello")
}

///|
test "from_fn1 converts 1-arg function to Js" {
  let double = fn(x : Int) -> Int { x * 2 }
  let js_double : @core.Any = @core.from_fn1(double)
  assert_eq(@core.typeof_(js_double), "function")
  let result = js_double._invoke([@core.any(5)])
  assert_eq(@core.identity(result), 10)
}

///|
test "from_fn3 converts 3-arg function to Js" {
  let add3 = fn(a : Int, b : Int, c : Int) -> Int { a + b + c }
  let js_add3 : @core.Any = @core.from_fn3(add3)
  assert_eq(@core.typeof_(js_add3), "function")
  let result = js_add3._invoke([@core.any(1), @core.any(2), @core.any(3)])
  assert_eq(@core.identity(result), 6)
}

///|
test "JsImpl for Option types" {
  let some_val : Int? = Some(42)
  let none_val : Int? = None
  let js_some : @core.Any = @core.any(some_val)
  let js_none : @core.Any = @core.any(none_val)
  assert_eq(@core.identity(js_some), 42)
  assert_true(@core.is_undefined(js_none))
}

///| ThrowError Tests - JavaScript Built-in Error Types

///|
/// Test TypeError is caught correctly
test "throwable catches TypeError" {
  let mut caught_type_error = false
  @core.throwable(fn() {
    let null_val = @core.null()
    // Calling a method on null will throw TypeError
    null_val._call("toString", []) |> ignore
  }) catch {
    _ => caught_type_error = true
    // _ => assert_true(false) // Should not catch other error types
  }
  assert_true(caught_type_error)
}

// ///|
// /// Test RangeError is caught correctly
// test "throwable catches RangeError" {
//   let mut caught_range_error = false
//   throwable(fn() {
//     // Creating array with invalid length throws RangeError
//     let arr = @core.any(([] : Array[Int]))
//     arr.set("length", -1)
//   }) catch {
//     ThrowError::RangeError(_) => caught_range_error = true
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_range_error)
// }

// ///|
// /// Test SyntaxError is caught correctly with JSON.parse
// test "throwable catches SyntaxError from JSON.parse" {
//   let mut caught_syntax_error = false
//   try {
//     // Invalid JSON will throw SyntaxError
//     let _ = JSON::parse("{invalid json}")

//   } catch {
//     ThrowError::SyntaxError(_) => caught_syntax_error = true
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_syntax_error)
// }

// ///|
// /// Test URIError is caught correctly
// test "throwable catches URIError" {
//   let mut caught_uri_error = false
//   throwable(fn() {
//     // Invalid URI encoding throws URIError
//     @global.decode_uri_component("%E0%A4%A") |> ignore
//   }) catch {
//     ThrowError::URIError(_) => caught_uri_error = true
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_uri_error)
// }

// ///|
// /// Test ReferenceError is caught correctly
// test "throwable catches ReferenceError" {
//   let mut caught_reference_error = false
//   throwable(fn() {
//     // Accessing undefined variable throws ReferenceError
//     let code = "nonExistentVariable"
//     @global.global_this().call1("eval", @core.any(code)) |> ignore
//   }) catch {
//     ThrowError::ReferenceError(_) => caught_reference_error = true
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_reference_error)
// }

// ///|
// /// Test EvalError can be created (eval errors are rare in modern JS)
// test "throwable catches EvalError" {
//   let mut caught_eval_error = false
//   throwable(fn() {
//     // Create EvalError manually since it's rarely thrown naturally
//     let eval_error_cls = @global.global_this()._get("EvalError")
//     let err = @core.new(eval_error_cls, [@core.any("Eval error message")])
//     throw_(err)
//   }) catch {
//     ThrowError::EvalError(_) => caught_eval_error = true
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_eval_error)
// }

// ///|
// /// Test AggregateError is caught correctly
// test "throwable catches AggregateError" {
//   let mut caught_aggregate_error = false
//   throwable(fn() {
//     // Create AggregateError with multiple errors
//     let errors = from_array([
//       JsError::new("Error 1").as_any(),
//       JsError::new("Error 2").as_any(),
//     ])
//     let agg_error_cls = @global.global_this()._get("AggregateError")
//     let agg_err = @core.new(agg_error_cls, [errors, any("Multiple errors")])
//     throw_(agg_err)
//   }) catch {
//     ThrowError::AggregateError(_) => caught_aggregate_error = true
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_aggregate_error)
// }

// ///|
// /// Test generic Error is caught when type doesn't match specific types
// test "throwable catches generic Error" {
//   let mut caught_error = false
//   throwable(fn() {
//     // Create and throw a generic Error
//     let err = JsError::new("Generic error message")
//     throw_(err.to_any())
//   }) catch {
//     ThrowError::Error(err) => {
//       caught_error = true
//       assert_eq(err.message, "Generic error message")
//     }
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_error)
// }

// ///|
// /// Test non-error value thrown as ThrowError::Value
// test "throwable catches non-error value" {
//   let mut caught_value = false
//   throwable(fn() {
//     // Throw a non-Error value (string)
//     throw_(@core.any("custom error string"))
//   }) catch {
//     ThrowError::Value(val) => {
//       caught_value = true
//       assert_eq(@core.identity(val), "custom error string")
//     }
//     _ => assert_true(false) // Should not catch other error types
//   }
//   assert_true(caught_value)
// }

// ///|
// /// Test error message is preserved in ThrowError
// test "ThrowError preserves error message" {
//   try {
//     let _ = JSON::parse("{bad json}")

//   } catch {
//     ThrowError::SyntaxError(err) =>
//       // Error message should contain information about the syntax error
//       assert_true(err.message.length() > 0)
//     _ => assert_true(false) // Should not reach here
//   }
// }

// ///|
// /// Test ThrowError Show trait implementation
// test "ThrowError Show trait works for all variants" {
//   // Test TypeError
//   throwable(fn() { @core.null()._call("toString", []) |> ignore }) catch {
//     ThrowError::TypeError(err) => {
//       let msg = err.to_string()
//       assert_true(msg.length() > 0)
//     }
//     _ => assert_true(false) // Should not catch other error types
//   }

//   // Test SyntaxError
//   try {
//     let _ = JSON::parse("{invalid}")

//   } catch {
//     ThrowError::SyntaxError(err) => {
//       let msg = err.to_string()
//       assert_true(msg.length() > 0)
//     }
//     _ => assert_true(false) // Should not catch other error types
//   }

//   // Test Value variant - direct to_string on ThrowError
//   throwable(fn() { throw_(@core.any(42)) }) catch {
//     err => {
//       // Test ThrowError's to_string() implementation
//       let msg = err.to_string()
//       assert_eq(msg, "42")
//     }
//   }
// }

// ///| call_self_throwable tests

// ///|
// test "call_self_throwable success" {
//   let parse_int = @global.global_this()._get("parseInt")
//   let result = throwable(fn() { parse_int._invoke([@core.any("42")]) })
//   let num : Int = @core.identity(result)
//   assert_eq(num, 42)
// }

// ///|
// test "call_self_throwable with error" {
//   // Create a function that throws
//   let throw_fn = @global.global_this()._call("eval", [
//     @core.any("(function() { throw new Error('test'); })"),
//   ])
//   let result = try? throwable(fn() { throw_fn._invoke([]) })
//   assert_true(result is Err(_))
// }

// ///| SuppressedError tests

// ///|
// test "SuppressedError instanceof check" {
//   let suppressed_error_cls = @global.global_this()._get("SuppressedError")
//   let err1 = JsError::new("Error 1")
//   let err2 = JsError::new("Error 2")
//   let suppressed_err = @core.new(suppressed_error_cls, [
//     err1 |> @core.any,
//     err2 |> @core.any,
//     @core.any("Suppressed error message"),
//   ])
//   // Check instanceof
//   assert_true(@core.instanceof_(suppressed_err, suppressed_error_cls))
//   // Check ThrowError::from
//   let throw_err = ThrowError::from(suppressed_err)
//   inspect(throw_err, content="Suppressed error message")
// }

// ///|
// test "from_entries and to_string" {
//   let obj : @core.Any = @core.from_entries([
//     ("name", @core.any("Alice")),
//     ("age", @core.any(30)),
//   ]).cast()
//   inspect(
//     JSON::stringify(obj),
//     content=(
//       #|{
//       #|  "name": "Alice",
//       #|  "age": 30
//       #|}
//     ),
//   )
// }
