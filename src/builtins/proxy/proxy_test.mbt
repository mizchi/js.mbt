///|
test "Proxy::new with no traps (transparent proxy)" {
  let target = @nostd.Object::new()
  target._set("name", "original" |> @nostd.any)
  target._set("value", 42 |> @nostd.any)

  // No traps creates a transparent proxy
  let proxy = Proxy::new(@nostd.any(target))

  // All operations pass through to target
  assert_eq(@nostd.identity(proxy.as_any()["name"]), "original")
  assert_eq(@nostd.identity(proxy.as_any()["value"]), 42)
  proxy.as_any()["name"] = @nostd.any("modified")
  assert_eq(@nostd.identity(target._get("name")), "modified")
}

///|
test "Proxy::new creates proxy object" {
  let target = @nostd.Object::new()
  let proxy = Proxy::new(@nostd.any(target))
  assert_true(@nostd.is_object(proxy.as_any().cast()))
}

///|
test "Proxy::revocable creates revocable proxy" {
  let target = @nostd.Object::new()
  target.set("data", "important")
  let revocable = Proxy::revocable(@nostd.any(target))
  let proxy = revocable["proxy"]
  let revoke = revocable["revoke"]

  // Proxy works before revocation
  assert_eq(@nostd.identity(proxy["data"]), "important")

  // Verify revoke function exists
  assert_eq(@nostd.typeof_(revoke), "function")

  // Revoke the proxy
  let revoke_fn : @nostd.Any = revoke.cast()
  revoke_fn.call_self([]) |> ignore
}

///|
test "Proxy with target array" {
  let target = @js.from_array([1, 2, 3])
  let proxy = Proxy::new(@nostd.any(target))

  // Transparent proxy works with arrays
  assert_true(@nostd.is_array(proxy.as_any().cast()))
}

///|
test "Proxy with target function" {
  let target_fn = @global.global_this()._get("Math")._get("max")
  let proxy = Proxy::new(@nostd.any(target_fn))

  // Proxy wraps function
  assert_eq(@nostd.typeof_(proxy.as_any()), "function")
}

///|
test "Proxy with get trap" {
  let target = @nostd.Object::new()
  target.set("x", 10)
  target.set("y", 20)
  let proxy = Proxy::new(@nostd.any(target), get=fn(_target, prop, _receiver) {
    let key : String = @nostd.identity(prop)
    if key == "x" {
      @nostd.any(100)
    } else {
      @nostd.any(200)
    }
  })
  assert_eq(@nostd.identity(proxy.as_any()["x"]), 100)
  assert_eq(@nostd.identity(proxy.as_any()["y"]), 200)
}

///|
test "Proxy with set trap" {
  let target = @nostd.Object::new()
  let proxy = Proxy::new(@nostd.any(target), set=fn(
    target_obj,
    prop,
    value,
    _receiver,
  ) {
    // Only allow setting if value is a number
    if @nostd.typeof_(value) == "number" {
      let key : String = @nostd.identity(prop)
      target_obj[key] = value
      true
    } else {
      false
    }
  })
  proxy.as_any()["x"] = @nostd.any(42)
  assert_eq(@nostd.identity(target._get("x")), 42)
}

///|
test "Proxy with has trap" {
  let target = @nostd.Object::new()
  target.set("real", "value")
  let proxy = Proxy::new(@nostd.any(target), has=fn(_target, prop) {
    let key : String = @nostd.identity(prop)
    // Always return true for "fake" property
    key == "fake" || key == "real"
  })

  // Note: MoonBit doesn't have direct 'in' operator, so we test indirectly
  assert_true(@nostd.is_object(proxy.as_any().cast()))
}

///|
test "Proxy with multiple traps" {
  let target = @nostd.Object::new()
  let proxy = Proxy::new(
    @nostd.any(target),
    get=fn(_target, _prop, _receiver) { @nostd.any("intercepted") },
    set=fn(target_obj, prop, value, _receiver) {
      let key : String = @nostd.identity(prop)
      target_obj[key] = value
      true
    },
  )
  proxy.as_any()["key"] = @nostd.any("original")
  // get trap returns "intercepted" instead of "original"
  assert_eq(@nostd.identity(proxy.as_any()["key"]), "intercepted")
}

///|
#skip("TODO: fixme")
test "Proxy with deleteProperty trap" {
  let mut delete_called = false
  let target = @nostd.Object::new()
  target._set("x", 10 |> @nostd.any)
  target._set("y", 20 |> @nostd.any)
  let proxy = Proxy::new(target, deleteProperty=fn(target_obj, prop) {
    delete_called = true
    let key : String = @nostd.identity(prop)
    let obj : @nostd.Any = target_obj.cast()
    obj._call("delete", [@nostd.any(key)]) |> ignore
    true
  })
  let proxy_obj : @nostd.Any = proxy.as_any().cast()
  proxy_obj._call("delete", [@nostd.any("x")]) |> ignore
  inspect(delete_called, content="true")
  // Verify the property was actually deleted
  let x_value = target._get("x")
  inspect(@nostd.is_undefined(x_value), content="true")
}

///|
test "Proxy with apply trap for function" {
  let target_fn = @nostd.from_fn1(fn(x : @nostd.Any) -> @nostd.Any {
    let n : Int = @nostd.identity(x)
    @nostd.any(n * 2)
  })
  let proxy = Proxy::new(@nostd.any(target_fn), apply=fn(_target, _this, args) {
    // Intercept function call and return modified result
    let first : Int = @nostd.identity(args["0"])
    @nostd.any(first * 10)
  })
  let proxy_fn : @nostd.Any = proxy.as_any().cast()
  let result : Int = @nostd.identity(proxy_fn.call_self([@nostd.any(5)]))
  inspect(result, content="50")
}

///|
test "Proxy with construct trap" {
  // Create a constructor function using JS eval
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.TestConstructor = function(x) { this.value = x; }"),
  ])
  |> ignore
  let constructor_fn = global._get("TestConstructor")
  let proxy = Proxy::new(@nostd.any(constructor_fn), construct=fn(
    _target,
    args,
    _newTarget,
  ) {
    let obj = @nostd.Object::new()
    let first : Int = @nostd.identity(args["0"])
    obj.set("constructed", first * 100)
    @nostd.any(obj)
  })
  let instance = @nostd.new(proxy.as_any().cast(), [@nostd.any(5)])
  let value : Int = @nostd.identity(instance._get("constructed"))
  inspect(value, content="500")
}

///|
test "Proxy with ownKeys trap" {
  let mut ownkeys_called = false
  let target = @nostd.Object::new()
  target.set("a", 1)
  target.set("b", 2)
  let proxy = Proxy::new(
    @nostd.any(target),
    ownKeys=fn(_target) {
      ownkeys_called = true
      // Return custom keys
      @nostd.any(@js.from_array(["x", "y", "z"]))
    },
    getOwnPropertyDescriptor=fn(_target, _prop) {
      // Need to return valid descriptor for Object.keys() to work
      @nostd.from_entries([
        ("value", @nostd.any(42)),
        ("writable", @nostd.any(true)),
        ("enumerable", @nostd.any(true)),
        ("configurable", @nostd.any(true)),
      ])
    },
  )
  let object_class = @global.global_this()._get("Object")
  let keys_any = object_class.call1("keys", proxy.as_any())
  let keys : @js.JsArray = @nostd.identity(keys_any)
  inspect(ownkeys_called, content="true")
  let length : Int = @nostd.identity(keys._get("length"))
  inspect(length, content="3")
  let first : String = @nostd.identity(keys._get("0"))
  inspect(first, content="x")
}

///|
test "Proxy with getPrototypeOf trap" {
  let target = @nostd.Object::new()
  let custom_proto = @nostd.Object::new()
  custom_proto.set("custom", true)
  let proxy = Proxy::new(@nostd.any(target), getPrototypeOf=fn(_target) {
    @nostd.any(custom_proto)
  })
  let object_class = @global.global_this()._get("Object")
  let proto = object_class.call1("getPrototypeOf", proxy.as_any())
  let has_custom : Bool = @nostd.identity(proto._get("custom"))
  inspect(has_custom, content="true")
}

///|
test "Proxy with setPrototypeOf trap" {
  let mut set_proto_called = false
  let target = @nostd.Object::new()
  let proxy = Proxy::new(@nostd.any(target), setPrototypeOf=fn(
    _target,
    _proto,
  ) {
    set_proto_called = true
    true
  })
  let new_proto = @nostd.Object::new()
  let object_class = @global.global_this()._get("Object")
  object_class.call2("setPrototypeOf", proxy.as_any(), new_proto) |> ignore
  inspect(set_proto_called, content="true")
}

///|
test "Proxy with isExtensible trap" {
  let target = @nostd.Object::new()
  // Make target non-extensible first to match trap result
  let object_class = @global.global_this()._get("Object")
  object_class.call1("preventExtensions", @nostd.any(target)) |> ignore
  let proxy = Proxy::new(@nostd.any(target), isExtensible=fn(_target) { false })
  let extensible : Bool = @nostd.identity(
    object_class.call1("isExtensible", proxy.as_any()),
  )
  inspect(extensible, content="false")
}

///|
test "Proxy with preventExtensions trap" {
  let mut prevent_called = false
  let target = @nostd.Object::new()
  let proxy = Proxy::new(@nostd.any(target), preventExtensions=fn(target_obj) {
    prevent_called = true
    // Actually prevent extensions on target
    let object_class = @global.global_this()._get("Object")
    let target_as_obj : @js.Object = target_obj.cast()
    object_class.call1("preventExtensions", target_as_obj.to_any()) |> ignore
    true
  })
  let object_class = @global.global_this()._get("Object")
  object_class.call1("preventExtensions", proxy.as_any()) |> ignore
  inspect(prevent_called, content="true")
}

///|
test "Proxy with getOwnPropertyDescriptor trap" {
  let target = @nostd.Object::new()
  target.set("x", 42)
  let proxy = Proxy::new(@nostd.any(target), getOwnPropertyDescriptor=fn(
    _target,
    _prop,
  ) {
    let descriptor = @nostd.Object::new()
    descriptor.set("value", 999)
    descriptor.set("writable", true)
    descriptor.set("enumerable", true)
    descriptor.set("configurable", true)
    @nostd.any(descriptor)
  })
  let object_class = @global.global_this()._get("Object")
  let descriptor = object_class.call2(
    "getOwnPropertyDescriptor",
    proxy.as_any(),
    @nostd.any("x"),
  )
  let value : Int = @nostd.identity(descriptor._get("value"))
  inspect(value, content="999")
}

///|
test "Proxy with defineProperty trap" {
  let mut define_called = false
  let target = @nostd.Object::new()
  let proxy = Proxy::new(@nostd.any(target), defineProperty=fn(
    target_obj,
    prop,
    descriptor,
  ) {
    define_called = true
    let obj : @js.Object = target_obj.cast()
    let key : String = @nostd.identity(prop)
    let val : Int = @nostd.identity(descriptor["value"])
    obj.to_any()._set(key, @nostd.any(val))
    true
  })
  let descriptor = @nostd.Object::new()
  descriptor.set("value", 123)
  descriptor.set("writable", true)
  let object_class = @global.global_this()._get("Object")
  let proxy_obj : @js.Object = @nostd.identity(proxy)
  object_class._call("defineProperty", [
    proxy_obj.to_any(),
    @nostd.any("newProp"),
    @nostd.any(descriptor),
  ])
  |> ignore
  inspect(define_called, content="true")
  let value : Int = @nostd.identity(target._get("newProp"))
  inspect(value, content="123")
}
