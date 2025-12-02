///|
test "Reflect.get" {
  let obj = @nostd.Object::new()
  obj._set("name", @nostd.any("Alice"))
  obj._set("age", @nostd.any(30))
  let name = @reflect.get(obj, @nostd.any("name"), None)
  let age = @reflect.get(obj, @nostd.any("age"), None)
  assert_eq(@nostd.identity(name), "Alice")
  assert_eq(@nostd.identity(age), 30)
}

///|
test "Reflect.set" {
  let obj = @nostd.Object::new()
  let result1 = @reflect.set(obj, @nostd.any("x"), @nostd.any(10), None)
  let result2 = @reflect.set(obj, @nostd.any("y"), @nostd.any(20), None)
  assert_true(result1)
  assert_true(result2)
  assert_eq(@nostd.identity(obj["x"]), 10)
  assert_eq(@nostd.identity(obj["y"]), 20)
}

///|
test "Reflect.has" {
  let obj = @nostd.Object::new()
  obj._set("prop", @nostd.any("value"))
  assert_true(has(obj, @nostd.any("prop")))
  assert_false(has(obj, @nostd.any("nonexistent")))
}

///|
test "Reflect.deleteProperty" {
  let obj = @nostd.Object::new()
  obj._set("temp", @nostd.any("delete me"))
  assert_true(has(obj, @nostd.any("temp")))
  let deleted = deleteProperty(obj, @nostd.any("temp"))
  assert_true(deleted)
  assert_false(has(obj, @nostd.any("temp")))
}

///|
test "Reflect.ownKeys" {
  let obj = @nostd.Object::new()
  obj._set("a", @nostd.any(1))
  obj._set("b", @nostd.any(2))
  obj._set("c", @nostd.any(3))
  let keys = ownKeys(obj)
  assert_eq(keys.length(), 3)
}

///|
test "Reflect.isExtensible and preventExtensions" {
  let obj = @nostd.Object::new()
  assert_true(isExtensible(obj))
  let result = preventExtensions(obj)
  assert_true(result)
  assert_false(isExtensible(obj))
}

///|
test "Reflect.getPrototypeOf" {
  let obj = @nostd.Object::new()
  let proto = getPrototypeOf(obj)
  assert_true(@js.is_object(proto.cast()))
}

///|
test "Reflect.setPrototypeOf" {
  let obj = @nostd.Object::new()
  let new_proto = @nostd.Object::new()
  new_proto._set("custom", @nostd.any(true))
  let result = setPrototypeOf(obj, new_proto)
  assert_true(result)
  let proto = getPrototypeOf(obj)
  assert_eq(@nostd.identity(proto["custom"]), true)
}

///|
test "Reflect.apply" {
  let g : @nostd.Any = @global.global_this() |> @nostd.any
  let add_fn = g["Math"]["max"]
  let result = apply(add_fn, @nostd.any(@global.undefined()), [
    @nostd.any(10),
    @nostd.any(20),
  ])
  assert_eq(@nostd.identity(result), 20)
}

///|
test "Reflect.construct" {
  let g : @nostd.Any = @global.global_this() |> @nostd.any
  let array_constructor = g["Array"]
  let arr = construct(array_constructor, [@nostd.any(3)], None)
  assert_true(@js.is_array(arr.cast()))
}

///|
test "Reflect.getOwnPropertyDescriptor" {
  let obj = @nostd.Object::new()
  obj._set("prop", @nostd.any("value"))
  let descriptor = getOwnPropertyDescriptor(obj, @nostd.any("prop"))
  assert_true(@js.is_object(descriptor.cast()))
  let value = descriptor["value"]
  assert_eq(@nostd.identity(value), "value")
}

///|
test "Reflect.defineProperty" {
  let obj = @nostd.Object::new()
  let descriptor = @nostd.Object::new()
  descriptor._set("value", @nostd.any(42))
  descriptor._set("writable", @nostd.any(true))
  descriptor._set("enumerable", @nostd.any(true))
  descriptor._set("configurable", @nostd.any(true))
  let result = defineProperty(obj, @nostd.any("newProp"), descriptor)
  assert_true(result)
  assert_eq(@nostd.identity(obj["newProp"]), 42)
}

///|
test "Reflect.set with receiver" {
  let obj = @nostd.Object::new()
  obj._set("x", @nostd.any(10))
  let receiver = @nostd.Object::new()
  let result = set(obj, @nostd.any("x"), @nostd.any(20), Some(receiver))
  assert_true(result)
}

///|
test "Reflect.get with receiver" {
  let obj = @nostd.Object::new()
  obj._set("value", @nostd.any(100))
  let receiver = @nostd.Object::new()
  let result = @reflect.get(obj, @nostd.any("value"), Some(receiver))
  assert_eq(@nostd.identity(result), 100)
}

///|
test "Reflect operations on frozen object" {
  let obj = @nostd.Object::new()
  obj._set("frozen", @nostd.any(true))
  @js.Object::freeze(obj |> @nostd.identity) |> ignore

  // Cannot add new properties to frozen object
  let set_result = @reflect.set(
    obj,
    @nostd.any("new"),
    @nostd.any("value"),
    None,
  )
  assert_false(set_result)

  // Cannot delete properties from frozen object
  let delete_result = @reflect.deleteProperty(obj, @nostd.any("frozen"))
  assert_false(delete_result)

  // Can still read properties
  let value = @reflect.get(obj, @nostd.any("frozen"), None)
  assert_eq(@nostd.identity(value), true)

  // Frozen object is not extensible
  assert_false(@reflect.isExtensible(obj))
}

///|
test "Reflect.ownKeys includes symbols" {
  let obj = @nostd.Object::new()
  obj._set("stringKey", @nostd.any(1))
  let sym = @js.symbol("test")
  // Use Reflect.set to set symbol key (since _set only takes String keys)
  @reflect.set(obj, @nostd.any(sym), @nostd.any(2), None) |> ignore
  let keys = ownKeys(obj)
  // Should include both string and symbol keys
  assert_true(keys.length() >= 2)
}
