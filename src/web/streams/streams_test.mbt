///|
/// ReadableStream and WritableStream async operations tests

// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// These FFI functions are used ONLY for testing purposes.
// They create test fixtures (streams with predefined data) that would normally
// be obtained from fetch(), file reads, or other I/O operations in real apps.
//
// The library provides ReadableStream/WritableStream types for consuming
// streams, but creating them with custom data requires JavaScript interop.
// =============================================================================

///|
/// [Test Helper] Creates a ReadableStream that emits predefined string chunks.
/// In real applications, ReadableStreams come from fetch().body, file reads, etc.
extern "js" fn test_ffi_readable_from_chunks(
  chunks : Array[String],
) -> ReadableStream =
  #| (chunks) => {
  #|   return new ReadableStream({
  #|     start(controller) {
  #|       chunks.forEach(chunk => controller.enqueue(chunk));
  #|       controller.close();
  #|     }
  #|   });
  #| }

///|
/// [Test Helper] Creates a WritableStream that collects all written chunks.
/// Returns the stream as @nostd.Any because it has a custom `.chunks` property.
extern "js" fn test_ffi_writable_collector() -> @nostd.Any =
  #| () => {
  #|   const chunks = [];
  #|   const writable = new WritableStream({
  #|     write(chunk) {
  #|       chunks.push(chunk);
  #|     }
  #|   });
  #|   writable.chunks = chunks;
  #|   return writable;
  #| }

///|
/// [Test Helper] Retrieves the collected chunks from a collector stream.
extern "js" fn test_ffi_get_collected_chunks(
  writable : @nostd.Any,
) -> Array[String] =
  #| (writable) => writable.chunks || []

///|
/// [Test Helper] Creates a transformer object that uppercases string chunks.
/// TransformStream constructor requires a JavaScript object with transform method.
extern "js" fn test_ffi_uppercase_transformer() -> @nostd.Any =
  #| () => ({
  #|   transform(chunk, controller) {
  #|     controller.enqueue(chunk.toString().toUpperCase());
  #|   }
  #| })

///|
/// [Test Helper] Writes a chunk to a WritableStreamDefaultWriter.
/// Writer.write() is not yet wrapped in the library's public API.
extern "js" fn test_ffi_writer_write(
  writer : @nostd.Any,
  chunk : String,
) -> @nostd.Any =
  #| (writer, chunk) => writer.write(chunk)

///|
/// [Test Helper] Closes a WritableStreamDefaultWriter.
extern "js" fn test_ffi_writer_close(writer : @nostd.Any) -> @nostd.Any =
  #| (writer) => writer.close()

///|
/// [Test Helper] Aborts a WritableStreamDefaultWriter.
extern "js" fn test_ffi_writer_abort(writer : @nostd.Any) -> @nostd.Any =
  #| (writer) => writer.abort()

///|
async test "ReadableStream: read chunks sequentially" {
  let stream = test_ffi_readable_from_chunks(["chunk1", "chunk2", "chunk3"])
  let reader = stream.get_reader()
  defer reader.release_lock()

  // Read first chunk
  let result1 : @nostd.Any = reader.as_any()._call("read", []).cast()
  let promise1 : @js.Promise[@nostd.Any] = @js.identity(result1)
  let data1 = promise1.wait()
  let done1 : Bool = @js.identity(data1._get("done"))
  let value1 : String = @js.identity(data1._get("value"))
  assert_eq(done1, false)
  assert_eq(value1, "chunk1")

  // Read second chunk
  let result2 : @nostd.Any = reader.as_any()._call("read", []).cast()
  let promise2 : @js.Promise[@nostd.Any] = @js.identity(result2)
  let data2 = promise2.wait()
  let value2 : String = @js.identity(data2._get("value"))
  assert_eq(value2, "chunk2")

  // Read third chunk
  let result3 : @nostd.Any = reader.as_any()._call("read", []).cast()
  let promise3 : @js.Promise[@nostd.Any] = @js.identity(result3)
  let data3 = promise3.wait()
  let value3 : String = @js.identity(data3._get("value"))
  assert_eq(value3, "chunk3")

  // Read end - should be done
  let result4 : @nostd.Any = reader.as_any()._call("read", []).cast()
  let promise4 : @js.Promise[@nostd.Any] = @js.identity(result4)
  let data4 = promise4.wait()
  let done4 : Bool = @js.identity(data4._get("done"))
  assert_eq(done4, true)
}

///|
async test "WritableStream: write chunks sequentially" {
  let writable_js = test_ffi_writable_collector()
  let writable : WritableStream = @js.identity(writable_js)
  let writer = writable.get_writer()
  defer writer.release_lock()

  // Write multiple chunks
  let write1 = test_ffi_writer_write(writer.as_any().cast(), "first")
  let promise1 : @js.Promise[Unit] = @js.identity(write1)
  promise1.wait()
  let write2 = test_ffi_writer_write(writer.as_any().cast(), "second")
  let promise2 : @js.Promise[Unit] = @js.identity(write2)
  promise2.wait()
  let write3 = test_ffi_writer_write(writer.as_any().cast(), "third")
  let promise3 : @js.Promise[Unit] = @js.identity(write3)
  promise3.wait()

  // Close writer
  let close_result = test_ffi_writer_close(writer.as_any().cast())
  let close_promise : @js.Promise[Unit] = @js.identity(close_result)
  close_promise.wait()

  // Verify collected chunks
  let chunks = test_ffi_get_collected_chunks(writable_js)
  assert_eq(chunks.length(), 3)
  assert_eq(chunks[0], "first")
  assert_eq(chunks[1], "second")
  assert_eq(chunks[2], "third")
}

///|
async test "ReadableStream: pipe to WritableStream" {
  let readable = test_ffi_readable_from_chunks(["data1", "data2", "data3"])
  let writable_js = test_ffi_writable_collector()
  let writable : WritableStream = @js.identity(writable_js)

  // Pipe readable to writable
  let pipe_result : @nostd.Any = readable
    .as_any()
    ._call("pipeTo", [@nostd.any(writable)])
    .cast()
  let pipe_promise : @js.Promise[Unit] = @js.identity(pipe_result)
  pipe_promise.wait()

  // Verify all chunks were piped
  let chunks = test_ffi_get_collected_chunks(writable_js)
  assert_eq(chunks.length(), 3)
  assert_eq(chunks[0], "data1")
  assert_eq(chunks[1], "data2")
  assert_eq(chunks[2], "data3")
}

///|
async test "TransformStream: transform data through pipeline" {
  let readable = test_ffi_readable_from_chunks(["hello", "world"])
  let writable_js = test_ffi_writable_collector()
  let writable : WritableStream = @js.identity(writable_js)

  // Create uppercase transformer using FFI
  let transformer = test_ffi_uppercase_transformer()
  let transform = TransformStream::new(@nostd.any(transformer))

  // Pipe through transform
  let pipe1 : @nostd.Any = readable
    .as_any()
    ._call("pipeTo", [transform.writable().as_any()])
    .cast()
  let pipe2 : @nostd.Any = transform
    .readable()
    .as_any()
    ._call("pipeTo", [writable.as_any()])
    .cast()
  let promise1 : @js.Promise[Unit] = @js.identity(pipe1)
  let promise2 : @js.Promise[Unit] = @js.identity(pipe2)
  promise1.wait()
  promise2.wait()

  // Verify transformed chunks
  let chunks = test_ffi_get_collected_chunks(writable_js)
  assert_eq(chunks.length(), 2)
  assert_eq(chunks[0], "HELLO")
  assert_eq(chunks[1], "WORLD")
}

///|
async test "ReadableStream: tee creates independent branches" {
  let stream = test_ffi_readable_from_chunks(["item1", "item2"])
  let (branch1, branch2) = stream.tee()
  let reader1 = branch1.get_reader()
  let reader2 = branch2.get_reader()
  defer reader1.release_lock()
  defer reader2.release_lock()

  // Read from branch1
  let result1 : @nostd.Any = reader1.as_any()._call("read", []).cast()
  let promise1 : @js.Promise[@nostd.Any] = @js.identity(result1)
  let data1 = promise1.wait()
  let value1 : String = @js.identity(data1._get("value"))
  assert_eq(value1, "item1")

  // Read from branch2 - should get same data
  let result2 : @nostd.Any = reader2.as_any()._call("read", []).cast()
  let promise2 : @js.Promise[@nostd.Any] = @js.identity(result2)
  let data2 = promise2.wait()
  let value2 : String = @js.identity(data2._get("value"))
  assert_eq(value2, "item1")
}

///|
async test "ReadableStream: cancel stops reading" {
  let stream = test_ffi_readable_from_chunks(["a", "b", "c", "d", "e"])
  let reader = stream.get_reader()
  defer reader.release_lock()

  // Read one chunk
  let result1 : @nostd.Any = reader.as_any()._call("read", []).cast()
  let promise1 : @js.Promise[@nostd.Any] = @js.identity(result1)
  let data1 = promise1.wait()
  let value1 : String = @js.identity(data1._get("value"))
  assert_eq(value1, "a")

  // Cancel the stream
  let cancel_result : @nostd.Any = reader.as_any()._call("cancel", []).cast()
  let cancel_promise : @js.Promise[Unit] = @js.identity(cancel_result)
  cancel_promise.wait()

  // Further reads should indicate done
  let result2 : @nostd.Any = reader.as_any()._call("read", []).cast()
  let promise2 : @js.Promise[@nostd.Any] = @js.identity(result2)
  let data2 = promise2.wait()
  let done2 : Bool = @js.identity(data2._get("done"))
  assert_eq(done2, true)
}

///|
async test "WritableStream: abort stops writing" {
  let writable_js = test_ffi_writable_collector()
  let writable : WritableStream = @js.identity(writable_js)
  let writer = writable.get_writer()
  defer writer.release_lock()

  // Write one chunk
  let write1 = test_ffi_writer_write(writer.as_any().cast(), "chunk1")
  let promise1 : @js.Promise[Unit] = @js.identity(write1)
  promise1.wait()

  // Abort the stream
  let abort_result = test_ffi_writer_abort(writer.as_any().cast())
  let abort_promise : @js.Promise[Unit] = @js.identity(abort_result)
  abort_promise.wait()

  // Verify only one chunk was written
  let chunks = test_ffi_get_collected_chunks(writable_js)
  assert_eq(chunks.length(), 1)
  assert_eq(chunks[0], "chunk1")
}
