# Escape Hatch: Working with Missing APIs

Executable examples demonstrating how to use `Js` type to access JavaScript APIs not yet in the library.

For full documentation, see [docs/user-escape-hatch.md](../../docs/user-escape-hatch.md).

## Core Operations

```moonbit

///|
test "basic js operations" {
  let obj = @js.Object::new()

  // Set property
  obj.set("name", "value")

  // Get property
  let name = obj.get("name")
  inspect(name, content="value")

  // Has property
  assert_eq(obj.hasOwnProperty("name"), true)

  // Delete property
  obj.delete("name")
  assert_eq(obj.hasOwnProperty("name"), false)
}
```

## Pattern: Accessing Missing Properties

```moonbit

///|
test "access globalThis properties" {
  // Access global object
  let global = @js.globalThis()

  // Check if Math exists
  let math = global.get("Math")
  assert_eq(@js.is_undefined(math), false)

  // Get Math.PI
  let pi : Double = @js.identity(math.get("PI"))
  inspect(pi, content="3.141592653589793")
}
```

## Pattern: Calling Missing Methods

```moonbit

///|
test "call methods with call()" {
  let obj = @js.Object::new()
  obj.set("value", 42)

  // Call toString()
  let str = obj.call0("toString")
  inspect(str, content="[object Object]")

  // Call hasOwnProperty
  let has : Bool = @js.identity(obj.call1("hasOwnProperty", "value"))
  assert_eq(has, true)
}
```

## Pattern: Building Complex Options

```moonbit

///|
test "build options object" {
  let options = @js.Object::new()
  options.set("method", "POST")
  options.set("mode", "cors")

  // Nested headers object
  let headers = @js.Object::new()
  headers.set("Content-Type", "application/json")
  headers.set("Accept", "application/json")
  options.set("headers", headers)
  inspect(
    options.to_any(),
    content=(
      #|{"method":"POST","mode":"cors","headers":{"Content-Type":"application/json","Accept":"application/json"}}
    ),
  )
  assert_eq(options.hasOwnProperty("method"), true)
  assert_eq(options.hasOwnProperty("headers"), true)
}
```

## Pattern: Working with Arrays

```moonbit

///|
test "array methods via call()" {
  let arr = @js.JsArray::from([1, 2, 3, 4, 5])

  // Use filter
  let filter_fn = fn(x : @js.Any) -> Bool {
    let num : Int = @js.identity(x)
    num > 2
  }
  let filtered = arr.call1("filter", @js.from_fn1(filter_fn))
  inspect(filtered, content="[3,4,5]")

  // Use map
  let map_fn = fn(x : @js.Any) -> @js.Any {
    let num : Int = @js.identity(x)
    @js.js(num * 2)
  }
  let mapped = arr.call1("map", @js.from_fn1(map_fn))
  inspect(mapped, content="[2,4,6,8,10]")
}
```

## Pattern: Using Set

```moonbit

///|
test "working with Set" {
  let set_class = @js.globalThis().get("Set")
  let set = @js.new_(set_class, [])

  // Add values
  set.call1("add", 1) |> ignore
  set.call1("add", 2) |> ignore
  set.call1("add", 1) |> ignore // Duplicate

  // Check size
  let size : Int = @js.identity(set.get("size"))
  assert_eq(size, 2)

  // Check has
  let has_one : Bool = @js.identity(set.call1("has", 1))
  assert_eq(has_one, true)
  let has_three : Bool = @js.identity(set.call1("has", 3))
  assert_eq(has_three, false)
}
```

## Pattern: Checking API Availability

```moonbit

///|
test "feature detection" {
  // Check if Math exists
  let math = @js.globalThis().get("Math")
  let has_math = !@js.is_undefined(math)
  assert_eq(has_math, true)

  // Check if a fictional API exists
  let fake_api = @js.globalThis().get("FakeAPI12345")
  let has_fake = !@js.is_undefined(fake_api)
  assert_eq(has_fake, false)
}
```

## Pattern: Accessing Nested Properties

```moonbit

///|
test "nested property access" {
  // Create nested structure
  let obj = @js.Object::new()
  let config = @js.Object::new()
  let api = @js.Object::new()
  api.set("endpoint", "https://api.example.com")
  config.set("api", api)
  obj.set("config", config)

  // Access nested value
  let endpoint : String = @js.identity(
    obj.get("config").get("api").get("endpoint"),
  )
  assert_eq(endpoint, "https://api.example.com")
}
```

## Pattern: Safe Nested Access

```moonbit

///|
test "safe nested access with checks" {
  let obj = @js.Object::new()

  // Try to access missing nested property
  let config = obj.get("config")
  if @js.is_undefined(config) {
    // Return early or use default
    inspect("Config not found", content="Config not found")
  } else {
    let api = config.get("api")
    if !@js.is_undefined(api) {
      let _ = api.get("endpoint")

    }
  }

  // Demonstrate successful case
  let obj2 = @js.Object::new()
  let config2 = @js.Object::new()
  config2.set("value", 42)
  obj2.set("config", config2)
  let cfg = obj2.get("config")
  assert_eq(@js.is_undefined(cfg), false)
}
```

## Pattern: Type Conversion Helpers

```moonbit

///|
test "type conversion helpers" {
  // from_array
  let moonbit_arr = [1, 2, 3]
  let js_arr = @js.from_array(moonbit_arr)
  inspect(js_arr, content="[1,2,3]")

  // from_map
  let moonbit_map = Map::new()
  moonbit_map.set("x", @js.js(10))
  moonbit_map.set("y", @js.js(20))
  let js_obj = @js.from_map(moonbit_map)
  let expected =
    #|{"x":10,"y":20}
  inspect(js_obj.to_any(), content=expected)

  // js() for basic types
  let num_js = @js.js(42)
  let str_js = @js.js("hello")
  let bool_js = @js.js(true)
  let num : Int = @js.identity(num_js)
  let str : String = @js.identity(str_js)
  let bool : Bool = @js.identity(bool_js)
  assert_eq(num, 42)
  assert_eq(str, "hello")
  assert_eq(bool, true)
}
```

## Pattern: Function Conversion

```moonbit

///|
test "function conversion with from_fn" {
  // from_fn0 - no arguments
  let fn0 = @js.from_fn0(fn() -> Int { 42 })
  let result0 : Int = @js.identity(fn0.call_self0())
  assert_eq(result0, 42)

  // from_fn1 - one argument
  let fn1 = @js.from_fn1(fn(x : Int) -> Int { x * 2 })
  let result1 : Int = @js.identity(fn1.call_self([10]))
  assert_eq(result1, 20)

  // from_fn2 - two arguments
  let fn2 = @js.from_fn2(fn(a : Int, b : Int) -> Int { a + b })
  let result2 : Int = @js.identity(fn2.call_self([5, 3]))
  assert_eq(result2, 8)
}
```

## Pattern: Type Checking

```moonbit

///|
test "type checking utilities" {
  let obj = @js.Object::new()
  let arr = @js.JsArray::new()
  let undef = @js.undefined()
  let num = @js.js(42)

  // is_undefined
  assert_eq(@js.is_undefined(undef), true)
  assert_eq(@js.is_undefined(obj), false)

  // is_object
  assert_eq(@js.is_object(obj), true)
  assert_eq(@js.is_object(num), false)

  // is_array
  assert_eq(@js.is_array(arr), true)
  assert_eq(@js.is_array(obj), false)

  // typeof_
  let num_type = @js.typeof_(num)
  inspect(num_type, content="number")
  let obj_type = @js.typeof_(obj)
  inspect(obj_type, content="object")
}
```

## Pattern: instanceof Check

```moonbit

///|
test "instanceof checking" {
  let arr = @js.JsArray::new()
  let array_constructor = @js.globalThis().get("Array")
  assert_eq(@js.instanceof_(arr.to_any(), array_constructor), true)
  let obj = @js.Object::new()
  assert_eq(@js.instanceof_(obj.to_any(), array_constructor), false)
}
```

## Pattern: Error Handling with throwable

```moonbit

///|
test "error handling with throwable" {
  // Simulate a risky operation
  let result = @js.throwable(fn() -> @js.Any {
    let obj = @js.Object::new()
    obj.set("value", 42)
    obj.to_any()
  }) catch {
    _ => @js.undefined()
  }
  assert_eq(@js.is_undefined(result), false)
}
```

## Pattern: Constructors with new_

```moonbit

///|
test "create instances with new_" {
  // Create Map instance
  let map_constructor = @js.globalThis().get("Map")
  let map = @js.new_(map_constructor, [])

  // Use Map methods
  map.call("set", ["key", "value"]) |> ignore
  let value = map.call1("get", "key")
  inspect(value, content="value")

  // Check size
  let size : Int = @js.identity(map.get("size"))
  assert_eq(size, 1)
}
```

## Best Practices Summary

```moonbit

///|
test "best practices demonstration" {
  // 1. Immediate type casting
  let obj = @js.Object::new()
  obj.set("count", 5)
  let count : Int = @js.identity(obj.get("count")) // Good: immediate cast
  assert_eq(count, 5)

  // 2. Check for undefined
  let maybe_value = obj.get("missing")
  if @js.is_undefined(maybe_value) {
    // Handle missing case
    inspect("Value is missing", content="Value is missing")
  }

  // 3. Use specific types when possible
  let arr = @js.JsArray::from([1, 2, 3]) // Better than generic Js
  assert_eq(@js.JsArray::isArray(arr), true)
}
```

## Summary

These patterns show how to:
- Access any JavaScript API using `get()`, `set()`, `call()`
- Work with arrays, objects, and collections
- Build complex configuration objects
- Check for API availability
- Handle undefined/null safely
- Convert between MoonBit and JavaScript types
- Use constructors and instanceof
- Handle errors with `throwable`

For complete documentation, see [docs/user-escape-hatch.md](../../docs/user-escape-hatch.md).
