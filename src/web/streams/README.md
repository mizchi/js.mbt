# mizchi/js/web/streams

Streams API for processing data incrementally.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/web/streams"
  ]
}
```

## Overview

Provides bindings for the Streams API: ReadableStream, WritableStream, and TransformStream.

## Usage Example

```moonbit
fn main {
  // Create a readable stream
  let readable = @streams.ReadableStream::new()
  
  // Get a reader
  let reader = readable.get_reader()
  
  // Create a writable stream
  let writable = @streams.WritableStream::new()
  
  // Get a writer
  let writer = writable.get_writer()
  
  // Create a transform stream
  let transform = @streams.TransformStream::new()
  
  // Pipe streams
  // readable.pipe_to(writable)
}
```

## Available Types

- **ReadableStream** - Stream of data to read
- **WritableStream** - Stream to write data to
- **TransformStream** - Transform data in a stream
- **Compression/Decompression** - gzip, deflate streams

## Reference

- [MDN: Streams API](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API)
- [MDN: ReadableStream](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream)
- [MDN: WritableStream](https://developer.mozilla.org/en-US/docs/Web/API/WritableStream)
