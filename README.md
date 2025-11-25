# mizchi/js

Comprehensive JavaScript/ FFI bindings for MoonBit, supporting multiple runtimes and platforms.

## Installation

```bash
$ moon add mizchi/js
```

Add to your `moon.pkg.json`:

```json
{
  "import": ["mizchi/js"]
}
```

> **⚠️ Future Plans**: Platform-specific APIs (Node.js, Browser, Deno, Cloudflare Workers) will be split into separate packages in the future. The core `mizchi/js` package will focus on JavaScript built-ins and Web Standard APIs.

## Quick Links

### 📚 API Documentation by Platform

| Platform | Documentation | Examples | Status |
|----------|--------------|----------|--------|
| **Core JavaScript** | [src/README.md](src/README.md) | [js_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/js_examples.mbt.md) | 🧪 Tested |
| **Browser** | [src/browser/README.md](src/browser/README.md) | - | 🧪 Tested |
| **Node.js** | [src/node/README.md](src/node/README.md) | [node_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/node_examples.mbt.md) | 🚧 Partially |
| **Deno** | [src/deno/README.md](src/deno/README.md) | - | 🧪 Tested |
| **Cloudflare Workers** | [src/cloudflare/README.md](src/cloudflare/README.md) | [cfw/](src/examples/cfw/) | 🧪 Tested |
| **React** | [src/npm/react/](src/npm/react/) | [react_app/](src/examples/react_app/) | 🧪 Tested |

### 📖 Learning Resources

- [MoonBit Cheatsheet](https://github.com/mizchi/js.mbt/blob/main/src/examples/moonbit_cheatsheet.mbt.md) - Quick reference for MoonBit syntax
- [FFI Bestpractice](https://github.com/mizchi/js.mbt/blob/main/src/examples/js_ffi.mbt.md) - Bestpractice for MoonBit JavaScript FFI
- [Escape Hatch Pattern](https://github.com/mizchi/js.mbt/blob/main/src/examples/escape_hatch.mbt.md) - Advanced FFI techniques
- [For TypeScript Users](https://github.com/mizchi/js.mbt/blob/main/src/examples/for_ts_user.mbt.md) - Migration guide from TypeScript

## Supported Modules

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage, production ready
- 🚧 **Partially**: Core functionality implemented, tests incomplete
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation
- ❌ **Not Supported**: Technical limitations

### Core JavaScript APIs

| Category | Package | Status | Note |
|----------|---------|--------|------|
| **Core FFI & Objects** |
| Core FFI | `mizchi/js` | 🧪 Tested | `get`, `set`, `call`, etc. |
| Object | `mizchi/js` | 🧪 Tested | Object manipulation |
| Function | `mizchi/js` | 🧪 Tested | Function operations |
| Promise | `mizchi/js` | 🧪 Tested | Async/Promise API |
| Error | `mizchi/js` | 🧪 Tested | Error handling |
| JSON | `mizchi/js` | 🧪 Tested | JSON parse/stringify |
| Iterator | `mizchi/js` | 🧪 Tested | JS Iterator protocol |
| AsyncIterator | `mizchi/js` | 🧪 Tested | Async iteration |
| WeakMap/Set/Ref | `mizchi/js` | 🧪 Tested | Weak references |
| **Async Helpers** |
| run_async | `mizchi/js` | 🧪 Tested | Async execution |
| suspend | `mizchi/js` | 🧪 Tested | Promise suspension |
| sleep | `mizchi/js` | 🧪 Tested | Delay execution |
| promisify | `mizchi/js` | 🧪 Tested | Callback → Promise |

### JavaScript Built-ins

| Category | Package | Status | Note |
|----------|---------|--------|------|
| ArrayBuffer | `mizchi/js/builtins/arraybuffer` | 🧪 Tested | Binary buffers |
| TypedArrays | `mizchi/js/builtins/typedarray` | 🧪 Tested | Uint8Array, etc. |
| DataView | `mizchi/js/builtins/arraybuffer` | 🧪 Tested | Buffer views |
| SharedArrayBuffer | `mizchi/js/builtins/arraybuffer` | 🤖 AI Generated | Shared memory |
| RegExp | `mizchi/js/builtins/regexp` | 🧪 Tested | Regular expressions |
| Date | `mizchi/js/builtins/date` | 🧪 Tested | Date/time operations |
| Math | `mizchi/js/builtins/math` | 🧪 Tested | Math operations |
| Reflect | `mizchi/js/builtins/reflect` | 🤖 AI Generated | Reflection API |
| Proxy | `mizchi/js/builtins/proxy` | 🤖 AI Generated | Proxy API |

### Web Standard APIs

Platform-independent Web Standard APIs (browsers, Node.js, Deno, edge runtimes):

> See **[mizchi/js/web](src/web/README.md)** for detailed Web APIs documentation

| Category | Package | Status | Note |
|----------|---------|--------|------|
| Console | `mizchi/js/web/console` | 🧪 Tested | console.log, console.error, etc. |
| fetch | `mizchi/js/web/http` | 🧪 Tested | HTTP requests |
| Request | `mizchi/js/web/http` | 🧪 Tested | Request objects |
| Response | `mizchi/js/web/http` | 🧪 Tested | Response objects |
| Headers | `mizchi/js/web/http` | 🧪 Tested | HTTP headers |
| FormData | `mizchi/js/web/http` | 🧪 Tested | Form data |
| URL | `mizchi/js/web/url` | 🧪 Tested | URL parsing |
| URLSearchParams | `mizchi/js/web/url` | 🧪 Tested | Query strings |
| URLPattern | `mizchi/js/web/url` | 🧪 Tested | URL pattern matching |
| Blob | `mizchi/js/web/blob` | 🧪 Tested | Binary data |
| ReadableStream | `mizchi/js/web/streams` | 🧪 Tested | Stream reading |
| WritableStream | `mizchi/js/web/streams` | 🧪 Tested | Stream writing |
| TransformStream | `mizchi/js/web/streams` | 🧪 Tested | Stream transformation |
| CompressionStream | `mizchi/js/web/streams` | 🧪 Tested | GZIP/Deflate compression |
| DecompressionStream | `mizchi/js/web/streams` | 🧪 Tested | GZIP/Deflate decompression |
| TextEncoder | `mizchi/js/web/encoding` | 🧪 Tested | String to Uint8Array |
| TextDecoder | `mizchi/js/web/encoding` | 🧪 Tested | Uint8Array to String |
| Event | `mizchi/js/web/event` | 🧪 Tested | Event objects |
| CustomEvent | `mizchi/js/web/event` | 🧪 Tested | Custom events |
| MessageEvent | `mizchi/js/web/event` | 🧪 Tested | Message events |
| Crypto | `mizchi/js/web/crypto` | 🧪 Tested | Web Crypto API |
| WebSocket | `mizchi/js/web/websocket` | 🧪 Tested | WebSocket API |
| Worker | `mizchi/js/web/worker` | 🧪 Tested | Web Workers |
| MessageChannel | `mizchi/js/web/message` | 🧪 Tested | Message passing |
| MessagePort | `mizchi/js/web/message` | 🧪 Tested | Message ports |
| WebAssembly | `mizchi/js/web/webassembly` | 🤖 AI Generated | WASM integration |
| Performance | `mizchi/js/web/performance` | 🤖 AI Generated | Performance API |

### Runtime-Specific APIs

| Platform | Package | Status | Documentation |
|----------|---------|--------|---------------|
| Node.js | `mizchi/js/node/*` | 🚧 Partially | [Node.js README](src/node/README.md) |
| Browser API | `mizchi/js/browser/*` | 🧪 Tested | [Browser README](src/browser/README.md) |
| Deno | `mizchi/js/deno` | 🤖 AI Generated | [Deno README](src/deno/README.md) |
| Cloudflare Workers | `mizchi/js/cloudflare` | 🧪 Tested | [Cloudflare README](src/cloudflare/README.md) |

### NPM Package Bindings

| Package | Package Name | Status | Documentation |
|---------|--------------|--------|---------------|
| React | `mizchi/js/npm/react` | 🧪 Tested | [React README](src/npm/react/) |
| React DOM (Client) | `mizchi/js/npm/react_dom_client` | 🧪 Tested | [React DOM Client](src/npm/react_dom_client/) |
| React DOM (Server) | `mizchi/js/npm/react_dom_server` | 🧪 Tested | [React DOM Server](src/npm/react_dom_server/) |
| Hono | `mizchi/js/npm/hono` | 🧪 Tested | [Hono README](src/npm/hono/) |
| semver | `mizchi/js/npm/semver` | 🤖 AI Generated | [semver](src/npm/semver/) |

### Not Supported APIs

| Feature | Reason |
|---------|--------|
| `eval()` | Security and type safety |
| `new Function()` | Security and type safety |
| `DisposableStack` | No `using` keyword in MoonBit |
| `AsyncDisposableStack` | No `await using` keyword in MoonBit |

## Project Status

- ✅ **React SPA** - Full support with SSR/CSR
- ✅ **Node.js Core APIs** - `fs`, `path`, `process`, `child_process`, etc.
- ✅ **Cloudflare Workers** - KV, D1, R2, Durable Objects
- ✅ **Deno Runtime** - File system, permissions, testing
- ✅ **DOM APIs** - Full browser DOM manipulation
- 🤖 **AI-Generated Bindings** - Many APIs generated from TypeScript definitions

## Goals

- Provide comprehensive JavaScript bindings for MoonBit
- **Platform Coverage**
  - ✅ Browser + React for frontend development
  - 🚧 Node.js/Deno support to replace TypeScript
  - ✅ Cloudflare Workers for edge computing
  - 📅 MCP server/client support

## Quick Start

### Basic FFI Operations

```moonbit
// Create JavaScript objects
let obj = @js.from_map({ "name": @js.any("Alice"), "age": @js.any(30) })

// Get property
let name = obj.get("name")

// Set property
obj.set("age", 31)

// Call method
let result = obj.call("toString", [])

// Type casting
let age: Int = obj.get("age").cast()
```

### Async/Await

```moonbit
async fn fetch_data() -> Unit {
  let response = @http.fetch("https://api.example.com/data").wait()
  let json = response.json().wait()
  @js.log(json)
}
```

## LICENSE

MIT
