///|

///|
test "WeakMap::set and get - store and retrieve values" {
  let wm : WeakMap[@js.Any, @js.Any] = WeakMap::new()
  let key = @js.Object::new().to_any()
  let value = @js.any("test value")
  wm.set(key, value) |> ignore
  let result = wm.get(key)
  assert_false(result is None)
}

///|
test "WeakMap::has - check if key exists" {
  let wm : WeakMap[@js.Any, @js.Any] = WeakMap::new()
  let key = @js.Object::new().to_any()
  let value = @js.any("test")
  let has_before = wm.has(key)
  wm.set(key, value) |> ignore
  let has_after = wm.has(key)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakMap::delete - remove a key-value pair" {
  let wm : WeakMap[@js.Any, @js.Any] = WeakMap::new()
  let key = @js.Object::new().to_any()
  let value = @js.any("test")
  wm.set(key, value) |> ignore
  let deleted = wm.delete(key)
  let has_after = wm.has(key)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakMap::get - return None for non-existent key" {
  let wm : WeakMap[@js.Any, @js.Any] = WeakMap::new()
  let key = @js.Object::new()
  let result = wm.get(key.to_any())
  assert_true(result is None)
}

///|
test "WeakSet::add and has - add and check values" {
  let ws : WeakSet[@js.Any] = WeakSet::new()
  let value = @js.Object::new()
  let has_before = ws.has(value.to_any())
  ws.add(value.to_any()) |> ignore
  let has_after = ws.has(value.to_any())
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakSet::delete - remove a value" {
  let ws : WeakSet[@js.Any] = WeakSet::new()
  let value = @js.Object::new()
  ws.add(value.to_any()) |> ignore
  let deleted = ws.delete(value.to_any())
  let has_after = ws.has(value.to_any())
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakSet::has - return false for non-existent value" {
  let ws : WeakSet[@js.Any] = WeakSet::new()
  let value = @js.Object::new()
  let has = ws.has(value.to_any())
  assert_false(has)
}

///|
test "WeakRef::new and deref - create and dereference" {
  let target = @js.Object::new()
  let wr : WeakRef[@js.Any] = WeakRef::new(target.to_any())
  let result = wr.deref()
  assert_false(result is None)
}

///|
test "FinalizationRegistry::register - register an object" {
  let registry : FinalizationRegistry[@js.Any] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target = @js.Object::new()
  let held_value = "cleanup info"
  registry.register(target, held_value |> @js.any)
  // Registry was created successfully
  assert_true(true)
}

///|
test "FinalizationRegistry::unregister - unregister with token" {
  let registry : FinalizationRegistry[@js.Any] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target = @js.Object::new()
  let held_value = "cleanup info"
  let token = @js.Object::new()
  registry.register(
    target,
    held_value |> @js.any,
    unregister_token=token.to_any(),
  )
  let unregistered = registry.unregister(token.to_any())
  assert_true(unregistered)
}

///|
test "WeakRef::deref returns None when target is collected" {
  // Create a mock WeakRef that returns undefined to simulate collected object
  let undef_ref : @js.Any = @js.undefined()
  let mock_weakref = @js.Object::new()
  mock_weakref.set("deref", @js.from_fn0(fn() { undef_ref }))
  let wr : WeakRef[@js.Any] = @js.identity(mock_weakref.to_any())
  let result = wr.deref()
  assert_true(result is None)
}
