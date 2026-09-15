# mizchi/js_node

Node.js global objects and variables.

This package will move to `mizchi/node` in future.

## Supported

- cjs
  - [x] `require`
  - [x] `require.resolve`
  - [x] `module` by `module_`
  - [x] `__filename`
  - [x] `__dirname`
  - [x] `Buffer`
  - [x] `process`
- esm
  - [x] `import.meta.url`
  - [x] `import.meta.resolve`
  - [x] `import.meta.resolve`
  - [x] `import.meta.filename`
  - [x] `import.meta.dirname`  

## Node.js Module Support Status

| Module | Package | Status | Note |
|--------|---------|--------|------|
| `node:assert` | `mizchi/js_node/assert` | 🧪 Tested | Assertions |
| `node:assert/strict` | `mizchi/js_node/assert_strict` | 🧪 Tested | Strict assertions |
| `node:buffer` | `mizchi/js_node/buffer` | 🧪 Tested | Buffer manipulation |
| `node:child_process` | `mizchi/js_node/child_process` | 🧪 Tested | Process spawning |
| `node:dns` | `mizchi/js_node/dns` | 🧪 Tested | DNS resolution |
| `node:events` | `mizchi/js_node/events` | 🧪 Tested | EventEmitter |
| `node:fs` | `mizchi/js_node/fs` | 🧪 Tested | File system (callback) |
| `node:fs/promises` | `mizchi/js_node/fs_promises` | 🧪 Tested | File system (Promise) |
| `node:http` | `mizchi/js_node/http` | 🧪 Tested | HTTP server/client |
| `node:http2` | `mizchi/js_node/http2` | 🧪 Tested | HTTP/2 support |
| `node:https` | `mizchi/js_node/https` | 🧪 Tested | HTTPS server/client |
| `node:inspector` | `mizchi/js_node/inspector` | 🧪 Tested | V8 Inspector debugging |
| `node:module` | `mizchi/js_node/module` | 🧪 Tested | Module utilities |
| `node:net` | `mizchi/js_node/net` | 🧪 Tested | TCP/IPC networking |
| `node:os` | `mizchi/js_node/os` | 🧪 Tested | OS utilities |
| `node:path` | `mizchi/js_node/path` | 🧪 Tested | Path manipulation |
| `node:process` | `mizchi/js_node/process` | 🧪 Tested | Process information |
| `node:readline` | `mizchi/js_node/readline` | 🧪 Tested | Interactive I/O |
| `node:readline/promises` | `mizchi/js_node/readline_promises` | 🤖 AI Generated | Interactive I/O (Promise) |
| `node:sqlite` | `mizchi/js_node/sqlite` | 🧪 Tested | SQLite database (Node 22.5+) |
| `node:stream` | `mizchi/js_node/stream` | 🧪 Tested | Stream API |
| `node:stream/promises` | `mizchi/js_node/stream_promises` | 🧪 Tested | Stream (Promise) |
| `node:test` | `mizchi/js_node/test` | 🧪 Tested | Testing framework |
| `node:timers` | `mizchi/js_node` | 🧪 Tested | setTimeout/setInterval |
| `node:tls` | `mizchi/js_node/tls` | 🧪 Tested | TLS/SSL connections |
| `node:tty` | `mizchi/js_node/tty` | 🧪 Tested | Terminal I/O |
| `node:url` | `mizchi/js_node/url` | 🧪 Tested | URL parsing |
| `node:util` | `mizchi/js_node/util` | 🧪 Tested | Utility functions |
| `node:v8` | `mizchi/js_node/v8` | 🧪 Tested | V8 engine utilities |
| `node:vm` | `mizchi/js_node/vm` | 🧪 Tested | VM script execution |
| `node:wasi` | `mizchi/js_node/wasi` | 🧪 Tested | WASI support |
| `node:worker_threads` | `mizchi/js_node/worker_threads` | 🧪 Tested | Worker threads |
| `node:zlib` | `mizchi/js_node/zlib` | 🧪 Tested | Compression/decompression |
| `node:async_hooks` | `mizchi/js_node/async_hooks` | 🧪 Tested | AsyncLocalStorage |
| `node:permissions` | - | 📅 Planned | Permissions API |
| `node:domain` | - | ❌ Not Planned | Deprecated in Node.js |
| `node:querystring` | - | ❌ Not Planned | Use URLSearchParams |
| `node:crypto` | - | ❌ Not Planned | Use Web Crypto API |
| `node:string_decoder` | - | ❌ Not Planned | Use TextDecoder |
| `node:punycode` | - | ❌ Not Planned | Deprecated |
| `node:dgram` | - | ❌ Not Planned | UDP sockets |

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage, production ready
- 🚧 **Partially**: Core functionality implemented, tests incomplete
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation
- ❌ **Not Planned**: Use Web standard alternatives

---

**Note**: Node.js bindings are actively developed. Some AI-generated modules require thorough testing before production use.
