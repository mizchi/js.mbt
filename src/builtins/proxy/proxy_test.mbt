///|
test "Proxy::new with no traps (transparent proxy)" {
  let target = @js.Object::new()
  target.set("name", "original")
  target.set("value", 42)

  // No traps creates a transparent proxy
  let proxy = Proxy::new(target)

  // All operations pass through to target
  assert_eq(@js.identity(proxy.get("name")), "original")
  assert_eq(@js.identity(proxy.get("value")), 42)
  proxy.set("name", "modified")
  assert_eq(@js.identity(target.get("name")), "modified")
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
  assert_eq(@js.identity(proxy.get("data")), "important")

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
    let key : String = @js.identity(prop)
    if key == "x" {
      @js.js(100)
    } else {
      @js.js(200)
    }
  })
  assert_eq(@js.identity(proxy.get("x")), 100)
  assert_eq(@js.identity(proxy.get("y")), 200)
}

///|
test "Proxy with set trap" {
  let target = @js.Object::new()
  let proxy = Proxy::new(target, set=fn(target_obj, prop, value, _receiver) {
    // Only allow setting if value is a number
    if @js.typeof_(value) == "number" {
      let key : String = @js.identity(prop)
      let obj : @js.Object = @js.identity(target_obj)
      obj.set(key, value)
      true
    } else {
      false
    }
  })
  proxy.set("x", 42)
  assert_eq(@js.identity(target.get("x")), 42)
}

///|
test "Proxy with has trap" {
  let target = @js.Object::new()
  target.set("real", "value")
  let proxy = Proxy::new(target, has=fn(_target, prop) {
    let key : String = @js.identity(prop)
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
      let key : String = @js.identity(prop)
      let obj : @js.Object = @js.identity(target_obj)
      obj.set(key, value)
      true
    },
  )
  proxy.set("key", "original")
  // get trap returns "intercepted" instead of "original"
  assert_eq(@js.identity(proxy.get("key")), "intercepted")
}

///|
test "Proxy with deleteProperty trap" {
  let mut delete_called = false
  let target = @js.Object::new()
  target.set("x", 10)
  target.set("y", 20)
  let proxy = Proxy::new(target, deleteProperty=fn(target_obj, prop) {
    delete_called = true
    let key : String = @js.identity(prop)
    let obj : @js.Object = @js.identity(target_obj)
    obj.delete(key)
    true
  })
  proxy.delete("x")
  inspect(delete_called, content="true")
  // Verify the property was actually deleted
  let x_value = target.get("x")
  inspect(@js.is_undefined(x_value), content="true")
}

///|
test "Proxy with apply trap for function" {
  let target_fn = @js.from_fn1(fn(x : @js.Js) -> @js.Js {
    let n : Int = @js.identity(x)
    @js.js(n * 2)
  })
  let proxy = Proxy::new(target_fn, apply=fn(_target, _this, args) {
    // Intercept function call and return modified result
    let arr : @js.JsArray = @js.identity(args)
    let first : Int = @js.identity(arr.get("0"))
    @js.js(first * 10)
  })
  let result : Int = @js.identity(proxy.call_self([@js.js(5)]))
  inspect(result, content="50")
}

///|
test "Proxy with construct trap" {
  // Create a constructor function using JS eval
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.TestConstructor = function(x) { this.value = x; }"),
  ])
  |> ignore
  let constructor_fn = global.get("TestConstructor")
  let proxy = Proxy::new(constructor_fn, construct=fn(
    _target,
    args,
    _newTarget,
  ) {
    let obj = @js.Object::new()
    let arr : @js.JsArray = @js.identity(args)
    let first : Int = @js.identity(arr.get("0"))
    obj.set("constructed", first * 100)
    obj.to_js()
  })
  let instance = @js.new_(proxy.to_js(), [@js.js(5)])
  let value : Int = @js.identity(instance.get("constructed"))
  inspect(value, content="500")
}

///|
test "Proxy with ownKeys trap" {
  let mut ownkeys_called = false
  let target = @js.Object::new()
  target.set("a", 1)
  target.set("b", 2)
  let proxy = Proxy::new(
    target,
    ownKeys=fn(_target) {
      ownkeys_called = true
      // Return custom keys
      let keys = @js.JsArray::new()
      keys.push("x")
      keys.push("y")
      keys.push("z")
      keys.to_js()
    },
    getOwnPropertyDescriptor=fn(_target, _prop) {
      // Need to return valid descriptor for Object.keys() to work
      let descriptor = @js.Object::new()
      descriptor.set("value", 42)
      descriptor.set("writable", true)
      descriptor.set("enumerable", true)
      descriptor.set("configurable", true)
      descriptor.to_js()
    },
  )
  let object_class = @js.globalThis().get("Object")
  let keys : @js.JsArray = @js.identity(object_class.call1("keys", proxy))
  inspect(ownkeys_called, content="true")
  let length : Int = @js.identity(keys.get("length"))
  inspect(length, content="3")
  let first : String = @js.identity(keys.get("0"))
  inspect(first, content="x")
}

///|
test "Proxy with getPrototypeOf trap" {
  let target = @js.Object::new()
  let custom_proto = @js.Object::new()
  custom_proto.set("custom", true)
  let proxy = Proxy::new(target, getPrototypeOf=fn(_target) {
    custom_proto.to_js()
  })
  let object_class = @js.globalThis().get("Object")
  let proto = object_class.call1("getPrototypeOf", proxy)
  let has_custom : Bool = @js.identity(proto.get("custom"))
  inspect(has_custom, content="true")
}

///|
test "Proxy with setPrototypeOf trap" {
  let mut set_proto_called = false
  let target = @js.Object::new()
  let proxy = Proxy::new(target, setPrototypeOf=fn(_target, _proto) {
    set_proto_called = true
    true
  })
  let new_proto = @js.Object::new()
  let object_class = @js.globalThis().get("Object")
  object_class.call2("setPrototypeOf", proxy, new_proto) |> ignore
  inspect(set_proto_called, content="true")
}

///|
test "Proxy with isExtensible trap" {
  let target = @js.Object::new()
  // Make target non-extensible first to match trap result
  let object_class = @js.globalThis().get("Object")
  object_class.call1("preventExtensions", target) |> ignore
  let proxy = Proxy::new(target, isExtensible=fn(_target) { false })
  let extensible : Bool = @js.identity(
    object_class.call1("isExtensible", proxy),
  )
  inspect(extensible, content="false")
}

///|
test "Proxy with preventExtensions trap" {
  let mut prevent_called = false
  let target = @js.Object::new()
  let proxy = Proxy::new(target, preventExtensions=fn(target_obj) {
    prevent_called = true
    // Actually prevent extensions on target
    let object_class = @js.globalThis().get("Object")
    object_class.call1("preventExtensions", target_obj) |> ignore
    true
  })
  let object_class = @js.globalThis().get("Object")
  object_class.call1("preventExtensions", proxy) |> ignore
  inspect(prevent_called, content="true")
}

///|
test "Proxy with getOwnPropertyDescriptor trap" {
  let target = @js.Object::new()
  target.set("x", 42)
  let proxy = Proxy::new(target, getOwnPropertyDescriptor=fn(_target, _prop) {
    let descriptor = @js.Object::new()
    descriptor.set("value", 999)
    descriptor.set("writable", true)
    descriptor.set("enumerable", true)
    descriptor.set("configurable", true)
    descriptor.to_js()
  })
  let object_class = @js.globalThis().get("Object")
  let descriptor = object_class.call2("getOwnPropertyDescriptor", proxy, "x")
  let value : Int = @js.identity(descriptor.get("value"))
  inspect(value, content="999")
}

///|
test "Proxy with defineProperty trap" {
  let mut define_called = false
  let target = @js.Object::new()
  let proxy = Proxy::new(target, defineProperty=fn(
    target_obj,
    prop,
    descriptor,
  ) {
    define_called = true
    let obj : @js.Object = @js.identity(target_obj)
    let key : String = @js.identity(prop)
    let desc : @js.Object = @js.identity(descriptor)
    obj.set(key, desc.get("value"))
    true
  })
  let descriptor = @js.Object::new()
  descriptor.set("value", 123)
  descriptor.set("writable", true)
  let object_class = @js.globalThis().get("Object")
  object_class.call("defineProperty", [
    proxy.to_js(),
    @js.js("newProp"),
    descriptor.to_js(),
  ])
  |> ignore
  inspect(define_called, content="true")
  let value : Int = @js.identity(target.get("newProp"))
  inspect(value, content="123")
}
