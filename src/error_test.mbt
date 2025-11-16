///|
test "JsError::isError" {
  let e = new_error("myerr")
  assert_eq(e.message(), "myerr")
  assert_true(JsError::isError(e))
}

///|
test "invoke_throwable" {
  let v = try? globalThis().invoke_throwable("nonexistentMethod", [])
  guard v is Err(JsThrowError::Error(e))
  assert_true(JsError::isError(e))
}
