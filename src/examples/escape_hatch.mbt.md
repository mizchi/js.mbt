# Escape Hatch: Accessing Unsupported JavaScript APIs

When `mizchi/js` doesn't provide a wrapper for a JavaScript API you need, use these patterns as an escape hatch.

## Pattern: Accessing Missing Properties

```moonbit

///|
test "access globalThis properties" {
  // Access global object
  let global = @nostd.global_this()

  // Check if Math exists
  let math = global._get("Math")
  assert_eq(@js.is_undefined(math), false)

  // Get Math.PI
  let pi : Double = @js.identity(math._get("PI"))
  inspect(pi, content="3.141592653589793")
}
```

## Pattern: Calling Missing Methods

```moonbit

///|
test "call methods with call()" {
  let obj = @nostd.Object::new()
  obj._set("value", 42 |> @nostd.any)

  // call0 - no arguments
  let str = obj._call("toString", [])
  inspect(str, content="[object Object]")

  // call1 - one argument
  let has : Bool = @js.identity(obj._call("hasOwnProperty", ["value" |> @nostd.any]))
  assert_eq(has, true)

  // call - variable arguments
  let arr = @js.JsArray::from([1, 2, 3])
  let joined : String = @js.identity(arr._call("join", ["-"]))
  inspect(joined, content="1-2-3")
}
```

## Pattern: Checking API Availability

```moonbit

///|
test "feature detection" {
  // Check if Math exists
  let math = @js.globalThis()._get("Math")
  let has_math = !@js.is_undefined(math)
  assert_eq(has_math, true)

  // Check if a fictional API exists
  let fake_api = @js.globalThis()._get("FakeAPI12345")
  let has_fake = !@js.is_undefined(fake_api)
  assert_eq(has_fake, false)
}
```

## Pattern: Accessing Nested Properties

```moonbit

///|
test "nested property access" {
  // Create nested structure
  let obj = @nostd.Object::new()
  let config = @nostd.Object::new()
  let api = @nostd.Object::new()
  api.set("endpoint", "https://api.example.com")
  config.set("api", api)
  obj.set("config", config)

  // Chain ._get() calls for nested access
  let endpoint : String = @js.identity(
    obj._get("config")._get("api")._get("endpoint"),
  )
  assert_eq(endpoint, "https://api.example.com")
}
```

## Pattern: Safe Nested Access

```moonbit

///|
test "safe nested access with undefined checks" {
  let obj = @nostd.Object::new()

  // Check each level before accessing
  let config = obj._get("config")
  if @js.is_undefined(config) {
    inspect("Config not found", content="Config not found")
  } else {
    let api = config._get("api")
    if !@js.is_undefined(api) {
      let _ = api._get("endpoint")

    }
  }
}
```

## Pattern: Error Handling with throwable

```moonbit

///|
test "error handling with throwable" {
  let result = @js.throwable(fn() -> @nostd.Any {
    // Risky JS operation
    let obj = @nostd.Object::new()
    obj.set("value", 42)
    obj.as_any()
  }) catch {
    _ => @js.undefined()
  }
  assert_eq(@js.is_undefined(result), false)
}
```

## Pattern: Creating Instances with new_

```moonbit

///|
test "create instances of unsupported classes" {
  // Access constructor from globalThis
  let map_constructor = @js.globalThis()._get("Map")
  let map = @js.new_(map_constructor, [])

  // Use methods via call()
  map._call("set", ["key", "value"]) |> ignore
  let value = map.call1("get", "key")
  inspect(value, content="value")
  let size : Int = @js.identity(map._get("size"))
  assert_eq(size, 1)
}
```

## Summary

| Pattern | Use Case |
|---------|----------|
| `globalThis()._get("API")` | Access any global API |
| `obj.call0/call1/call()` | Call any method |
| `@js.identity(val)` | Cast to MoonBit type |
| `@js.is_undefined(val)` | Check if property exists |
| `@js.new_(ctor, args)` | Create instance of any class |
| `@js.throwable(fn)` | Handle JS exceptions |
