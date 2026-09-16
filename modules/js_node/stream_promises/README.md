# mizchi/js_node/stream_promises

## node:stream/promises

Promise-based stream utilities

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_node@0.13.0",
  "mizchi/js_web@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_web/streams",
  "mizchi/js_node/stream_promises",
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
