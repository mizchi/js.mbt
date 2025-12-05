///| AbortController tests

///|
test "AbortController::signal and abort" {
  let controller = AbortController::new()
  let _signal = controller.signal()
  controller.abort() |> ignore
}

///| Show trait tests

///|
test "JsError Show output" {
  let err = JsError::new("test message")
  // Using inspect triggers Show::output
  inspect(err |> @core.any, content="Error: test message")
  assert_eq(err.message, "test message")
}

///|
test "ThrowError Show output" {
  let result = try? throwable(fn() {
    @global.global_this()._call("nonexistentMethod", [])
  })
  match result {
    Err(throw_err) => {
      // Using inspect triggers Show::output
      let str = throw_err.to_string()
      assert_true(str.length() > 0)
    }
    Ok(_) => fail("Expected error")
  }
}
