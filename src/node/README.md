# mizchi/js/node

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
| `node:assert` | `mizchi/js/node/assert` | 🧪 Tested | Assertions |
| `node:assert/strict` | `mizchi/js/node/assert_strict` | 🧪 Tested | Strict assertions |
| `node:buffer` | `mizchi/js/node/buffer` | 🧪 Tested | Buffer manipulation |
| `node:child_process` | `mizchi/js/node/child_process` | 🧪 Tested | Process spawning |
| `node:dns` | `mizchi/js/node/dns` | 🧪 Tested | DNS resolution |
| `node:events` | `mizchi/js/node/events` | 🧪 Tested | EventEmitter |
| `node:fs` | `mizchi/js/node/fs` | 🧪 Tested | File system (callback) |
| `node:fs/promises` | `mizchi/js/node/fs_promises` | 🧪 Tested | File system (Promise) |
| `node:http` | `mizchi/js/node/http` | 🧪 Tested | HTTP server/client |
| `node:http2` | `mizchi/js/node/http2` | 🧪 Tested | HTTP/2 support |
| `node:https` | `mizchi/js/node/https` | 🧪 Tested | HTTPS server/client |
| `node:inspector` | `mizchi/js/node/inspector` | 🧪 Tested | V8 Inspector debugging |
| `node:module` | `mizchi/js/node/module` | 🧪 Tested | Module utilities |
| `node:net` | `mizchi/js/node/net` | 🧪 Tested | TCP/IPC networking |
| `node:os` | `mizchi/js/node/os` | 🧪 Tested | OS utilities |
| `node:path` | `mizchi/js/node/path` | 🧪 Tested | Path manipulation |
| `node:process` | `mizchi/js/node/process` | 🧪 Tested | Process information |
| `node:readline` | `mizchi/js/node/readline` | 🧪 Tested | Interactive I/O |
| `node:readline/promises` | `mizchi/js/node/readline_promises` | 🤖 AI Generated | Interactive I/O (Promise) |
| `node:sqlite` | `mizchi/js/node/sqlite` | 🧪 Tested | SQLite database (Node 22.5+) |
| `node:stream` | `mizchi/js/node/stream` | 🧪 Tested | Stream API |
| `node:stream/promises` | `mizchi/js/node/stream_promises` | 🧪 Tested | Stream (Promise) |
| `node:test` | `mizchi/js/node/test` | 🧪 Tested | Testing framework |
| `node:timers` | `mizchi/js/node` | 🧪 Tested | setTimeout/setInterval |
| `node:tls` | `mizchi/js/node/tls` | 🧪 Tested | TLS/SSL connections |
| `node:tty` | `mizchi/js/node/tty` | 🧪 Tested | Terminal I/O |
| `node:url` | `mizchi/js/node/url` | 🧪 Tested | URL parsing |
| `node:util` | `mizchi/js/node/util` | 🧪 Tested | Utility functions |
| `node:v8` | `mizchi/js/node/v8` | 🧪 Tested | V8 engine utilities |
| `node:vm` | `mizchi/js/node/vm` | 🧪 Tested | VM script execution |
| `node:wasi` | `mizchi/js/node/wasi` | 🧪 Tested | WASI support |
| `node:worker_threads` | `mizchi/js/node/worker_threads` | 🧪 Tested | Worker threads |
| `node:zlib` | `mizchi/js/node/zlib` | 🧪 Tested | Compression/decompression |
| `node:async_hooks` | `mizchi/js/node/async_hooks` | 🧪 Tested | AsyncLocalStorage |
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
