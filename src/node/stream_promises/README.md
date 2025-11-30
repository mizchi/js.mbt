# mizchi/js/node/stream_promises

## node:stream/promises

Promise-based stream utilities

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js",
    "mizchi/js/web/streams",
    "mizchi/js/node/stream_promises"
  ]
}
```

### Functions
- [x] pipeline(streams) -> Promise[Unit] - Pipe streams together with Promise API
- [x] finished(stream, options?) -> Promise[Unit] - Wait for stream to finish

### Usage
These are Promise-based versions of the callback-based stream utilities.

```moonbit
let streams = [readable.as_any(), transform.as_any(), writable]
pipeline(streams).then(fn(_) {
  // All streams completed successfully
})
```

## Test Coverage
Tests in src/_tests/node_stream_promises_test.mbt
