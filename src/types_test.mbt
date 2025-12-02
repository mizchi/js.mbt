///|
test "ThrowError Show trait" {
  let result = try? throwable(fn() {
    @core.global_this()._call("nonexistentMethod", [])
  })
  match result {
    Err(throw_err) => {
      let str = throw_err.to_string()
      assert_true(str.length() > 0)
    }
    Ok(_) => fail("Expected error")
  }
}

///| Symbol tests

///| JsString tests

///|
test "JsString::fromCharCode" {
  let str = JsString::fromCharCode([72, 101, 108, 108, 111]) // "Hello"
  assert_eq(str, "Hello")
  let str2 = JsString::fromCharCode([65, 66, 67]) // "ABC"
  assert_eq(str2, "ABC")
}

///|
test "JsString::fromCodePoint" {
  let str = JsString::fromCodePoint([72, 101, 108, 108, 111]) // "Hello"
  assert_eq(str, "Hello")

  // Unicode emoji (beyond Basic Multilingual Plane)
  let emoji = JsString::fromCodePoint([128512]) // 😀
  assert_eq(emoji, "😀")
}

///|
test "Js Show trait for different types" {
  // Numbers
  let num = @core.any(123)
  assert_eq(num.to_string(), "123")

  // Strings
  let str = @core.any("test")
  assert_eq(str.to_string(), "test")

  // Booleans
  let bool_val = @core.any(true)
  assert_eq(bool_val.to_string(), "true")

  // Arrays
  let arr = @core.any([1, 2])
  let arr_str = JSON::stringify(arr)
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Objects
  let obj = @core.Object::new()
  obj._set("key", "value" |> @core.any)
  let obj_str = JSON::stringify(obj)
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}

///| Object::to_string tests

///|
test "Object::to_string" {
  let obj = @core.Object::new()
  obj._set("name", "Alice" |> @core.any)
  obj._set("age", 30 |> @core.any)
  let obj_typed = @core.identity(obj)
  let str = obj_typed |> JSON::stringify
  assert_true(str.contains("name"))
  assert_true(str.contains("Alice"))
  assert_true(str.contains("age"))
  assert_true(str.contains("30"))
}

///| AbortController tests

///|
test "AbortController::signal and abort" {
  let controller = AbortController::new()
  let _signal = controller.signal()
  // let aborted_before : Bool = @core.identity(signal._get("aborted"))
  // assert_false(aborted_before)
  controller.abort() |> ignore
  // let aborted_after : Bool = @core.identity(signal._get("aborted"))
  // assert_true(aborted_after)
}
