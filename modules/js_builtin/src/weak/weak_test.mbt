///|

///|
test "WeakMap::set and get - store and retrieve values" {
  let wm : WeakMap[@core.Any, @core.Any] = WeakMap::new()
  let key : @core.Any = @core.new_object() |> @core.identity
  let value = @core.any("test value")
  wm.set(key, value) |> ignore
  let result = wm.get(key)
  assert_false(result is None)
}

///|
test "WeakMap::has - check if key exists" {
  let wm : WeakMap[@core.Any, @core.Any] = WeakMap::new()
  let key : @core.Any = @core.new_object() |> @core.identity
  let value = @core.any("test")
  let has_before = wm.has(key)
  wm.set(key, value) |> ignore
  let has_after = wm.has(key)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakMap::delete - remove a key-value pair" {
  let wm : WeakMap[@core.Any, @core.Any] = WeakMap::new()
  let key : @core.Any = @core.new_object() |> @core.identity
  let value = @core.any("test")
  wm.set(key, value) |> ignore
  let deleted = wm.delete(key)
  let has_after = wm.has(key)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakMap::get - return None for non-existent key" {
  let wm : WeakMap[@core.Any, @core.Any] = WeakMap::new()
  let key : @core.Any = @core.new_object() |> @core.identity
  let result = wm.get(key)
  assert_true(result is None)
}

///|
test "WeakSet::add and has - add and check values" {
  let ws : WeakSet[@core.Any] = WeakSet::new()
  let value : @core.Any = @core.new_object() |> @core.identity
  let has_before = ws.has(value)
  ws.add(value) |> ignore
  let has_after = ws.has(value)
  assert_false(has_before)
  assert_true(has_after)
}

///|
test "WeakSet::delete - remove a value" {
  let ws : WeakSet[@core.Any] = WeakSet::new()
  let value : @core.Any = @core.new_object() |> @core.identity
  ws.add(value) |> ignore
  let deleted = ws.delete(value)
  let has_after = ws.has(value)
  assert_true(deleted)
  assert_false(has_after)
}

///|
test "WeakSet::has - return false for non-existent value" {
  let ws : WeakSet[@core.Any] = WeakSet::new()
  let value : @core.Any = @core.new_object() |> @core.identity
  let has = ws.has(value)
  assert_false(has)
}

///|
test "WeakRef::new and deref - create and dereference" {
  let target : @core.Any = @core.new_object() |> @core.identity
  let wr : WeakRef[@core.Any] = WeakRef::new(target)
  let result = wr.deref()
  assert_false(result is None)
}

///|
test "FinalizationRegistry::register - register an object" {
  let registry : FinalizationRegistry[@core.Any] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target : @core.Any = @core.new_object() |> @core.identity
  let held_value = "cleanup info"
  registry.register(target, held_value |> @core.any)
  // Registry was created successfully
  assert_true(true)
}

///|
test "FinalizationRegistry::unregister - unregister with token" {
  let registry : FinalizationRegistry[@core.Any] = FinalizationRegistry::new(fn(
    _held_value,
  ) {
    ()
  })
  let target : @core.Any = @core.new_object() |> @core.identity
  let held_value = "cleanup info"
  let token : @core.Any = @core.new_object()
  registry.register(target, held_value |> @core.any, unregister_token=token)
  let unregistered = registry.unregister(token)
  assert_true(unregistered)
}

///|
test "WeakRef::deref returns None when target is collected" {
  // Create a mock WeakRef that returns undefined to simulate collected object
  let undef_ref : @core.Any = @global.undefined()
  let mock_weakref = @core.new_object()
  mock_weakref._set("deref", @core.from_fn0(fn() { undef_ref }) |> @core.any)
  let wr : WeakRef[@core.Any] = mock_weakref |> @core.identity
  let result = wr.deref()
  assert_true(result is None)
}
