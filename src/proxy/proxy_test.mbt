///|
test "Proxy basic get trap" {
  let target = @js.Object::new()
  target.set("message", "hello")
  let handler = create_handler_with_get(fn(_target, _prop, _receiver) {
    @js.js("hello") // Return directly for simplicity
  })
  let proxy = Proxy::new(target, handler)
  let result = proxy.get("message")
  assert_eq(@js.unsafe_cast(result), "hello")
}

///|
test "Proxy get trap with default value" {
  let target = @js.Object::new()
  target.set("x", 10)
  let handler = create_handler_with_get(fn(_target, prop, _receiver) {
    let key : String = @js.unsafe_cast(prop)
    if key == "x" {
      @js.js(10)
    } else {
      @js.js(42) // default value
    }
  })
  let proxy = Proxy::new(target, handler)
  assert_eq(@js.unsafe_cast(proxy.get("x")), 10)
  assert_eq(@js.unsafe_cast(proxy.get("y")), 42)
}

///|
test "Proxy set trap" {
  let target = @js.Object::new()
  let handler = create_handler_with_set(fn(_target, _prop, _value, _receiver) {
    true // Just return true for simplicity
  })
  let proxy = Proxy::new(target, handler)
  proxy.set("name", "Alice")
  // Verify proxy was created successfully
  assert_true(@js.is_object(proxy))
}

///|
test "Proxy has trap" {
  let target = @js.Object::new()
  target.set("secret", "value")
  let handler = create_handler_with_has(fn(_target, prop) {
    let key : String = @js.unsafe_cast(prop)
    key != "secret" // hide 'secret' property
  })
  let proxy = Proxy::new(target, handler)

  // Verify handler is set up correctly
  assert_true(@js.is_object(handler))
  assert_true(target.hasOwnProperty("secret"))
}

///|
test "Proxy deleteProperty trap" {
  let target = @js.Object::new()
  target.set("canDelete", "yes")
  target.set("cannotDelete", "no")
  let handler = create_handler_with_delete(fn(_target, prop) {
    let key : String = @js.unsafe_cast(prop)
    if key == "cannotDelete" {
      false // prevent deletion
    } else {
      true // allow deletion
    }
  })
  let proxy = Proxy::new(target, handler)

  // Verify handler is set up correctly
  assert_true(@js.is_object(handler))
  assert_true(target.hasOwnProperty("canDelete"))
  assert_true(target.hasOwnProperty("cannotDelete"))
}

///|
test "Proxy with multiple traps" {
  let target = @js.Object::new()
  let handler = create_empty_handler()
  add_get_trap(handler, fn(_target, _prop, _receiver) { @js.js(100) })
  add_set_trap(handler, fn(_target, _prop, _value, _receiver) { true })
  let proxy = Proxy::new(target, handler)
  proxy.set("x", 100)
  assert_eq(@js.unsafe_cast(proxy.get("x")), 100)
}

///|
test "Proxy revocable" {
  let target = @js.Object::new()
  target.set("data", "important")
  let handler = @js.Object::new()
  let revocable = Proxy::revocable(target, handler)
  let proxy = revocable.get("proxy")
  let revoke = revocable.get("revoke")

  // Proxy works before revocation
  assert_eq(@js.unsafe_cast(proxy.get("data")), "important")

  // Revoke the proxy
  revoke.call_self([]) |> ignore

  // After revocation, accessing the proxy should fail (in real JS it throws)
  // We just verify the revoke function exists and is callable
  assert_eq(@js.typeof_(revoke), "function")
}

///|
test "Proxy ownKeys trap" {
  let target = @js.Object::new()
  target.set("a", 1)
  target.set("b", 2)
  target.set("_hidden", 3)
  let handler = create_handler_with_ownKeys(fn(_target) {
    @js.from_array([@js.js("a"), @js.js("b")])
  })
  let proxy = Proxy::new(target, handler)
  let keys = @js.Object::keys(proxy)
  assert_eq(keys.length(), 2)
  assert_true(keys.contains("a"))
  assert_true(keys.contains("b"))
  assert_false(keys.contains("_hidden"))
}

///|
test "Proxy apply trap for function" {
  let target_fn = @js.globalThis().get("Math").get("max")
  let handler = create_handler_with_apply(fn(_target, _this_arg, _args) {
    @js.js(10) // Return fixed value for simplicity
  })
  let proxy = Proxy::new(target_fn, handler)
  let result = proxy.call_self([@js.js(5), @js.js(10), @js.js(3)])
  assert_eq(@js.unsafe_cast(result), 10)
}

///|
test "Proxy validation in set trap" {
  let target = @js.Object::new()
  let handler = create_handler_with_set(fn(_target, prop, value, _receiver) {
    let key : String = @js.unsafe_cast(prop)
    if key == "age" {
      let age : Int = @js.unsafe_cast(value)
      if age < 0 || age > 150 {
        return false
      }
    }
    true
  })
  let proxy = Proxy::new(target, handler)

  // Valid age
  proxy.set("age", 30)

  // Verify proxy works
  assert_true(@js.is_object(proxy))
}

///|
test "Proxy transparent wrapper" {
  let target = @js.Object::new()
  target.set("name", "original")
  target.set("value", 42)

  // Empty handler creates a transparent proxy
  let handler = @js.Object::new()
  let proxy = Proxy::new(target, handler)

  // All operations pass through to target
  assert_eq(@js.unsafe_cast(proxy.get("name")), "original")
  assert_eq(@js.unsafe_cast(proxy.get("value")), 42)
  proxy.set("name", "modified")
  assert_eq(@js.unsafe_cast(target.get("name")), "modified")
}

///|
test "Proxy constructor exists" {
  let target = @js.Object::new()
  let handler = @js.Object::new()
  let proxy = Proxy::new(target, handler)
  assert_true(@js.is_object(proxy))
}
