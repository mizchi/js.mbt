# mizchi/js_web

Web Standard API bindings for MoonBit, providing **universal, platform-independent** access to standardized Web APIs.

These APIs work consistently across:
- **Browsers** (Chrome, Firefox, Safari, Edge)
- **Server-side runtimes** (Node.js 18+, Deno, Bun)
- **Edge runtimes** (Vercel Edge, Netlify Edge, and others)
- **Any WinterCG-compliant runtime**

## Web API Support Status

| API | Package | Status | Note |
|-----|---------|--------|------|
| **HTTP & Networking** |
| fetch | `mizchi/js_web/http` | 🧪 Tested | HTTP requests |
| Request | `mizchi/js_web/http` | 🧪 Tested | Request objects |
| Response | `mizchi/js_web/http` | 🧪 Tested | Response objects |
| Headers | `mizchi/js_web/http` | 🧪 Tested | HTTP headers |
| FormData | `mizchi/js_web/http` | 🧪 Tested | Form data handling |
| URL | `mizchi/js_web/url` | 🧪 Tested | URL parsing |
| URLSearchParams | `mizchi/js_web/url` | 🧪 Tested | Query strings |
| URLPattern | `mizchi/js_web/url` | 🧪 Tested | URL pattern matching |
| WebSocket | `mizchi/js_web/websocket` | 🧪 Tested | WebSocket API |
| **Streams** |
| ReadableStream | `mizchi/js_web/streams` | 🧪 Tested | Readable streams |
| WritableStream | `mizchi/js_web/streams` | 🧪 Tested | Writable streams |
| TransformStream | `mizchi/js_web/streams` | 🧪 Tested | Transform streams |
| CompressionStream | `mizchi/js_web/streams` | 🧪 Tested | GZIP/Deflate compression |
| DecompressionStream | `mizchi/js_web/streams` | 🧪 Tested | GZIP/Deflate decompression |
| **Binary Data** |
| Blob | `mizchi/js_web/blob` | 🧪 Tested | Binary data |
| File | `mizchi/js_web/file` | 🧪 Tested | Blob with a name and mtime |
| FileReader | `mizchi/js_web/file` | 🧪 Tested | Read a Blob as text/ArrayBuffer/data URL |
| **Encoding** |
| TextEncoder | `mizchi/js_web/encoding` | 🧪 Tested | String to Uint8Array |
| TextDecoder | `mizchi/js_web/encoding` | 🧪 Tested | Uint8Array to String |
| **Events** |
| Event | `mizchi/js_web/event` | 🧪 Tested | Event objects |
| CustomEvent | `mizchi/js_web/event` | 🧪 Tested | Custom events |
| MessageEvent | `mizchi/js_web/event` | 🧪 Tested | Message events |
| **Cryptography** |
| Crypto | `mizchi/js_web/crypto` | 🆗 Reviewed | Web Crypto API |
| SubtleCrypto | `mizchi/js_web/crypto` | 🤖 AI Generated | Cryptographic operations |
| **Workers & Concurrency** |
| Worker | `mizchi/js_web/worker` | 🧪 Tested | Web Workers |
| MessagePort | `mizchi/js_web/worker` | 🧪 Tested | Message passing |
| MessageChannel | `mizchi/js_web/message` | 🧪 Tested | Channel messaging |
| **WebAssembly** |
| WebAssembly | `mizchi/js_web/webassembly` | 🤖 AI Generated | WASM integration |
| **WebGPU** |
| WebGPU | `mizchi/js_web/webgpu` | 🧪 Experimental | GPU compute/rendering (Deno only) |
| **WebGL** |
| WebGL | `mizchi/js_web/webgl` | 📅 Planned | 2D/3D graphics rendering |
| WebGL2 | `mizchi/js_web/webgl` | 📅 Planned | WebGL 2.0 API |
| **WebTransport** |
| WebTransport | `mizchi/js_web/webtransport` | 📅 Planned | HTTP/3 based transport |

### Status Legend

- 🆗 **Reviewed**: Human reviewed (AI agents cannot change this status)
- 🧪 **Tested**: Comprehensive test coverage
- 🧪 **Experimental**: Early stage, limited platform support
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation

## Overview

This package provides comprehensive bindings to **Web Standard APIs** - the common subset of APIs standardized by WHATWG and W3C that work universally across JavaScript runtimes.

**Classification follows [WinterCG (Web-interoperable Runtimes Community Group)](https://wintercg.org/) definitions**, specifically the [Minimum Common Web Platform API](https://common-min-api.proposal.wintercg.org/) specification. APIs in `mizchi/js_web/*` are platform-independent and work across browsers, Node.js, Deno, Bun, and edge runtimes.

### Why Use web/* Packages?

- **Write Once, Run Anywhere**: Code using these APIs works in browsers, Node.js, Deno, and other modern runtimes
- **Server-Side JavaScript**: Build backend services with the same APIs you use in the browser
- **Edge Computing**: Deploy to edge runtimes without platform-specific code
- **Future-Proof**: Based on living standards that continue to evolve
- **Type-Safe**: MoonBit's type system ensures compile-time safety
- **Well-Tested**: Comprehensive test coverage across environments

### Included APIs

- **HTTP/Networking**: fetch, Request/Response, Headers, FormData, URL APIs, WebSocket
- **Streams**: ReadableStream, WritableStream, TransformStream for efficient data processing
- **Cryptography**: Web Crypto API for secure operations (hashing, encryption, key generation)
- **Workers**: Web Workers and MessageChannel for concurrency (browser and Node.js)
- **WebGPU**: GPU compute and rendering (experimental, Deno `--unstable-webgpu` required)

## Installation

Add specific sub-packages to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js_web/blob",
    "mizchi/js_web/crypto",
    "mizchi/js_web/encoding",
    "mizchi/js_web/event",
    "mizchi/js_web/http",
    "mizchi/js_web/streams",
    "mizchi/js_web/url",
    "mizchi/js_web/webassembly",
    "mizchi/js_web/webgpu",
    "mizchi/js_web/websocket",
    "mizchi/js_web/worker"
  ]
}
```

**Note**: The `mizchi/js_web` package itself is a meta-package. You need to import specific sub-packages (like `mizchi/js_web/http`, `mizchi/js_web/crypto`, etc.) to use their APIs. There is no "wildcard import" in MoonBit - each sub-package must be imported explicitly.

## Usage Examples

### Fetch API (Universal - Browser & Server)

```moonbit
// Simple GET request - works in browser, Node.js, Deno, and edge runtimes
let response = @http.fetch("https://api.example.com/data")
let json = response.json()

// POST request with JSON body
let request = @http.Request::new("https://api.example.com/users", 
  method="POST",
  body="{\"name\":\"Alice\"}",
  headers=headers
)
let response = @http.fetch_with_request(request)

// Server-side API handler example (Cloudflare Workers, Vercel Edge, etc.)
fn handle_request(request : @http.Request) -> @http.Response {
  let url = request.url()
  if url.pathname == "/api/hello" {
    @http.Response::new(
      body="{\"message\":\"Hello World\"}",
      status=200,
      headers=...
    )
  } else {
    @http.Response::new(body="Not Found", status=404)
  }
}
```

### Streams (Server-Side Data Processing)

```moonbit
// Streaming API responses - efficient for large datasets
fn stream_large_file(file_path : String) -> @http.Response {
  let stream = @streams.ReadableStream::new(...)
  @http.Response::new(
    body=stream,
    headers=...
  )
}

// Transform streams for data processing pipelines
fn process_stream(input : @streams.ReadableStream) -> @streams.ReadableStream {
  let transform = @streams.TransformStream::new()
  input.pipe_through(transform)
}

// Server-sent events (SSE) example
fn create_sse_stream() -> @streams.ReadableStream {
  @streams.ReadableStream::new(controller => {
    // Send periodic updates
    controller.enqueue("data: {\"time\": \"...\"}\n\n")
  })
}

// Compression streams - compress data on the fly
fn compress_response(data : String) -> @streams.ReadableStream {
  let compressor = @streams.CompressionStream::new("gzip")
  let encoder = @encoding.TextEncoder::new()
  
  // Create a readable stream from data
  let readable = create_stream_from_string(data)
  
  // Pipe through compression
  readable.pipeThrough(compressor)
  compressor.readable()
}

// Decompression streams - decompress streamed data
fn decompress_request(compressed_stream : @streams.ReadableStream) -> @streams.ReadableStream {
  let decompressor = @streams.DecompressionStream::new("gzip")
  compressed_stream.pipeThrough(decompressor)
  decompressor.readable()
}
```

### Web Crypto (Secure Server-Side Operations)

```moonbit
// Password hashing (server-side authentication)
fn hash_password(password : String) -> @js.Promise[@arraybuffer.ArrayBuffer] {
  let crypto = @crypto.get_crypto()
  let subtle = crypto.subtle
  let encoder = @js.TextEncoder::new()
  let data = encoder.encode(password)
  subtle.digest("SHA-256", data)
}

// Generate JWT tokens (API authentication)
fn sign_jwt(payload : String, secret : String) -> @js.Promise[String] {
  let crypto = @crypto.get_crypto()
  let subtle = crypto.subtle
  
  // Import HMAC key
  let key = subtle.import_key(
    "raw",
    secret,
    {name: "HMAC", hash: "SHA-256"},
    false,
    ["sign"]
  )
  
  // Sign payload
  subtle.sign("HMAC", key, payload)
}

// Encrypt sensitive data (database encryption)
fn encrypt_data(data : String) -> @js.Promise[@arraybuffer.ArrayBuffer] {
  let crypto = @crypto.get_crypto()
  let subtle = crypto.subtle
  
  // Generate key
  let key = subtle.generate_key(
    @crypto.AesKeyGenParams::new("AES-GCM", 256),
    true,
    ["encrypt", "decrypt"]
  )
  
  // Encrypt
  subtle.encrypt(algorithm, key, data)
}
```

### WebSocket (Real-Time Communication)

```moonbit
// Client-side (browser) or server-side (Node.js, Bun)
let ws = @websocket.WebSocket::new("wss://api.example.com/ws")

ws.addEventListener("open", fn(event) {
  ws.send("{\"type\":\"subscribe\",\"channel\":\"updates\"}")
})

ws.addEventListener("message", fn(event) {
  let data = event.data()
  // Process real-time updates
  console.log(data)
})

ws.addEventListener("error", fn(event) {
  console.error("WebSocket error")
})

// Cloudflare Workers Durable Objects WebSocket example
fn handle_websocket(request : @http.Request) -> @http.Response {
  let upgrade = request.headers()._get("Upgrade")
  if upgrade == Some("websocket") {
    // Upgrade connection to WebSocket
    // Handle WebSocket messages
  }
  @http.Response::new(body="Not a WebSocket request", status=400)
}
```

### Web Workers

```moonbit
let worker = @worker.Worker::new("worker.js")

worker.addEventListener("message", fn(event) {
  let result = event.data()
  console.log(result)
})

worker.postMessage("Start processing")
```

## Common Use Cases

### 🌐 Universal API Client
Build HTTP clients that work in any environment:
```moonbit
// Same code runs in browser, Node.js, Deno, Cloudflare Workers
fn fetch_user(id : Int) -> @js.Promise[@core.Any] {
  let response = @http.fetch("https://api.example.com/users/\(id)")
  response.json()
}
```

### 🔐 Authentication & Security
Handle authentication uniformly across platforms:
```moonbit
fn verify_jwt(token : String) -> Bool {
  // Web Crypto works everywhere
  let crypto = @crypto.get_crypto()
  // Verify signature
}
```

### 📡 Edge Computing
Build edge functions with standard APIs:
```moonbit
// Deploy to Cloudflare Workers, Vercel Edge, Netlify Edge
fn handle(request : @http.Request) -> @http.Response {
  let path = request.url().pathname
  match path {
    "/api/data" => fetch_and_transform_data()
    _ => @http.Response::new(body="Not Found", status=404)
  }
}
```

### 🔄 Data Streaming
Process large datasets efficiently:
```moonbit
// Stream processing works on server and client
fn process_large_file(url : String) -> @stream.ReadableStream {
  let response = @http.fetch(url)
  response.body()
}
```

### 💬 Real-Time Communication
WebSocket works in all environments:
```moonbit
// Same code for browser client and Node.js backend
fn connect_to_server() -> @websocket.WebSocket {
  @websocket.WebSocket::new("wss://api.example.com/ws")
}
```

## Platform Compatibility

| API | Browser | Node.js | Deno | Bun | Cloudflare Workers | Vercel Edge |
|-----|---------|---------|------|-----|-------------------|-------------|
| fetch | ✅ | ✅ (18+) | ✅ | ✅ | ✅ | ✅ |
| Request/Response | ✅ | ✅ (18+) | ✅ | ✅ | ✅ | ✅ |
| Headers | ✅ | ✅ (18+) | ✅ | ✅ | ✅ | ✅ |
| URL | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| WebSocket | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Streams | ✅ | ✅ (16+) | ✅ | ✅ | ✅ | ✅ |
| Web Crypto | ✅ | ✅ (15+) | ✅ | ✅ | ✅ | ✅ |
| Workers | ✅ | ✅ (10+) | ✅ | ✅ | ✅ (Durable Objects) | ❌ |
| WebGPU | ✅ | ❌ | ✅ (unstable) | ❌ | ❌ | ❌ |

## When to Use web/* vs Other Packages

### Use `mizchi/js_web/*` when:
- ✅ Building cross-platform libraries
- ✅ Writing code for edge computing (Cloudflare Workers, Vercel Edge)
- ✅ Creating universal API clients
- ✅ Need standard HTTP/fetch APIs
- ✅ Working with streams for data processing
- ✅ Implementing authentication/cryptography

### Use `mizchi/js_browser/*` when:
- 🌐 Manipulating the DOM (Document, Element, Events)
- 🌐 Browser-specific APIs (Window, Navigator, Storage)
- 🌐 Canvas rendering
- 🌐 Browser-only features (MutationObserver, etc.)

### Use `mizchi/js_node/*` when:
- 🟢 Accessing file system (fs)
- 🟢 Process management (child_process)
- 🟢 Node.js-specific modules (path, os, etc.)

### Use `mizchi/js/cloudflare/*` when:
- ⚡ Using Cloudflare Workers APIs (KV, D1, R2)
- ⚡ Durable Objects
- ⚡ Workers-specific features

## Related Packages

- **`mizchi/js`** - Core JavaScript FFI and built-in objects
- **`mizchi/js_browser/dom`** - Browser-specific DOM and rendering APIs
- **`mizchi/js_node`** - Node.js-specific runtime APIs
- **`mizchi/js/cloudflare`** - Cloudflare Workers platform APIs
- **`mizchi/js_deno`** - Deno runtime APIs (separate module)

## Standards Compliance

All APIs follow official **WHATWG** and **W3C** specifications, ensuring compatibility across JavaScript runtimes:

- [Fetch Standard](https://fetch.spec.whatwg.org/) - HTTP requests and responses
- [Streams Standard](https://streams.spec.whatwg.org/) - Streaming data processing
- [Compression Streams API](https://wicg.github.io/compression/) - GZIP/Deflate compression and decompression
- [Web Crypto API](https://www.w3.org/TR/WebCryptoAPI/) - Cryptographic operations
- [WebSocket API](https://websockets.spec.whatwg.org/) - Real-time bidirectional communication
- [Web Workers](https://html.spec.whatwg.org/multipage/workers.html) - Background processing
- [URL Standard](https://url.spec.whatwg.org/) - URL parsing and manipulation
- [WebAssembly JavaScript Interface](https://webassembly.github.io/spec/js-api/) - WASM integration
- [WebGPU API](https://www.w3.org/TR/webgpu/) - GPU compute and rendering (experimental)

These bindings follow [WinterCG (Web-interoperable Runtimes Community Group)](https://wintercg.org/) standards, specifically:
- [Minimum Common Web Platform API](https://common-min-api.proposal.wintercg.org/) - Core APIs that work across all JavaScript runtimes
- [Runtime Keys](https://runtime-keys.proposal.wintercg.org/) - Runtime detection and capabilities

## License

See the main project license.
