# @mizchi/js

Comprehensive JavaScript/TypeScript FFI bindings for MoonBit, supporting multiple runtimes and platforms.

```bash
$ moon add mizchi/js
```

## Quick Links

### 📚 API Documentation by Platform

| Platform | Documentation | Examples | Status |
|----------|--------------|----------|--------|
| **Core JavaScript** | [src/README.md](./src/README.md) | [js_examples.mbt.md](./src/examples/js_examples.mbt.md) | ✅ Tested |
| **Browser/DOM** | [src/dom/README.md](./src/dom/README.md) | - | ✅ Tested |
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
- **[mizchi/js/arraybuffer](./src/arraybuffer/)** - Binary data handling
- **[mizchi/js/http](./src/http/)** - Fetch API and HTTP primitives
- **[mizchi/js/stream](./src/stream/)** - Streams API (ReadableStream, etc.)
- **[mizchi/js/crypto](./src/crypto/)** - Web Crypto API
- **[mizchi/js/console](./src/console/)** - Console logging

### Runtime-Specific
- **[mizchi/js/node](./src/node/README.md)** - Node.js runtime APIs
- **[mizchi/js/dom](./src/dom/README.md)** - Browser DOM APIs
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

### Create your own bindings:

```mbt
using @js {
  trait JsImpl,
  unsafe_cast,
}

#external
pub type MyType

impl JsImpl for MyType

pub fn MyType::myMethod(self: Self, arg: String) -> Int {
  self.call("myMethod", [arg]) |> unsafe_cast
}
```

See escape hatch pattern in [docs/moonbit-js-ffi.md](./docs/moonbit-js-ffi.md)

## LICENSE

MIT
