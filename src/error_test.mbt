///|
test "JsError::isError" {
  let e = JsError::new("myerr")
  assert_eq(e.message(), "myerr")
  assert_true(JsError::isError(e))
}

///|
test "invoke_throwable" {
  let v = try? globalThis().invoke_throwable("nonexistentMethod", [])
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
