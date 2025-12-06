# mizchi/js

Comprehensive JavaScript/ FFI bindings for MoonBit, supporting multiple runtimes and platforms.

## Installation

```bash
$ moon add mizchi/js
```

Add to your `moon.pkg.json`:

```json
{
  "import": ["mizchi/js/core", "mizchi/js"]
}
```

> **⚠️ Future Plans**: Platform-specific APIs (Node.js, Browser, Deno) will be split into separate packages in the future. The core `mizchi/js` package will focus on JavaScript built-ins and Web Standard APIs.
>
> **Note**: Cloudflare Workers bindings have been moved to a separate package: [@mizchi/cloudflare-mbt](https://github.com/mizchi/cloudflare.mbt)

## Quick Links

### 📚 API Documentation by Platform

| Platform | Documentation | Examples | Status |
|----------|--------------|----------|--------|
| **Core JavaScript** | [src/README.md](src/README.md) | [js_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/js_examples.mbt.md) | 🧪 Tested |
| **Browser** | [src/browser/README.md](src/browser/README.md) | [browser_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/browser_examples.mbt.md) | 🧪 Tested |
| **Node.js** | [src/node/README.md](src/node/README.md) | [node_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/node_examples.mbt.md) | 🧪 Tested |
| **Deno** | [src/deno/README.md](src/deno/README.md) | - | 🧪 Tested |
| **React** | [src/npm/react/](src/npm/react/) | [react_app/](src/examples/react_app/) | 🧪 Tested |

### 📖 Learning Resources

- [MoonBit Cheatsheet](https://github.com/mizchi/js.mbt/blob/main/src/examples/moonbit_cheatsheet.mbt.md) - Quick reference for MoonBit syntax
- [FFI Best Practice](https://github.com/mizchi/js.mbt/blob/main/src/examples/ffi_bestpractice.mbt.md) - Best practice for MoonBit JavaScript FFI
- [Escape Hatch Pattern](https://github.com/mizchi/js.mbt/blob/main/src/examples/escape_hatch.mbt.md) - Advanced FFI techniques
- [For TypeScript Users](https://github.com/mizchi/js.mbt/blob/main/src/examples/moonbit_for_ts_user.mbt.md) - Migration guide from TypeScript

## Supported Modules

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage, production ready
- 🚧 **Partially**: Core functionality implemented, tests incomplete
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation
- ❌ **Not Supported**: Technical limitations

### Core JavaScript APIs

#### mizchi/js/core - Core FFI Package

The `mizchi/js/core` package provides the foundation for JavaScript interoperability in MoonBit:

**Type System**
- `Any` - Opaque type for JavaScript values
- `Nullable[T]` - Represents `null | T`
- `Nullish[T]` - Represents `null | undefined | T`
- `Union2[A,B]` ~ `Union5[A,B,C,D,E]` - TypeScript union types (`A | B`)
- `Promise[T]` - JavaScript Promise wrapper

**FFI Operations** (zero-cost conversions)
- `identity[A,B](value: A) -> B` - Type casting using `%identity`
- `any[T](value: T) -> Any` - Convert to Any
- `Any::cast[T](self) -> T` - Cast from Any
- `obj["key"]`, `obj["key"] = value` - Property access (or `_get(key)`, `_set(key, value)`)
- `Any::_call(method, args)`, `Any::_invoke(args)` - Method calls

**Object & JSON**
- `new_object()`, `new_array()` - Create JS objects/arrays
- `object_keys()`, `object_values()`, `object_assign()`, `object_has_own()`
- `json_stringify()`, `json_parse()`, `json_stringify_pretty()`

**Async/Promise Support**
- `run_async(f)` - Execute async functions (MoonBit builtin `%async.run`)
- `suspend(f)` - Await promises (MoonBit builtin `%async.suspend`)
- `promisify0` ~ `promisify3` - Convert callbacks to promises
- Promise utilities: `resolve`, `reject`, `all`, `race`, `any`, `withResolvers`

**Error Handling**
- `JsError` - Generic JS error type
- `ThrowError` - Wrapper for thrown errors
- `try_sync(op)` - Safe wrapper converting JS exceptions to MoonBit errors
- `throwable(f)` - Convert JS exceptions to ThrowError
- `export_sync(op)` - Convert MoonBit errors to JS exceptions
- `throw_error(msg)` - Throw JS Error

**Type Checking**
- `is_object()`, `is_array()`, `is_null()`, `is_undefined()`, `is_nullish()`

**Nullish Utilities**
- `Nullish::to_option()`, `Nullable::to_option()` - Convert to MoonBit Option
- `nullable(opt)` - Convert Option to JS nullable
- `as_any(opt)` - Convert Option[Any] to Any

#### API Summary

| Category | Package | Status | Note |
|----------|---------|--------|------|
| **Core FFI & Objects** |
| Core FFI | `mizchi/js/core` | 🧪 Tested | `get`, `set`, `call`, etc. |
| Object | `mizchi/js/builtins/object` | 🧪 Tested | Object manipulation |
| Function | `mizchi/js/builtins/function` | 🧪 Tested | Function operations |
| Promise | `mizchi/js/core` | 🧪 Tested | Async/Promise API |
| Error | `mizchi/js/builtins/error` | 🧪 Tested | Error handling |
| JSON | `mizchi/js/builtins/json` | 🧪 Tested | JSON parse/stringify |
| Iterator | `mizchi/js/builtins/iterator` | 🧪 Tested | JS Iterator protocol |
| AsyncIterator | `mizchi/js/builtins/iterator` | 🧪 Tested | Async iteration |
| WeakMap/Set/Ref | `mizchi/js/builtins/weak` | 🧪 Tested | Weak references |
| **Async Helpers** |
| run_async | `mizchi/js/core` | 🧪 Tested | Async execution |
| suspend | `mizchi/js/core` | 🧪 Tested | Promise suspension |
| sleep | `mizchi/js/core` | 🧪 Tested | Delay execution |
| promisify | `mizchi/js/core` | 🧪 Tested | Callback → Promise |

### JavaScript Built-ins

All JavaScript built-in objects are exported from `mizchi/js`:

| Category | Package | Status | Note |
|----------|---------|--------|------|
| **Global Functions** |
| Global | `mizchi/js/builtins/global` | 🧪 Tested | globalThis, parseInt, parseFloat, setTimeout etc. |
| **Core Types** |
| Object | `mizchi/js/builtins/object` | 🧪 Tested | Object manipulation |
| Function | `mizchi/js/builtins/function` | 🧪 Tested | Function operations |
| Symbol | `mizchi/js/builtins/symbol` | 🧪 Tested | Symbol primitive |
| Error | `mizchi/js/builtins/error` | 🧪 Tested | Error types (TypeError, RangeError, etc.) |
| **Primitives & Data** |
| String | `mizchi/js/builtins/string` | 🧪 Tested | JsString (String methods) |
| Array | `mizchi/js/builtins/array` | 🧪 Tested | JsArray (Array methods) |
| BigInt | `mizchi/js/builtins/bigint` | 🧪 Tested | JsBigInt (arbitrary precision) |
| JSON | `mizchi/js/builtins/json` | 🧪 Tested | JSON parse/stringify |
| **Date & Math** |
| Date | `mizchi/js/builtins/date` | 🧪 Tested | Date/time operations |
| Math | `mizchi/js/builtins/math` | 🧪 Tested | Math operations |
| **Collections** |
| Map/Set | `mizchi/js/builtins/collection` | 🧪 Tested | JsMap, JsSet |
| WeakMap/Set/Ref | `mizchi/js/builtins/weak` | 🧪 Tested | WeakMap, WeakSet, WeakRef, FinalizationRegistry |
| **Binary Data** |
| ArrayBuffer | `mizchi/js/builtins/arraybuffer` | 🧪 Tested | Binary buffers |
| DataView | `mizchi/js/builtins/arraybuffer` | 🧪 Tested | Buffer views |
memory |
| **Pattern & Reflection** |
| RegExp | `mizchi/js/builtins/regexp` | 🧪 Tested | Regular expressions |
| Reflect | `mizchi/js/builtins/reflect` | 🧪 Tested | Reflection API |
| Proxy | `mizchi/js/builtins/proxy` | 🤖 AI Generated | Proxy API |
| **Iteration & Async** |
| Iterator | `mizchi/js/builtins/iterator` | 🧪 Tested | JsIterator protocol |
| AsyncIterator | `mizchi/js/builtins/iterator` | 🧪 Tested | Async iteration |
| **Concurrency** |
| Atomics | `mizchi/js/builtins/atomics` | 🧪 Tested | Atomic operations |
| **Resource Management** |
| DisposableStack | `mizchi/js/builtins/disposable` | 🧪 Tested | Disposable resources |

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
| Node.js | `mizchi/js/node/*` | 🧪 Tested | [Node.js README](src/node/README.md) |
| Browser API | `mizchi/js/browser/*` | 🧪 Tested | [Browser README](src/browser/README.md) |
| Deno | `mizchi/js/deno` | 🧪 Tested | [Deno README](src/deno/README.md) |

### NPM Package Bindings

> See **[src/npm/README.md](src/npm/README.md)** for full npm package documentation

| Category | Packages | Status |
|----------|----------|--------|
| **UI Frameworks** | React, React DOM, React Router, Preact, Ink | 🧪 Tested |
| **Web Frameworks** | Hono, better-auth | 🧪 Tested |
| **AI / LLM** | Vercel AI SDK, MCP SDK, Claude Code SDK | 🧪 Tested |
| **Cloud Services** | @aws-sdk/client-s3 (S3, R2, GCS, MinIO) | 🧪 Tested |
| **Database** | PGlite, DuckDB, Drizzle, pg | 🧪 Tested |
| **Validation** | Zod, AJV | 🧪 Tested |
| **Build Tools** | Terser, Vite, Unplugin, Lighthouse | 🧪 Tested |
| **Utilities** | date-fns, semver, chalk, dotenv, chokidar, yargs, debug | 🧪 Tested |
| **Testing** | Testing Library, Puppeteer, Playwright, Vitest, JSDOM, MSW | 🧪 Tested |
| **Parsing** | htmlparser2, js-yaml | 🧪 Tested |
| **Other** | simple-git, ignore, memfs, source-map, comlink | 🧪 Tested |

### Limited Support APIs

| Feature | Status | Note |
|---------|--------|------|
| `eval()` | ❌ Not Supported | Security and type safety concerns |
| `new Function()` | ❌ Not Supported | Security and type safety concerns |

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
  - ✅ Node.js/Deno support to replace TypeScript
  - ✅ Cloudflare Workers for edge computing
  - ✅ MCP server/client support

## Quick Start

### Basic FFI Operations

```moonbit
// Create JavaScript objects
let obj = @js.from_entries([
  ("name", @js.any("Alice")),
  ("age", @js.any(30))
])

// Get property
let name = obj["name"]

// Set property
obj["age"] = @js.any(31)

// Call method
let result = obj._call("toString", [])

// Type casting
let age: Int = obj["age"].cast()
```

## LICENSE

MIT
