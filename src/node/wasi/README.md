# mizchi/js/node/wasi

## node:wasi

WebAssembly System Interface (WASI) support

### WASI
- [x] WASI type
- [x] WASI::new(options) - Create WASI instance
  - Options: args, env, preopens, returnOnExit, stdin, stdout, stderr
- [x] start(instance) - Start WASI instance
- [x] initialize(instance) - Initialize WASI instance
- [x] wasiImport - Get WASI import object

## Usage
Provides WebAssembly System Interface support for running WASI modules in Node.js.

```moonbit
let wasi = WASI::new(args=["arg1", "arg2"], env=env_obj)
let imports = { "wasi_snapshot_preview1": wasi.wasiImport }
// Load and instantiate WASM module with imports
wasi.start(instance)
```
