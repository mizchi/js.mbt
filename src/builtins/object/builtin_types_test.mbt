// Tests for frequently used JavaScript builtin types
// Organized in the same order as builtins_types.mbt

///| Object tests

///|
test "Object creation and basic operations" {
  let obj = @core.Object::new()
  obj._set("name", "Alice" |> @core.any)
  obj._set("age", 30 |> @core.any)
  assert_eq(@core.identity(obj._get("name")), "Alice")
  assert_eq(@core.identity(obj._get("age")), 30)
  let obj_typed : @object.Object = @core.identity(obj)
  assert_true(obj_typed.hasOwnProperty("name"))
  assert_false(obj_typed.hasOwnProperty("nonexistent"))
}

///|
test "Object::create" {
  let obj = @object.Object::create(@core.Object::new())
  assert_true(@core.is_object(obj))
}

///|
test "Object::keys, values, entries" {
  let obj = @core.Object::new()
  obj._set("name", "Alice" |> @core.any)
  obj._set("age", 30 |> @core.any)
  obj._set("city", "Tokyo" |> @core.any)

  // Test keys
  let keys = Object::keys(obj)
  assert_eq(keys.length(), 3)
  assert_true(keys.contains("name"))
  assert_true(keys.contains("age"))
  assert_true(keys.contains("city"))

  // Test values
  let obj2 = @core.Object::new()
  obj2._set("a", 1 |> @core.any)
  obj2._set("b", 2 |> @core.any)
  obj2._set("c", 3 |> @core.any)
  let values = @object.Object::values(obj2)
  assert_eq(values.length(), 3)
  let sum : Int = @core.identity(values[0]) +
    @core.identity(values[1]) +
    @core.identity(values[2])
  assert_eq(sum, 6)

  // Test entries
  let entries = Object::entries(obj)
  assert_eq(entries.length(), 3)
  let mut found_name = false
  let mut found_age = false
  for entry in entries {
    let (key, value) = entry
    if key == "name" {
      assert_eq(@core.identity(value), "Alice")
      found_name = true
    } else if key == "age" {
      assert_eq(@core.identity(value), 30)
      found_age = true
    }
  }
  assert_true(found_name)
  assert_true(found_age)
}

///|
test "Object::assign" {
  let target = @core.Object::new()
  target._set("a", 1 |> @core.any)
  target._set("b", 2 |> @core.any)
  let source = @core.Object::new()
  source._set("b", 3 |> @core.any)
  source._set("c", 4 |> @core.any)
  let result = Object::assign(target, source)
  assert_eq(@core.identity(result._get("a")), 1)
  assert_eq(@core.identity(result._get("b")), 3)
  assert_eq(@core.identity(result._get("c")), 4)
}

///|
test "Object::is_ comparison" {
  let obj1 = @core.Object::new()
  let obj2 = @core.Object::new()
  assert_true(Object::is_(obj1, obj1))
  assert_false(Object::is_(obj1, obj2))

  // Primitive values
  assert_true(Object::is_(42 |> @core.any, 42 |> @core.any))
  assert_false(Object::is_(42 |> @core.any, 43 |> @core.any))
  assert_true(Object::is_("hello" |> @core.any, "hello" |> @core.any))
  assert_false(Object::is_("hello" |> @core.any, "world" |> @core.any))
}

///|
test "Object freeze, seal, preventExtensions" {
  // Test freeze
  let frozen = @core.Object::new()
  frozen._set("a", 1 |> @core.any)
  assert_false(Object::isFrozen(frozen))
  Object::freeze(frozen) |> ignore
  assert_true(Object::isFrozen(frozen))
  assert_false(Object::isExtensible_static(frozen))
  assert_eq(@core.identity(frozen._get("a")), 1)

  // Test seal
  let sealed_obj = @core.Object::new()
  sealed_obj._set("b", 2 |> @core.any)
  assert_false(Object::isSealed(sealed_obj))
  Object::seal(sealed_obj) |> ignore
  assert_true(Object::isSealed(sealed_obj))
  assert_false(Object::isExtensible_static(sealed_obj))
  assert_eq(@core.identity(sealed_obj._get("b")), 2)

  // Test preventExtensions
  let non_ext = @core.Object::new()
  non_ext._set("c", 3 |> @core.any)
  assert_true(Object::isExtensible_static(non_ext))
  Object::preventExtensions(non_ext) |> ignore
  assert_false(Object::isExtensible_static(non_ext))
  assert_eq(@core.identity(non_ext._get("c")), 3)

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
  let obj = @core.Object::new()
  obj._set("enumerable", "value" |> @core.any)
  let obj_typed : Object = @core.identity(obj)
  assert_true(obj_typed.propertyIsEnumerable("enumerable"))
  assert_false(obj_typed.propertyIsEnumerable("nonexistent"))
}

///|
test "Object::isPrototypeOf" {
  let parent = @core.Object::new()
  let parent_typed : Object = @core.identity(parent)
  let child = Object::create(parent)
  assert_true(parent_typed.isPrototypeOf(child))
  let child_obj : Object = @core.identity(child)
  assert_false(child_obj.isPrototypeOf(parent))
}

///|
test "Object::isExtensible instance method" {
  let obj = @core.Object::new()
  obj._set("prop", "value" |> @core.any)
  let obj_typed : Object = @core.identity(obj)
  assert_true(obj_typed.isExtensible())
  Object::preventExtensions(obj) |> ignore
  assert_false(obj_typed.isExtensible())
}

///|
test "Object with empty strings" {
  let obj = @core.Object::new()
  obj._set("empty", "" |> @core.any)
  assert_eq(@core.identity(obj._get("empty")), "")
  let obj_typed : Object = @core.identity(obj)
  assert_true(obj_typed.hasOwnProperty("empty"))
}

///| Array tests

///|
test "JsArray creation and type checking" {
  let arr = @core.JsArray::new()
  assert_true(@core.is_array(arr))
  assert_true(@core.is_object(arr))

  // Native array is also js array
  assert_true(@core.is_array([1] |> @core.any))
}

///| Iterator tests

///|
test "JsIterator::from converts iterable to iterator" {
  // Create an array - arrays are iterable in JavaScript
  let arr = @core.any([1, 2, 3])

  // Use Iterator.from to convert iterable to iterator
  let js_iter : @js.JsIterator[@core.Any] = @js.JsIterator::from(arr)

  // Verify it's created (basic type check)
  assert_true(@core.is_object(js_iter.as_any()))
}

///| Function tests

///| Error tests

///| Type conversion and casting tests

///|
test "Primitive type casting" {
  let int_val = @core.any(42)
  let int_result : Int = @core.identity(int_val)
  assert_eq(int_result, 42)
  let double_val = @core.any(3.14)
  let double_result : Double = @core.identity(double_val)
  assert_eq(double_result, 3.14)
  let str_val = @core.any("hello")
  let str_result : String = @core.identity(str_val)
  assert_eq(str_result, "hello")
  let bool_val = @core.any(true)
  let bool_result : Bool = @core.identity(bool_val)
  assert_eq(bool_result, true)
}

///|
test "identity_option" {
  // Some cases
  let some_str : String? = @core.any("hello") |> @core.identity_option()
  assert_eq(some_str, Some("hello"))
  let some_int : Int? = @core.any(42) |> @core.identity_option()
  assert_eq(some_int, Some(42))

  // None cases
  let none_str : String? = @core.undefined() |> @core.identity_option()
  assert_eq(none_str, None)
  let none_int : Int? = @core.null() |> @core.identity_option()
  assert_eq(none_int, None)
}

///|
test "identity_option with Show types" {
  let num_val = @core.any(42)
  let num_opt : Int? = @core.identity_option(num_val)
  assert_eq(num_opt, Some(42))
  let str_val = @core.any("hello")
  let str_opt : String? = @core.identity_option(str_val)
  assert_eq(str_opt, Some("hello"))

  // Test with null - should not cause infinite loop
  let null_val = @core.null()
  let null_opt : String? = @core.identity_option(null_val)
  assert_eq(null_opt, None)

  // Test with undefined - should not cause infinite loop
  let undef_val = @global.undefined()
  let undef_opt : String? = @core.identity_option(undef_val)
  assert_eq(undef_opt, None)
}

///|
test "identity_option for nullish detection" {
  let obj = @core.Object::new()
  let result : @js.Object? = @core.identity_option(obj)
  assert_false(result is None)
  let null_result : @js.Object? = @core.identity_option(@core.null())
  assert_true(null_result is None)
  let undef_result : @js.Object? = @core.identity_option(@global.undefined())
  assert_true(undef_result is None)
}

///|
test "Conditional property setting with Option" {
  let obj = @core.Object::new()

  // Set with Some value
  match Some("value1") {
    Some(v) => obj._set("key1", v |> @core.any)
    None => ()
  }
  assert_eq(@core.identity(obj._get("key1")), "value1")

  // Set with None should not add property
  let v : Int? = None
  match v {
    Some(val) => obj._set("key2", val |> @core.any)
    None => ()
  }
  assert_true(@core.is_undefined(obj._get("key2")))

  // Set with undefined value - check before setting
  match Some(@core.undefined()) {
    Some(val) if not(@core.is_undefined(val)) =>
      obj._set("key3", val |> @core.any)
    _ => ()
  }
  assert_true(@core.is_undefined(obj._get("key3")))
}

///| instanceof_ tests

///|
test "instanceof_" {
  let arr = @core.any([1, 2, 3])
  let array_class = @global.global_this()._get("Array")
  assert_true(@core.instanceof_(arr, array_class))
  let obj = @core.Object::new()
  let object_class = @global.global_this()._get("Object")
  assert_true(@core.instanceof_(obj, object_class))
}

///| Show trait tests

///|
test "JsError Show output" {
  let err = @js.JsError::new("test message")
  // Using inspect triggers Show::output
  inspect(err |> @core.any, content="Error: test message")
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
  let obj = @core.Object::new()
  Object::defineProperty(obj, "name", value="Alice" |> @js.any, writable=true)
  |> ignore
  assert_eq(@core.identity(obj._get("name")), "Alice")
  // Should be writable
  obj._set("name", "Bob" |> @core.any)
  assert_eq(@core.identity(obj._get("name")), "Bob")
}

///|
test "Object::defineProperty with non-writable" {
  let obj = @core.Object::new()
  Object::defineProperty(
    obj,
    "id",
    value=123 |> @js.any,
    writable=false,
    configurable=true,
  )
  |> ignore
  assert_eq(@core.identity(obj._get("id")), 123)
  // Attempting to write won't work in strict mode, but in non-strict mode it's silently ignored
  obj._set("id", 456 |> @core.any)
  // Value should still be 123 (write ignored)
  assert_eq(@core.identity(obj._get("id")), 123)
}

///|
test "Object::defineProperty with getter/setter" {
  let obj = @core.Object::new()
  let storage : Ref[Int] = { val: 0 }
  Object::defineProperty(
    obj,
    "value",
    get=fn() { storage.val |> @js.any },
    set=fn(v) { storage.val = @core.identity(v) },
    enumerable=true,
    configurable=true,
  )
  |> ignore
  // Test getter
  assert_eq(@core.identity(obj._get("value")), 0)
  // Test setter
  obj._set("value", 42 |> @core.any)
  assert_eq(@core.identity(obj._get("value")), 42)
  assert_eq(storage.val, 42)
}

///|
test "Object::getOwnPropertyDescriptor" {
  let obj = @core.Object::new()
  obj._set("name", "Alice" |> @core.any)
  let desc = Object::getOwnPropertyDescriptor(obj, "name")
  assert_true(desc is Some(_))
  guard desc is Some(d)
  assert_eq(@core.identity(d.value.unwrap()), "Alice")
  assert_eq(d.writable, Some(true))
  assert_eq(d.enumerable, Some(true))
  assert_eq(d.configurable, Some(true))
}

///|
test "Object::getOwnPropertyDescriptor returns None for non-existent" {
  let obj = @core.Object::new()
  let desc = Object::getOwnPropertyDescriptor(obj, "nonexistent")
  assert_true(desc is None)
}

///|
test "Object::getOwnPropertyNames" {
  let obj = @core.Object::new()
  obj._set("a", 1 |> @core.any)
  obj._set("b", 2 |> @core.any)
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
  let obj = @core.Object::new()
  let sym = @symbol.symbol("mySymbol") |> @core.identity
  obj._set(sym, "symbol value" |> @core.any)
  let symbols = Object::getOwnPropertySymbols(obj)
  assert_eq(symbols.length(), 1)
}

///|
test "Object::defineProperties" {
  let obj = @core.Object::new()
  let props = @core.Object::new()
  let x_desc = @core.Object::new()
  x_desc._set("value", 10 |> @core.any)
  x_desc._set("writable", true |> @core.any)
  props._set("x", x_desc |> @core.any)
  let y_desc = @core.Object::new()
  y_desc._set("value", 20 |> @core.any)
  y_desc._set("writable", true |> @core.any)
  props._set("y", y_desc |> @core.any)
  Object::defineProperties(obj, props) |> ignore
  assert_eq(@core.identity(obj._get("x")), 10)
  assert_eq(@core.identity(obj._get("y")), 20)
}

///| Object.groupBy tests

///|
test "Object::groupBy basic" {
  let items : Array[@core.Any] = [1, 2, 3, 4, 5].map(fn(x) { x |> @js.any })
  let result = Object::groupBy(items, fn(item, _index) {
    let n : Int = item |> @core.identity
    if n % 2 == 0 {
      "even"
    } else {
      "odd"
    }
  })
  let odd : Array[Int] = result._get("odd") |> @core.identity
  let even : Array[Int] = result._get("even") |> @core.identity
  assert_eq(odd, [1, 3, 5])
  assert_eq(even, [2, 4])
}

///|
test "Object::groupBy with objects" {
  let inventory = @core.Object::new()
  inventory._set("name", "apple" |> @core.any)
  inventory._set("type", "fruit" |> @core.any)
  let inventory2 = @core.Object::new()
  inventory2._set("name", "beef" |> @core.any)
  inventory2._set("type", "meat" |> @core.any)
  let inventory3 = @core.Object::new()
  inventory3._set("name", "banana" |> @core.any)
  inventory3._set("type", "fruit" |> @core.any)
  let items = [inventory, inventory2, inventory3]
  let result = Object::groupBy(items, fn(item, _index) {
    item._get("type") |> @core.identity
  })
  let fruits : Array[@core.Any] = result._get("fruit") |> @core.identity
  let meats : Array[@core.Any] = result._get("meat") |> @core.identity
  assert_eq(fruits.length(), 2)
  assert_eq(meats.length(), 1)
}
