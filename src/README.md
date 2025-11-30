# mizchi/js - Core Package

Core JavaScript FFI bindings package. This is the foundation package that provides:

- Core FFI operations (`get`, `set`, `call`, `cast`, etc.)
- JavaScript built-in types (Object, Array, Promise, Function, Error, etc.)
- Async helpers (run_async, suspend, sleep, promisify)
- Type conversion utilities

## Installation

```bash
moon add mizchi/js
```

Add to your `moon.pkg.json`:

```json
{
  "import": ["mizchi/js"]
}
```

## Basic Usage

### Core FFI Operations

```moonbit
// Create objects
let obj = @js.Object::new()
obj.set("name", "Alice")
obj.set("age", 30)

// Get properties
let name = obj.get("name")  // Returns @js.Any
let age: Int = obj.get("age").cast()  // Type-safe casting

// Call methods
let has_name: Bool = obj.call("hasOwnProperty", ["name"]).cast()

// Create from map
let obj2 = @js.from_map({ "x": @js.any(10), "y": @js.any(20) })
```

### Type Casting

```moonbit
// Using cast() method (recommended)
let value: Int = js_value.cast()
let str: String = js_value.cast()

// Using identity() for low-level FFI
let value: Int = @js.identity(js_value)

// Optional types
let nullable: Int? = @js.identity_option(js_value)
```

### Promises and Async

```moonbit
// Create and use promises
let promise = @js.Promise::resolve(42)
promise.then_(fn(value) {
  @console.log(value)
})

// Async/await
async fn example() -> Int {
  let promise = @js.Promise::resolve(42)
  let value = promise.wait()
  value
}

// Run async code
@js.run_async(async fn() {
  let value = some_promise.wait()
  @console.log(value)
})
```

### Async Helpers

```moonbit
// Sleep
async fn delayed() -> Unit {
  @js.sleep(1000)  // Sleep for 1 second
  @console.log("Delayed!")
}

// Promisify callbacks
let async_fn = async fn(x: Int) -> String {
  @js.sleep(100)
  x.to_string()
}
let promise_fn = @js.promisify1(async_fn)
let promise = promise_fn(42)  // Returns Promise[String]
```

### Arrays

```moonbit
// Create arrays
let arr = @js.JsArray::new()
arr.push(1)
arr.push(2)
arr.push(3)

// Array operations
let length = arr.length()
let first = arr.get(0)
arr.set(1, 42)

// From MoonBit Array
let mbt_arr = [1, 2, 3]
let js_arr = @js.JsArray::from_array(mbt_arr)
```

### Error Handling

```moonbit
// Create errors
let err = @js.Error::new("Something went wrong")

// Throw errors (use in FFI functions marked with `raise`)
fn example() -> Int raise {
  fail("Error message")
}

// Catch errors in async
async fn safe_operation() -> Unit {
  try {
    let result = risky_operation().wait()
    @console.log(result)
  } catch {
    e => @console.error("Error: " + e.to_string())
  }
}
```

### JSON Operations

```moonbit
// Parse JSON
let json_str = "{\"name\":\"Alice\",\"age\":30}"
let obj = @js.JSON::parse(json_str)

// Stringify
let obj = @js.from_map({ "name": @js.any("Alice"), "age": @js.any(30) })
let json_str = @js.JSON::stringify(obj)

// With formatting
let pretty = @js.JSON::stringify_with_indent(obj, 2)
```

### Nullish Handling

```moonbit
// Nullish[T] handles both null and undefined
let nullish: @js.Nullish[Int] = @js.null()

match nullish.to_option() {
  Some(value) => @console.log(value)
  None => @console.log("null or undefined")
}

// Nullable[T] only handles null
let nullable: @js.Nullable[Int] = @js.Nullable::null()
```

### Iterators

```moonbit
// JavaScript iterator
let iter = js_array.values()
loop {
  let next = iter.next()
  if next.done {
    break
  }
  @console.log(next.value)
}

// Async iterator
async fn iterate_async(iter: @js.AsyncIterator) -> Unit {
  loop {
    let next = iter.next().wait()
    if next.done {
      break
    }
    @console.log(next.value)
  }
}
```

## Understanding Core FFI Types

When reading test code or using this library, you'll encounter several core types and functions for bridging MoonBit and JavaScript. This section explains what they are and when to use them.

### `@js.Any` - The Universal JavaScript Type

`@js.Any` represents any JavaScript value (similar to TypeScript's `any`). It's the foundation type for all JavaScript interop.

```moonbit
// @js.Any can hold any JavaScript value
let num : @js.Any = @js.any(42)        // number
let str : @js.Any = @js.any("hello")   // string
let obj : @js.Any = @js.Object::new()  // object
```

**When you see `@js.Any` in code**: This value came from JavaScript and its type is unknown at compile time.

### `@js.any()` - Converting MoonBit Values to JavaScript

`@js.any()` converts MoonBit values that implement `JsImpl` trait to `@js.Any`.

```moonbit
// Convert MoonBit values to JavaScript
let js_int = @js.any(42)           // Int → @js.Any
let js_str = @js.any("hello")      // String → @js.Any
let js_bool = @js.any(true)        // Bool → @js.Any
let js_arr = @js.any([1, 2, 3])    // Array → @js.Any
```

**When to use**: When passing MoonBit values to JavaScript APIs that expect dynamic types.

### `@js.identity()` - Unsafe Type Casting

`@js.identity()` performs an unsafe cast between any two types. It's used to convert `@js.Any` back to typed MoonBit values.

```moonbit
// Cast @js.Any to specific types (unsafe!)
let js_value : @js.Any = obj.get("count")
let count : Int = @js.identity(js_value)

// Common pattern: inline casting
let name : String = @js.identity(obj.get("name"))
```

**Warning**: `@js.identity()` does no runtime checking. If the JavaScript value isn't the expected type, you'll get undefined behavior.

**Alternative**: Use `.cast()` method which is equivalent but more readable:
```moonbit
let count : Int = obj.get("count").cast()
```

### `JsImpl` Trait - Types That Can Interop with JavaScript

`JsImpl` is a trait for types that can be safely converted to JavaScript values. All JavaScript wrapper types and MoonBit primitives implement this trait.

```moonbit
// These types implement JsImpl:
// - @js.Any, @js.Object, @js.JsArray, @js.Promise[T], etc.
// - MoonBit primitives: String, Int, Double, Bool, etc.
// - Array[T] where T : JsImpl

// JsImpl provides these methods:
trait JsImpl {
  as_any(Self) -> Any           // Convert to @js.Any
  get(Self, key) -> Any         // JS: self[key]
  set(Self, key, val) -> Unit   // JS: self[key] = val
  call(Self, key, args) -> Any  // JS: self[key](...args)
  // ... and more
}
```

**When you see `&JsImpl` in function signatures**: The function accepts any type that can be converted to JavaScript.

### Common Patterns in Test Code

#### Pattern 1: Getting typed values from JavaScript objects

```moonbit
// JavaScript: const name = obj.name
let name : String = @js.identity(obj.get("name"))

// Alternative using cast()
let age : Int = obj.get("age").cast()
```

#### Pattern 2: Creating JavaScript objects with MoonBit values

```moonbit
// Using from_map (recommended)
let obj = @js.from_map({
  "name": @js.any("Alice"),
  "age": @js.any(30)
})

// Manual construction
let obj = @js.Object::new()
obj.set("name", "Alice")  // String implements JsImpl
obj.set("age", 30)        // Int implements JsImpl
```

#### Pattern 3: Handling nullable/optional values

```moonbit
// JavaScript null/undefined → MoonBit Option
let maybe_value : Int? = @js.identity_option(obj.get("optional_field"))

// MoonBit Option → JavaScript null
let js_value = @js.from_option(Some(42))  // → 42
let js_null = @js.from_option(None)       // → null
```

#### Pattern 4: Calling JavaScript methods

```moonbit
// No arguments: obj.method()
let result = obj.call0("method")

// With arguments: obj.method(arg1, arg2)
let result = obj.call("method", [arg1, arg2])

// With type casting
let str_result : String = obj.call0("toString").cast()
```

### Summary Table

| Function/Type | Purpose | Example |
|---------------|---------|---------|
| `@js.Any` | Universal JS value type | `let v : @js.Any = ...` |
| `@js.any(x)` | MoonBit → JS conversion | `@js.any(42)` |
| `@js.identity(x)` | Unsafe type cast | `let n : Int = @js.identity(v)` |
| `.cast()` | Same as identity (method) | `v.cast()` |
| `JsImpl` | Trait for JS-compatible types | `fn foo(x : &JsImpl)` |
| `.as_any()` | Convert to @js.Any | `obj.as_any()` |
| `.get(key)` | Property access | `obj.get("name")` |
| `.set(key, val)` | Property assignment | `obj.set("age", 30)` |

## Advanced Patterns

### Escape Hatch Pattern

When you need to access JavaScript APIs not yet wrapped in this library:

```moonbit
// Define external FFI function
extern "js" fn ffi_my_custom_api(arg: @js.Any) -> @js.Any =
  #|arg => {
  #|  // JavaScript code here
  #|  return arg.customMethod();
  #|}

// Wrap it in a type-safe function
pub fn my_custom_api(value: String) -> String {
  let result = ffi_my_custom_api(value)
  result.cast()
}
```

See [escape_hatch.mbt.md](examples/escape_hatch.mbt.md) for more patterns.

## Type Reference

### Core Types

- `@js.Any` - Universal JavaScript value type (was `@js.Js` before v0.5.0)
- `@js.Object` - JavaScript object
- `@js.JsArray` - JavaScript array
- `@js.Promise[T]` - JavaScript Promise
- `@js.Function` - JavaScript function
- `@js.Error` - JavaScript Error

### Nullish Types

- `@js.Nullish[T]` - Handles both null and undefined (converts to `Option[T]`)
- `@js.Nullable[T]` - Handles only null
- `@js.Undefinedable[T]` - Handles only undefined

### Binary Data

See `mizchi/js/builtins/arraybuffer` and `mizchi/js/builtins/typedarray` packages.

## Related Packages

This core package is used by:

- `mizchi/js/web/*` - Web Standard APIs
- `mizchi/js/browser/*` - Browser DOM APIs
- `mizchi/js/node/*` - Node.js runtime APIs
- `mizchi/js/cloudflare/*` - Cloudflare Workers APIs
- `mizchi/js/npm/*` - NPM package bindings

See the main [project README](../README.md) for the complete package list.

## Migration from v0.4.0

### Breaking Changes in v0.5.0

```moonbit
// Type rename: @js.Js → @js.Any
let value: @js.Any = obj.get("key")

// Method rename: to_js() → as_any()
let any = obj.as_any()

// Function rename: @js.js() → @js.any()
let converted = @js.any(value)

// Casting: unsafe_cast() → identity() or cast()
let typed: Int = value.cast()
```

## Contributing

See the main project documentation for contribution guidelines.
