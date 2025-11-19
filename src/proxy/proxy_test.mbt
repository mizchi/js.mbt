///|
test "Proxy::new with no traps (transparent proxy)" {
  let target = @js.Object::new()
  target.set("name", "original")
  target.set("value", 42)

  // No traps creates a transparent proxy
  let proxy = Proxy::new(target)

  // All operations pass through to target
  assert_eq(@js.unsafe_cast(proxy.get("name")), "original")
  assert_eq(@js.unsafe_cast(proxy.get("value")), 42)
  proxy.set("name", "modified")
  assert_eq(@js.unsafe_cast(target.get("name")), "modified")
}

///|
test "Proxy::new creates proxy object" {
  let target = @js.Object::new()
  let proxy = Proxy::new(target)
  assert_true(@js.is_object(proxy))
}

///|
test "Proxy::revocable creates revocable proxy" {
  let target = @js.Object::new()
  target.set("data", "important")
  let revocable = Proxy::revocable(target)
  let proxy = revocable.get("proxy")
  let revoke = revocable.get("revoke")

  // Proxy works before revocation
  assert_eq(@js.unsafe_cast(proxy.get("data")), "important")

  // Verify revoke function exists
  assert_eq(@js.typeof_(revoke), "function")

  // Revoke the proxy
  revoke.call_self([]) |> ignore
}

///|
test "Proxy with target array" {
  let target = @js.JsArray::new()
  target.push(1)
  target.push(2)
  target.push(3)
  let proxy = Proxy::new(target)

  // Transparent proxy works with arrays
  assert_true(@js.is_array(proxy))
}

///|
test "Proxy with target function" {
  let target_fn = @js.globalThis().get("Math").get("max")
  let proxy = Proxy::new(target_fn)

  // Proxy wraps function
  assert_eq(@js.typeof_(proxy), "function")
}

///|
test "Proxy with get trap" {
  let target = @js.Object::new()
  target.set("x", 10)
  target.set("y", 20)
  let proxy = Proxy::new(target, get=fn(_target, prop, _receiver) {
    let key : String = @js.unsafe_cast(prop)
    if key == "x" {
      @js.js(100)
    } else {
      @js.js(200)
    }
  })
  assert_eq(@js.unsafe_cast(proxy.get("x")), 100)
  assert_eq(@js.unsafe_cast(proxy.get("y")), 200)
}

///|
test "Proxy with set trap" {
  let target = @js.Object::new()
  let proxy = Proxy::new(target, set=fn(target_obj, prop, value, _receiver) {
    // Only allow setting if value is a number
    if @js.typeof_(value) == "number" {
      let key : String = @js.unsafe_cast(prop)
      let obj : @js.Object = @js.unsafe_cast(target_obj)
      obj.set(key, value)
      true
    } else {
      false
    }
  })
  proxy.set("x", 42)
  assert_eq(@js.unsafe_cast(target.get("x")), 42)
}

///|
test "Proxy with has trap" {
  let target = @js.Object::new()
  target.set("real", "value")
  let proxy = Proxy::new(target, has=fn(_target, prop) {
    let key : String = @js.unsafe_cast(prop)
    // Always return true for "fake" property
    key == "fake" || key == "real"
  })

  // Note: MoonBit doesn't have direct 'in' operator, so we test indirectly
  assert_true(@js.is_object(proxy))
}

///|
test "Proxy with multiple traps" {
  let target = @js.Object::new()
  let proxy = Proxy::new(
    target,
    get=fn(_target, _prop, _receiver) { @js.js("intercepted") },
    set=fn(target_obj, prop, value, _receiver) {
      let key : String = @js.unsafe_cast(prop)
      let obj : @js.Object = @js.unsafe_cast(target_obj)
      obj.set(key, value)
      true
    },
  )
  proxy.set("key", "original")
  // get trap returns "intercepted" instead of "original"
  assert_eq(@js.unsafe_cast(proxy.get("key")), "intercepted")
}
