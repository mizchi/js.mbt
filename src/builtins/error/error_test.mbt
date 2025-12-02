// ///|
// test "JsError Show implementation" {
//   let err = JsError::new("Test error")
//   let shown = err.to_string()
//   assert_true(shown.contains("Test error"))
// }

// ///|
// test "JsError creation and properties" {
//   let error = JsError::new("Test error")
//   assert_eq(error.message, "Test error")
//   assert_true(JsError::isError(error.to_any()))
//   let error_val : @core.Any = @core.identity(error)
//   assert_true(@core.is_object(error_val))
//   assert_eq(@core.identity(error_val._get("message")), "Test error")
// }

// ///|
// test "JsError with cause" {
//   let cause_error = JsError::new("Cause error")
//   let error_with_cause = JsError::new("Main error", cause=cause_error)
//   let error_with_cause_val : @core.Any = @core.identity(error_with_cause)
//   assert_eq(@core.identity(error_with_cause_val._get("message")), "Main error")
// }

// ///|
// test "JsError Show trait" {
//   let err = JsError::new("error message")
//   inspect(err, content="error message")
//   let str = err.message
//   assert_eq(str, "error message")
// }

// ///|
// test "ThrowError from call_throwable" {
//   let v = try? @js.throwable(fn() {
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

// ///|
// test "ThrowError::from with TypeError" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testTypeError = new TypeError('Type error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testTypeError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::TypeError(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with RangeError" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testRangeError = new RangeError('Range error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testRangeError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::RangeError(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with ReferenceError" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testRefError = new ReferenceError('Ref error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testRefError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::ReferenceError(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with SyntaxError" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testSyntaxError = new SyntaxError('Syntax error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testSyntaxError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::SyntaxError(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with URIError" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testURIError = new URIError('URI error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testURIError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::URIError(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with EvalError" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testEvalError = new EvalError('Eval error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testEvalError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::EvalError(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with AggregateError" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testAggError = new AggregateError([], 'Agg error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testAggError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::AggregateError(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with generic Error" {
//   let global = @global.global_this()
//   global._call("eval", [
//     @core.any("globalThis.testGenericError = new Error('Generic error')"),
//   ])
//   |> ignore
//   let js_error = global._get("testGenericError")
//   let throw_error = ThrowError::from(js_error)
//   match throw_error {
//     ThrowError::Error(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }

// ///|
// test "ThrowError::from with non-error value" {
//   let value = @core.any("plain string value")
//   let throw_error = ThrowError::from(value)
//   match throw_error {
//     ThrowError::Value(_) => inspect(true, content="true")
//     _ => inspect(false, content="true")
//   }
// }
