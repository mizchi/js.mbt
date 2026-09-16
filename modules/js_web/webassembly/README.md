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

The bound types are `WebAssemblyModule` and `WebAssemblyInstance`, and they
are built with `from_*` factories rather than a constructor:

```moonbit
///|
pub fn load(bytes : @arraybuffer.Uint8Array) -> @core.Any {
  // Compile a module from bytes, then instantiate it
  let wasm = @webassembly.WebAssemblyModule::from_bytes(bytes)
  let instance = @webassembly.WebAssemblyInstance::from_module(wasm, None)

  // Access exports
  let exports = instance.exports()

  // Call an exported function
  exports._call("add", [@core.any(1), @core.any(2)])
}
```

`instantiate_bytes` does both steps at once, and `validate` checks a binary
without compiling it:

```moonbit
///|
pub fn load_in_one_step(
  bytes : @arraybuffer.Uint8Array,
) -> @webassembly.WebAssemblyInstance? {
  guard @webassembly.validate(bytes) else { None }
  let (_module, instance) = @webassembly.instantiate_bytes(bytes, None)
  Some(instance)
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
