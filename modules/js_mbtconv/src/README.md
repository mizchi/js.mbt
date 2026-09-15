# mbtconv - MoonBit to JavaScript Conversion Utilities

This package provides utilities to convert MoonBit types to JavaScript values and vice versa.

## Responsibility

**Core responsibility**: Convert MoonBit objects to JavaScript objects with proper type handling.

This package handles conversions that require runtime processing (iteration, recursion, property setting). For zero-cost conversions, use `@core.identity()` or `@core.any()` instead.

## MoonBit Types JavaScript Representation

Understanding how MoonBit types are compiled to JavaScript is essential for writing JS interop code.

### Option[T]

MoonBit's `Option[T]` is optimized to avoid wrapper objects:

| MoonBit | JavaScript |
|---------|------------|
| `Some(42)` | `42` |
| `None` | `undefined` |

```moonbit
let some_val : Int? = Some(42)
let js_val = @core.any(some_val)  // JS: 42

let none_val : Int? = None
let js_val = @core.any(none_val)  // JS: undefined
```

### Result[T, E]

MoonBit's `Result[T, E]` compiles to objects with `_0` property. **Important**: Ok and Err have the same JSON structure, but different constructor names.

| MoonBit | JavaScript | constructor.name |
|---------|------------|------------------|
| `Ok(42)` | `{ _0: 42 }` | `"Result$Ok$N$"` |
| `Err("error")` | `{ _0: "error" }` | `"Result$Err$N$"` |

To distinguish Ok from Err in JavaScript:
```javascript
// Use constructor name
const isOk = value.constructor.name.includes("Ok")
const isErr = value.constructor.name.includes("Err")

// Or use mbtconv utilities from MoonBit
let is_ok = @mbtconv.is_result_ok(js_val)
let is_err = @mbtconv.is_result_err(js_val)
```

### Enum Types

MoonBit enums compile differently based on whether they have arguments:

**Unit variants (no arguments)**:
```moonbit
enum Color { Red, Green, Blue }
let red = Red  // JS: { $tag: 0, $name: "Red" }
```

**Tuple variants (with arguments)**:
```moonbit
enum Color { Rgb(Int, Int, Int) }
let rgb = Rgb(255, 0, 0)  // JS: { $tag: 3, _0: 255, _1: 0, _2: 0 }
                          // constructor.name: "Color$Rgb"
```

**Struct variants (with named fields)**:
```moonbit
enum Shape { Circle(~radius: Int) }
let c = Circle(radius=10)  // JS: { $tag: 0, radius: 10 }
```

### Struct Types

MoonBit structs compile to plain JavaScript objects:

```moonbit
struct Point { x: Int, y: Int }
let p = Point::{ x: 10, y: 20 }  // JS: { x: 10, y: 20 }
```

## Main Functions

### Map Conversions

```moonbit
// Convert Map to JS object
let obj = @mbtconv.from_map({
  "name": @core.any("Alice"),
  "age": @core.any(30)
})
// JavaScript: { name: "Alice", age: 30 }

// Convert Map with optional values (skips None)
let obj = @mbtconv.from_option_map({
  "name": Some(@core.any("Bob")),
  "email": None,  // Skipped
  "age": Some(@core.any(25))
})
// JavaScript: { name: "Bob", age: 25 }

// Returns undefined if all values are None
let result = @mbtconv.from_option_map_or_undefined({
  "timeout": None,
  "retries": None
})
// JavaScript: undefined
```

### Json Conversions

```moonbit
// Convert MoonBit Json to JS value
let json : Json = { "name": "Alice", "age": 30 }
let js_obj = @mbtconv.from_json(json)

// Convert JS value to MoonBit Json
let js_obj = @core.any({ "name": "Alice" })
let json = @mbtconv.to_json(js_obj)
```

**Important**: `from_json` converts MoonBit's `Json` type (from `@json` package), NOT JavaScript's JSON string. For parsing JSON strings, use `JSON.parse()`.

### Option Conversions

```moonbit
// Convert Option to @core.Any (None becomes null)
let some_val : @core.Any? = Some(@core.any(42))
let result = @mbtconv.from_option(some_val)  // 42

let none_val : @core.Any? = None
let result = @mbtconv.from_option(none_val)  // null

// Convert @core.Any to Option (null/undefined becomes None)
let val = @core.any(123)
let opt : Int? = @mbtconv.to_option(val)  // Some(123)

let null_val = @core.null()
let opt : Int? = @mbtconv.to_option(@core.any(null_val))  // None
```

### Result Conversions

```moonbit
// Check if Result is Ok or Err
let ok_result : Result[Int, String] = Ok(42)
let is_ok = @mbtconv.is_result_ok(@core.any(ok_result))  // true
let is_err = @mbtconv.is_result_err(@core.any(ok_result))  // false

// Unwrap values
let value : Int = @mbtconv.unwrap_ok(@core.any(ok_result))  // 42

let err_result : Result[Int, String] = Err("error")
let error : String = @mbtconv.unwrap_err(@core.any(err_result))  // "error"

// Convert back to MoonBit Result
let js_val = @core.any(ok_result)
let back : Result[Int, String] = @mbtconv.to_result(js_val)  // Ok(42)
```

### Enum Utilities

```moonbit
enum Color { Red, Green, Blue, Rgb(Int, Int, Int) }

// Get variant name
let name = @mbtconv.get_enum_variant_name(@core.any(Red))  // "Red"
let name = @mbtconv.get_enum_variant_name(@core.any(Rgb(255, 0, 0)))  // "Rgb"

// Get tag index
let tag = @mbtconv.get_enum_tag(@core.any(Red))  // 0
let tag = @mbtconv.get_enum_tag(@core.any(Rgb(255, 0, 0)))  // 3
```

## Performance Considerations

All conversions in this package have runtime overhead due to iteration and recursive processing:

- `from_map`: O(n) iteration + property setting
- `from_json`: O(n) recursive matching
- `to_json`: O(n) recursive conversion
- `is_result_ok`/`is_result_err`: O(1) string check
- `to_result`: O(1)

For zero-cost conversions of primitive types and arrays, use:
- `@core.identity()` - Type casting without conversion
- `@core.any()` - Wrap MoonBit value as JavaScript value

## Writing JS Bindings

When writing JavaScript bindings that interact with MoonBit types:

### Handling Result from MoonBit

```javascript
// JavaScript side
function handleMoonBitResult(result) {
  if (result.constructor.name.includes("Ok")) {
    return { success: true, value: result._0 };
  } else {
    return { success: false, error: result._0 };
  }
}
```

### Creating Result for MoonBit

If you need to create a Result-like structure from JS for MoonBit consumption, the safest approach is to use MoonBit's own constructors or handle the conversion in MoonBit code.

## TypeScript Helpers

This package includes TypeScript type definitions and helper functions for working with MoonBit types from TypeScript/JavaScript.

### Installation

```typescript
import {
  isOk, isErr, unwrapOk, matchResult,
  isSome, isNone, unwrapOr,
  getVariantName, getEnumTag, getTupleArgs,
} from "./src/mbtconv/types.ts";
```

### Result Helpers

```typescript
import { isOk, isErr, unwrapOk, matchResult, toResultObject } from "./types.ts";

// Type-safe Result handling
const result = mbtFunction(); // Returns MoonBit Result

if (isOk(result)) {
  console.log("Success:", result._0);
} else {
  console.log("Error:", result._0);
}

// Pattern matching
const message = matchResult(result, {
  ok: (value) => `Got value: ${value}`,
  err: (error) => `Error: ${error}`,
});

// Convert to plain object (for serialization)
const obj = toResultObject(result);
// { type: "ok", value: 42 } or { type: "err", error: "..." }
```

### Option Helpers

```typescript
import { isSome, isNone, unwrapOr } from "./types.ts";

const option = mbtFunction(); // Returns MoonBit Option (T | undefined)

if (isSome(option)) {
  console.log("Value:", option);
}

// With default value
const value = unwrapOr(option, 0);
```

### Enum Helpers

```typescript
import { isUnitVariant, getVariantName, getEnumTag, getTupleArgs } from "./types.ts";

const color = mbtFunction(); // Returns MoonBit enum

// Get variant name
const name = getVariantName(color); // "Red" or "Rgb"

// Get tag index
const tag = getEnumTag(color); // 0, 1, 2, ...

// For tuple variants, get arguments
if (!isUnitVariant(color)) {
  const args = getTupleArgs(color); // [255, 128, 64]
}
```

### JSON Serialization with Type Preservation

```typescript
import { serializeResult, deserializeResult } from "./types.ts";

// Result loses Ok/Err distinction in JSON
// Use these helpers to preserve it:

const result = mbtFunction();
const serialized = serializeResult(result);
// { _type: "Ok", _0: 42 }

const json = JSON.stringify(serialized);
// Can be safely transmitted/stored

const parsed = JSON.parse(json);
const restored = deserializeResult(parsed);
// { type: "ok", value: 42 }
```

### Prototype Restoration (Full Interop)

After JSON deserialization, `isOk()`/`isErr()` won't work because `constructor.name` is lost. Use `restoreResult` to restore the prototype:

```typescript
import {
  serializeResult,
  restoreResult,
  isOk,
  unwrapOk,
  createOk,
  createErr,
} from "./types.ts";

// Serialize from MoonBit
const result = mbtFunction();
const serialized = serializeResult(result);
const json = JSON.stringify(serialized);

// Later: restore with prototype
const parsed = JSON.parse(json);
const restored = restoreResult<number, string>(parsed);

// Now isOk/isErr work again!
if (isOk(restored)) {
  console.log(unwrapOk(restored));
}

// Or create new Result values from TypeScript
const ok = createOk(42);      // Works with isOk()
const err = createErr("msg"); // Works with isErr()
```

For enums with tuple variants:

```typescript
import { restoreEnum, createEnumTuple, getEnumTag, getVariantName } from "./types.ts";

// Restore from serialized form
const serialized = '{"_tag":3,"_name":"Rgb","_args":[255,128,64]}';
const color = restoreEnum(JSON.parse(serialized), "Color");

getEnumTag(color);     // 3
getVariantName(color); // "Rgb"

// Or create directly
const rgb = createEnumTuple("Color", "Rgb", 3, [255, 128, 64]);
```

### Type Definitions

```typescript
// Result type
type MbtResult<T, E> = MbtResultOk<T> | MbtResultErr<E>;

// Option type (MoonBit unwraps Some)
type MbtOption<T> = T | undefined;

// Enum unit variant
interface MbtEnumUnit {
  $tag: number;
  $name: string;
}

// Enum tuple variant
interface MbtEnumTuple {
  _0?: unknown;
  _1?: unknown;
  // ...
}

// Trait object
interface MbtTraitObject<T> {
  self: T;
  method_0: Function;
  // ...
}
```

## JSON Roundtrip Compatibility

| Type | JSON Safe | Notes |
|------|-----------|-------|
| Primitives | ✅ | Fully preserved |
| Array | ✅ | Fully preserved |
| Struct | ✅ | Field names preserved |
| Enum (unit) | ✅ | $tag and $name preserved |
| Enum (tuple) | ⚠️ | $tag LOST in JSON |
| Enum (labeled) | ❌ | Labels become _0, _1... |
| Result | ❌ | Ok/Err distinction LOST |
| Option None | ⚠️ | Becomes null/undefined |
| BigInt | ❌ | JSON.stringify throws |
| Map | ❌ | Internal structure |
| Function | ❌ | Not serializable |

## Related Packages

- `@core` - Low-level JavaScript interop primitives
- `@json` - MoonBit's built-in Json type
