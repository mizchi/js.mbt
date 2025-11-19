# mizchi/js/node/stream_promises

## node:stream/promises

Promise-based stream utilities

### Functions
- [x] pipeline(streams) -> Promise[Unit] - Pipe streams together with Promise API
- [x] finished(stream, options?) -> Promise[Unit] - Wait for stream to finish

### Usage
These are Promise-based versions of the callback-based stream utilities.

```moonbit
let streams = [readable.to_js(), transform.to_js(), writable]
pipeline(streams).then(fn(_) {
  // All streams completed successfully
})
```

## Test Coverage
Tests in src/_tests/node_stream_promises_test.mbt
