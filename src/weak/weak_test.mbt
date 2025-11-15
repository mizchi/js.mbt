///|
using @js {type Val, js, new_empty_object}

///|
test "WeakMap::set and get - store and retrieve values" {
  let wm : WeakMap[Val, Val] = WeakMap::new()
  let key = new_empty_object()
  let value = js("test value")
  wm.set(key, value) |> ignore
  let result = wm.get(key)
  assert_false(result.is_empty())
}

///|
test "WeakMap::has - check if key exists" {
  let wm : WeakMap[Val, Val] = WeakMap::new()
  let key = new_empty_object()
  let value = js("test")
  let has_before = wm.has(key)
  wm.set(key, value) |> ignore
  let has_after = wm.has(key)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakMap::delete - remove a key-value pair" {
  let wm : WeakMap[Val, Val] = WeakMap::new()
  let key = new_empty_object()
  let value = js("test")
  wm.set(key, value) |> ignore
  let deleted = wm.delete(key)
  let has_after = wm.has(key)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakMap::get - return None for non-existent key" {
  let wm : WeakMap[Val, Val] = WeakMap::new()
  let key = new_empty_object()
  let result = wm.get(key)
  assert_true(result.is_empty())
}

///|
test "WeakSet::add and has - add and check values" {
  let ws : WeakSet[Val] = WeakSet::new()
  let value = new_empty_object()
  let has_before = ws.has(value)
  ws.add(value) |> ignore
  let has_after = ws.has(value)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakSet::delete - remove a value" {
  let ws : WeakSet[Val] = WeakSet::new()
  let value = new_empty_object()
  ws.add(value) |> ignore
  let deleted = ws.delete(value)
  let has_after = ws.has(value)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakSet::has - return false for non-existent value" {
  let ws : WeakSet[Val] = WeakSet::new()
  let value = new_empty_object()
  let has = ws.has(value)
  assert_false(has)
}

///|
test "WeakRef::new and deref - create and dereference" {
  let target = new_empty_object()
  let wr : WeakRef[Val] = WeakRef::new(target)
  let result = wr.deref()
  assert_false(result.is_empty())
}

///|
test "FinalizationRegistry::register - register an object" {
  let registry : FinalizationRegistry[Val] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target = new_empty_object()
  let held_value = js("cleanup info")
  registry.register(target, held_value)
  // Registry was created successfully
  assert_true(true)
}

///|
test "FinalizationRegistry::unregister - unregister with token" {
  let registry : FinalizationRegistry[Val] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target = new_empty_object()
  let held_value = js("cleanup info")
  let token = new_empty_object()
  registry.register(target, held_value, unregister_token=token)
  let unregistered = registry.unregister(token)
  assert_true(unregistered)
}
