# mizchi/js/builtins/collection

JavaScript collection types (Map, Set, WeakMap, WeakSet).

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/builtins/collection"
  ]
}
```

## Overview

Provides bindings for JavaScript's collection types:
- **Map** - Key-value pairs with any type of key
- **Set** - Collection of unique values
- **WeakMap** - Weak key-value pairs (keys are objects)
- **WeakSet** - Weak collection of objects

## Usage Example

```moonbit
fn main {
  // Map
  let map = @collection.JsMap::new()
  map.set("key", "value")
  let value = map._get("key")
  let has = map.has("key")
  
  // Set
  let set = @collection.JsSet::new()
  set.add("item")
  let has_item = set.has("item")
  
  // WeakMap (for objects only)
  let weak_map = @collection.WeakMap::new()
  
  // WeakSet (for objects only)
  let weak_set = @collection.WeakSet::new()
}
```

## Reference

- [MDN: Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map)
- [MDN: Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set)
- [MDN: WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)
- [MDN: WeakSet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakSet)
