# mizchi/js/web

Web Standard API bindings for MoonBit, providing platform-independent access to Web APIs that work across browsers, Node.js, Deno, and edge runtimes.

## Web API Support Status

| API | Package | Status | Note |
|-----|---------|--------|------|
| **HTTP & Networking** |
| fetch | `mizchi/js/web/http` | ✅ Tested | HTTP requests |
| Request | `mizchi/js/web/http` | ✅ Tested | Request objects |
| Response | `mizchi/js/web/http` | ✅ Tested | Response objects |
| Headers | `mizchi/js/web/http` | ✅ Tested | HTTP headers |
| FormData | `mizchi/js/web/http` | ✅ Tested | Form data handling |
| URL | `mizchi/js/web/http` | ✅ Tested | URL parsing |
| URLSearchParams | `mizchi/js/web/http` | ✅ Tested | Query strings |
| URLPattern | `mizchi/js/web/http` | ✅ Tested | URL pattern matching |
| WebSocket | `mizchi/js/web/websocket` | ✅ Tested | WebSocket API |
| **Streams** |
| ReadableStream | `mizchi/js/web/stream` | ✅ Tested | Readable streams |
| WritableStream | `mizchi/js/web/stream` | ✅ Tested | Writable streams |
| TransformStream | `mizchi/js/web/stream` | ✅ Tested | Transform streams |
| **Binary Data** |
| Blob | `mizchi/js/browser/blob` | 🤖 AI Generated | Binary data |
| File | `mizchi/js/browser/file` | 🤖 AI Generated | File objects |
| **Cryptography** |
| Crypto | `mizchi/js/web/crypto` | ✅ Tested | Web Crypto API |
| SubtleCrypto | `mizchi/js/web/crypto` | ✅ Tested | Cryptographic operations |
| **Workers & Concurrency** |
| Worker | `mizchi/js/web/worker` | ✅ Tested | Web Workers |
| MessagePort | `mizchi/js/web/worker` | ✅ Tested | Message passing |
| MessageChannel | `mizchi/js/web/worker` | ✅ Tested | Channel messaging |

### Status Legend

- ✅ **Tested**: Comprehensive test coverage
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation

## Overview

This package provides comprehensive bindings to Web Standard APIs that are:

- **Platform-independent**: Work across browsers, Node.js, Deno, and Cloudflare Workers
- **Spec-compliant**: Follow WHATWG and W3C specifications
- **Type-safe**: MoonBit type system ensures compile-time safety
- **Well-tested**: Extensive test coverage

### Included APIs

- **HTTP/Networking**: fetch, Request/Response, Headers, FormData, URL APIs, WebSocket
- **Streams**: ReadableStream, WritableStream, TransformStream
- **Cryptography**: Web Crypto API for secure operations
- **Workers**: Web Workers and MessageChannel for concurrency

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/web/http",
    "mizchi/js/web/stream",
    "mizchi/js/web/crypto",
    "mizchi/js/web/websocket",
    "mizchi/js/web/worker"
  ]
}
```

## Usage Examples

### Fetch API

```moonbit
let response = @http.fetch("https://api.example.com/data")
let json = response.json()

// With custom request
let request = @http.Request::new("https://api.example.com/data", 
  method="POST",
  body="...",
  headers=headers
)
let response = @http.fetch_with_request(request)
```

### Streams

```moonbit
fn process_stream(stream : @stream.ReadableStream) -> Unit {
  let reader = stream.get_reader()
  // Process stream data
}
```

### Web Crypto

```moonbit
fn encrypt_data(data : String) -> @js.Promise[@js.ArrayBuffer] {
  let crypto = @crypto.get_crypto()
  let subtle = crypto.subtle()
  
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

### WebSocket

```moonbit
let ws = @websocket.WebSocket::new("wss://example.com/ws")

ws.addEventListener("open", fn(event) {
  ws.send("Hello!")
})

ws.addEventListener("message", fn(event) {
  let data = event.data()
  console.log(data)
})
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

## Platform Compatibility

| API | Browser | Node.js | Deno | Cloudflare Workers |
|-----|---------|---------|------|-------------------|
| fetch | ✅ | ✅ (18+) | ✅ | ✅ |
| Request/Response | ✅ | ✅ (18+) | ✅ | ✅ |
| Headers | ✅ | ✅ (18+) | ✅ | ✅ |
| URL | ✅ | ✅ | ✅ | ✅ |
| WebSocket | ✅ | ✅ | ✅ | ✅ |
| Streams | ✅ | ✅ (16+) | ✅ | ✅ |
| Web Crypto | ✅ | ✅ (15+) | ✅ | ✅ |
| Workers | ✅ | ✅ (10+) | ✅ | ✅ (Durable Objects) |

## Related Packages

- `mizchi/js` - Core JavaScript FFI
- `mizchi/js/browser/dom` - Browser DOM APIs
- `mizchi/js/node` - Node.js-specific APIs
- `mizchi/js/cloudflare` - Cloudflare Workers APIs

## Standards Compliance

All APIs follow official specifications:

- [Fetch Standard](https://fetch.spec.whatwg.org/)
- [Streams Standard](https://streams.spec.whatwg.org/)
- [Web Crypto API](https://www.w3.org/TR/WebCryptoAPI/)
- [WebSocket API](https://websockets.spec.whatwg.org/)
- [Web Workers](https://html.spec.whatwg.org/multipage/workers.html)
- [URL Standard](https://url.spec.whatwg.org/)

## License

See the main project license.
