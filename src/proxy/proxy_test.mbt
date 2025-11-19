///|
test "Proxy::new with empty handler (transparent proxy)" {
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
test "Proxy::new creates proxy object" {
  let target = @js.Object::new()
  let handler = @js.Object::new()
  let proxy = Proxy::new(target, handler)
  assert_true(@js.is_object(proxy))
}

///|
test "Proxy::revocable creates revocable proxy" {
  let target = @js.Object::new()
  target.set("data", "important")
  let handler = @js.Object::new()
  let revocable = Proxy::revocable(target, handler)
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
  let handler = @js.Object::new()
  let proxy = Proxy::new(target, handler)

  // Transparent proxy works with arrays
  assert_true(@js.is_array(proxy))
}

///|
test "Proxy with target function" {
  let target_fn = @js.globalThis().get("Math").get("max")
  let handler = @js.Object::new()
  let proxy = Proxy::new(target_fn, handler)

  // Proxy wraps function
  assert_eq(@js.typeof_(proxy), "function")
}
