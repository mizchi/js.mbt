///|
/// ReadableStream represents a readable stream of byte data
/// https://developer.mozilla.org/ja/docs/Web/API/ReadableStream
pub(all) struct ReadableStream {
  locked : Bool
}

///|
pub impl @js.JsImpl for ReadableStream

///|
/// Create a new ReadableStream (typically constructed from JavaScript)
extern "js" fn ffi_new_readable_stream(underlying_source : @js.Any) -> @js.Any =
  #|(source) => new ReadableStream(source)

///|
/// Create a new ReadableStream with an underlying source
pub fn ReadableStream::new(underlying_source : @js.Any) -> ReadableStream {
  @js.identity(ffi_new_readable_stream(underlying_source))
}

///|
/// Cancel the stream
pub async fn ReadableStream::cancel(self : Self, reason? : @js.Any) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => self.call("cancel", [r]).cast()
    None => self.call0("cancel").cast()
  }
  promise.wait()
}

///|
/// Get a reader for this stream
#alias(get_reader)
pub fn ReadableStream::getReader(self : Self) -> ReadableStreamDefaultReader {
  self.call0("getReader").cast()
}

///|
/// Pipe this stream to a WritableStream
#alias(pipe_to)
pub async fn ReadableStream::pipeTo(
  self : Self,
  destination : WritableStream,
  options? : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match options {
    Some(opts) => self.call2("pipeTo", destination, opts).cast()
    None => self.call("pipeTo", [destination]).cast()
  }
  promise.wait()
}

///|
/// Pipe through a transform stream
#alias(pipe_through)
pub fn ReadableStream::pipeThrough(
  self : Self,
  transform : @js.Any,
  options? : @js.Any,
) -> ReadableStream {
  match options {
    Some(opts) => self.call2("pipeThrough", transform, opts).cast()
    None => self.call("pipeThrough", [transform]).cast()
  }
}

///|
extern "js" fn ffi_array_get(arr : @js.Any, index : Int) -> @js.Any =
  #|(arr, i) => arr[i]

///|
/// Tee this stream into two branches
pub fn ReadableStream::tee(self : Self) -> (ReadableStream, ReadableStream) {
  let result = self.call0("tee")
  let first : ReadableStream = @js.identity(ffi_array_get(result, 0))
  let second : ReadableStream = @js.identity(ffi_array_get(result, 1))
  (first, second)
}

///|
/// ReadableStreamDefaultReader represents a default reader for reading from a ReadableStream
pub(all) struct ReadableStreamDefaultReader {
  closed : @js.Promise[Unit]
}

///|
pub impl @js.JsImpl for ReadableStreamDefaultReader

///|
/// Read a chunk from the stream
pub async fn ReadableStreamDefaultReader::read(self : Self) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call0("read").cast()
  promise.wait()
}

///|
/// Release the reader's lock on the stream
#alias(release_lock)
pub fn ReadableStreamDefaultReader::releaseLock(self : Self) -> Unit {
  self.call0("releaseLock") |> ignore
}

///|
/// Cancel the stream
pub async fn ReadableStreamDefaultReader::cancel(
  self : Self,
  reason? : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => self.call("cancel", [r]).cast()
    None => self.call0("cancel").cast()
  }
  promise.wait()
}

///|
/// WritableStream represents a writable stream
pub(all) struct WritableStream {
  locked : Bool
}

///|
pub impl @js.JsImpl for WritableStream

///|
/// Create a new WritableStream
extern "js" fn ffi_new_writable_stream(underlying_sink : @js.Any) -> @js.Any =
  #|(sink) => new WritableStream(sink)

///|
/// Create a new WritableStream with an underlying sink
pub fn WritableStream::new(underlying_sink : @js.Any) -> WritableStream {
  @js.identity(ffi_new_writable_stream(underlying_sink))
}

///|
/// Abort the stream
pub async fn WritableStream::abort(self : Self, reason? : @js.Any) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => self.call("abort", [r]).cast()
    None => self.call0("abort").cast()
  }
  promise.wait()
}

///|
/// Close the stream
pub async fn WritableStream::close(self : Self) -> Unit {
  let promise : @js.Promise[Unit] = self.call0("close").cast()
  promise.wait()
}

///|
/// Get a writer for this stream
#alias(get_writer)
pub fn WritableStream::getWriter(self : Self) -> WritableStreamDefaultWriter {
  self.call0("getWriter").cast()
}

///|
/// WritableStreamDefaultWriter represents a default writer for writing to a WritableStream
pub(all) struct WritableStreamDefaultWriter {
  closed : @js.Promise[Unit]
  ready : @js.Promise[Unit]
  desiredSize : @js.Nullable[Int]
}

///|
pub impl @js.JsImpl for WritableStreamDefaultWriter

///|
/// Write a chunk to the stream
pub async fn WritableStreamDefaultWriter::write(
  self : Self,
  chunk : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self.call("write", [chunk]).cast()
  promise.wait()
}

///|
/// Close the writer
pub async fn WritableStreamDefaultWriter::close(self : Self) -> Unit {
  let promise : @js.Promise[Unit] = self.call0("close").cast()
  promise.wait()
}

///|
/// Abort the writer
pub async fn WritableStreamDefaultWriter::abort(
  self : Self,
  reason? : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => self.call("abort", [r]).cast()
    None => self.call0("abort").cast()
  }
  promise.wait()
}

///|
/// Release the writer's lock on the stream
#alias(release_lock)
pub fn WritableStreamDefaultWriter::releaseLock(self : Self) -> Unit {
  self.call0("releaseLock") |> ignore
}

///|
/// TransformStream represents a transform stream for piping data through a transformation
pub(all) struct TransformStream {
  readable : ReadableStream
  writable : WritableStream
}

///|
pub impl @js.JsImpl for TransformStream

///|
/// Create a new TransformStream
extern "js" fn ffi_new_transform_stream(transformer : @js.Any) -> @js.Any =
  #|(transformer) => new TransformStream(transformer)

///|
/// Create a new TransformStream with a transformer
pub fn TransformStream::new(transformer : @js.Any) -> TransformStream {
  ffi_new_transform_stream(transformer).cast()
}

///|
/// Create a new identity TransformStream (passes data through unmodified)
extern "js" fn ffi_new_identity_transform_stream() -> @js.Any =
  #|() => new TransformStream()

///|
/// Create a new identity TransformStream
#alias(newIdentity)
pub fn TransformStream::new_identity() -> TransformStream {
  ffi_new_identity_transform_stream().cast()
}
