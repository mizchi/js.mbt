# mizchi/js_builtin/proxy

Proxy API for intercepting and customizing object operations.

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
  "mizchi/js_builtin/proxy",
}
```

## Overview

Provides bindings for JavaScript's Proxy object, which allows you to create a wrapper around objects to intercept and customize fundamental operations.

## Usage Example

```moonbit
fn main {
  let target = @core.Object::new()
  let handler = @core.Object::new()
  
  // Create a proxy
  let proxy = @proxy.Proxy(target, handler)
  
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
