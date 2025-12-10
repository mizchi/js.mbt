# mizchi/js - Core Package

Core JavaScript FFI bindings package. This is the foundation package that provides:

- Core FFI operations (`_get`, `_set`, `_call`, `cast`, etc.)
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

```mbt test
// Create objects
let obj = @core.new_object()
obj["name"] = @core.any("Alice")
obj["age"] = @core.any(25)

// Get properties
let name : String = obj["name"].cast()
let age : Int = obj["age"].cast()
inspect(name, content="Alice")
inspect(age, content="25")

// Call methods
let has_name : Bool = obj._call("hasOwnProperty", [@core.any("name")]).cast()
inspect(has_name, content="true")

// Create from entries
let obj2 = @core.from_entries([("x", @core.any(10)), ("y", @core.any(20))])
let x : Int = obj2["x"].cast()
inspect(x, content="10")
```

### Type Casting

```mbt test
// Using cast() method (recommended)
let js_value : @core.Any = @core.any(42)
let value : Int = js_value.cast()
inspect(value, content="42")

// Using identity() for low-level FFI
let value2 : Int = @core.identity(js_value)
inspect(value2, content="42")

// Optional types
let nullable : Int? = @core.identity_option(@core.null())
inspect(nullable, content="None")
let some_value : Int? = @core.identity_option(@core.any(100))
inspect(some_value, content="Some(100)")
```

### JSON Operations

```mbt test
// Parse JSON
let json_str = "{\"name\":\"Alice\",\"age\":30}"
let obj = @core.json_parse(json_str)
let name : String = obj["name"].cast()
inspect(name, content="Alice")

// Stringify
let obj2 = @core.from_entries([("x", @core.any(1))])
let json_str2 = @core.json_stringify(obj2)
inspect(json_str2, content="{\"x\":1}")
```

### Nullish Handling

```mbt test
// Check nullish values
let null_val = @core.null()
let undefined_val = @core.undefined()
inspect(@core.is_nullish(null_val), content="true")
inspect(@core.is_nullish(undefined_val), content="true")
inspect(@core.is_nullish(@core.any(42)), content="false")

// identity_option for safe conversion
let maybe_null : Int? = @core.identity_option(null_val)
inspect(maybe_null, content="None")

// from_option for MoonBit Option -> JS
let js_some = @core.from_option(Some(42))
let js_none = @core.from_option((None : Int?))
inspect(@core.is_nullish(js_some), content="false")
inspect(@core.is_nullish(js_none), content="true")
```

## Understanding Core FFI Types

### `@core.Any` - The Universal JavaScript Type

`@core.Any` represents any JavaScript value (similar to TypeScript's `any`). It's the foundation type for all JavaScript interop.

```mbt test
// @core.Any can hold any JavaScript value
let num : @core.Any = @core.any(42)
let str : @core.Any = @core.any("hello")
let obj : @core.Any = @core.new_object()
inspect(@core.typeof_(num), content="number")
inspect(@core.typeof_(str), content="string")
inspect(@core.typeof_(obj), content="object")
```

### `@core.any()` - Converting MoonBit Values to JavaScript

`@core.any()` converts MoonBit values to `@core.Any`.

```mbt test
// Convert MoonBit values to JavaScript
let js_int = @core.any(42)
let js_str = @core.any("hello")
let js_bool = @core.any(true)
let int_val : Int = js_int.cast()
let str_val : String = js_str.cast()
let bool_val : Bool = js_bool.cast()
inspect(int_val, content="42")
inspect(str_val, content="hello")
inspect(bool_val, content="true")
```

### Common Patterns

#### Pattern 1: Getting typed values from JavaScript objects

```mbt test
let obj = @core.from_entries([
  ("name", @core.any("Alice")),
  ("age", @core.any(30)),
])

// Using cast()
let name : String = obj["name"].cast()
let age : Int = obj["age"].cast()
inspect(name, content="Alice")
inspect(age, content="30")
```

#### Pattern 2: Handling nullable/optional values

```mbt test
let obj = @core.from_entries([("name", @core.any("Alice"))])

// Existing field
let name : String? = @core.identity_option(obj["name"])
inspect(
  name,
  content=(
    #|Some("Alice")
  ),
)

// Missing field returns undefined
let missing : String? = @core.identity_option(obj["missing"])
inspect(missing, content="None")
```

#### Pattern 3: Calling JavaScript methods

```mbt test
let arr = @core.any([1, 2, 3])

// Call method with arguments
let joined : String = arr._call("join", [@core.any("-")]).cast()
inspect(joined, content="1-2-3")

// Get property
let length : Int = arr["length"].cast()
inspect(length, content="3")
```

### TypeOf[T] - JavaScript Constructor Type

`TypeOf[T]` represents a JavaScript constructor/class, similar to TypeScript's `typeof ClassName`.

```mbt check
///|
extern "js" fn get_array_constructor() -> @core.TypeOf[Array[Int]] =
  #| () => Array

///|
test "TypeOf usage" {
  let arr_ctor = get_array_constructor()

  // Create instance using constructor
  let arr : Array[Int] = @core.new_instance(arr_ctor, [])
  inspect(arr.length(), content="0")

  // instanceof check
  let js_arr = @core.any([1, 2, 3])
  inspect(arr_ctor.is_instanceof(js_arr), content="true")
  inspect(arr_ctor.is_instanceof(@core.any("not array")), content="false")
}
```

## Summary Table

| Function/Type | Purpose | Example |
|---------------|---------|---------|
| `@core.Any` | Universal JS value type | `let v : @core.Any = ...` |
| `@core.any(x)` | MoonBit -> JS conversion | `@core.any(42)` |
| `@core.identity(x)` | Unsafe type cast | `let n : Int = @core.identity(v)` |
| `.cast()` | Same as identity (method) | `v.cast()` |
| `._get(key)` / `[key]` | Property access | `obj["name"]` |
| `._set(key, val)` / `[key]=` | Property assignment | `obj["age"] = @core.any(30)` |
| `._call(method, args)` | Method call | `obj._call("toString", [])` |
| `TypeOf[T]` | Constructor type | `TypeOf[Date]` |

## Related Packages

This core package is used by:

- `mizchi/js/web/*` - Web Standard APIs
- `mizchi/js/browser/*` - Browser DOM APIs
- `mizchi/js/node/*` - Node.js runtime APIs
- [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) - NPM package bindings (React, Hono, AI SDK, etc.)

See the main [project README](../README.md) for the complete package list.
