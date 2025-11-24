///|
test "Reflect.get" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  let name = @reflect.get(obj, "name", None)
  let age = @reflect.get(obj, "age", None)
  assert_eq(@js.identity(name), "Alice")
  assert_eq(@js.identity(age), 30)
}

///|
test "Reflect.set" {
  let obj = @js.Object::new()
  let result1 = @reflect.set(obj, "x", 10, None)
  let result2 = @reflect.set(obj, "y", 20, None)
  assert_true(result1)
  assert_true(result2)
  assert_eq(@js.identity(obj.get("x")), 10)
  assert_eq(@js.identity(obj.get("y")), 20)
}

///|
test "Reflect.has" {
  let obj = @js.Object::new()
  obj.set("prop", "value")
  assert_true(has(obj, "prop"))
  assert_false(has(obj, "nonexistent"))
}

///|
test "Reflect.deleteProperty" {
  let obj = @js.Object::new()
  obj.set("temp", "delete me")
  assert_true(has(obj, "temp"))
  let deleted = deleteProperty(obj, "temp")
  assert_true(deleted)
  assert_false(has(obj, "temp"))
}

///|
test "Reflect.ownKeys" {
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  let keys = ownKeys(obj)
  assert_eq(keys.length(), 3)
}

///|
test "Reflect.isExtensible and preventExtensions" {
  let obj = @js.Object::new()
  assert_true(isExtensible(obj))
  let result = preventExtensions(obj)
  assert_true(result)
  assert_false(isExtensible(obj))
}

///|
test "Reflect.getPrototypeOf" {
  let obj = @js.Object::new()
  let proto = getPrototypeOf(obj)
  assert_true(@js.is_object(proto))
}

///|
test "Reflect.setPrototypeOf" {
  let obj = @js.Object::new()
  let new_proto = @js.Object::new()
  new_proto.set("custom", true)
  let result = setPrototypeOf(obj, new_proto)
  assert_true(result)
  let proto = getPrototypeOf(obj)
  assert_eq(@js.identity(proto.get("custom")), true)
}

///|
test "Reflect.apply" {
  let add_fn = @js.globalThis().get("Math").get("max")
  let result = apply(add_fn, @js.undefined(), [@js.js(10), @js.js(20)])
  assert_eq(@js.identity(result), 20)
}

///|
test "Reflect.construct" {
  let array_constructor = @js.globalThis().get("Array")
  let arr = construct(array_constructor, [@js.js(3)], None)
  assert_true(@js.is_array(arr))
}

///|
test "Reflect.getOwnPropertyDescriptor" {
  let obj = @js.Object::new()
  obj.set("prop", "value")
  let descriptor = getOwnPropertyDescriptor(obj, "prop")
  assert_true(@js.is_object(descriptor))
  let value = descriptor.get("value")
  assert_eq(@js.identity(value), "value")
}

///|
test "Reflect.defineProperty" {
  let obj = @js.Object::new()
  let descriptor = @js.Object::new()
  descriptor.set("value", 42)
  descriptor.set("writable", true)
  descriptor.set("enumerable", true)
  descriptor.set("configurable", true)
  let result = defineProperty(obj, "newProp", descriptor)
  assert_true(result)
  assert_eq(@js.identity(obj.get("newProp")), 42)
}

///|
test "Reflect.set with receiver" {
  let obj = @js.Object::new()
  obj.set("x", 10)
  let receiver = @js.Object::new()
  let result = set(obj, "x", 20, Some(receiver.to_any()))
  assert_true(result)
}

///|
test "Reflect.get with receiver" {
  let obj = @js.Object::new()
  obj.set("value", 100)
  let receiver = @js.Object::new()
  let result = @reflect.get(obj, "value", Some(receiver.to_any()))
  assert_eq(@js.identity(result), 100)
}

///|
test "Reflect operations on frozen object" {
  let obj = @js.Object::new()
  obj.set("frozen", true)
  @js.Object::freeze(obj) |> ignore

  // Cannot add new properties to frozen object
  let set_result = @reflect.set(obj, "new", "value", None)
  assert_false(set_result)

  // Cannot delete properties from frozen object
  let delete_result = @reflect.deleteProperty(obj, "frozen")
  assert_false(delete_result)

  // Can still read properties
  let value = @reflect.get(obj, "frozen", None)
  assert_eq(@js.identity(value), true)

  // Frozen object is not extensible
  assert_false(@reflect.isExtensible(obj))
}

///|
test "Reflect.ownKeys includes symbols" {
  let obj = @js.Object::new()
  obj.set("stringKey", 1)
  let sym = @js.symbol("test")
  obj.set(sym, 2)
  let keys = ownKeys(obj)
  // Should include both string and symbol keys
  assert_true(keys.length() >= 2)
}
