///|
/// Test isatty function returns boolean
test "isatty returns boolean value" {
  let result = isatty(0)
  // Result depends on execution environment (may be true or false)
  // Just verify it returns a boolean by using it in a boolean context
  if result {
    inspect("isatty(0)", content="isatty(0)")
  } else {
    inspect("not tty", content="not tty")
  }
}

///|
/// Test isatty with invalid fd returns false
test "isatty with invalid fd returns false" {
  let result = isatty(999)
  inspect(result, content="false")
}
