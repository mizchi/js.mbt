# mizchi/js

Comprehensive JavaScript/ FFI bindings for MoonBit, supporting multiple runtimes and platforms.

## Package Layout

Starting in **v0.11.0**, environment-specific bindings live in their own MoonBit modules under the `mizchi/js_*` namespace. The core `mizchi/js` module covers JavaScript built-ins, Web Standard APIs, and Node.js — pull in the additional modules only for the runtimes you target.

| Module | Scope | Source |
|--------|-------|--------|
| [`mizchi/js`](https://github.com/mizchi/js.mbt) | Core FFI, JS built-ins, Web Standard APIs, Node.js | `src/` |
| [`mizchi/js_browser`](https://github.com/mizchi/js.mbt/tree/main/modules/js_browser) | Browser-only APIs (DOM, canvas, IndexedDB, storage, navigation, service worker, …) | `modules/js_browser/` |
| [`mizchi/js_deno`](https://github.com/mizchi/js.mbt/tree/main/modules/js_deno) | Deno runtime APIs | `modules/js_deno/` |
| [`mizchi/js_bun`](https://github.com/mizchi/js.mbt/tree/main/modules/js_bun) | Bun runtime APIs | `modules/js_bun/` |
| [`mizchi/js_webextensions`](https://github.com/mizchi/js.mbt/tree/main/modules/js_webextensions) | WebExtensions (`chrome.*` / `browser.*`) | `modules/js_webextensions/` |
| [`mizchi/npm_typed`](https://github.com/mizchi/npm_typed.mbt) | NPM package bindings (React, Hono, Zod, AI SDK, …) | separate repo |
| [`mizchi/cloudflare.mbt`](https://github.com/mizchi/cloudflare.mbt) | Cloudflare Workers bindings | separate repo |

See [`docs/package-split.md`](docs/package-split.md) for the migration steps and the multi-module layout.

## Version Requirements

**v0.10.0+** requires MoonBit nightly `2025-12-09` or later for ESM `#module` directive support:

```
moon 0.1.20251209 (8d6e473 2025-12-09)
moonc v0.6.34+7262739a4-nightly (2025-12-09)
moonrun 0.1.20251209 (8d6e473 2025-12-09)
```

If you need stable toolchain compatibility, use **v0.8.x**.

## Installation

```bash
$ moon add mizchi/js
# Pull in additional runtimes as needed:
$ moon add mizchi/js_browser
$ moon add mizchi/js_deno
$ moon add mizchi/js_bun
$ moon add mizchi/js_webextensions
```

Add to your `moon.pkg.json`:

```json
{
  "import": ["mizchi/js_core", "mizchi/js"]
}
```

## Quick Links

### 📚 API Documentation by Platform

| Platform | Documentation | Examples | Status |
|----------|--------------|----------|--------|
| **Core JavaScript** | [src/README.md](src/README.md) | [js_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/js_examples.mbt.md) | 🧪 Tested |
| **Browser** | [modules/js_browser/src/README.md](modules/js_browser/src/README.md) | [browser_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/browser_examples.mbt.md) | 🧪 Tested |
| **Node.js** | [src/node/README.md](src/node/README.md) | [node_examples.mbt.md](https://github.com/mizchi/js.mbt/blob/main/src/examples/node_examples.mbt.md) | 🧪 Tested |
| **Deno** | [src/deno/README.md](src/deno/README.md) | - | 🧪 Tested |
| **React** | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) | See npm_typed repo | 📦 Moved |

### 📖 Learning Resources

- [MoonBit Cheatsheet](https://github.com/mizchi/js.mbt/blob/main/src/examples/moonbit_cheatsheet.mbt.md) - Quick reference for MoonBit syntax
- [FFI Best Practice](https://github.com/mizchi/js.mbt/blob/main/src/examples/ffi_bestpractice.mbt.md) - Best practice for MoonBit JavaScript FFI
- [Escape Hatch Pattern](https://github.com/mizchi/js.mbt/blob/main/src/examples/escape_hatch.mbt.md) - Advanced FFI techniques
- [For TypeScript Users](https://github.com/mizchi/js.mbt/blob/main/src/examples/moonbit_for_ts_user.mbt.md) - Migration guide from TypeScript
- [Package Split Guide](docs/package-split.md) - moon.work multi-module layout and migration steps

## Supported Modules

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage, production ready
- 🚧 **Partially**: Core functionality implemented, tests incomplete
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation
- ❌ **Not Supported**: Technical limitations

### Core JavaScript APIs

#### mizchi/js_core - Core FFI Package

The `mizchi/js_core` package provides the foundation for JavaScript interoperability in MoonBit:

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
| Core FFI | `mizchi/js_core` | 🧪 Tested | `get`, `set`, `call`, etc. |
| Object | `mizchi/js_builtin/object` | 🧪 Tested | Object manipulation |
| Function | `mizchi/js_builtin/function` | 🧪 Tested | Function operations |
| Promise | `mizchi/js_core` | 🧪 Tested | Async/Promise API |
| Error | `mizchi/js_builtin/error` | 🧪 Tested | Error handling |
| JSON | `mizchi/js_builtin/json` | 🧪 Tested | JSON parse/stringify |
| Iterator | `mizchi/js_builtin/iterator` | 🧪 Tested | JS Iterator protocol |
| AsyncIterator | `mizchi/js_builtin/iterator` | 🧪 Tested | Async iteration |
| WeakMap/Set/Ref | `mizchi/js_builtin/weak` | 🧪 Tested | Weak references |
| **Async Helpers** |
| run_async | `mizchi/js_core` | 🧪 Tested | Async execution |
| suspend | `mizchi/js_core` | 🧪 Tested | Promise suspension |
| sleep | `mizchi/js_core` | 🧪 Tested | Delay execution |
| promisify | `mizchi/js_core` | 🧪 Tested | Callback → Promise |

### JavaScript Built-ins

All JavaScript built-in objects are exported from `mizchi/js`:

| Category | Package | Status | Note |
|----------|---------|--------|------|
| **Global Functions** |
| Global | `mizchi/js_builtin/global` | 🧪 Tested | globalThis, parseInt, parseFloat, setTimeout etc. |
| **Core Types** |
| Object | `mizchi/js_builtin/object` | 🧪 Tested | Object manipulation |
| Function | `mizchi/js_builtin/function` | 🧪 Tested | Function operations |
| Symbol | `mizchi/js_builtin/symbol` | 🧪 Tested | Symbol primitive |
| Error | `mizchi/js_builtin/error` | 🧪 Tested | Error types (TypeError, RangeError, etc.) |
| **Primitives & Data** |
| String | `mizchi/js_builtin/string` | 🧪 Tested | JsString (String methods) |
| Array | `mizchi/js_builtin/array` | 🧪 Tested | JsArray (Array methods) |
| BigInt | `mizchi/js_builtin/bigint` | 🧪 Tested | JsBigInt (arbitrary precision) |
| JSON | `mizchi/js_builtin/json` | 🧪 Tested | JSON parse/stringify |
| **Date & Math** |
| Date | `mizchi/js_builtin/date` | 🧪 Tested | Date/time operations |
| Math | `mizchi/js_builtin/math` | 🧪 Tested | Math operations |
| **Collections** |
| Map/Set | `mizchi/js_builtin/collection` | 🧪 Tested | JsMap, JsSet |
| WeakMap/Set/Ref | `mizchi/js_builtin/weak` | 🧪 Tested | WeakMap, WeakSet, WeakRef, FinalizationRegistry |
| **Binary Data** |
| ArrayBuffer | `mizchi/js_builtin/arraybuffer` | 🧪 Tested | Binary buffers |
| DataView | `mizchi/js_builtin/arraybuffer` | 🧪 Tested | Buffer views |
memory |
| **Pattern & Reflection** |
| RegExp | `mizchi/js_builtin/regexp` | 🧪 Tested | Regular expressions |
| Reflect | `mizchi/js_builtin/reflect` | 🧪 Tested | Reflection API |
| Proxy | `mizchi/js_builtin/proxy` | 🤖 AI Generated | Proxy API |
| **Iteration & Async** |
| Iterator | `mizchi/js_builtin/iterator` | 🧪 Tested | JsIterator protocol |
| AsyncIterator | `mizchi/js_builtin/iterator` | 🧪 Tested | Async iteration |
| **Concurrency** |
| Atomics | `mizchi/js_builtin/atomics` | 🧪 Tested | Atomic operations |
| **Resource Management** |
| DisposableStack | `mizchi/js_builtin/disposable` | 🧪 Tested | Disposable resources |

### Web Standard APIs

Platform-independent Web Standard APIs (browsers, Node.js, Deno, edge runtimes),
shipped as the separate `mizchi/js_web` module:

> See **[mizchi/js_web](modules/js_web/src/README.md)** for detailed Web APIs documentation

| Category | Package | Status | Note |
|----------|---------|--------|------|
| Console | `mizchi/js_web/console` | 🧪 Tested | console.log, console.error, etc. |
| fetch | `mizchi/js_web/http` | 🧪 Tested | HTTP requests |
| Request | `mizchi/js_web/http` | 🧪 Tested | Request objects |
| Response | `mizchi/js_web/http` | 🧪 Tested | Response objects |
| Headers | `mizchi/js_web/http` | 🧪 Tested | HTTP headers |
| FormData | `mizchi/js_web/http` | 🧪 Tested | Form data |
| URL | `mizchi/js_web/url` | 🧪 Tested | URL parsing |
| URLSearchParams | `mizchi/js_web/url` | 🧪 Tested | Query strings |
| URLPattern | `mizchi/js_web/url` | 🧪 Tested | URL pattern matching |
| Blob | `mizchi/js_web/blob` | 🧪 Tested | Binary data |
| ReadableStream | `mizchi/js_web/streams` | 🧪 Tested | Stream reading |
| WritableStream | `mizchi/js_web/streams` | 🧪 Tested | Stream writing |
| TransformStream | `mizchi/js_web/streams` | 🧪 Tested | Stream transformation |
| CompressionStream | `mizchi/js_web/streams` | 🧪 Tested | GZIP/Deflate compression |
| DecompressionStream | `mizchi/js_web/streams` | 🧪 Tested | GZIP/Deflate decompression |
| TextEncoder | `mizchi/js_web/encoding` | 🧪 Tested | String to Uint8Array |
| TextDecoder | `mizchi/js_web/encoding` | 🧪 Tested | Uint8Array to String |
| Event | `mizchi/js_web/event` | 🧪 Tested | Event objects |
| CustomEvent | `mizchi/js_web/event` | 🧪 Tested | Custom events |
| MessageEvent | `mizchi/js_web/event` | 🧪 Tested | Message events |
| Crypto | `mizchi/js_web/crypto` | 🧪 Tested | Web Crypto API |
| WebSocket | `mizchi/js_web/websocket` | 🧪 Tested | WebSocket API |
| Worker | `mizchi/js_web/worker` | 🧪 Tested | Web Workers |
| MessageChannel | `mizchi/js_web/message` | 🧪 Tested | Message passing |
| MessagePort | `mizchi/js_web/message` | 🧪 Tested | Message ports |
| WebAssembly | `mizchi/js_web/webassembly` | 🤖 AI Generated | WASM integration |
| Performance | `mizchi/js_web/performance` | 🤖 AI Generated | Performance API |

### Runtime-Specific APIs

Web Standard, Node.js, Browser, Deno, Bun, and WebExtensions APIs ship as separate `mizchi/js_*` modules — add each one to your `moon.mod` `import` list only if you need it.

| Platform | Module | Status | Documentation |
|----------|--------|--------|---------------|
| Web Standards | `mizchi/js_web/*` | 🧪 Tested | [Web README](modules/js_web/src/README.md) |
| Node.js | `mizchi/js_node/*` | 🧪 Tested | [Node.js README](modules/js_node/src/README.md) |
| Browser API | `mizchi/js_browser/*` | 🧪 Tested | [Browser README](modules/js_browser/src/README.md) |
| Deno | `mizchi/js_deno` | 🧪 Tested | [Deno README](modules/js_deno/src/README.md) |
| Bun | `mizchi/js_bun` | 🤖 AI Generated | - |
| WebExtensions | `mizchi/js_webextensions` | 🤖 AI Generated | [WebExtensions README](modules/js_webextensions/src/README.md) |

### NPM Package Bindings

> **Moved to separate repository**: NPM package bindings are now maintained at [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt)

| Category | Packages | Repository |
|----------|----------|------------|
| **UI Frameworks** | React, React DOM, React Router, Preact, Ink | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Web Frameworks** | Hono, better-auth | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **AI / LLM** | Vercel AI SDK, MCP SDK, Claude Code SDK | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Cloud Services** | @aws-sdk/client-s3 (S3, R2, GCS, MinIO) | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Database** | PGlite, DuckDB, Drizzle, pg | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Validation** | Zod, AJV | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Build Tools** | Terser, Vite, Unplugin, Lighthouse | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Utilities** | date-fns, semver, chalk, dotenv, chokidar, yargs, debug | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Testing** | Testing Library, Puppeteer, Playwright, Vitest, JSDOM, MSW | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Parsing** | htmlparser2, js-yaml | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |
| **Other** | simple-git, ignore, memfs, source-map, comlink | [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) |

### Limited Support APIs

| Feature | Status | Note |
|---------|--------|------|
| `eval()` | ❌ Not Supported | Security and type safety concerns |
| `new Function()` | ❌ Not Supported | Security and type safety concerns |

## Project Status

- 📦 **FFI foundation** (`mizchi/js_core`) - `Any`, `Promise`, `Nullable`, target-specific interop. Split out into its own module
- 📦 **JS built-ins** (`mizchi/js_builtin`) - Object, Array, JSON, RegExp, Symbol, Proxy, ... Split out into its own module
- ✅ **`mizchi/js`** - meta package re-exporting `js_core` + `js_builtin`, plus `mbtconv` and the wasm-gc entry
- 📦 **Web Standards** (`mizchi/js_web`) - fetch, URL, Streams, Blob, Crypto, WebSocket, Workers. Split out into its own module
- 📦 **Node.js Core APIs** (`mizchi/js_node`) - `fs`, `path`, `process`, `child_process`, etc. Split out into its own module
- 📦 **Browser / DOM** (`mizchi/js_browser`) - Split out in v0.11.0
- 📦 **Deno Runtime** (`mizchi/js_deno`) - Split out in v0.11.0
- 📦 **Bun Runtime** (`mizchi/js_bun`) - Split out in v0.11.0
- 📦 **WebExtensions** (`mizchi/js_webextensions`) - Split out in v0.11.0
- 📦 **React / NPM Packages** - Maintained at [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt)
- 📦 **Cloudflare Workers** - Maintained at [mizchi/cloudflare.mbt](https://github.com/mizchi/cloudflare.mbt)

## Goals

- Provide comprehensive JavaScript FFI bindings for MoonBit
- **Platform Coverage** (split across `mizchi/js_*` modules)
  - ✅ Browser DOM and Web APIs (`mizchi/js_browser`)
  - ✅ Node.js (bundled with `mizchi/js`) / Deno (`mizchi/js_deno`) / Bun (`mizchi/js_bun`)
  - ✅ JavaScript built-in objects and Web Standard APIs (`mizchi/js`)
- **Ecosystem**
  - 📦 NPM package bindings: [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt)
  - 📦 Cloudflare Workers: [mizchi/cloudflare.mbt](https://github.com/mizchi/cloudflare.mbt)

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
