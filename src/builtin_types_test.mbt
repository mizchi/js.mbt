// Tests for frequently used JavaScript builtin types
// Organized in the same order as builtins_types.mbt

///| Object tests

///|
test "Object creation and basic operations" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_true(obj.hasOwnProperty("name"))
  assert_false(obj.hasOwnProperty("nonexistent"))
}

///|
test "Object::create" {
  let obj = Object::create(@js.Object::new().to_js())
  assert_true(@js.is_object(obj))
}

///|
test "Object::keys, values, entries" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  obj.set("city", "Tokyo")

  // Test keys
  let keys = Object::keys(obj.to_js())
  assert_eq(keys.length(), 3)
  assert_true(keys.contains("name"))
  assert_true(keys.contains("age"))
  assert_true(keys.contains("city"))

  // Test values
  let obj2 = @js.Object::new()
  obj2.set("a", 1)
  obj2.set("b", 2)
  obj2.set("c", 3)
  let values = Object::values(obj2)
  assert_eq(values.length(), 3)
  let sum : Int = unsafe_cast(values[0]) +
    unsafe_cast(values[1]) +
    unsafe_cast(values[2])
  assert_eq(sum, 6)

  // Test entries
  let entries = Object::entries(obj)
  assert_eq(entries.length(), 3)
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
  assert_eq(unsafe_cast(result.get("a")), 1)
  assert_eq(unsafe_cast(result.get("b")), 3)
  assert_eq(unsafe_cast(result.get("c")), 4)
}

///|
test "Object::is_ comparison" {
  let obj1 = @js.Object::new()
  let obj2 = @js.Object::new()
  assert_true(Object::is_(obj1, obj1))
  assert_false(Object::is_(obj1, obj2))

  // Primitive values
  assert_true(Object::is_(42, 42))
  assert_false(Object::is_(42, 43))
  assert_true(Object::is_("hello", "hello"))
  assert_false(Object::is_("hello", "world"))
}

///|
test "Object freeze, seal, preventExtensions" {
  // Test freeze
  let frozen = @js.Object::new()
  frozen.set("a", 1)
  assert_false(Object::isFrozen(frozen))
  Object::freeze(frozen) |> ignore
  assert_true(Object::isFrozen(frozen))
  assert_false(Object::isExtensible_static(frozen))
  assert_eq(unsafe_cast(frozen.get("a")), 1)

  // Test seal
  let sealed_obj = @js.Object::new()
  sealed_obj.set("b", 2)
  assert_false(Object::isSealed(sealed_obj))
  Object::seal(sealed_obj) |> ignore
  assert_true(Object::isSealed(sealed_obj))
  assert_false(Object::isExtensible_static(sealed_obj))
  assert_eq(unsafe_cast(sealed_obj.get("b")), 2)

  // Test preventExtensions
  let non_ext = @js.Object::new()
  non_ext.set("c", 3)
  assert_true(Object::isExtensible_static(non_ext))
  Object::preventExtensions(non_ext) |> ignore
  assert_false(Object::isExtensible_static(non_ext))
  assert_eq(unsafe_cast(non_ext.get("c")), 3)

  // Compare all three
  assert_true(Object::isFrozen(frozen))
  assert_true(Object::isSealed(frozen))
  assert_false(Object::isFrozen(sealed_obj))
  assert_true(Object::isSealed(sealed_obj))
  assert_false(Object::isFrozen(non_ext))
  assert_false(Object::isSealed(non_ext))
}

///|
test "Object::propertyIsEnumerable" {
  let obj = @js.Object::new()
  obj.set("enumerable", "value")
  assert_true(obj.propertyIsEnumerable("enumerable"))
  assert_false(obj.propertyIsEnumerable("nonexistent"))
}

///|
test "Object::isPrototypeOf" {
  let parent = @js.Object::new()
  let child = Object::create(parent.to_js())
  assert_true(parent.isPrototypeOf(child.to_js()))
  let child_obj : Object = unsafe_cast(child)
  assert_false(child_obj.isPrototypeOf(parent.to_js()))
}

///|
test "Object::isExtensible instance method" {
  let obj = @js.Object::new()
  obj.set("prop", "value")
  assert_true(obj.isExtensible())
  Object::preventExtensions(obj) |> ignore
  assert_false(obj.isExtensible())
}

///|
test "Object with empty strings" {
  let obj = @js.Object::new()
  obj.set("empty", "")
  assert_eq(unsafe_cast(obj.get("empty")), "")
  assert_true(obj.hasOwnProperty("empty"))
}

///| Array tests

///|
test "JsArray creation and type checking" {
  let arr = JsArray::new()
  assert_true(@js.is_array(arr))
  assert_true(@js.is_object(arr))

  // Native array is also js array
  assert_true(@js.is_array([1] |> @js.from_array))
}

///| Function tests

///|
test "Function::to_string" {
  let parse_int = @js.globalThis().get("parseInt")
  let func : Function = unsafe_cast(parse_int)
  let func_str = func.to_string()
  assert_true(func_str.length() > 0)
}

///|
test "Function::name" {
  let parse_int = @js.globalThis().get("parseInt")
  let func : Function = unsafe_cast(parse_int)
  let name = func.name()
  assert_eq(name, "parseInt")
}

///| Error tests

///|
test "JsError creation and properties" {
  let error = JsError::new("Test error")
  assert_eq(error.message, "Test error")
  assert_true(JsError::isError(error))
  let error_val : Js = unsafe_cast(error)
  assert_true(@js.is_object(error_val))
  assert_eq(unsafe_cast(error_val.get("message")), "Test error")
}

///|
test "JsError with cause" {
  let cause_error = JsError::new("Cause error")
  let error_with_cause = JsError::new("Main error", cause=cause_error)
  let error_with_cause_val : Js = unsafe_cast(error_with_cause)
  assert_eq(unsafe_cast(error_with_cause_val.get("message")), "Main error")
}

///|
test "JsError Show trait" {
  let err = JsError::new("error message")
  inspect(err, content="error message")
  let str = err.message
  assert_eq(str, "error message")
}

///|
test "ThrowError from call_throwable" {
  let v = try? globalThis().call_throwable("nonexistentMethod", [])
  guard v is Err(ThrowError::Error(e))
  assert_true(JsError::isError(e))
}

///|
test "ThrowError Show trait" {
  let result = try? globalThis().call_throwable("nonexistentMethod", [])
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
  assert_eq(@js.typeof_(js(sym)), "symbol")
  assert_eq(@js.typeof_(js(iter_sym)), "symbol")
  assert_eq(@js.typeof_(js(dispose_sym)), "symbol")
  assert_eq(@js.typeof_(js(async_dispose_sym)), "symbol")
}

///|
test "Symbol::for_ global registry" {
  let sym1 = Symbol::for_("mySymbol")
  let sym2 = Symbol::for_("mySymbol")
  assert_eq(@js.typeof_(sym1), "symbol")
  assert_eq(@js.typeof_(sym2), "symbol")
  let sym3 = Symbol::for_("differentSymbol")
  assert_eq(@js.typeof_(sym3), "symbol")
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

///| Type conversion and casting tests

///|
test "Primitive type casting" {
  let int_val = js(42)
  let int_result : Int = unsafe_cast(int_val)
  assert_eq(int_result, 42)
  let double_val = js(3.14)
  let double_result : Double = unsafe_cast(double_val)
  assert_eq(double_result, 3.14)
  let str_val = js("hello")
  let str_result : String = unsafe_cast(str_val)
  assert_eq(str_result, "hello")
  let bool_val = js(true)
  let bool_result : Bool = unsafe_cast(bool_val)
  assert_eq(bool_result, true)
}

///|
test "unsafe_cast_option" {
  // Some cases
  let some_str : String? = js("hello") |> @js.unsafe_cast_option()
  assert_eq(some_str, Some("hello"))
  let some_int : Int? = js(42) |> @js.unsafe_cast_option()
  assert_eq(some_int, Some(42))

  // None cases
  let none_str : String? = undefined() |> @js.unsafe_cast_option()
  assert_eq(none_str, None)
  let none_int : Int? = null_() |> @js.unsafe_cast_option()
  assert_eq(none_int, None)
}

///|
test "unsafe_cast_option with Show types" {
  let num_val = @js.js(42)
  let num_opt : Int? = @js.unsafe_cast_option(num_val)
  assert_eq(num_opt, Some(42))
  let str_val = @js.js("hello")
  let str_opt : String? = @js.unsafe_cast_option(str_val)
  assert_eq(str_opt, Some("hello"))

  // Test with null - should not cause infinite loop
  let null_val = @js.null_()
  let null_opt : String? = @js.unsafe_cast_option(null_val)
  assert_eq(null_opt, None)

  // Test with undefined - should not cause infinite loop
  let undef_val = @js.undefined()
  let undef_opt : String? = @js.unsafe_cast_option(undef_val)
  assert_eq(undef_opt, None)
}

///|
test "check_option for nullish detection" {
  let obj = @js.Object::new()
  let result = check_option(obj)
  assert_false(result is None)
  let null_obj : @js.Object = @js.unsafe_cast(@js.null_())
  let null_result = check_option(null_obj)
  assert_true(null_result is None)
  let undef_obj : @js.Object = @js.unsafe_cast(@js.undefined())
  let undef_result = check_option(undef_obj)
  assert_true(undef_result is None)
}

///|
test "Conditional property setting with Option" {
  let obj = @js.Object::new()

  // Set with Some value
  match Some("value1") {
    Some(v) => obj.set("key1", v)
    None => ()
  }
  assert_eq(unsafe_cast(obj.get("key1")), "value1")

  // Set with None should not add property
  let v : Int? = None
  match v {
    Some(val) => obj.set("key2", val)
    None => ()
  }
  assert_true(@js.is_undefined(obj.get("key2")))

  // Set with undefined value - check before setting
  match Some(undefined()) {
    Some(val) if not(@js.is_undefined(val)) => obj.set("key3", val)
    _ => ()
  }
  assert_true(@js.is_undefined(obj.get("key3")))
}

///|
test "Js Show trait for different types" {
  // Numbers
  let num = @js.js(123)
  assert_eq(num.to_string(), "123")

  // Strings
  let str = @js.js("test")
  assert_eq(str.to_string(), "test")

  // Booleans
  let bool_val = @js.js(true)
  assert_eq(bool_val.to_string(), "true")

  // Arrays
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  let arr_str = arr.to_js().to_string()
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Objects
  let obj = @js.Object::new()
  obj.set("key", "value")
  let obj_str = obj.to_js().to_string()
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}

///|
test "JsError Show implementation" {
  let err = JsError::new("Test error")
  let shown = err.to_string()
  assert_true(shown.contains("Test error"))
}
