# mizchi/js_web/webassembly

WebAssembly API for loading and running WebAssembly modules.

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_web@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_core" @core,
  "mizchi/js_web/webassembly",
}
```

## Overview

Provides bindings for the WebAssembly JavaScript API to compile and instantiate WASM modules.

## Usage Example

```moonbit
fn main {
  // Compile WebAssembly module from bytes
  let bytes = get_wasm_bytes() // your WASM binary
  let module = @webassembly.WebAssembly_Module::new(bytes)
  
  // Instantiate the module
  let imports = @core.Object::new()
  let instance = @webassembly.WebAssembly_Instance::new(module, imports)
  
  // Access exports
  let exports = instance.exports()
  
  // Call exported functions
  // let result = exports._get("add")._call([1, 2])
}
```

## Available Types

- **WebAssembly.Module** - Compiled WASM module
- **WebAssembly.Instance** - Instantiated WASM module
- **WebAssembly.Memory** - Linear memory
- **WebAssembly.Table** - Function table

## Reference

- [MDN: WebAssembly](https://developer.mozilla.org/en-US/docs/WebAssembly)
- [MDN: WebAssembly JavaScript API](https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface)
