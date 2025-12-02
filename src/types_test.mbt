///|
test "ThrowError Show trait" {
  let result = try? throwable(fn() {
    @nostd.global_this()._call("nonexistentMethod", [])
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

///|
test "Symbol creation and well-known symbols" {
  let sym = symbol("test")
  let iter_sym = Symbol::iterator()
  let dispose_sym = Symbol::dispose()
  let async_dispose_sym = Symbol::asyncDispose()
  assert_eq(@nostd.typeof_(any(sym)), "symbol")
  assert_eq(@nostd.typeof_(any(iter_sym)), "symbol")
  assert_eq(@nostd.typeof_(any(dispose_sym)), "symbol")
  assert_eq(@nostd.typeof_(any(async_dispose_sym)), "symbol")
}

///|
test "Symbol::for_ global registry" {
  let sym1 = Symbol::for_("mySymbol")
  let sym2 = Symbol::for_("mySymbol")
  assert_eq(@nostd.typeof_(sym1 |> @nostd.any), "symbol")
  assert_eq(@nostd.typeof_(sym2 |> @nostd.any), "symbol")
  let sym3 = Symbol::for_("differentSymbol")
  assert_eq(@nostd.typeof_(sym3 |> @nostd.any), "symbol")
}

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
  let num = @nostd.any(123)
  assert_eq(num.to_string(), "123")

  // Strings
  let str = @nostd.any("test")
  assert_eq(str.to_string(), "test")

  // Booleans
  let bool_val = @nostd.any(true)
  assert_eq(bool_val.to_string(), "true")

  // Arrays
  let arr = @js.from_array([1, 2])
  let arr_str = JSON::stringify(arr)
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Objects
  let obj = @nostd.Object::new()
  obj._set("key", "value" |> @nostd.any)
  let obj_str = JSON::stringify(obj)
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}

///| Object::to_string tests

///|
test "Object::to_string" {
  let obj = @nostd.Object::new()
  obj._set("name", "Alice" |> @nostd.any)
  obj._set("age", 30 |> @nostd.any)
  let obj_typed = @nostd.identity(obj)
  let str = obj_typed |> JSON::stringify
  assert_true(str.contains("name"))
  assert_true(str.contains("Alice"))
  assert_true(str.contains("age"))
  assert_true(str.contains("30"))
}

///|
test "Symbol::asyncIterator" {
  let async_iter_sym = Symbol::asyncIterator()
  assert_eq(@nostd.typeof_(async_iter_sym |> @nostd.any), "symbol")
}

///| AbortController tests

///|
test "AbortController::signal and abort" {
  let controller = AbortController::new()
  let _signal = controller.signal()
  // let aborted_before : Bool = @nostd.identity(signal._get("aborted"))
  // assert_false(aborted_before)
  controller.abort() |> ignore
  // let aborted_after : Bool = @nostd.identity(signal._get("aborted"))
  // assert_true(aborted_after)
}
