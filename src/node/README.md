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

## Node.js Module Support Status

| Module | Package | Status | Note |
|--------|---------|--------|------|
| `node:assert` | `mizchi/js/node/assert` | 🤖 AI Generated | Basic assertions |
| `node:buffer` | `mizchi/js/node/buffer` | ✅ Tested | Buffer manipulation |
| `node:child_process` | `mizchi/js/node/child_process` | ✅ Tested | Process spawning |
| `node:events` | `mizchi/js/node/events` | ✅ Tested | EventEmitter |
| `node:fs` | `mizchi/js/node/fs` | ✅ Tested | File system (callback) |
| `node:fs/promises` | `mizchi/js/node/fs_promises` | ✅ Tested | File system (Promise) |
| `node:http` | `mizchi/js/node/http` | 🚧 Partially | HTTP server/client |
| `node:module` | `mizchi/js/node/module` | 🤖 AI Generated | Module utilities |
| `node:net` | `mizchi/js/node/net` | 🚧 Partially | TCP/IPC networking |
| `node:os` | `mizchi/js/node/os` | 🤖 AI Generated | OS utilities |
| `node:path` | `mizchi/js/node/path` | 🤖 AI Generated | Path manipulation |
| `node:process` | `mizchi/js/node/process` | ✅ Tested | Process information |
| `node:readline` | `mizchi/js/node/readline` | 🤖 AI Generated | Interactive I/O |
| `node:readline/promises` | `mizchi/js/node/readline_promises` | 🤖 AI Generated | Interactive I/O (Promise) |
| `node:sqlite` | `mizchi/js/node/sqlite` | 🤖 AI Generated | SQLite database |
| `node:stream` | `mizchi/js/node/stream` | 🚧 Partially | Stream API |
| `node:stream/promises` | `mizchi/js/node/stream_promises` | 🤖 AI Generated | Stream (Promise) |
| `node:test` | `mizchi/js/node/test` | ✅ Tested | Testing framework |
| `node:timers` | `mizchi/js/node` | ✅ Tested | setTimeout/setInterval |
| `node:url` | `mizchi/js/node/url` | 🤖 AI Generated | URL parsing |
| `node:util` | `mizchi/js/node/util` | 🤖 AI Generated | Utility functions |
| `node:v8` | `mizchi/js/node/v8` | 🤖 AI Generated | V8 engine utilities |
| `node:vm` | `mizchi/js/node/vm` | 🤖 AI Generated | VM script execution |
| `node:wasi` | `mizchi/js/node/wasi` | 🤖 AI Generated | WASI support |
| `node:https` | `mizchi/js/node/https` | 🤖 AI Generated | HTTPS server/client |
| `node:http2` | `mizchi/js/node/http2` | 🤖 AI Generated | HTTP/2 support |
| `node:tty` | `mizchi/js/node/tty` | 🤖 AI Generated | Terminal I/O |
| `node:tls` | `mizchi/js/node/tls` | 🤖 AI Generated | TLS/SSL connections |
| `node:dns` | `mizchi/js/node/dns` | 🤖 AI Generated | DNS resolution |
| `node:zlib` | `mizchi/js/node/zlib` | 🤖 AI Generated | Compression/decompression |
| `node:inspector` | `mizchi/js/node/inspector` | 🤖 AI Generated | V8 Inspector debugging |
| `node:worker_threads` | - | 📅 Planned | Worker threads |
| `node:permissions` | - | 📅 Planned | Permissions API |
| `node:domain` | - | 📅 Planned | Domain error handling |
| `node:querystring` | - | ❌ Not Planned | Use URLSearchParams |
| `node:crypto` | - | ❌ Not Planned | Use Web Crypto API |
| `node:string_decoder` | - | ❌ Not Planned | Use TextDecoder |
| `node:punycode` | - | ❌ Not Planned | |
| `node:dgram` | - | ❌ Not Planned | |
| `node:async_hooks` | - | ❌ Not Planned | |

### Status Legend

- ✅ **Tested**: Comprehensive test coverage, production ready
- 🚧 **Partially**: Core functionality implemented, tests incomplete
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation
- ❌ **Not Planned**: Use Web standard alternatives

---

**Note**: Node.js bindings are actively developed. Some AI-generated modules require thorough testing before production use.
