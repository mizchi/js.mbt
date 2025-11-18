///|
using @js {trait JsImpl, type Js, safe_js, unsafe_cast, is_undefined}

///|
test "WeakMap::set and get - store and retrieve values" {
  let wm : WeakMap[Js, Js] = WeakMap::new()
  let key = @js.Object::new().to_js()
  let value = safe_js("test value")
  wm.set(key, value) |> ignore
  let result = wm.get(key)
  assert_false(result.is_empty())
}

///|
test "WeakMap::has - check if key exists" {
  let wm : WeakMap[Js, Js] = WeakMap::new()
  let key = @js.Object::new().to_js()
  let value = safe_js("test")
  let has_before = wm.has(key)
  wm.set(key, value) |> ignore
  let has_after = wm.has(key)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakMap::delete - remove a key-value pair" {
  let wm : WeakMap[Js, Js] = WeakMap::new()
  let key = @js.Object::new().to_js()
  let value = safe_js("test")
  wm.set(key, value) |> ignore
  let deleted = wm.delete(key)
  let has_after = wm.has(key)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakMap::get - return None for non-existent key" {
  let wm : WeakMap[Js, Js] = WeakMap::new()
  let key = @js.Object::new()
  let result = wm.get(key.to_js())
  assert_true(result.is_empty())
}

///|
test "WeakSet::add and has - add and check values" {
  let ws : WeakSet[Js] = WeakSet::new()
  let value = @js.Object::new()
  let has_before = ws.has(value.to_js())
  ws.add(value.to_js()) |> ignore
  let has_after = ws.has(value.to_js())
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakSet::delete - remove a value" {
  let ws : WeakSet[Js] = WeakSet::new()
  let value = @js.Object::new()
  ws.add(value.to_js()) |> ignore
  let deleted = ws.delete(value.to_js())
  let has_after = ws.has(value.to_js())
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakSet::has - return false for non-existent value" {
  let ws : WeakSet[Js] = WeakSet::new()
  let value = @js.Object::new()
  let has = ws.has(value.to_js())
  assert_false(has)
}

///|
test "WeakRef::new and deref - create and dereference" {
  let target = @js.Object::new()
  let wr : WeakRef[Js] = WeakRef::new(target.to_js())
  let result = wr.deref()
  assert_false(result.is_empty())
}

///|
test "FinalizationRegistry::register - register an object" {
  let registry : FinalizationRegistry[Js] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target = @js.Object::new()
  let held_value = "cleanup info"
  registry.register(target, held_value |> safe_js)
  // Registry was created successfully
  assert_true(true)
}

///|
test "FinalizationRegistry::unregister - unregister with token" {
  let registry : FinalizationRegistry[Js] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target = @js.Object::new()
  let held_value = "cleanup info"
  let token = @js.Object::new()
  registry.register(
    target,
    held_value |> safe_js,
    unregister_token=token.to_js(),
  )
  let unregistered = registry.unregister(token.to_js())
  assert_true(unregistered)
}
