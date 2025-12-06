///| Test error handling

///|
test "try_sync: successful operation" {
  let result = try_sync(() => @core.any(42))
  let value : Int = @core.identity(result)
  inspect(value, content="42")
}

///|
test "try_sync: operation that throws" {
  let result = try? try_sync(() => {
    throw_error("test error")
    @core.any(0)
  })
  inspect(result is Err(_), content="true")
}

///|
test "export_sync: operation that raises error" {
  // export_sync catches raised errors and calls throw_error
  // which itself throws, making the undefined() call unreachable
  fn failing_op() -> @core.Any raise Failure {
    fail("This should be caught")
  }

  let result = try? @core.try_sync(() => export_sync(failing_op))
  inspect(result is Err(_), content="true")
}

///|
test "assert_throws: catches thrown exceptions" {
  let msg = assert_throws(() => {
    throw_error("test exception")
    @core.any(0)
  }) catch { JsError(m) => m }

  inspect(msg.contains("test exception"), content="true")
}

///|
test "assert_throws_with: validates error message" {
  assert_throws_with(
    () => {
      throw_error("specific error message")
      @core.any(0)
    },
    "specific error",
  )
}
