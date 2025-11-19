///|
test "Object::create" {
  let obj = Object::create(@js.Object::new().to_js())
  assert_true(@js.is_object(obj))
}


///|
test "Object::propertyIsEnumerable" {
  let obj = @js.Object::new()
  obj.set("enumerable", "value")
  assert_true(obj.propertyIsEnumerable("enumerable"))
  assert_false(obj.propertyIsEnumerable("nonexistent"))
}

///|
test "Object::keys" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  obj.set("city", "Tokyo")
  let keys = Object::keys(obj.to_js())
  assert_eq(keys.length(), 3)
  assert_true(keys.contains("name"))
  assert_true(keys.contains("age"))
  assert_true(keys.contains("city"))
}

///|
test "Object::values" {
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  let values = Object::values(obj)
  assert_eq(values.length(), 3)
  // Values should be present (order not guaranteed)
  let sum : Int = unsafe_cast(values[0]) +
    unsafe_cast(values[1]) +
    unsafe_cast(values[2])
  assert_eq(sum, 6)
}

///|
test "Object::entries" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  let entries = Object::entries(obj)
  assert_eq(entries.length(), 2)
  let mut found_name = false
  let mut found_age = false
  for entry in entries {
    let (key, value) = entry
    if key == "name" {
      assert_eq(unsafe_cast(value), "Alice")
      found_name = true
    } else if key == "age" {
      assert_eq(unsafe_cast(value), 30)
      found_age = true
    }
  }
  assert_true(found_name)
  assert_true(found_age)
}

///|
test "Object::assign" {
  let target = @js.Object::new()
  target.set("a", 1)
  target.set("b", 2)
  let source = @js.Object::new()
  source.set("b", 3)
  source.set("c", 4)
  let result = Object::assign(target, source)

  // b should be overwritten, c should be added
  assert_eq(unsafe_cast(result.get("a")), 1)
  assert_eq(unsafe_cast(result.get("b")), 3)
  assert_eq(unsafe_cast(result.get("c")), 4)
}

///|
test "JsArray::new" {
  let arr = JsArray::new()
  assert_true(@js.is_array(arr))
  assert_true(@js.is_object(arr))
  // native array is also js array
  assert_true(@js.is_array([1] |> @js.from_array))
}

///|
test "symbols" {
  let sym = symbol("test")
  let iter_sym = Symbol::iterator()
  let dispose_sym = Symbol::dispose()
  let async_dispose_sym = Symbol::asyncDispose()

  // Symbols should have symbol type
  let sym_val : Js = js(sym)
  let iter_val : Js = js(iter_sym)
  let dispose_val : Js = js(dispose_sym)
  let async_dispose_val : Js = js(async_dispose_sym)
  assert_eq(@js.typeof_(sym_val), "symbol")
  assert_eq(@js.typeof_(iter_val), "symbol")
  assert_eq(@js.typeof_(dispose_val), "symbol")
  assert_eq(@js.typeof_(async_dispose_val), "symbol")
}

///|
test "Js with empty strings" {
  let obj = @js.Object::new()
  obj.set("empty", "")
  assert_eq(unsafe_cast(obj.get("empty")), "")
  assert_true(obj.hasOwnProperty("empty"))
}
