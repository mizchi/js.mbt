# mizchi/js - MoonBit JavaScript Bindings

Comprehensive JavaScript FFI bindings for MoonBit, providing type-safe access to JavaScript APIs across browsers, Node.js, and edge runtimes.

## Core JavaScript API Support Status

| Category | Package | Status | Note |
|----------|---------|--------|------|
| **Core JS** |
| Core FFI | `mizchi/js` | ✅ Tested | `get`, `set`, `call`, etc. |
| Object | `mizchi/js` | ✅ Tested | Object manipulation |
| Function | `mizchi/js` | ✅ Tested | Function operations |
| Promise | `mizchi/js` | ✅ Tested | Async/Promise API |
| Error | `mizchi/js` | ✅ Tested | Error handling |
| JSON | `mizchi/js` | ✅ Tested | JSON parse/stringify |
| Iterator | `mizchi/js` | ✅ Tested | JS Iterator protocol |
| AsyncIterator | `mizchi/js` | ✅ Tested | Async iteration |
| WeakMap/Set/Ref | `mizchi/js` | ✅ Tested | Weak references |
| **Async Helpers** |
| run_async | `mizchi/js` | ✅ Tested | Async execution |
| suspend | `mizchi/js` | ✅ Tested | Promise suspension |
| sleep | `mizchi/js` | ✅ Tested | Delay execution |
| promisify | `mizchi/js` | ✅ Tested | Callback → Promise |
| **Binary Data** |
| ArrayBuffer | `mizchi/js/arraybuffer` | ✅ Tested | Binary buffers |
| TypedArrays | `mizchi/js/arraybuffer` | ✅ Tested | Uint8Array, etc. |
| DataView | `mizchi/js/arraybuffer` | ✅ Tested | Buffer views |
| SharedArrayBuffer | `mizchi/js/arraybuffer` | 🤖 AI Generated | Shared memory |
| **Standard APIs** |
| RegExp | `mizchi/js/regexp` | ✅ Tested | Regular expressions |
| Date | `mizchi/js/date` | ✅ Tested | Date/time operations |
| Console | `mizchi/js/console` | ✅ Tested | Console logging |
| Performance | `mizchi/js/performance` | 🤖 AI Generated | Performance API |
| Math | `mizchi/js/math` | ✅ Tested | Math operations |
| Reflect | `mizchi/js/reflect` | 🤖 AI Generated | Reflection API |
| **Web Standard APIs** |
| fetch | `mizchi/js/web/http` | ✅ Tested | HTTP requests |
| Request | `mizchi/js/web/http` | ✅ Tested | Request objects |
| Response | `mizchi/js/web/http` | ✅ Tested | Response objects |
| Headers | `mizchi/js/web/http` | ✅ Tested | HTTP headers |
| FormData | `mizchi/js/web/http` | ✅ Tested | Form data |
| URL | `mizchi/js/web/url` | ✅ Tested | URL parsing |
| URLSearchParams | `mizchi/js/web/url` | ✅ Tested | Query strings |
| URLPattern | `mizchi/js/web/url` | ✅ Tested | URL pattern matching |
| Blob | `mizchi/js/web/blob` | ✅ Tested | Binary data |
| Streams | `mizchi/js/web/streams` | ✅ Tested | ReadableStream, etc. |
| CompressionStream | `mizchi/js/web/streams` | ✅ Tested | GZIP/Deflate compression |
| DecompressionStream | `mizchi/js/web/streams` | ✅ Tested | GZIP/Deflate decompression |
| TextEncoder | `mizchi/js/web/encoding` | ✅ Tested | String to Uint8Array |
| TextDecoder | `mizchi/js/web/encoding` | ✅ Tested | Uint8Array to String |
| Event | `mizchi/js/web/event` | ✅ Tested | Event objects |
| CustomEvent | `mizchi/js/web/event` | ✅ Tested | Custom events |
| Crypto | `mizchi/js/web/crypto` | ✅ Tested | Web Crypto API |
| WebSocket | `mizchi/js/web/websocket` | ✅ Tested | WebSocket API |
| Worker | `mizchi/js/web/worker` | ✅ Tested | Web Workers |
| MessageChannel | `mizchi/js/web/worker` | ✅ Tested | Message passing |
| WebAssembly | `mizchi/js/web/webassembly` | 🤖 AI Generated | WASM integration |
| **Platform-Specific** |
| Node.js APIs | `mizchi/js/node/*` | 🚧 Partially | See [node/README](./node/README.md) |
| DOM APIs | `mizchi/js/browser/*` | ✅ Tested | See [browser/dom/README](./browser/dom/README.md) |
| Cloudflare | `mizchi/js/cloudflare/*` | 🤖 AI Generated | Workers/D1/KV/R2 |
| Deno | `mizchi/js/deno/*` | 🤖 AI Generated | Deno-specific APIs |
| **NPM Packages** |
| React | `mizchi/js/npm/react` | ✅ Tested | React bindings |
| React DOM | `mizchi/js/npm/react_dom_*` | ✅ Tested | React rendering |
| Hono | `mizchi/js/npm/hono` | ✅ Tested | Hono web framework |
| semver | `mizchi/js/npm/semver` | 🤖 AI Generated | Version parsing |

### Status Legend

- ✅ **Tested**: Comprehensive test coverage, production ready
- 🚧 **Partially**: Core functionality implemented, tests incomplete
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation
- ❌ **Not Supported**: Technical limitations

## Not Supported

| Feature | Reason |
|---------|--------|
| `eval()` | Security and type safety |
| `new Function()` | Security and type safety |
| `DisposableStack` | No `using` keyword in MoonBit |
| `AsyncDisposableStack` | No `await using` keyword in MoonBit |

## Package Structure

```
mizchi/js/
├── Core (js.mbt)              - Core FFI primitives
├── arraybuffer/               - Binary data handling
├── console/                   - Console API
├── date/                      - Date/time operations
├── math/                      - Math operations
├── performance/               - Performance API
├── reflect/                   - Reflection API
├── regexp/                    - Regular expressions
├── webassembly/               - WebAssembly API
├── web/                       - Web Standard APIs (platform-independent)
│   ├── blob/                  - Blob API
│   ├── crypto/                - Web Crypto API
│   ├── encoding/              - TextEncoder/TextDecoder
│   ├── event/                 - Event APIs
│   ├── http/                  - Fetch API (Request/Response/Headers/FormData)
│   ├── streams/               - Streams API (ReadableStream/WritableStream)
│   ├── url/                   - URL APIs (URL/URLSearchParams/URLPattern)
│   ├── webassembly/           - WebAssembly API
│   ├── websocket/             - WebSocket API
│   └── worker/                - Web Workers API
├── browser/                   - Browser-specific APIs
│   └── dom/                   - DOM APIs (see browser/dom/README.md)
├── node/                      - Node.js APIs (see node/README.md)
├── cloudflare/                - Cloudflare Workers APIs
├── deno/                      - Deno runtime APIs
└── npm/                       - NPM package bindings
    ├── hono/                  - Hono web framework
    ├── react/                 - React library
    ├── react_dom_server/      - React SSR
    ├── react_dom_client/      - React CSR
    └── semver/                - Semantic versioning
```

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js"
  ]
}
```

For specific APIs, import additional packages:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/browser/dom",
    "mizchi/js/node",
    "mizchi/js/web/http"
  ]
}
```

## Quick Start

### Basic FFI Operations

```moonbit
let obj = @js.from_entries([("name", "Alice"), ("age", 30)])
let name = obj.get("name")  // Get property
obj.set("age", 31)          // Set property
let result = obj.call("toString", [])  // Call method
```

### Async/Await

```moonbit
fn fetch_data() -> Unit {
  @js.run_async(fn() {
    let response = @http.fetch("https://api.example.com/data").await
    let json = response.json().await
    // Process json
  })
}
```

### Promise Handling

```moonbit
let promise = @js.Promise::resolve(42)
promise.then_(fn(value) {
  @console.log(value)
})
```

## Related Documentation

- [DOM APIs](./dom/README.md) - Browser DOM bindings
- [Node.js APIs](./node/README.md) - Node.js runtime bindings
- [Examples](./examples/) - Usage examples

## Contributing

See the main project documentation for contribution guidelines.
