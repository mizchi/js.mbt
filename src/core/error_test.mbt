///| Test error handling

///|
test "try_sync: successful operation" {
  let result = @core.try_sync(() => @core.any(42))
  let value : Int = @core.identity(result)
  inspect(value, content="42")
}

///|
test "try_sync: operation that throws" {
  let result = try? @core.try_sync(() => {
    @core.throw_error("test error")
    @core.any(0)
  })
  inspect(result is Err(_), content="true")
}

///|
test "@core.export_sync: operation that raises error" {
  // export_sync catches raised errors and calls throw_error
  // which itself throws, making the undefined() call unreachable
  fn failing_op() -> @core.Any raise Failure {
    fail("This should be caught")
  }

  let result = try? @core.try_sync(() => @core.export_sync(failing_op))
  inspect(result is Err(_), content="true")
}

///|
test "assert_throws: catches thrown exceptions" {
  let msg = @core.assert_throws(() => {
    @core.throw_error("test exception")
    @core.any(0)
  }) catch {
    JsError(m) => m
  }
  inspect(msg.contains("test exception"), content="true")
}

///|
test "assert_throws_with: validates error message" {
  @core.assert_throws_with(
    () => {
      @core.throw_error("specific error message")
      @core.any(0)
    },
    "specific error",
  )
}
