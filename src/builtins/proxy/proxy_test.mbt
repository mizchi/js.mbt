///|
test "Proxy::new with no traps (transparent proxy)" {
  let target = @core.new_object()
  target._set("name", "original" |> @core.any)
  target._set("value", 42 |> @core.any)

  // No traps creates a transparent proxy
  let proxy = Proxy::new(@core.any(target))

  // All operations pass through to target
  assert_eq(@core.identity(proxy.as_any()["name"]), "original")
  assert_eq(@core.identity(proxy.as_any()["value"]), 42)
  proxy.as_any()["name"] = @core.any("modified")
  assert_eq(@core.identity(target._get("name")), "modified")
}

///|
test "Proxy::new creates proxy object" {
  let target = @core.new_object()
  let proxy = Proxy::new(@core.any(target))
  assert_true(@core.is_object(proxy.as_any().cast()))
}

///|
test "Proxy::revocable creates revocable proxy" {
  let target = @core.new_object()
  target._set("data", "important" |> @core.any)
  let revocable = Proxy::revocable(@core.any(target))
  let proxy = revocable["proxy"]
  let revoke = revocable["revoke"]

  // Proxy works before revocation
  assert_eq(@core.identity(proxy["data"]), "important")

  // Verify revoke function exists
  assert_eq(@core.typeof_(revoke), "function")

  // Revoke the proxy
  let revoke_fn : @core.Any = revoke.cast()
  revoke_fn._invoke([]) |> ignore
}

///|
test "Proxy with target array" {
  let target = @core.any([1, 2, 3])
  let proxy = Proxy::new(@core.any(target))

  // Transparent proxy works with arrays
  assert_true(@core.is_array(proxy.as_any().cast()))
}

///|
test "Proxy with target function" {
  let target_fn = @global.global_this()._get("Math")._get("max")
  let proxy = Proxy::new(@core.any(target_fn))

  // Proxy wraps function
  assert_eq(@core.typeof_(proxy.as_any()), "function")
}

///|
test "Proxy with get trap" {
  let target = @core.new_object()
  target._set("x", 10 |> @core.any)
  target._set("y", 20 |> @core.any)
  let proxy = Proxy::new(@core.any(target), get=fn(_target, prop, _receiver) {
    let key : String = @core.identity(prop)
    if key == "x" {
      @core.any(100)
    } else {
      @core.any(200)
    }
  })
  assert_eq(@core.identity(proxy.as_any()["x"]), 100)
  assert_eq(@core.identity(proxy.as_any()["y"]), 200)
}

///|
test "Proxy with set trap" {
  let target = @core.new_object()
  let proxy = Proxy::new(@core.any(target), set=fn(
    target_obj,
    prop,
    value,
    _receiver,
  ) {
    // Only allow setting if value is a number
    if @core.typeof_(value) == "number" {
      let key : String = @core.identity(prop)
      target_obj[key] = value
      true
    } else {
      false
    }
  })
  proxy.as_any()["x"] = @core.any(42)
  assert_eq(@core.identity(target._get("x")), 42)
}

///|
test "Proxy with has trap" {
  let target = @core.new_object()
  target._set("real", "value" |> @core.any)
  let proxy = Proxy::new(@core.any(target), has=fn(_target, prop) {
    let key : String = @core.identity(prop)
    // Always return true for "fake" property
    key == "fake" || key == "real"
  })

  // Note: MoonBit doesn't have direct 'in' operator, so we test indirectly
  assert_true(@core.is_object(proxy.as_any().cast()))
}

///|
test "Proxy with multiple traps" {
  let target = @core.new_object()
  let proxy = Proxy::new(
    @core.any(target),
    get=fn(_target, _prop, _receiver) { @core.any("intercepted") },
    set=fn(target_obj, prop, value, _receiver) {
      let key : String = @core.identity(prop)
      target_obj[key] = value
      true
    },
  )
  proxy.as_any()["key"] = @core.any("original")
  // get trap returns "intercepted" instead of "original"
  assert_eq(@core.identity(proxy.as_any()["key"]), "intercepted")
}

///|
#skip("TODO: fixme")
test "Proxy with deleteProperty trap" {
  let mut delete_called = false
  let target = @core.new_object()
  target._set("x", 10 |> @core.any)
  target._set("y", 20 |> @core.any)
  let proxy = Proxy::new(target, deleteProperty=fn(target_obj, prop) {
    delete_called = true
    let key : String = @core.identity(prop)
    let obj : @core.Any = target_obj.cast()
    obj._call("delete", [@core.any(key)]) |> ignore
    true
  })
  let proxy_obj : @core.Any = proxy.as_any().cast()
  proxy_obj._call("delete", [@core.any("x")]) |> ignore
  inspect(delete_called, content="true")
  // Verify the property was actually deleted
  let x_value = target._get("x")
  inspect(@core.is_undefined(x_value), content="true")
}

///|
test "Proxy with apply trap for function" {
  let target_fn = @core.from_fn1(fn(x : @core.Any) -> @core.Any {
    let n : Int = @core.identity(x)
    @core.any(n * 2)
  })
  let proxy = Proxy::new(@core.any(target_fn), apply=fn(_target, _this, args) {
    // Intercept function call and return modified result
    let first : Int = @core.identity(args["0"])
    @core.any(first * 10)
  })
  let proxy_fn : @core.Any = proxy.as_any().cast()
  let result : Int = @core.identity(proxy_fn._invoke([@core.any(5)]))
  inspect(result, content="50")
}

///|
test "Proxy with construct trap" {
  // Create a constructor function using JS eval
  let global = @global.global_this()
  global._call("eval", [
    @core.any("globalThis.TestConstructor = function(x) { this.value = x; }"),
  ])
  |> ignore
  let constructor_fn = global._get("TestConstructor")
  let proxy = Proxy::new(@core.any(constructor_fn), construct=fn(
    _target,
    args,
    _newTarget,
  ) {
    let obj = @core.new_object()
    let first : Int = @core.identity(args["0"])
    obj._set("constructed", (first * 100) |> @core.any)
    @core.any(obj)
  })
  let instance = @core.new(proxy.as_any().cast(), [@core.any(5)])
  let value : Int = @core.identity(instance._get("constructed"))
  inspect(value, content="500")
}

///|
test "Proxy with ownKeys trap" {
  let mut ownkeys_called = false
  let target = @core.new_object()
  target._set("a", 1 |> @core.any)
  target._set("b", 2 |> @core.any)
  let proxy = Proxy::new(
    @core.any(target),
    ownKeys=fn(_target) {
      ownkeys_called = true
      // Return custom keys
      @core.any(@core.any(["x", "y", "z"]))
    },
    getOwnPropertyDescriptor=fn(_target, _prop) {
      // Need to return valid descriptor for Object.keys() to work
      @core.from_entries([
        ("value", @core.any(42)),
        ("writable", @core.any(true)),
        ("enumerable", @core.any(true)),
        ("configurable", @core.any(true)),
      ])
    },
  )
  let object_class = @global.global_this()._get("Object")
  let keys_any = object_class._call("keys", [proxy.as_any()])
  let keys : @js.JsArray = @core.identity(keys_any)
  inspect(ownkeys_called, content="true")
  let length : Int = @core.identity(keys.as_any()._get("length"))
  inspect(length, content="3")
  let first : String = @core.identity(keys.as_any()._get("0"))
  inspect(first, content="x")
}

///|
test "Proxy with getPrototypeOf trap" {
  let target = @core.new_object()
  let custom_proto = @core.new_object()
  custom_proto._set("custom", true |> @core.any)
  let proxy = Proxy::new(@core.any(target), getPrototypeOf=fn(_target) {
    @core.any(custom_proto)
  })
  let object_class = @global.global_this()._get("Object")
  let proto = object_class._call("getPrototypeOf", [proxy.as_any()])
  let has_custom : Bool = @core.identity(proto._get("custom"))
  inspect(has_custom, content="true")
}

///|
test "Proxy with setPrototypeOf trap" {
  let mut set_proto_called = false
  let target = @core.new_object()
  let proxy = Proxy::new(@core.any(target), setPrototypeOf=fn(_target, _proto) {
    set_proto_called = true
    true
  })
  let new_proto = @core.new_object()
  let object_class = @global.global_this()._get("Object")
  object_class._call("setPrototypeOf", [proxy.as_any(), new_proto]) |> ignore
  inspect(set_proto_called, content="true")
}

///|
test "Proxy with isExtensible trap" {
  let target = @core.new_object()
  // Make target non-extensible first to match trap result
  let object_class = @global.global_this()._get("Object")
  object_class._call("preventExtensions", [@core.any(target)]) |> ignore
  let proxy = Proxy::new(@core.any(target), isExtensible=fn(_target) { false })
  let extensible : Bool = @core.identity(
    object_class._call("isExtensible", [proxy.as_any()]),
  )
  inspect(extensible, content="false")
}

///|
test "Proxy with preventExtensions trap" {
  let mut prevent_called = false
  let target = @core.new_object()
  let proxy = Proxy::new(@core.any(target), preventExtensions=fn(target_obj) {
    prevent_called = true
    // Actually prevent extensions on target
    let object_class = @global.global_this()._get("Object")
    let target_as_obj : @js.Any = target_obj.cast()
    object_class._call("preventExtensions", [target_as_obj]) |> ignore
    true
  })
  let object_class = @global.global_this()._get("Object")
  object_class._call("preventExtensions", [proxy.as_any()]) |> ignore
  inspect(prevent_called, content="true")
}

///|
test "Proxy with getOwnPropertyDescriptor trap" {
  let target = @core.new_object()
  target._set("x", 42 |> @core.any)
  let proxy = Proxy::new(@core.any(target), getOwnPropertyDescriptor=fn(
    _target,
    _prop,
  ) {
    let descriptor = @core.new_object()
    descriptor._set("value", 999 |> @core.any)
    descriptor._set("writable", true |> @core.any)
    descriptor._set("enumerable", true |> @core.any)
    descriptor._set("configurable", true |> @core.any)
    @core.any(descriptor)
  })
  let object_class = @global.global_this()._get("Object")
  let descriptor = object_class._call("getOwnPropertyDescriptor", [
    proxy.as_any(),
    @core.any("x"),
  ])
  let value : Int = @core.identity(descriptor._get("value"))
  inspect(value, content="999")
}

///|
test "Proxy with defineProperty trap" {
  let mut define_called = false
  let target = @core.new_object()
  let proxy = Proxy::new(@core.any(target), defineProperty=fn(
    target_obj,
    prop,
    descriptor,
  ) {
    define_called = true
    let key : String = @core.identity(prop)
    let val : Int = @core.identity(descriptor["value"])
    target_obj._set(key, @core.any(val))
    true
  })
  let descriptor = @core.new_object()
  descriptor._set("value", 123 |> @core.any)
  descriptor._set("writable", true |> @core.any)
  let object_class = @global.global_this()._get("Object")
  let proxy_obj : @js.Any = @core.identity(proxy)
  object_class._call("defineProperty", [
    proxy_obj,
    @core.any("newProp"),
    @core.any(descriptor),
  ])
  |> ignore
  inspect(define_called, content="true")
  let value : Int = @core.identity(target._get("newProp"))
  inspect(value, content="123")
}
