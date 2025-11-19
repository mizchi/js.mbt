///|
test "JsError::isError" {
  let e = JsError::new("myerr")
  assert_eq(e.message(), "myerr")
  assert_true(JsError::isError(e))
}

///|
test "call_throwable" {
  let v = try? globalThis().call_throwable("nonexistentMethod", [])
  guard v is Err(JsThrowError::Error(e))
  assert_true(JsError::isError(e))
}

///|
test "new_error" {
  let error = JsError::new("Test error")
  let error_val : Js = unsafe_cast(error)
  assert_true(@js.is_object(error_val))
  assert_eq(unsafe_cast(error_val.get("message")), "Test error")

  // Error with cause
  let cause_error = JsError::new("Cause error")
  let error_with_cause = JsError::new("Main error", cause=cause_error)
  let error_with_cause_val : Js = unsafe_cast(error_with_cause)
  assert_eq(unsafe_cast(error_with_cause_val.get("message")), "Main error")
}

///|
test "JsThrowError Show trait with Error variant" {
  // Test that JsThrowError.to_string() doesn't cause infinite recursion
  // We create a JsThrowError by calling a method that doesn't exist
  let result = try? globalThis().call_throwable("nonexistentMethod", [])
  match result {
    Err(throw_err) => {
      // This should not cause infinite recursion
      let str = throw_err.to_string()
      assert_true(str.length() > 0)
    }
    Ok(_) => fail("Expected error")
  }
}

///|
test "JsError Show trait" {
  let err = JsError::new("error message")
  // JsError has Show trait implementation
  inspect(err, content="error message")
}

///|
test "JsError message method" {
  let err = JsError::new("error message")
  let str = err.message()
  assert_eq(str, "error message")
}
