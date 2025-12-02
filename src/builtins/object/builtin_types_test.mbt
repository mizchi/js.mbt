// Tests for frequently used JavaScript builtin types
// Organized in the same order as builtins_types.mbt

///| Object tests

///|
test "Object creation and basic operations" {
  let obj = @nostd.Object::new()
  obj._set("name", "Alice" |> @nostd.any)
  obj._set("age", 30 |> @nostd.any)
  assert_eq(@nostd.identity(obj._get("name")), "Alice")
  assert_eq(@nostd.identity(obj._get("age")), 30)
  let obj_typed : @object.Object = @nostd.identity(obj)
  assert_true(obj_typed.hasOwnProperty("name"))
  assert_false(obj_typed.hasOwnProperty("nonexistent"))
}

///|
test "Object::create" {
  let obj = @object.Object::create(@nostd.Object::new())
  assert_true(@nostd.is_object(obj))
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
  let values = @object.Object::values(obj2)
  assert_eq(values.length(), 3)
  let sum : Int = @nostd.identity(values[0]) +
    @nostd.identity(values[1]) +
    @nostd.identity(values[2])
  assert_eq(sum, 6)

  // Test entries
  let entries = Object::entries(obj)
  assert_eq(entries.length(), 3)
  let mut found_name = false
  let mut found_age = false
  for entry in entries {
    let (key, value) = entry
    if key == "name" {
      assert_eq(@nostd.identity(value), "Alice")
      found_name = true
    } else if key == "age" {
      assert_eq(@nostd.identity(value), 30)
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
  assert_eq(@nostd.identity(result._get("a")), 1)
  assert_eq(@nostd.identity(result._get("b")), 3)
  assert_eq(@nostd.identity(result._get("c")), 4)
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
  assert_eq(@nostd.identity(frozen._get("a")), 1)

  // Test seal
  let sealed_obj = @nostd.Object::new()
  sealed_obj._set("b", 2 |> @nostd.any)
  assert_false(Object::isSealed(sealed_obj))
  Object::seal(sealed_obj) |> ignore
  assert_true(Object::isSealed(sealed_obj))
  assert_false(Object::isExtensible_static(sealed_obj))
  assert_eq(@nostd.identity(sealed_obj._get("b")), 2)

  // Test preventExtensions
  let non_ext = @nostd.Object::new()
  non_ext._set("c", 3 |> @nostd.any)
  assert_true(Object::isExtensible_static(non_ext))
  Object::preventExtensions(non_ext) |> ignore
  assert_false(Object::isExtensible_static(non_ext))
  assert_eq(@nostd.identity(non_ext._get("c")), 3)

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
  let obj_typed : Object = @nostd.identity(obj)
  assert_true(obj_typed.propertyIsEnumerable("enumerable"))
  assert_false(obj_typed.propertyIsEnumerable("nonexistent"))
}

///|
test "Object::isPrototypeOf" {
  let parent = @nostd.Object::new()
  let parent_typed : Object = @nostd.identity(parent)
  let child = Object::create(parent)
  assert_true(parent_typed.isPrototypeOf(child))
  let child_obj : Object = @nostd.identity(child)
  assert_false(child_obj.isPrototypeOf(parent))
}

///|
test "Object::isExtensible instance method" {
  let obj = @nostd.Object::new()
  obj._set("prop", "value" |> @nostd.any)
  let obj_typed : Object = @nostd.identity(obj)
  assert_true(obj_typed.isExtensible())
  Object::preventExtensions(obj) |> ignore
  assert_false(obj_typed.isExtensible())
}

///|
test "Object with empty strings" {
  let obj = @nostd.Object::new()
  obj._set("empty", "" |> @nostd.any)
  assert_eq(@nostd.identity(obj._get("empty")), "")
  let obj_typed : Object = @nostd.identity(obj)
  assert_true(obj_typed.hasOwnProperty("empty"))
}

///| Array tests

///|
test "JsArray creation and type checking" {
  let arr = @nostd.JsArray::new()
  assert_true(@nostd.is_array(arr))
  assert_true(@nostd.is_object(arr))

  // Native array is also js array
  assert_true(@nostd.is_array([1] |> @nostd.any))
}

///| Iterator tests

///|
test "JsIterator::from converts iterable to iterator" {
  // Create an array - arrays are iterable in JavaScript
  let arr = @nostd.any([1, 2, 3])

  // Use Iterator.from to convert iterable to iterator
  let js_iter : @js.JsIterator[@nostd.Any] = @js.JsIterator::from(arr)

  // Verify it's created (basic type check)
  assert_true(@nostd.is_object(js_iter.as_any()))
}

///| Function tests

///| Error tests

///| Type conversion and casting tests

///|
test "Primitive type casting" {
  let int_val = @nostd.any(42)
  let int_result : Int = @nostd.identity(int_val)
  assert_eq(int_result, 42)
  let double_val = @nostd.any(3.14)
  let double_result : Double = @nostd.identity(double_val)
  assert_eq(double_result, 3.14)
  let str_val = @nostd.any("hello")
  let str_result : String = @nostd.identity(str_val)
  assert_eq(str_result, "hello")
  let bool_val = @nostd.any(true)
  let bool_result : Bool = @nostd.identity(bool_val)
  assert_eq(bool_result, true)
}

///|
test "identity_option" {
  // Some cases
  let some_str : String? = @nostd.any("hello") |> @nostd.identity_option()
  assert_eq(some_str, Some("hello"))
  let some_int : Int? = @nostd.any(42) |> @nostd.identity_option()
  assert_eq(some_int, Some(42))

  // None cases
  let none_str : String? = @nostd.undefined() |> @nostd.identity_option()
  assert_eq(none_str, None)
  let none_int : Int? = @nostd.null() |> @nostd.identity_option()
  assert_eq(none_int, None)
}

///|
test "identity_option with Show types" {
  let num_val = @nostd.any(42)
  let num_opt : Int? = @nostd.identity_option(num_val)
  assert_eq(num_opt, Some(42))
  let str_val = @nostd.any("hello")
  let str_opt : String? = @nostd.identity_option(str_val)
  assert_eq(str_opt, Some("hello"))

  // Test with null - should not cause infinite loop
  let null_val = @nostd.null()
  let null_opt : String? = @nostd.identity_option(null_val)
  assert_eq(null_opt, None)

  // Test with undefined - should not cause infinite loop
  let undef_val = @global.undefined()
  let undef_opt : String? = @nostd.identity_option(undef_val)
  assert_eq(undef_opt, None)
}

///|
test "identity_option for nullish detection" {
  let obj = @nostd.Object::new()
  let result : @js.Object? = @nostd.identity_option(obj)
  assert_false(result is None)
  let null_result : @js.Object? = @nostd.identity_option(@nostd.null())
  assert_true(null_result is None)
  let undef_result : @js.Object? = @nostd.identity_option(@global.undefined())
  assert_true(undef_result is None)
}

///|
test "Conditional property setting with Option" {
  let obj = @nostd.Object::new()

  // Set with Some value
  match Some("value1") {
    Some(v) => obj._set("key1", v |> @nostd.any)
    None => ()
  }
  assert_eq(@nostd.identity(obj._get("key1")), "value1")

  // Set with None should not add property
  let v : Int? = None
  match v {
    Some(val) => obj._set("key2", val |> @nostd.any)
    None => ()
  }
  assert_true(@nostd.is_undefined(obj._get("key2")))

  // Set with undefined value - check before setting
  match Some(@nostd.undefined()) {
    Some(val) if not(@nostd.is_undefined(val)) =>
      obj._set("key3", val |> @nostd.any)
    _ => ()
  }
  assert_true(@nostd.is_undefined(obj._get("key3")))
}

///| instanceof_ tests

///|
test "instanceof_" {
  let arr = @nostd.any([1, 2, 3])
  let array_class = @global.global_this()._get("Array")
  assert_true(@nostd.instanceof_(arr, array_class))
  let obj = @nostd.Object::new()
  let object_class = @global.global_this()._get("Object")
  assert_true(@nostd.instanceof_(obj, object_class))
}

///| Show trait tests

///|
test "JsError Show output" {
  let err = @js.JsError::new("test message")
  // Using inspect triggers Show::output
  inspect(err |> @nostd.any, content="Error: test message")
  assert_eq(err.message, "test message")
}

///|
test "ThrowError Show output" {
  let result = try? @js.throwable(fn() {
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
  assert_eq(@nostd.identity(obj._get("name")), "Alice")
  // Should be writable
  obj._set("name", "Bob" |> @nostd.any)
  assert_eq(@nostd.identity(obj._get("name")), "Bob")
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
  assert_eq(@nostd.identity(obj._get("id")), 123)
  // Attempting to write won't work in strict mode, but in non-strict mode it's silently ignored
  obj._set("id", 456 |> @nostd.any)
  // Value should still be 123 (write ignored)
  assert_eq(@nostd.identity(obj._get("id")), 123)
}

///|
test "Object::defineProperty with getter/setter" {
  let obj = @nostd.Object::new()
  let storage : Ref[Int] = { val: 0 }
  Object::defineProperty(
    obj,
    "value",
    get=fn() { storage.val |> @js.any },
    set=fn(v) { storage.val = @nostd.identity(v) },
    enumerable=true,
    configurable=true,
  )
  |> ignore
  // Test getter
  assert_eq(@nostd.identity(obj._get("value")), 0)
  // Test setter
  obj._set("value", 42 |> @nostd.any)
  assert_eq(@nostd.identity(obj._get("value")), 42)
  assert_eq(storage.val, 42)
}

///|
test "Object::getOwnPropertyDescriptor" {
  let obj = @nostd.Object::new()
  obj._set("name", "Alice" |> @nostd.any)
  let desc = Object::getOwnPropertyDescriptor(obj, "name")
  assert_true(desc is Some(_))
  guard desc is Some(d)
  assert_eq(@nostd.identity(d.value.unwrap()), "Alice")
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
  obj._set("a", 1 |> @nostd.any)
  obj._set("b", 2 |> @nostd.any)
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
  let sym = @js.symbol("mySymbol").to_any().cast()
  obj._set(sym, "symbol value" |> @nostd.any)
  let symbols = Object::getOwnPropertySymbols(obj)
  assert_eq(symbols.length(), 1)
}

///|
test "Object::defineProperties" {
  let obj = @nostd.Object::new()
  let props = @nostd.Object::new()
  let x_desc = @nostd.Object::new()
  x_desc._set("value", 10 |> @nostd.any)
  x_desc._set("writable", true |> @nostd.any)
  props._set("x", x_desc |> @nostd.any)
  let y_desc = @nostd.Object::new()
  y_desc._set("value", 20 |> @nostd.any)
  y_desc._set("writable", true |> @nostd.any)
  props._set("y", y_desc |> @nostd.any)
  Object::defineProperties(obj, props) |> ignore
  assert_eq(@nostd.identity(obj._get("x")), 10)
  assert_eq(@nostd.identity(obj._get("y")), 20)
}

///| Object.groupBy tests

///|
test "Object::groupBy basic" {
  let items : Array[@nostd.Any] = [1, 2, 3, 4, 5].map(fn(x) { x |> @js.any })
  let result = Object::groupBy(items, fn(item, _index) {
    let n : Int = item |> @nostd.identity
    if n % 2 == 0 {
      "even"
    } else {
      "odd"
    }
  })
  let odd : Array[Int] = result._get("odd") |> @nostd.identity
  let even : Array[Int] = result._get("even") |> @nostd.identity
  assert_eq(odd, [1, 3, 5])
  assert_eq(even, [2, 4])
}

///|
test "Object::groupBy with objects" {
  let inventory = @nostd.Object::new()
  inventory._set("name", "apple" |> @nostd.any)
  inventory._set("type", "fruit" |> @nostd.any)
  let inventory2 = @nostd.Object::new()
  inventory2._set("name", "beef" |> @nostd.any)
  inventory2._set("type", "meat" |> @nostd.any)
  let inventory3 = @nostd.Object::new()
  inventory3._set("name", "banana" |> @nostd.any)
  inventory3._set("type", "fruit" |> @nostd.any)
  let items = [inventory, inventory2, inventory3]
  let result = Object::groupBy(items, fn(item, _index) {
    item._get("type") |> @nostd.identity
  })
  let fruits : Array[@nostd.Any] = result._get("fruit") |> @nostd.identity
  let meats : Array[@nostd.Any] = result._get("meat") |> @nostd.identity
  assert_eq(fruits.length(), 2)
  assert_eq(meats.length(), 1)
}
