# Escape Hatch: Accessing Unsupported JavaScript APIs

When `mizchi/js` doesn't provide a wrapper for a JavaScript API you need, use these patterns as an escape hatch.

## Pattern: Accessing Missing Properties

```moonbit nocheck
///|
test "access globalThis properties" {
  // Access global object
  let global = @core.global_this()

  // Check if Math exists
  let math = global._get("Math")
  assert_eq(@js.is_undefined(math), false)

  // Get Math.PI
  let pi : Double = @js.identity(math._get("PI"))
  inspect(pi, content="3.141592653589793")
}
```

## Pattern: Calling Missing Methods

```moonbit nocheck
///|
test "call methods with call()" {
  let obj = @core.new_object()
  obj._set("value", 42 |> @core.any)

  // call0 - no arguments
  let str = obj._call("toString", [])
  inspect(str, content="[object Object]")

  // call1 - one argument
  let has : Bool = @core.identity(
    obj._call("hasOwnProperty", ["value" |> @core.any]),
  )
  assert_eq(has, true)

  // call - variable arguments
  let arr = @core.any([1, 2, 3])
  let joined : String = @core.identity(arr._call("join", ["-" |> @core.any]))
  inspect(joined, content="1-2-3")
}
```

## Pattern: Checking API Availability

```moonbit nocheck
///|
test "feature detection" {
  // Check if Math exists
  let math = @core.global_this()._get("Math")
  let has_math = !@js.is_undefined(math)
  assert_eq(has_math, true)

  // Check if a fictional API exists
  let fake_api = @core.global_this()._get("FakeAPI12345")
  let has_fake = !@js.is_undefined(fake_api)
  assert_eq(has_fake, false)
}
```

## Pattern: Accessing Nested Properties

```moonbit nocheck
///|
test "nested property access" {
  // Create nested structure
  let obj = @core.new_object()
  let config = @core.new_object()
  let api = @core.new_object()
  api._set("endpoint", @core.any("https://api.example.com"))
  config._set("api", api)
  obj._set("config", config)

  // Chain ._get() calls for nested access
  let endpoint : String = @js.identity(
    obj._get("config")._get("api")._get("endpoint"),
  )
  assert_eq(endpoint, "https://api.example.com")
}
```

## Pattern: Safe Nested Access

```moonbit nocheck
///|
test "safe nested access with undefined checks" {
  let obj = @core.new_object()

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

```moonbit nocheck
///|
test "error handling with throwable" {
  let result = @js.throwable(fn() -> @core.Any {
    // Risky JS operation
    let obj = @core.new_object()
    obj._set("value", @core.any(42))
    obj
  }) catch {
    _ => @js.undefined()
  }
  assert_eq(@js.is_undefined(result), false)
}
```

## Pattern: Creating Instances with new_

```moonbit nocheck
///|
test "create instances of unsupported classes" {
  // Access constructor from globalThis
  let map_constructor = @core.global_this()._get("Map")
  let map = @core.new(map_constructor, [])

  // Use methods via call()
  map._call("set", ["key" |> @core.any, "value" |> @core.any]) |> ignore
  let value = map._call("get", ["key" |> @core.any])
  inspect(value, content="value")
  let size : Int = @js.identity(map._get("size"))
  assert_eq(size, 1)
}
```

## Summary

| Pattern | Use Case |
|---------|----------|
| `globalThis()._get("API")` | Access any global API |
| `obj._call(method, args)` | Call any method |
| `@js.identity(val)` | Cast to MoonBit type |
| `@js.is_undefined(val)` | Check if property exists |
| `@core.new(ctor, args)` | Create instance of any class |
| `@js.throwable(fn)` | Handle JS exceptions |
