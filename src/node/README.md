# mizchi/js/node

Node.js global objects and variables.

This package will move to `mizchi/node` in future.

## Supported

- cjs
  - [x] `require`
  - [x] `require.resolve`
  - [ ] `module`
  - [x] `__filename`
  - [x] `__dirname`
- esm
  - [x] `import.meta.url`
  - [x] `import.meta.resolve`
  - [x] `import.meta.resolve`
  - [x] `import.meta.filename`
  - [x] `import.meta.dirname`  

Not Supported

- `process`
  - Use `mizchi/js/node/process`
- `Buffer`
  - Use `mizchi/js/node/buffer`

## Node.js binding

Caution: Node.js bindings are not fully tested yet. In near future, we split Node.js bindings into a separate package.

- [x] `mizchi/js/node` : Node.js global API
  - `require`, etc.
- [x] `mizchi/js/node/buffer` : `Buffer`
- [x] `mizchi/js/node/fs` : `node:fs`
- [x] `mizchi/js/node/fs_promises` : `node:fs/promises`
- [x] `mizchi/js/node/path` : `node:path`
- [x] `mizchi/js/node/os` : `node:os`
- [x] `mizchi/js/node/sqlite` : `node:sqlite`
- [x] `mizchi/js/node/module` : `node:module`
- [x] `mizchi/js/node/process` : `node:process`
- [x] `mizchi/js/node/v8` : `node:v8`
- [x] `mizchi/js/node/events` : `node:events`
  - [x] `EventEmitter`
- [x] `mizchi/js/node/util` : `node:util`
  - [x] `inspect`
  - [x] `parseArgs`
- [x] `mizchi/js/node/child_process` : `node:child_process`
- [x] `mizchi/js/node/test` : `node:test`
  - We use async testing instead of `async test` in Moonbit
- [x] `node:stream`
  - Partially tested
- [ ] `node:stream/promises`
  - Not tesed
- [x] `node:wasi`
- [ ] `node:net`

Not yet

- [ ] `node:vm`
- [ ] `node:worker_threads`
- [ ] `node:domain`
- [ ] `node:http`
- [ ] `node:https`
- [ ] `node:http2`
- [ ] `node:dns`
- [ ] `node:permissions`

Not planned

- `node:zlib`
  - Use CompressionStream/DecompressionStream instead.
- `node:querystring`
  - Use `URLSearchParams` instead.
- `node:crypto`
  - Use Web Crypto API instead.
- `node:string_decoder`
  - Use TextDecoder/TextEncoder instead.
- `node:inspector`
- `node:punnycode`
- `node:dgram`
- `node:async_hooks`
