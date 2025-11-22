# mizchi/js

Comprehensive JavaScript/ FFI bindings for MoonBit, supporting multiple runtimes and platforms.

```bash
$ moon add mizchi/js
```

## Quick Links

### 📚 API Documentation by Platform

| Platform | Documentation | Examples | Status |
|----------|--------------|----------|--------|
| **Core JavaScript** | [src/README.md](src/README.md) | [js_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/js_examples.mbt.md) | 🧪 Tested |
| **Browser/DOM** | [src/browser/dom/README.md](src/browser/dom/README.md) | - | 🧪 Tested |
| **Node.js** | [src/node/README.md](src/node/README.md) | [node_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/node_examples.mbt.md) | 🚧 Partially |
| **Deno** | [src/deno/README.md](src/deno/README.md) | - | 🧪 Tested |
| **Cloudflare Workers** | [src/cloudflare/README.md](src/cloudflare/README.md) | [cfw/](src/examples/cfw/) | 🧪 Tested |
| **React** | [src/npm/react/](src/npm/react/) | [react_app/](src/examples/react_app/) | 🧪 Tested |

### 📖 Learning Resources

- [MoonBit Cheatsheet](https://github.com/mizchi/js.mbt/blob/main/src/examples/moonbit_cheatsheet.mbt.md) - Quick reference for MoonBit syntax
- [FFI Guide](https://github.com/mizchi/js.mbt/blob/main/src/examples/js_ffi.mbt.md) - Understanding MoonBit JavaScript FFI
- [Escape Hatch Pattern](https://github.com/mizchi/js.mbt/blob/main/src/examples/escape_hatch.mbt.md) - Advanced FFI techniques
- [For TypeScript Users](https://github.com/mizchi/js.mbt/blob/main/src/examples/for_ts_user.mbt.md) - Migration guide from TypeScript

---

## Installation

```bash
moon add mizchi/js
```

Add to your `moon.pkg.json`:

```json
{
  "import": ["mizchi/js"]
}
```

> **⚠️ Future Plans**: Platform-specific APIs (Node.js, Browser, Deno, Cloudflare Workers) will be split into separate packages in the future. The core `mizchi/js` package will focus on JavaScript built-ins and Web Standard APIs.

## Supported Modules

### Core APIs

- **[mizchi/js](src/README.md)** - Core JavaScript built-in APIs (Object, Promise, Array, ArrayBuffer, etc.)

### JavaScript Built-ins

- **[mizchi/js/builtins/typed_array](src/builtins/typed_array/)** - Binary data handling (TypedArrays, DataView)
- **[mizchi/js/builtins/date](src/builtins/date/)** - Date and time manipulation (Date)
- **[mizchi/js/builtins/math](src/builtins/math/)** - Mathematical operations (Math)
- **[mizchi/js/builtins/regexp](src/builtins/regexp/)** - Regular expressions (RegExp)
- **[mizchi/js/builtins/reflect](src/builtins/reflect/)** - Reflection API (Reflect)
- **[mizchi/js/builtins/proxy](src/builtins/proxy/)** - Proxy API (Proxy, Reflect)

### Web Standard APIs

Platform-independent Web Standard APIs (browsers, Node.js, Deno, edge runtimes):

- **[mizchi/js/web](src/web/README.md)** - Web APIs documentation
- **[mizchi/js/web/console](src/web/console/)** - Console logging (console.log, console.error, etc.)
- **[mizchi/js/web/http](src/web/http/)** - Fetch API (Request, Response, Headers, FormData)
- **[mizchi/js/web/url](src/web/url/)** - URL API (URL, URLSearchParams, URLPattern)
- **[mizchi/js/web/streams](src/web/streams/)** - Streams API (ReadableStream, WritableStream, TransformStream)
- **[mizchi/js/web/blob](src/web/blob/)** - Blob API (Blob, File)
- **[mizchi/js/web/encoding](src/web/encoding/)** - Encoding API (TextEncoder, TextDecoder)
- **[mizchi/js/web/event](src/web/event/)** - Event API (Event, CustomEvent, MessageEvent)
- **[mizchi/js/web/crypto](src/web/crypto/)** - Web Crypto API (SubtleCrypto, getRandomValues, randomUUID)
- **[mizchi/js/web/performance](src/web/performance/)** - Performance API (Performance, PerformanceEntry)
- **[mizchi/js/web/webassembly](src/web/webassembly/)** - WebAssembly API (WebAssembly.Module, WebAssembly.Instance)
- **[mizchi/js/web/websocket](src/web/websocket/)** - WebSocket API (WebSocket)
- **[mizchi/js/web/worker](src/web/worker/)** - Web Workers API (Worker, MessagePort)
- **[mizchi/js/web/message_channel](src/web/message_channel/)** - MessageChannel API (MessageChannel, MessagePort)

### Runtime-Specific

- **[mizchi/js/node](src/node/README.md)** - Node.js runtime APIs
- **[mizchi/js/browser/dom](src/browser/dom/README.md)** - Browser DOM APIs
- **[mizchi/js/deno](src/deno/README.md)** - Deno runtime APIs
- **[mizchi/js/cloudflare](src/cloudflare/README.md)** - Cloudflare Workers platform

### NPM Packages

- **[mizchi/js/npm/react](src/npm/react/)** - React library bindings
- **[mizchi/js/npm/hono](src/npm/hono/)** - Hono web framework
- **[mizchi/js/npm/semver](src/npm/semver/)** - Semantic versioning

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

### Basic Usages

```mbt
fn main {
  // JS: const obj = {}
  let obj = @js.Object::new()
  // JS: obj.xxx = 42
  obj.set("xxx", 42)
  
  // get with cast
  // JS: const v = obj.xxx
  let v: Int = obj.get("xxx") |> @js.unsafe_cast
  
  // call method
  // JS: const has_world = obj.hasOwnProperty("world")
  let has_world: Bool = obj.call("hasOwnProperty", ["world"]) |> @js.unsafe_cast
}
```

See escape hatch pattern in [escape_hatch.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/escape_hatch.mbt.md)

## LICENSE

MIT
