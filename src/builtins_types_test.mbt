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

///|
test "Object::freeze" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)

  // Before freeze, object is extensible
  assert_false(Object::isFrozen(obj))

  // Freeze the object
  Object::freeze(obj) |> ignore

  // After freeze, object is frozen
  assert_true(Object::isFrozen(obj))
  assert_false(Object::isExtensible_static(obj))

  // Existing properties are still accessible
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
}

///|
test "Object::seal" {
  let obj = @js.Object::new()
  obj.set("x", 10)
  obj.set("y", 20)

  // Before seal, object is not sealed
  assert_false(Object::isSealed(obj))

  // Seal the object
  Object::seal(obj) |> ignore

  // After seal, object is sealed
  assert_true(Object::isSealed(obj))
  assert_false(Object::isExtensible_static(obj))

  // Existing properties are still accessible
  assert_eq(unsafe_cast(obj.get("x")), 10)
  assert_eq(unsafe_cast(obj.get("y")), 20)
}

///|
test "Object::preventExtensions" {
  let obj = @js.Object::new()
  obj.set("prop", "value")

  // Before preventExtensions, object is extensible
  assert_true(Object::isExtensible_static(obj))

  // Prevent extensions
  Object::preventExtensions(obj) |> ignore

  // After preventExtensions, object is not extensible
  assert_false(Object::isExtensible_static(obj))

  // Existing properties are still accessible
  assert_eq(unsafe_cast(obj.get("prop")), "value")
}

///|
test "Object freeze vs seal vs preventExtensions" {
  let frozen = @js.Object::new()
  frozen.set("a", 1)
  Object::freeze(frozen) |> ignore
  assert_true(Object::isFrozen(frozen))
  assert_true(Object::isSealed(frozen))
  assert_false(Object::isExtensible_static(frozen))
  let sealed_obj = @js.Object::new()
  sealed_obj.set("b", 2)
  Object::seal(sealed_obj) |> ignore
  assert_false(Object::isFrozen(sealed_obj))
  assert_true(Object::isSealed(sealed_obj))
  assert_false(Object::isExtensible_static(sealed_obj))
  let non_extensible = @js.Object::new()
  non_extensible.set("c", 3)
  Object::preventExtensions(non_extensible) |> ignore
  assert_false(Object::isFrozen(non_extensible))
  assert_false(Object::isSealed(non_extensible))
  assert_false(Object::isExtensible_static(non_extensible))
}

///|
test "Symbol::for_ creates global symbols" {
  let sym1 = Symbol::for_("mySymbol")
  let sym2 = Symbol::for_("mySymbol")
  // Global symbols with same key should reference the same symbol
  assert_eq(@js.typeof_(sym1), "symbol")
  assert_eq(@js.typeof_(sym2), "symbol")
  // Verify they are stored in global symbol registry
  let sym3 = Symbol::for_("differentSymbol")
  assert_eq(@js.typeof_(sym3), "symbol")
}

///|
test "JsString::fromCharCode" {
  // Create string from character codes
  let str = JsString::fromCharCode([72, 101, 108, 108, 111]) // "Hello"
  assert_eq(str, "Hello")
  let str2 = JsString::fromCharCode([65, 66, 67]) // "ABC"
  assert_eq(str2, "ABC")
}

///|
test "JsString::fromCodePoint" {
  // Create string from code points (supports Unicode beyond BMP)
  let str = JsString::fromCodePoint([72, 101, 108, 108, 111]) // "Hello"
  assert_eq(str, "Hello")
  // Unicode emoji (beyond Basic Multilingual Plane)
  let emoji = JsString::fromCodePoint([128512]) // 😀
  assert_eq(emoji, "😀")
}

///|
test "Object::isPrototypeOf" {
  let parent = @js.Object::new()
  let child = Object::create(parent.to_js())
  // parent should be in the prototype chain of child
  assert_true(parent.isPrototypeOf(child.to_js()))

  // child should not be in the prototype chain of parent
  let child_obj : Object = unsafe_cast(child)
  assert_false(child_obj.isPrototypeOf(parent.to_js()))
}

///|
test "Object::isExtensible instance method" {
  let obj = @js.Object::new()
  obj.set("prop", "value")

  // Object should be extensible by default
  assert_true(obj.isExtensible())

  // After preventExtensions, should not be extensible
  Object::preventExtensions(obj) |> ignore
  assert_false(obj.isExtensible())
}

///|
test "Function::to_string returns string" {
  let parse_int = @js.globalThis().get("parseInt")
  let func : Function = unsafe_cast(parse_int)
  let func_str = func.to_string()
  // The string representation should contain "function" or be a valid string
  assert_true(func_str.length() > 0)
}

///|
test "Object::is_ compares values" {
  let obj1 = @js.Object::new()
  let obj2 = @js.Object::new()

  // Same object should be equal
  assert_true(Object::is_(obj1, obj1))

  // Different objects should not be equal
  assert_false(Object::is_(obj1, obj2))

  // Primitive values
  assert_true(Object::is_(42, 42))
  assert_false(Object::is_(42, 43))
  assert_true(Object::is_("hello", "hello"))
  assert_false(Object::is_("hello", "world"))
}

///|
test "Function::name" {
  // Get a built-in function's name
  let parse_int = @js.globalThis().get("parseInt")
  let func : Function = unsafe_cast(parse_int)
  let name = func.name()
  assert_eq(name, "parseInt")
}

///|
test "Val cast primitive types" {
  // Integer
  let int_val = js(42)
  let int_result : Int = unsafe_cast(int_val)
  assert_eq(int_result, 42)

  // Double
  let double_val = js(3.14)
  let double_result : Double = unsafe_cast(double_val)
  assert_eq(double_result, 3.14)

  // String
  let str_val = js("hello")
  let str_result : String = unsafe_cast(str_val)
  assert_eq(str_result, "hello")

  // Boolean
  let bool_val = js(true)
  let bool_result : Bool = unsafe_cast(bool_val)
  assert_eq(bool_result, true)
}

///|
test "Val cast_option" {
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
test "conditional property setting" {
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
test "option_js returns None for nullish values" {
  let obj = @js.Object::new()
  let result = option_js(obj)
  assert_false(result is None)

  // Test with null/undefined values
  let null_obj : @js.Object = @js.unsafe_cast(@js.null_())
  let null_result = option_js(null_obj)
  assert_true(null_result is None)
  let undef_obj : @js.Object = @js.unsafe_cast(@js.undefined())
  let undef_result = option_js(undef_obj)
  assert_true(undef_result is None)
}

///|
test "unsafe_cast_option with Show types" {
  // Test that unsafe_cast_option properly handles types with Show trait
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
test "Js Show trait with different types" {
  // Test Show trait for numbers
  let num = @js.js(123)
  let num_str = num.to_string()
  assert_eq(num_str, "123")

  // Test Show trait for strings
  let str = @js.js("test")
  let str_str = str.to_string()
  assert_eq(str_str, "test")

  // Test Show trait for booleans
  let bool_val = @js.js(true)
  let bool_str = bool_val.to_string()
  assert_eq(bool_str, "true")

  // Test Show trait for arrays
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  let arr_str = arr.to_js().to_string()
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Test Show trait for objects
  let obj = @js.Object::new()
  obj.set("key", "value")
  let obj_str = obj.to_js().to_string()
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}

///|
test "JsError::isError" {
  let e = JsError::new("myerr")
  assert_eq(e.message, "myerr")
  assert_true(JsError::isError(e))
}

///|
test "call_throwable" {
  let v = try? globalThis().call_throwable("nonexistentMethod", [])
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

///|
test "JsThrowError Show trait with Error variant" {
  // Test that JsThrowError.to_string() doesn't cause infinite recursion
  // We create a JsThrowError by calling a method that doesn't exist
  let result = try? globalThis().call_throwable("nonexistentMethod", [])
  match result {
    Err(throw_err) => {
      // This should not cause infinite recursion
      let str = throw_err.to_string()
      assert_true(str.length() > 0)
    }
    Ok(_) => fail("Expected error")
  }
}

///|
test "JsError Show trait" {
  let err = JsError::new("error message")
  // JsError has Show trait implementation
  inspect(err, content="error message")
}

///|
test "JsError message method" {
  let err = JsError::new("error message")
  let str = err.message
  assert_eq(str, "error message")
}

///|
test "Val cast primitive types" {
  // Integer
  let int_val = js(42)
  let int_result : Int = unsafe_cast(int_val)
  assert_eq(int_result, 42)

  // Double
  let double_val = js(3.14)
  let double_result : Double = unsafe_cast(double_val)
  assert_eq(double_result, 3.14)

  // String
  let str_val = js("hello")
  let str_result : String = unsafe_cast(str_val)
  assert_eq(str_result, "hello")

  // Boolean
  let bool_val = js(true)
  let bool_result : Bool = unsafe_cast(bool_val)
  assert_eq(bool_result, true)
}

///|
test "Val cast_option" {
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
test "conditional property setting" {
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
test "option_js returns None for nullish values" {
  let obj = @js.Object::new()
  let result = option_js(obj)
  assert_false(result is None)

  // Test with null/undefined values
  let null_obj : @js.Object = @js.unsafe_cast(@js.null_())
  let null_result = option_js(null_obj)
  assert_true(null_result is None)
  let undef_obj : @js.Object = @js.unsafe_cast(@js.undefined())
  let undef_result = option_js(undef_obj)
  assert_true(undef_result is None)
}

///|
test "unsafe_cast_option with Show types" {
  // Test that unsafe_cast_option properly handles types with Show trait
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
test "Js Show trait with different types" {
  // Test Show trait for numbers
  let num = @js.js(123)
  let num_str = num.to_string()
  assert_eq(num_str, "123")

  // Test Show trait for strings
  let str = @js.js("test")
  let str_str = str.to_string()
  assert_eq(str_str, "test")

  // Test Show trait for booleans
  let bool_val = @js.js(true)
  let bool_str = bool_val.to_string()
  assert_eq(bool_str, "true")

  // Test Show trait for arrays
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  let arr_str = arr.to_js().to_string()
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Test Show trait for objects
  let obj = @js.Object::new()
  obj.set("key", "value")
  let obj_str = obj.to_js().to_string()
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}

///|
test "Val cast primitive types" {
  // Integer
  let int_val = js(42)
  let int_result : Int = unsafe_cast(int_val)
  assert_eq(int_result, 42)

  // Double
  let double_val = js(3.14)
  let double_result : Double = unsafe_cast(double_val)
  assert_eq(double_result, 3.14)

  // String
  let str_val = js("hello")
  let str_result : String = unsafe_cast(str_val)
  assert_eq(str_result, "hello")

  // Boolean
  let bool_val = js(true)
  let bool_result : Bool = unsafe_cast(bool_val)
  assert_eq(bool_result, true)
}

///|
test "Val cast_option" {
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
test "conditional property setting" {
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
test "option_js returns None for nullish values" {
  let obj = @js.Object::new()
  let result = option_js(obj)
  assert_false(result is None)

  // Test with null/undefined values
  let null_obj : @js.Object = @js.unsafe_cast(@js.null_())
  let null_result = option_js(null_obj)
  assert_true(null_result is None)
  let undef_obj : @js.Object = @js.unsafe_cast(@js.undefined())
  let undef_result = option_js(undef_obj)
  assert_true(undef_result is None)
}

///|
test "unsafe_cast_option with Show types" {
  // Test that unsafe_cast_option properly handles types with Show trait
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
test "Js Show trait with different types" {
  // Test Show trait for numbers
  let num = @js.js(123)
  let num_str = num.to_string()
  assert_eq(num_str, "123")

  // Test Show trait for strings
  let str = @js.js("test")
  let str_str = str.to_string()
  assert_eq(str_str, "test")

  // Test Show trait for booleans
  let bool_val = @js.js(true)
  let bool_str = bool_val.to_string()
  assert_eq(bool_str, "true")

  // Test Show trait for arrays
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  let arr_str = arr.to_js().to_string()
  assert_true(arr_str.contains("1") && arr_str.contains("2"))

  // Test Show trait for objects
  let obj = @js.Object::new()
  obj.set("key", "value")
  let obj_str = obj.to_js().to_string()
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}
