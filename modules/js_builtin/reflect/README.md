# mizchi/js_builtin/reflect

Reflection API with JavaScript's Reflect object.

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_builtin@0.13.0",
  "mizchi/js_core@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_core" @core,
  "mizchi/js_builtin/reflect",
}
```

## Overview

Provides bindings for JavaScript's Reflect API for intercepting JavaScript operations.

## Usage Example

```moonbit
fn main {
  let obj = @core.Object::new()
  
  // Set property
  @reflect.set(obj, "name", "value")
  
  // Get property
  let value = @reflect._get(obj, "name")
  
  // Has property
  let has = @reflect.has(obj, "name")  // true
  
  // Delete property
  @reflect.delete_property(obj, "name")
}
```

## Available Methods

- `get(target, key)` - Get property value
- `set(target, key, value)` - Set property value
- `has(target, key)` - Check if property exists
- `deleteProperty(target, key)` - Delete property
- `ownKeys(target)` - Get all own property keys

## Reference

- [MDN: Reflect](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect)
