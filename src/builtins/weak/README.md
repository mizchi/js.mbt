# mizchi/js/builtins/weak

Weak references (WeakRef, FinalizationRegistry).

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/builtins/weak"
  ]
}
```

## Overview

Provides bindings for JavaScript's weak reference APIs:
- **WeakRef** - Weak reference to an object that doesn't prevent garbage collection
- **FinalizationRegistry** - Callback when objects are garbage collected

## Usage Example

```moonbit
fn main {
  let obj = @nostd.Object::new()
  
  // Create a weak reference
  let weak_ref = @weak.WeakRef::new(obj)
  
  // Dereference (might return None if collected)
  let deref = weak_ref.deref()
  
  // FinalizationRegistry for cleanup callbacks
  let registry = @weak.FinalizationRegistry::new()
}
```

## Use Cases

- Cache implementations
- Memory-sensitive data structures
- Resource cleanup tracking

## Reference

- [MDN: WeakRef](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef)
- [MDN: FinalizationRegistry](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/FinalizationRegistry)
