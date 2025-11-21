# @mizchi/js

Comprehensive JavaScript/ FFI bindings for MoonBit, supporting multiple runtimes and platforms.

```bash
$ moon add mizchi/js
```

## Quick Links

### 📚 API Documentation by Platform

| Platform | Documentation | Examples | Status |
|----------|--------------|----------|--------|
| **Core JavaScript** | [src/README.md](./src/README.md) | [js_examples.mbt.md](./src/examples/js_examples.mbt.md) | ✅ Tested |
| **Browser/DOM** | [src/browser/dom/README.md](./src/browser/dom/README.md) | - | ✅ Tested |
| **Node.js** | [src/node/README.md](./src/node/README.md) | [node_examples.mbt.md](./src/examples/node_examples.mbt.md) | 🚧 Partially |
| **Deno** | [src/deno/README.md](./src/deno/README.md) | - | ✅ Tested |
| **Cloudflare Workers** | [src/cloudflare/README.md](./src/cloudflare/README.md) | [cfw/](./src/examples/cfw/) | ✅ Tested |
| **React** | [src/npm/react/](./src/npm/react/) | [react_app/](./src/examples/react_app/) | ✅ Tested |

### 📖 Learning Resources

- [FFI Guide](./src/examples/js_ffi.mbt.md) - Understanding MoonBit JavaScript FFI
- [Escape Hatch Pattern](./src/examples/escape_hatch.mbt.md) - Advanced FFI techniques
- [For TypeScript Users](./src/examples/for_ts_user.mbt.md) - Migration guide from TypeScript

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

## Supported Modules

### Core APIs

- **[mizchi/js](./src/README.md)** - Core JavaScript built-in APIs (Object, Promise, Array, etc.)
- **[mizchi/js/arraybuffer](./src/arraybuffer/)** - Binary data handling (ArrayBuffer, TypedArrays)
- **[mizchi/js/console](./src/console/)** - Console logging

### Web Standard APIs

Platform-independent Web Standard APIs that work across browsers, Node.js, Deno, Bun, and edge runtimes:

- **[mizchi/js/web](./src/web/README.md)** - Meta-package documentation for all Web APIs
- **[mizchi/js/web/http](./src/web/http/)** - Fetch API (Request, Response, Headers, FormData)
- **[mizchi/js/web/url](./src/web/url/)** - URL APIs (URL, URLSearchParams, URLPattern)
- **[mizchi/js/web/streams](./src/web/streams/)** - Streams API (ReadableStream, WritableStream, TransformStream)
- **[mizchi/js/web/blob](./src/web/blob/)** - Blob API for binary data
- **[mizchi/js/web/encoding](./src/web/encoding/)** - Encoding API (TextEncoder, TextDecoder)
- **[mizchi/js/web/event](./src/web/event/)** - Event APIs (Event, CustomEvent, MessageEvent)
- **[mizchi/js/web/crypto](./src/web/crypto/)** - Web Crypto API for cryptographic operations
- **[mizchi/js/web/websocket](./src/web/websocket/)** - WebSocket API for real-time communication
- **[mizchi/js/web/worker](./src/web/worker/)** - Web Workers API for background processing

### Runtime-Specific

- **[mizchi/js/node](./src/node/README.md)** - Node.js runtime APIs
- **[mizchi/js/browser/dom](./src/browser/dom/README.md)** - Browser DOM APIs
- **[mizchi/js/deno](./src/deno/README.md)** - Deno runtime APIs
- **[mizchi/js/cloudflare](./src/cloudflare/README.md)** - Cloudflare Workers platform

### NPM Packages

- **[mizchi/js/npm/react](./src/npm/react/)** - React library bindings
- **[mizchi/js/npm/hono](./src/npm/hono/)** - Hono web framework
- **[mizchi/js/npm/semver](./src/npm/semver/)** - Semantic versioning

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

See escape hatch pattern in [docs/moonbit-js-ffi.md](./docs/moonbit-js-ffi.md)

## LICENSE

MIT
