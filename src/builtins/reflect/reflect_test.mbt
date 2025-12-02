///|
test "Reflect.get" {
  let obj = @core.new_object()
  obj._set("name", @core.any("Alice"))
  obj._set("age", @core.any(30))
  let name = @reflect.get(obj, @core.any("name"), None)
  let age = @reflect.get(obj, @core.any("age"), None)
  assert_eq(@core.identity(name), "Alice")
  assert_eq(@core.identity(age), 30)
}

///|
test "Reflect.set" {
  let obj = @core.new_object()
  let result1 = @reflect.set(obj, @core.any("x"), @core.any(10), None)
  let result2 = @reflect.set(obj, @core.any("y"), @core.any(20), None)
  assert_true(result1)
  assert_true(result2)
  assert_eq(@core.identity(obj["x"]), 10)
  assert_eq(@core.identity(obj["y"]), 20)
}

///|
test "Reflect.has" {
  let obj = @core.new_object()
  obj._set("prop", @core.any("value"))
  assert_true(has(obj, @core.any("prop")))
  assert_false(has(obj, @core.any("nonexistent")))
}

///|
test "Reflect.deleteProperty" {
  let obj = @core.new_object()
  obj._set("temp", @core.any("delete me"))
  assert_true(has(obj, @core.any("temp")))
  let deleted = deleteProperty(obj, @core.any("temp"))
  assert_true(deleted)
  assert_false(has(obj, @core.any("temp")))
}

///|
test "Reflect.ownKeys" {
  let obj = @core.new_object()
  obj._set("a", @core.any(1))
  obj._set("b", @core.any(2))
  obj._set("c", @core.any(3))
  let keys = ownKeys(obj)
  assert_eq(keys.length(), 3)
}

///|
test "Reflect.isExtensible and preventExtensions" {
  let obj = @core.new_object()
  assert_true(isExtensible(obj))
  let result = preventExtensions(obj)
  assert_true(result)
  assert_false(isExtensible(obj))
}

///|
test "Reflect.getPrototypeOf" {
  let obj = @core.new_object()
  let proto = getPrototypeOf(obj)
  assert_true(@core.is_object(proto.cast()))
}

///|
test "Reflect.setPrototypeOf" {
  let obj = @core.new_object()
  let new_proto = @core.new_object()
  new_proto._set("custom", @core.any(true))
  let result = setPrototypeOf(obj, new_proto)
  assert_true(result)
  let proto = getPrototypeOf(obj)
  assert_eq(@core.identity(proto["custom"]), true)
}

///|
test "Reflect.apply" {
  let g : @core.Any = @global.global_this() |> @core.any
  let add_fn = g["Math"]["max"]
  let result = apply(add_fn, @core.any(@global.undefined()), [
    @core.any(10),
    @core.any(20),
  ])
  assert_eq(@core.identity(result), 20)
}

///|
test "Reflect.construct" {
  let g : @core.Any = @global.global_this() |> @core.any
  let array_constructor = g["Array"]
  let arr = construct(array_constructor, [@core.any(3)], None)
  assert_true(@core.is_array(arr.cast()))
}

///|
test "Reflect.getOwnPropertyDescriptor" {
  let obj = @core.new_object()
  obj._set("prop", @core.any("value"))
  let descriptor = getOwnPropertyDescriptor(obj, @core.any("prop"))
  assert_true(@core.is_object(descriptor.cast()))
  let value = descriptor["value"]
  assert_eq(@core.identity(value), "value")
}

///|
test "Reflect.defineProperty" {
  let obj = @core.new_object()
  let descriptor = @core.new_object()
  descriptor._set("value", @core.any(42))
  descriptor._set("writable", @core.any(true))
  descriptor._set("enumerable", @core.any(true))
  descriptor._set("configurable", @core.any(true))
  let result = defineProperty(obj, @core.any("newProp"), descriptor)
  assert_true(result)
  assert_eq(@core.identity(obj["newProp"]), 42)
}

///|
test "Reflect.set with receiver" {
  let obj = @core.new_object()
  obj._set("x", @core.any(10))
  let receiver = @core.new_object()
  let result = set(obj, @core.any("x"), @core.any(20), Some(receiver))
  assert_true(result)
}

///|
test "Reflect.get with receiver" {
  let obj = @core.new_object()
  obj._set("value", @core.any(100))
  let receiver = @core.new_object()
  let result = @reflect.get(obj, @core.any("value"), Some(receiver))
  assert_eq(@core.identity(result), 100)
}

///|
test "Reflect operations on frozen object" {
  let obj = @core.new_object()
  obj._set("frozen", @core.any(true))
  @object.Object::freeze(obj |> @core.identity) |> ignore

  // Cannot add new properties to frozen object
  let set_result = @reflect.set(obj, @core.any("new"), @core.any("value"), None)
  assert_false(set_result)

  // Cannot delete properties from frozen object
  let delete_result = @reflect.deleteProperty(obj, @core.any("frozen"))
  assert_false(delete_result)

  // Can still read properties
  let value = @reflect.get(obj, @core.any("frozen"), None)
  assert_eq(@core.identity(value), true)

  // Frozen object is not extensible
  assert_false(@reflect.isExtensible(obj))
}

///|
test "Reflect.ownKeys includes symbols" {
  let obj = @core.new_object()
  obj._set("stringKey", @core.any(1))
  let sym = @symbol.symbol("test")
  // Use Reflect.set to set symbol key (since _set only takes String keys)
  @reflect.set(obj, @core.any(sym), @core.any(2), None) |> ignore
  let keys = ownKeys(obj)
  // Should include both string and symbol keys
  assert_true(keys.length() >= 2)
}
