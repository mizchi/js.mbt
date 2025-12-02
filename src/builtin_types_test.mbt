// Tests for frequently used JavaScript builtin types
// Organized in the same order as builtins_types.mbt

///| Object tests

///|
test "Object creation and basic operations" {
  let obj = @nostd.Object::new()
  obj._set("name", "Alice" |> @nostd.any)
  obj._set("age", 30 |> @nostd.any)
  assert_eq(@js.identity(obj._get("name")), "Alice")
  assert_eq(@js.identity(obj._get("age")), 30)
  let obj_typed : Object = @js.identity(obj)
  assert_true(obj_typed.hasOwnProperty("name"))
  assert_false(obj_typed.hasOwnProperty("nonexistent"))
}

///|
test "Object::create" {
  let obj = Object::create(@nostd.Object::new())
  assert_true(@js.is_object(obj))
}

///|
test "Object::keys, values, entries" {
  let obj = @nostd.Object::new()
  obj._set("name", "Alice" |> @nostd.any)
  obj._set("age", 30 |> @nostd.any)
  obj._set("city", "Tokyo" |> @nostd.any)

  // Test keys
  let keys = Object::keys(obj)
  assert_eq(keys.length(), 3)
  assert_true(keys.contains("name"))
  assert_true(keys.contains("age"))
  assert_true(keys.contains("city"))

  // Test values
  let obj2 = @nostd.Object::new()
  obj2._set("a", 1 |> @nostd.any)
  obj2._set("b", 2 |> @nostd.any)
  obj2._set("c", 3 |> @nostd.any)
  let values = Object::values(obj2)
  assert_eq(values.length(), 3)
  let sum : Int = @js.identity(values[0]) +
    @js.identity(values[1]) +
    @js.identity(values[2])
  assert_eq(sum, 6)

  // Test entries
  let entries = Object::entries(obj)
  assert_eq(entries.length(), 3)
  let mut found_name = false
  let mut found_age = false
  for entry in entries {
    let (key, value) = entry
    if key == "name" {
      assert_eq(@js.identity(value), "Alice")
      found_name = true
    } else if key == "age" {
      assert_eq(@js.identity(value), 30)
      found_age = true
    }
  }
  assert_true(found_name)
  assert_true(found_age)
}

///|
test "Object::assign" {
  let target = @nostd.Object::new()
  target._set("a", 1 |> @nostd.any)
  target._set("b", 2 |> @nostd.any)
  let source = @nostd.Object::new()
  source._set("b", 3 |> @nostd.any)
  source._set("c", 4 |> @nostd.any)
  let result = Object::assign(target, source)
  assert_eq(@js.identity(result._get("a")), 1)
  assert_eq(@js.identity(result._get("b")), 3)
  assert_eq(@js.identity(result._get("c")), 4)
}

///|
test "Object::is_ comparison" {
  let obj1 = @nostd.Object::new()
  let obj2 = @nostd.Object::new()
  assert_true(Object::is_(obj1, obj1))
  assert_false(Object::is_(obj1, obj2))

  // Primitive values
  assert_true(Object::is_(42 |> @nostd.any, 42 |> @nostd.any))
  assert_false(Object::is_(42 |> @nostd.any, 43 |> @nostd.any))
  assert_true(Object::is_("hello" |> @nostd.any, "hello" |> @nostd.any))
  assert_false(Object::is_("hello" |> @nostd.any, "world" |> @nostd.any))
}

///|
test "Object freeze, seal, preventExtensions" {
  // Test freeze
  let frozen = @nostd.Object::new()
  frozen._set("a", 1 |> @nostd.any)
  assert_false(Object::isFrozen(frozen))
  Object::freeze(frozen) |> ignore
  assert_true(Object::isFrozen(frozen))
  assert_false(Object::isExtensible_static(frozen))
  assert_eq(@js.identity(frozen._get("a")), 1)

  // Test seal
  let sealed_obj = @nostd.Object::new()
  sealed_obj._set("b", 2 |> @nostd.any)
  assert_false(Object::isSealed(sealed_obj))
  Object::seal(sealed_obj) |> ignore
  assert_true(Object::isSealed(sealed_obj))
  assert_false(Object::isExtensible_static(sealed_obj))
  assert_eq(@js.identity(sealed_obj._get("b")), 2)

  // Test preventExtensions
  let non_ext = @nostd.Object::new()
  non_ext._set("c", 3 |> @nostd.any)
  assert_true(Object::isExtensible_static(non_ext))
  Object::preventExtensions(non_ext) |> ignore
  assert_false(Object::isExtensible_static(non_ext))
  assert_eq(@js.identity(non_ext._get("c")), 3)

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
  let obj = @nostd.Object::new()
  obj._set("enumerable", "value" |> @nostd.any)
  let obj_typed : Object = @js.identity(obj)
  assert_true(obj_typed.propertyIsEnumerable("enumerable"))
  assert_false(obj_typed.propertyIsEnumerable("nonexistent"))
}

///|
test "Object::isPrototypeOf" {
  let parent = @nostd.Object::new()
  let parent_typed : Object = @js.identity(parent)
  let child = Object::create(parent)
  assert_true(parent_typed.isPrototypeOf(child))
  let child_obj : Object = @js.identity(child)
  assert_false(child_obj.isPrototypeOf(parent))
}

///|
test "Object::isExtensible instance method" {
  let obj = @nostd.Object::new()
  obj._set("prop", "value" |> @nostd.any)
  let obj_typed : Object = @js.identity(obj)
  assert_true(obj_typed.isExtensible())
  Object::preventExtensions(obj) |> ignore
  assert_false(obj_typed.isExtensible())
}

///|
test "Object with empty strings" {
  let obj = @nostd.Object::new()
  obj._set("empty", "" |> @nostd.any)
  assert_eq(@js.identity(obj._get("empty")), "")
  let obj_typed : Object = @js.identity(obj)
  assert_true(obj_typed.hasOwnProperty("empty"))
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

///| Iterator tests

///|
test "JsIterator::from converts iterable to iterator" {
  // Create an array - arrays are iterable in JavaScript
  let arr = @js.from_array([1, 2, 3])

  // Use Iterator.from to convert iterable to iterator
  let js_iter : JsIterator[@nostd.Any] = JsIterator::from(arr)

  // Verify it's created (basic type check)
  assert_true(@js.is_object(js_iter.as_any()))
}

///| Function tests

///|
test "Function::to_string" {
  let parse_int = @global.global_this()._get("parseInt")
  let func : Function = @js.identity(parse_int)
  let func_str = func.to_string()
  assert_true(func_str.length() > 0)
}

///|
test "Function::name" {
  let parse_int = @global.global_this()._get("parseInt")
  let func : Function = @js.identity(parse_int)
  let name = func.name()
  assert_eq(name, "parseInt")
}

///| Error tests

///|
test "JsError creation and properties" {
  let error = JsError::new("Test error")
  assert_eq(error.message, "Test error")
  assert_true(JsError::isError(error.to_any()))
  let error_val : @nostd.Any = @js.identity(error)
  assert_true(@js.is_object(error_val))
  assert_eq(@js.identity(error_val._get("message")), "Test error")
}

///|
test "JsError with cause" {
  let cause_error = JsError::new("Cause error")
  let error_with_cause = JsError::new("Main error", cause=cause_error)
  let error_with_cause_val : @nostd.Any = @js.identity(error_with_cause)
  assert_eq(@js.identity(error_with_cause_val._get("message")), "Main error")
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
  let v = try? throwable(fn() {
    @nostd.global_this()._call("nonexistentMethod", [])
  })
  match v {
    Err(ThrowError::Error(e)) | Err(ThrowError::TypeError(e)) =>
      assert_true(JsError::isError(e.to_any()))
    Err(_) => fail("Expected Error or TypeError")
    Ok(_) => fail("Expected error to be thrown")
  }
}

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
  assert_eq(@js.typeof_(any(sym)), "symbol")
  assert_eq(@js.typeof_(any(iter_sym)), "symbol")
  assert_eq(@js.typeof_(any(dispose_sym)), "symbol")
  assert_eq(@js.typeof_(any(async_dispose_sym)), "symbol")
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
  let int_val = @nostd.any(42)
  let int_result : Int = @js.identity(int_val)
  assert_eq(int_result, 42)
  let double_val = @nostd.any(3.14)
  let double_result : Double = @js.identity(double_val)
  assert_eq(double_result, 3.14)
  let str_val = @nostd.any("hello")
  let str_result : String = @js.identity(str_val)
  assert_eq(str_result, "hello")
  let bool_val = @nostd.any(true)
  let bool_result : Bool = @js.identity(bool_val)
  assert_eq(bool_result, true)
}

///|
test "identity_option" {
  // Some cases
  let some_str : String? = @nostd.any("hello") |> @js.identity_option()
  assert_eq(some_str, Some("hello"))
  let some_int : Int? = @nostd.any(42) |> @js.identity_option()
  assert_eq(some_int, Some(42))

  // None cases
  let none_str : String? = @nostd.undefined() |> @js.identity_option()
  assert_eq(none_str, None)
  let none_int : Int? = @nostd.null() |> @js.identity_option()
  assert_eq(none_int, None)
}

///|
test "identity_option with Show types" {
  let num_val = @nostd.any(42)
  let num_opt : Int? = @js.identity_option(num_val)
  assert_eq(num_opt, Some(42))
  let str_val = @nostd.any("hello")
  let str_opt : String? = @js.identity_option(str_val)
  assert_eq(str_opt, Some("hello"))

  // Test with null - should not cause infinite loop
  let null_val = @nostd.null()
  let null_opt : String? = @js.identity_option(null_val)
  assert_eq(null_opt, None)

  // Test with undefined - should not cause infinite loop
  let undef_val = @global.undefined()
  let undef_opt : String? = @js.identity_option(undef_val)
  assert_eq(undef_opt, None)
}

///|
test "identity_option for nullish detection" {
  let obj = @nostd.Object::new()
  let result : @js.Object? = @js.identity_option(obj)
  assert_false(result is None)
  let null_result : @js.Object? = @js.identity_option(@nostd.null())
  assert_true(null_result is None)
  let undef_result : @js.Object? = @js.identity_option(@global.undefined())
  assert_true(undef_result is None)
}

///|
test "Conditional property setting with Option" {
  let obj = @nostd.Object::new()

  // Set with Some value
  match Some("value1") {
    Some(v) => obj.set("key1", v)
    None => ()
  }
  assert_eq(@js.identity(obj._get("key1")), "value1")

  // Set with None should not add property
  let v : Int? = None
  match v {
    Some(val) => obj.set("key2", val)
    None => ()
  }
  assert_true(@js.is_undefined(obj._get("key2")))

  // Set with undefined value - check before setting
  match Some(@nostd.undefined()) {
    Some(val) if not(@js.is_undefined(val)) => obj.set("key3", val)
    _ => ()
  }
  assert_true(@js.is_undefined(obj._get("key3")))
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
  obj.set("key", "value")
  let obj_str = JSON::stringify(obj)
  assert_true(obj_str.contains("key") && obj_str.contains("value"))
}

///|
test "JsError Show implementation" {
  let err = JsError::new("Test error")
  let shown = err.to_string()
  assert_true(shown.contains("Test error"))
}

///| Object::to_string tests

///|
test "Object::to_string" {
  let obj = @nostd.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  let obj_typed : Object = @js.identity(obj)
  let str = obj_typed.to_string()
  assert_true(str.contains("name"))
  assert_true(str.contains("Alice"))
  assert_true(str.contains("age"))
  assert_true(str.contains("30"))
}

///| JsArray::to_string tests

///|
test "JsArray::to_string" {
  let arr : JsArray = @js.identity(JsArray::new())
  arr.push(@nostd.any(1))
  arr.push(@nostd.any(2))
  arr.push(@nostd.any(3))
  let str = arr.to_string()
  assert_true(str.contains("1"))
  assert_true(str.contains("2"))
  assert_true(str.contains("3"))
}

///| Symbol::asyncIterator tests

///|
test "Symbol::asyncIterator" {
  let async_iter_sym = Symbol::asyncIterator()
  assert_eq(@js.typeof_(async_iter_sym), "symbol")
}

///| AbortController tests

///|
test "AbortController::signal and abort" {
  let controller = AbortController::new()
  let _signal = controller.signal()
  // let aborted_before : Bool = @js.identity(signal._get("aborted"))
  // assert_false(aborted_before)
  controller.abort() |> ignore
  // let aborted_after : Bool = @js.identity(signal._get("aborted"))
  // assert_true(aborted_after)
}

///| instanceof_ tests

///|
test "instanceof_" {
  let arr = @js.from_array([1, 2, 3])
  let array_class = @global.global_this()._get("Array")
  assert_true(@js.instanceof_(arr, array_class))
  let obj = @nostd.Object::new()
  let object_class = @global.global_this()._get("Object")
  assert_true(@js.instanceof_(obj, object_class))
}

///| Show trait tests

///|
test "JsError Show output" {
  let err = JsError::new("test message")
  // Using inspect triggers Show::output
  inspect(err, content="test message")
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

///| Object.defineProperty tests

///|
test "Object::defineProperty with value" {
  let obj = @nostd.Object::new()
  Object::defineProperty(obj, "name", value="Alice" |> @js.any, writable=true)
  |> ignore
  assert_eq(@js.identity(obj._get("name")), "Alice")
  // Should be writable
  obj.set("name", "Bob")
  assert_eq(@js.identity(obj._get("name")), "Bob")
}

///|
test "Object::defineProperty with non-writable" {
  let obj = @nostd.Object::new()
  Object::defineProperty(
    obj,
    "id",
    value=123 |> @js.any,
    writable=false,
    configurable=true,
  )
  |> ignore
  assert_eq(@js.identity(obj._get("id")), 123)
  // Attempting to write won't work in strict mode, but in non-strict mode it's silently ignored
  obj.set("id", 456)
  // Value should still be 123 (write ignored)
  assert_eq(@js.identity(obj._get("id")), 123)
}

///|
test "Object::defineProperty with getter/setter" {
  let obj = @nostd.Object::new()
  let storage : Ref[Int] = { val: 0 }
  Object::defineProperty(
    obj,
    "value",
    get=fn() { storage.val |> @js.any },
    set=fn(v) { storage.val = @js.identity(v) },
    enumerable=true,
    configurable=true,
  )
  |> ignore
  // Test getter
  assert_eq(@js.identity(obj._get("value")), 0)
  // Test setter
  obj.set("value", 42)
  assert_eq(@js.identity(obj._get("value")), 42)
  assert_eq(storage.val, 42)
}

///|
test "Object::getOwnPropertyDescriptor" {
  let obj = @nostd.Object::new()
  obj.set("name", "Alice")
  let desc = Object::getOwnPropertyDescriptor(obj, "name")
  assert_true(desc is Some(_))
  guard desc is Some(d)
  assert_eq(@js.identity(d.value.unwrap()), "Alice")
  assert_eq(d.writable, Some(true))
  assert_eq(d.enumerable, Some(true))
  assert_eq(d.configurable, Some(true))
}

///|
test "Object::getOwnPropertyDescriptor returns None for non-existent" {
  let obj = @nostd.Object::new()
  let desc = Object::getOwnPropertyDescriptor(obj, "nonexistent")
  assert_true(desc is None)
}

///|
test "Object::getOwnPropertyNames" {
  let obj = @nostd.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  Object::defineProperty(obj, "c", value=3 |> @js.any, enumerable=false)
  |> ignore
  let names = Object::getOwnPropertyNames(obj)
  // Should include non-enumerable property "c"
  assert_true(names.contains("a"))
  assert_true(names.contains("b"))
  assert_true(names.contains("c"))
}

///|
test "Object::getOwnPropertySymbols" {
  let obj = @nostd.Object::new()
  let sym = @js.symbol("mySymbol")
  obj.set(sym, "symbol value")
  let symbols = Object::getOwnPropertySymbols(obj)
  assert_eq(symbols.length(), 1)
}

///|
test "Object::defineProperties" {
  let obj = @nostd.Object::new()
  let props = @nostd.Object::new()
  let x_desc = @nostd.Object::new()
  x_desc.set("value", 10)
  x_desc.set("writable", true)
  props.set("x", x_desc)
  let y_desc = @nostd.Object::new()
  y_desc.set("value", 20)
  y_desc.set("writable", true)
  props.set("y", y_desc)
  Object::defineProperties(obj, props) |> ignore
  assert_eq(@js.identity(obj._get("x")), 10)
  assert_eq(@js.identity(obj._get("y")), 20)
}

///| Object.groupBy tests

///|
test "Object::groupBy basic" {
  let items : Array[@nostd.Any] = [1, 2, 3, 4, 5].map(fn(x) { x |> @js.any })
  let result = Object::groupBy(items, fn(item, _index) {
    let n : Int = item |> @js.identity
    if n % 2 == 0 {
      "even"
    } else {
      "odd"
    }
  })
  let odd : Array[Int] = result._get("odd") |> @js.identity
  let even : Array[Int] = result._get("even") |> @js.identity
  assert_eq(odd, [1, 3, 5])
  assert_eq(even, [2, 4])
}

///|
test "Object::groupBy with objects" {
  let inventory = @nostd.Object::new()
  inventory.set("name", "apple")
  inventory.set("type", "fruit")
  let inventory2 = @nostd.Object::new()
  inventory2.set("name", "beef")
  inventory2.set("type", "meat")
  let inventory3 = @nostd.Object::new()
  inventory3.set("name", "banana")
  inventory3.set("type", "fruit")
  let items = [inventory, inventory2, inventory3]
  let result = Object::groupBy(items, fn(item, _index) {
    item._get("type") |> @js.identity
  })
  let fruits : Array[@nostd.Any] = result._get("fruit") |> @js.identity
  let meats : Array[@nostd.Any] = result._get("meat") |> @js.identity
  assert_eq(fruits.length(), 2)
  assert_eq(meats.length(), 1)
}
