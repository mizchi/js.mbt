# mizchi/js/node/stream

## node:stream

Stream APIs for working with streaming data

### Stream Types
- [x] Readable - Readable stream
- [x] Writable - Writable stream
- [x] Duplex - Duplex stream (both readable and writable)
- [x] Transform - Transform stream
- [x] PassThrough - Pass-through stream

### Readable Stream
- [x] read(size?) - Read data
- [x] setEncoding(encoding) - Set character encoding
- [x] pause() - Pause reading
- [x] resume() - Resume reading
- [x] pipe(destination, options?) - Pipe to writable
- [x] unpipe(destination?) - Unpipe
- [x] isPaused() - Check if paused
- [x] on(event, callback) - Event listeners
- [x] Events: 'data', 'end', 'error', 'close', 'readable'

### Writable Stream
- [x] write(chunk, encoding?, callback?) - Write data
- [x] end(chunk?, encoding?, callback?) - End writing
- [x] cork() - Buffer writes
- [x] uncork() - Flush buffered writes
- [x] on(event, callback) - Event listeners
- [x] Events: 'drain', 'finish', 'error', 'close', 'pipe', 'unpipe'

### Duplex Stream
Inherits from both Readable and Writable

### Transform Stream
Inherits from Duplex, for transforming data

### PassThrough Stream
Inherits from Transform, passes data through unchanged

### Utility Functions
- [x] pipeline(streams, callback) - Pipe streams together with error handling
- [x] finished(stream, options?, callback?) - Wait for stream to finish

## Test Coverage
Tests in src/_tests/node_stream_test.mbt
