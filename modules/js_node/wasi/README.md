# mizchi/js_node/wasi

## node:wasi

WebAssembly System Interface (WASI) support

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_node@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_node/wasi",
}
```

### WASI
- [x] WASI type
- [x] WASI(options) - Create WASI instance
  - Options: args, env, preopens, returnOnExit, stdin, stdout, stderr
- [x] start(instance) - Start WASI instance
- [x] initialize(instance) - Initialize WASI instance
- [x] wasiImport - Get WASI import object

## Usage
Provides WebAssembly System Interface support for running WASI modules in Node.js.

```moonbit
let wasi = WASI(args=["arg1", "arg2"], env=env_obj)
let imports = { "wasi_snapshot_preview1": wasi.wasiImport }
// Load and instantiate WASM module with imports
wasi.start(instance)
```
