///|

///|
test "WeakMap::set and get - store and retrieve values" {
  let wm : WeakMap[@nostd.Any, @nostd.Any] = WeakMap::new()
  let key : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let value = @nostd.any("test value")
  wm.set(key, value) |> ignore
  let result = wm.get(key)
  assert_false(result is None)
}

///|
test "WeakMap::has - check if key exists" {
  let wm : WeakMap[@nostd.Any, @nostd.Any] = WeakMap::new()
  let key : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let value = @nostd.any("test")
  let has_before = wm.has(key)
  wm.set(key, value) |> ignore
  let has_after = wm.has(key)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakMap::delete - remove a key-value pair" {
  let wm : WeakMap[@nostd.Any, @nostd.Any] = WeakMap::new()
  let key : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let value = @nostd.any("test")
  wm.set(key, value) |> ignore
  let deleted = wm.delete(key)
  let has_after = wm.has(key)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakMap::get - return None for non-existent key" {
  let wm : WeakMap[@nostd.Any, @nostd.Any] = WeakMap::new()
  let key : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let result = wm.get(key)
  assert_true(result is None)
}

///|
test "WeakSet::add and has - add and check values" {
  let ws : WeakSet[@nostd.Any] = WeakSet::new()
  let value : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let has_before = ws.has(value)
  ws.add(value) |> ignore
  let has_after = ws.has(value)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakSet::delete - remove a value" {
  let ws : WeakSet[@nostd.Any] = WeakSet::new()
  let value : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  ws.add(value) |> ignore
  let deleted = ws.delete(value)
  let has_after = ws.has(value)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakSet::has - return false for non-existent value" {
  let ws : WeakSet[@nostd.Any] = WeakSet::new()
  let value : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let has = ws.has(value)
  assert_false(has)
}

///|
test "WeakRef::new and deref - create and dereference" {
  let target : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let wr : WeakRef[@nostd.Any] = WeakRef::new(target)
  let result = wr.deref()
  assert_false(result is None)
}

///|
test "FinalizationRegistry::register - register an object" {
  let registry : FinalizationRegistry[@nostd.Any] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let held_value = "cleanup info"
  registry.register(target, held_value |> @nostd.any)
  // Registry was created successfully
  assert_true(true)
}

///|
test "FinalizationRegistry::unregister - unregister with token" {
  let registry : FinalizationRegistry[@nostd.Any] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target : @nostd.Any = @nostd.Object::new() |> @nostd.identity
  let held_value = "cleanup info"
  let token : @nostd.Any = @nostd.Object::new()
  registry.register(target, held_value |> @nostd.any, unregister_token=token)
  let unregistered = registry.unregister(token)
  assert_true(unregistered)
}

///|
test "WeakRef::deref returns None when target is collected" {
  // Create a mock WeakRef that returns undefined to simulate collected object
  let undef_ref : @nostd.Any = @global.undefined()
  let mock_weakref = @nostd.Object::new()
  mock_weakref._set("deref", @js.from_fn0(fn() { undef_ref }) |> @nostd.any)
  let wr : WeakRef[@nostd.Any] = mock_weakref |> @nostd.identity
  let result = wr.deref()
  assert_true(result is None)
}
