///|
test "Reflect.get" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  let name = @reflect.get(@nostd.any(obj), @nostd.any("name"), None)
  let age = @reflect.get(@nostd.any(obj), @nostd.any("age"), None)
  assert_eq(@nostd.identity(name), "Alice")
  assert_eq(@nostd.identity(age), 30)
}

///|
test "Reflect.set" {
  let obj = @js.Object::new()
  let result1 = @reflect.set(
    @nostd.any(obj),
    @nostd.any("x"),
    @nostd.any(10),
    None,
  )
  let result2 = @reflect.set(
    @nostd.any(obj),
    @nostd.any("y"),
    @nostd.any(20),
    None,
  )
  assert_true(result1)
  assert_true(result2)
  assert_eq(@js.identity(obj.get("x")), 10)
  assert_eq(@js.identity(obj.get("y")), 20)
}

///|
test "Reflect.has" {
  let obj = @js.Object::new()
  obj.set("prop", "value")
  assert_true(has(@nostd.any(obj), @nostd.any("prop")))
  assert_false(has(@nostd.any(obj), @nostd.any("nonexistent")))
}

///|
test "Reflect.deleteProperty" {
  let obj = @js.Object::new()
  obj.set("temp", "delete me")
  assert_true(has(@nostd.any(obj), @nostd.any("temp")))
  let deleted = deleteProperty(@nostd.any(obj), @nostd.any("temp"))
  assert_true(deleted)
  assert_false(has(@nostd.any(obj), @nostd.any("temp")))
}

///|
test "Reflect.ownKeys" {
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  let keys = ownKeys(@nostd.any(obj))
  assert_eq(keys.length(), 3)
}

///|
test "Reflect.isExtensible and preventExtensions" {
  let obj = @js.Object::new()
  assert_true(isExtensible(@nostd.any(obj)))
  let result = preventExtensions(@nostd.any(obj))
  assert_true(result)
  assert_false(isExtensible(@nostd.any(obj)))
}

///|
test "Reflect.getPrototypeOf" {
  let obj = @js.Object::new()
  let proto = getPrototypeOf(@nostd.any(obj))
  assert_true(@js.is_object(proto.cast()))
}

///|
test "Reflect.setPrototypeOf" {
  let obj = @js.Object::new()
  let new_proto = @js.Object::new()
  new_proto.set("custom", true)
  let result = setPrototypeOf(@nostd.any(obj), @nostd.any(new_proto))
  assert_true(result)
  let proto = getPrototypeOf(@nostd.any(obj))
  assert_eq(@nostd.identity(proto["custom"]), true)
}

///|
test "Reflect.apply" {
  let add_fn = @js.globalThis().get("Math").get("max")
  let result = apply(@nostd.any(add_fn), @nostd.any(@js.undefined()), [
    @nostd.any(10),
    @nostd.any(20),
  ])
  assert_eq(@nostd.identity(result), 20)
}

///|
test "Reflect.construct" {
  let array_constructor = @js.globalThis().get("Array")
  let arr = construct(@nostd.any(array_constructor), [@nostd.any(3)], None)
  assert_true(@js.is_array(arr.cast()))
}

///|
test "Reflect.getOwnPropertyDescriptor" {
  let obj = @js.Object::new()
  obj.set("prop", "value")
  let descriptor = getOwnPropertyDescriptor(@nostd.any(obj), @nostd.any("prop"))
  assert_true(@js.is_object(descriptor.cast()))
  let value = descriptor["value"]
  assert_eq(@nostd.identity(value), "value")
}

///|
test "Reflect.defineProperty" {
  let obj = @js.Object::new()
  let descriptor = @js.Object::new()
  descriptor.set("value", 42)
  descriptor.set("writable", true)
  descriptor.set("enumerable", true)
  descriptor.set("configurable", true)
  let result = defineProperty(
    @nostd.any(obj),
    @nostd.any("newProp"),
    @nostd.any(descriptor),
  )
  assert_true(result)
  assert_eq(@js.identity(obj.get("newProp")), 42)
}

///|
test "Reflect.set with receiver" {
  let obj = @js.Object::new()
  obj.set("x", 10)
  let receiver = @js.Object::new()
  let result = set(
    @nostd.any(obj),
    @nostd.any("x"),
    @nostd.any(20),
    Some(@nostd.any(receiver)),
  )
  assert_true(result)
}

///|
test "Reflect.get with receiver" {
  let obj = @js.Object::new()
  obj.set("value", 100)
  let receiver = @js.Object::new()
  let result = @reflect.get(
    @nostd.any(obj),
    @nostd.any("value"),
    Some(@nostd.any(receiver)),
  )
  assert_eq(@nostd.identity(result), 100)
}

///|
test "Reflect operations on frozen object" {
  let obj = @js.Object::new()
  obj.set("frozen", true)
  @js.Object::freeze(obj) |> ignore

  // Cannot add new properties to frozen object
  let set_result = @reflect.set(
    @nostd.any(obj),
    @nostd.any("new"),
    @nostd.any("value"),
    None,
  )
  assert_false(set_result)

  // Cannot delete properties from frozen object
  let delete_result = @reflect.deleteProperty(
    @nostd.any(obj),
    @nostd.any("frozen"),
  )
  assert_false(delete_result)

  // Can still read properties
  let value = @reflect.get(@nostd.any(obj), @nostd.any("frozen"), None)
  assert_eq(@nostd.identity(value), true)

  // Frozen object is not extensible
  assert_false(@reflect.isExtensible(@nostd.any(obj)))
}

///|
test "Reflect.ownKeys includes symbols" {
  let obj = @js.Object::new()
  obj.set("stringKey", 1)
  let sym = @js.symbol("test")
  obj.set(sym, 2)
  let keys = ownKeys(@nostd.any(obj))
  // Should include both string and symbol keys
  assert_true(keys.length() >= 2)
}
