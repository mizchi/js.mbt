# mbtconv - MoonBit to JavaScript Conversion Utilities

This package provides utilities to convert MoonBit types to JavaScript values and vice versa.

## Responsibility

**Core responsibility**: Convert MoonBit objects to JavaScript objects with proper type handling.

This package handles conversions that require runtime processing (iteration, recursion, property setting). For zero-cost conversions, use `@core.identity()` or `@core.any()` instead.

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

## Performance Considerations

All conversions in this package have runtime overhead due to iteration and recursive processing:

- `from_map`: O(n) iteration + property setting
- `from_json`: O(n) recursive matching
- `to_json`: O(n) recursive conversion

For zero-cost conversions of primitive types and arrays, use:
- `@core.identity()` - Type casting without conversion
- `@core.any()` - Wrap MoonBit value as JavaScript value

## Related Packages

- `@core` - Low-level JavaScript interop primitives
- `@json` - MoonBit's built-in Json type
