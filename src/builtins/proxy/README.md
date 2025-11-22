# mizchi/js/builtins/proxy

Proxy API for intercepting and customizing object operations.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/builtins/proxy"
  ]
}
```

## Overview

Provides bindings for JavaScript's Proxy object, which allows you to create a wrapper around objects to intercept and customize fundamental operations.

## Usage Example

```moonbit
fn main {
  let target = @js.Object::new()
  let handler = @js.Object::new()
  
  // Create a proxy
  let proxy = @proxy.Proxy::new(target, handler)
  
  // The proxy intercepts operations on the target object
}
```

## Available Features

- Intercept property access (get/set)
- Intercept function calls
- Intercept property enumeration
- Customize object behavior

## Reference

- [MDN: Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)
- [MDN: Reflect](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect)
