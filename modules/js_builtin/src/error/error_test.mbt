///|
test "JsError creation and properties" {
  let error = JsError::new("Test error")
  assert_eq(error.message, "Test error")
  assert_true(JsError::isError(error.as_any()))
  let error_val : @core.Any = @core.identity(error)
  assert_true(@core.is_object(error_val))
  assert_eq(@core.identity(error_val._get("message")), "Test error")
}

///|
test "JsError with cause" {
  let cause_error = JsError::new("Cause error")
  let error_with_cause = JsError::new("Main error", cause=cause_error)
  let error_with_cause_val : @core.Any = @core.identity(error_with_cause)
  assert_eq(@core.identity(error_with_cause_val._get("message")), "Main error")
}

// ///|
// test "JsError Show trait" {
//   let err = JsError::new("error message")
//   inspect(err, content="error message")
//   let str = err.message
//   assert_eq(str, "error message")
// }

// ///|
// test "ThrowError from call_throwable" {
//   let v = try? @core.throwable(fn() {
//     @core.global_this()._call("nonexistentMethod", [])
//   })
//   match v {
//     Err(ThrowError::Error(e)) | Err(ThrowError::TypeError(e)) =>
//       assert_true(JsError::isError(e.to_any()))
//     Err(_) => fail("Expected Error or TypeError")
//     Ok(_) => fail("Expected error to be thrown")
//   }
// }

// ///|
// test "JsError Show implementation" {
//   let error = JsError::new("Test error message")
//   let str = error.to_string()
//   inspect(str, content="Test error message")
//   // Test that output() uses to_string()
//   inspect(error, content="Test error message")
// }

// ///|
// test "JsError with cause" {
//   let cause = JsError::new("Root cause")
//   let error = JsError::new("Main error", cause~)
//   let str = error.to_string()
//   inspect(str, content="Main error")
// }

// ///|
// test "ThrowError Show through throwable" {
//   // Test Error variant
//   let mut error_str = ""
//   throwable(fn() {
//     let err = JsError::new("Show test error")
//     throw_(err.to_any())
//   }) catch {
//     e => error_str = e.to_string()
//   }
//   inspect(error_str, content="Show test error")
// }

///|
test "TypeError instanceof check" {
  let type_error = TypeError::new("Type error")
  assert_true(TypeError::instanceof(type_error.as_any()))
  assert_eq(type_error.message, "Type error")
}

///|
test "RangeError instanceof check" {
  let range_error = RangeError::new("Range error")
  assert_true(RangeError::instanceof(range_error.as_any()))
  assert_eq(range_error.message, "Range error")
}

///|
test "ReferenceError instanceof check" {
  let ref_error = ReferenceError::new("Reference error")
  assert_true(ReferenceError::instanceof(ref_error.as_any()))
  assert_eq(ref_error.message, "Reference error")
}

///|
test "SyntaxError instanceof check" {
  let syntax_error = SyntaxError::new("Syntax error")
  assert_true(SyntaxError::instanceof(syntax_error.as_any()))
  assert_eq(syntax_error.message, "Syntax error")
}

///|
test "URIError instanceof check" {
  let uri_error = URIError::new("URI error")
  assert_true(URIError::instanceof(uri_error.as_any()))
  assert_eq(uri_error.message, "URI error")
}

///|
test "EvalError instanceof check" {
  let eval_error = EvalError::new("Eval error")
  assert_true(EvalError::instanceof(eval_error.as_any()))
  assert_eq(eval_error.message, "Eval error")
}

///|
test "AggregateError instanceof check" {
  let errors = @core.new_array()
  let agg_error = AggregateError::new(errors, "Aggregate error")
  assert_true(AggregateError::instanceof(agg_error.as_any()))
  assert_eq(agg_error.message, "Aggregate error")
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
