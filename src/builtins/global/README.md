# @global - JavaScript Global Functions

This package provides JavaScript global functions and utilities that are available in all JavaScript environments.

## Exported Functions

### Global Objects

```moonbit
// Access globalThis
let global = @global.globalThis()

// Get undefined
let undef = @global.undefined()
```

### Type Checking

```moonbit
// Check if value is NaN
let nan_val = @core.any(0.0 / 0.0)
@global.isNaN(nan_val)  // true

// Check if value is finite
@global.isFinite(42.0)  // true
@global.isFinite(1.0 / 0.0)  // false (Infinity)
```

### Number Parsing

```moonbit
// Parse integer with optional radix
@global.parseInt("42")  // Some(42)
@global.parseInt("ff", radix=16)  // Some(255)
@global.parseInt("invalid")  // None

// Parse floating point
@global.parseFloat("3.14")  // Some(3.14)
@global.parseFloat("1.5e2")  // Some(150.0)
@global.parseFloat("invalid")  // None
```

### String Encoding (Base64)

```moonbit
// Encode to Base64
let encoded = @global.btoa("Hello World")
// "SGVsbG8gV29ybGQ="

// Decode from Base64
let decoded = @global.atob("SGVsbG8gV29ybGQ=")
// "Hello World"
```

### URI Encoding

```moonbit
// Encode complete URI
let uri = @global.encodeURI("https://example.com/path?name=John Doe")
// "https://example.com/path?name=John%20Doe"

// Decode URI
let decoded = @global.decodeURI("https://example.com/path?name=John%20Doe")
// "https://example.com/path?name=John Doe"

// Encode URI component
let encoded = @global.encodeURIComponent("Hello World & Friends")
// "Hello%20World%20%26%20Friends"

// Decode URI component
let decoded = @global.decodeURIComponent("Hello%20World%20%26%20Friends")
// "Hello World & Friends"
```

### Object Cloning

```moonbit
// Deep clone using structured clone algorithm
let obj = @core.new_object()
obj["name"] = @core.any("Alice")
obj["age"] = @core.any(30)

let cloned = @global.structuredClone(obj)
// Creates an independent deep copy
```

**Note**: `structuredClone` can clone:
- Primitive values
- Objects and arrays (nested)
- Dates, RegExp, Maps, Sets
- TypedArrays and ArrayBuffers
- Many built-in types

Cannot clone:
- Functions
- DOM nodes
- Symbols (as property keys)

### Timers

```moonbit
// Set timeout
let timer = @global.setTimeout(fn() {
  @console.log("Delayed!")
}, 1000)

// Clear timeout
@global.clearTimeout(timer)

// Set interval
let interval = @global.setInterval(fn() {
  @console.log("Repeating!")
}, 1000)

// Clear interval
@global.clearInterval(interval)
```

### Microtasks

```moonbit
// Queue a microtask
@global.queueMicrotask(fn() {
  @console.log("Microtask executed")
})
```

### Module Loading

```moonbit
// Dynamic import (returns Promise)
let module_promise = @global.dynamic_import("./module.js")
```

## Error Handling

Most encoding/decoding functions can throw errors:

```moonbit
// Functions that can raise errors
try {
  let decoded = @global.atob("invalid base64!@#")
} catch {
  err => @console.log("Decoding failed")
}
```

## Type Aliases

This package exports the `Timer` type for use with timer functions:

```moonbit
pub type Timer  // Represents a timer ID
```

## See Also

- [MDN: Global Objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects)
- [MDN: structuredClone](https://developer.mozilla.org/en-US/docs/Web/API/structuredClone)
- [MDN: Timers](https://developer.mozilla.org/en-US/docs/Web/API/setTimeout)
