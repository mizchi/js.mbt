# @core - MoonBit/JavaScript Interop Core

`@core` is a minimal utility package for binding MoonBit objects to JavaScript objects. This package contains only the essential types and functions for JS interop, **without** JavaScript built-in APIs.

## Package Responsibility

**Core responsibility**: Provide minimal, zero-cost utilities for MoonBit ↔ JavaScript object binding.

This package includes:
- ✅ Type casting functions (`identity`, `any`, `cast`)
- ✅ Core binding types (`Any`, `Nullable`, `Nullish`, `Promise`)
- ✅ Basic type checking (`typeof_`, `instanceof_`)
- ✅ Property access and method calls (`_get`, `_set`, `_call`)
- ✅ Object and array creation (`new_object`, `new_array`)
- ✅ Function conversion (`from_fn0`, `from_fn1`, etc.)

This package does NOT include:
- ❌ JavaScript built-in APIs (use `@global`, `@math`, `@date`, etc.)
- ❌ Web APIs (use `@web/*` packages)
- ❌ Runtime-specific APIs (use `@node/*`, `@browser/*`, etc.)

## Core Types

### `Any` - Universal JavaScript Value

The fundamental type for all JavaScript values:

```moonbit
pub type Any

// Convert MoonBit value to JS
let js_val : @core.Any = @core.any(42)
let js_str : @core.Any = @core.any("hello")

// Cast back to MoonBit type
let num : Int = js_val.cast()
let str : String = js_str.cast()
```

### `Nullable[T]` - Nullable Type

Represents values that can be `null`:

```moonbit
pub type Nullable[T]

// JavaScript value that might be null
let maybe_null : @core.Nullable[Int] = get_nullable_value()

match maybe_null {
  Null => @console.log("Got null")
  NotNull(value) => @console.log(value)
}
```

### `Nullish[T]` - Nullish Type

Represents values that can be `null` or `undefined`:

```moonbit
pub type Nullish[T]

// JavaScript value that might be null or undefined
let maybe_nullish : @core.Nullish[String] = get_nullish_value()

match maybe_nullish {
  Nullish => @console.log("Got null or undefined")
  NotNullish(value) => @console.log(value)
}
```

### `Promise[T]` - Promise Type

JavaScript Promise wrapper:

```moonbit
pub type Promise[T]

// Create promises
let p = @core.Promise::resolve(42)
let q = @core.Promise::reject("error")

// Wait in async context
async fn example() -> Int {
  let value = p.wait()
  value
}
```

## Type Casting Functions

### `identity[A, B](value: A) -> B`

Zero-cost type casting (unsafe, use with caution):

```moonbit
// Cast between types without conversion
let js_num : @core.Any = get_js_value()
let num : Int = @core.identity(js_num)
```

### `any[T](value: T) -> Any`

Convert MoonBit value to JavaScript value:

```moonbit
let js_val = @core.any(42)
let js_str = @core.any("hello")
let js_bool = @core.any(true)
```

### `cast[A, B](value: A) -> B`

Type-safe casting with `.cast()` method:

```moonbit
let js_val : @core.Any = @core.any(42)
let num : Int = js_val.cast()  // Recommended
```

## Type Checking

```moonbit
// Check JavaScript type
@core.typeof_(value)  // "number", "string", "boolean", etc.

// Check if value is instance of constructor
@core.instanceof_(value, constructor)

// Null/undefined checks
@core.is_null(value)
@core.is_undefined(value)
@core.is_nullish(value)

// Type checks
@core.is_number(value)
@core.is_string(value)
@core.is_boolean(value)
@core.is_object(value)
@core.is_array(value)
@core.is_function(value)
```

## Property Access

```moonbit
// Get property
let name = obj._get("name")

// Set property
obj._set("name", @core.any("Alice"))

// Index access (bracket notation)
obj["key"] = @core.any(value)
let val = obj["key"]
```

## Method Calls

```moonbit
// Call method
let result = obj._call("toString", [])
let result = obj._call("method", [@core.any(arg1), @core.any(arg2)])

// Invoke function
let fn = get_function()
let result = fn._invoke([@core.any(1), @core.any(2)])
```

## Object Creation

```moonbit
// Create empty object
let obj = @core.new_object()
obj["name"] = @core.any("Alice")
obj["age"] = @core.any(30)

// Create empty array
let arr = @core.new_array()

// Create object with constructor
let date = @core.new(date_constructor, [@core.any(2025), @core.any(11), @core.any(6)])
```

## Function Conversion

Convert MoonBit functions to JavaScript functions:

```moonbit
// 0 arguments
let js_fn = @core.from_fn0(fn() -> String { "hello" })

// 1 argument
let js_fn = @core.from_fn1(fn(x: Int) -> Int { x * 2 })

// 2 arguments
let js_fn = @core.from_fn2(fn(x: Int, y: Int) -> Int { x + y })

// 3 arguments
let js_fn = @core.from_fn3(fn(x: Int, y: Int, z: Int) -> Int { x + y + z })
```

## Promise Utilities

```moonbit
// Promisify async functions
let promise_fn = @core.promisify0(async fn() -> Int { 42 })
let promise_fn = @core.promisify1(async fn(x: Int) -> Int { x * 2 })

// Run async code
@core.run_async(async fn() {
  let value = some_promise.wait()
  @console.log(value)
})

// Suspend current async context
@core.suspend(fn(resolve, reject) {
  // Async operation
  resolve(@core.any(42))
})
```

## Error Handling

```moonbit
// Try-catch for JavaScript exceptions
@core.throwable(fn() {
  potentially_throwing_code()
}) catch {
  err => @console.log("Caught error")
}
```

## Logging

```moonbit
// Console log (for debugging)
@core.log("Debug message")
@core.log(some_value)
```

## Design Principles

1. **Minimal**: Only essential interop utilities
2. **Zero-cost**: Direct FFI bindings without overhead
3. **Type-safe**: Leverage MoonBit's type system where possible
4. **Composable**: Build higher-level abstractions on top

## See Also

- **Built-in APIs**: Use `@global`, `@math`, `@date`, etc. from `mizchi/js`
- **Web APIs**: Use `@web/*` packages for fetch, WebSocket, etc.
- **Runtime APIs**: Use `@node/*`, `@browser/*`, `@deno`, `@cloudflare`

## Performance Note

This package is designed for minimal overhead. Most operations compile to direct JavaScript operations without runtime checks or conversions. For detailed performance characteristics, see [docs/runtime-cost.md](../../docs/runtime-cost.md).
