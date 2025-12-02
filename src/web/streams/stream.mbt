///|
/// ReadableStream represents a readable stream of byte data
/// https://developer.mozilla.org/ja/docs/Web/API/ReadableStream
#external
pub type ReadableStream

///|
pub fn ReadableStream::as_any(self : ReadableStream) -> @core.Any = "%identity"

///|
/// Create a new ReadableStream (typically constructed from JavaScript)
extern "js" fn ffi_new_readable_stream(
  underlying_source : @core.Any,
) -> ReadableStream =
  #|(source) => new ReadableStream(source)

///|
/// Create a new ReadableStream with an underlying source
pub fn ReadableStream::new(underlying_source : @core.Any) -> ReadableStream {
  ffi_new_readable_stream(underlying_source)
}

///|
/// Cancel the stream
pub async fn ReadableStream::cancel(
  self : ReadableStream,
  reason? : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => @core.any(self)._call("cancel", [r]).cast()
    None => @core.any(self)._call("cancel", []).cast()
  }
  promise.wait()
}

///|
/// Get a reader for this stream
#alias(get_reader)
pub fn ReadableStream::getReader(
  self : ReadableStream,
) -> ReadableStreamDefaultReader {
  @core.any(self)._call("getReader", []).cast()
}

///|
/// Pipe this stream to a WritableStream
#alias(pipe_to)
pub async fn ReadableStream::pipeTo(
  self : ReadableStream,
  destination : WritableStream,
  options? : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match options {
    Some(opts) =>
      @core.any(self)._call("pipeTo", [@core.any(destination), opts]).cast()
    None => @core.any(self)._call("pipeTo", [@core.any(destination)]).cast()
  }
  promise.wait()
}

///|
/// Pipe through a transform stream
#alias(pipe_through)
pub fn ReadableStream::pipeThrough(
  self : ReadableStream,
  transform : @core.Any,
  options? : @core.Any,
) -> ReadableStream {
  match options {
    Some(opts) => @core.any(self)._call("pipeThrough", [transform, opts]).cast()
    None => @core.any(self)._call("pipeThrough", [transform]).cast()
  }
}

///|
extern "js" fn ffi_array_get(arr : @core.Any, index : Int) -> @core.Any =
  #|(arr, i) => arr[i]

///|
/// Tee this stream into two branches
pub fn ReadableStream::tee(
  self : ReadableStream,
) -> (ReadableStream, ReadableStream) {
  let result = @core.any(self)._call("tee", [])
  let first : ReadableStream = ffi_array_get(result, 0).cast()
  let second : ReadableStream = ffi_array_get(result, 1).cast()
  (first, second)
}

///|
/// Check if the stream is locked
pub fn ReadableStream::locked(self : ReadableStream) -> Bool {
  @core.any(self)["locked"].cast()
}

///|
/// ReadableStreamDefaultReader represents a default reader for reading from a ReadableStream
#external
pub type ReadableStreamDefaultReader

///|
pub fn ReadableStreamDefaultReader::as_any(
  self : ReadableStreamDefaultReader,
) -> @core.Any = "%identity"

///|
/// Read a chunk from the stream
pub async fn ReadableStreamDefaultReader::read(
  self : ReadableStreamDefaultReader,
) -> @core.Any {
  let promise : @js.Promise[@core.Any] = @core.any(self)
    ._call("read", [])
    .cast()
  promise.wait()
}

///|
/// Release the reader's lock on the stream
#alias(release_lock)
pub fn ReadableStreamDefaultReader::releaseLock(
  self : ReadableStreamDefaultReader,
) -> Unit {
  @core.any(self)._call("releaseLock", []) |> ignore
}

///|
/// Cancel the stream
pub async fn ReadableStreamDefaultReader::cancel(
  self : ReadableStreamDefaultReader,
  reason? : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => @core.any(self)._call("cancel", [r]).cast()
    None => @core.any(self)._call("cancel", []).cast()
  }
  promise.wait()
}

///|
/// Get the closed promise
pub fn ReadableStreamDefaultReader::closed(
  self : ReadableStreamDefaultReader,
) -> @js.Promise[Unit] {
  @core.any(self)["closed"].cast()
}

///|
/// WritableStream represents a writable stream
#external
pub type WritableStream

///|
pub fn WritableStream::as_any(self : WritableStream) -> @core.Any = "%identity"

///|
/// Create a new WritableStream
extern "js" fn ffi_new_writable_stream(
  underlying_sink : @core.Any,
) -> WritableStream =
  #|(sink) => new WritableStream(sink)

///|
/// Create a new WritableStream with an underlying sink
pub fn WritableStream::new(underlying_sink : @core.Any) -> WritableStream {
  ffi_new_writable_stream(underlying_sink)
}

///|
/// Abort the stream
pub async fn WritableStream::abort(
  self : WritableStream,
  reason? : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => @core.any(self)._call("abort", [r]).cast()
    None => @core.any(self)._call("abort", []).cast()
  }
  promise.wait()
}

///|
/// Close the stream
pub async fn WritableStream::close(self : WritableStream) -> Unit {
  let promise : @js.Promise[Unit] = @core.any(self)._call("close", []).cast()
  promise.wait()
}

///|
/// Get a writer for this stream
#alias(get_writer)
pub fn WritableStream::getWriter(
  self : WritableStream,
) -> WritableStreamDefaultWriter {
  @core.any(self)._call("getWriter", []).cast()
}

///|
/// Check if the stream is locked
pub fn WritableStream::locked(self : WritableStream) -> Bool {
  @core.any(self)["locked"].cast()
}

///|
/// WritableStreamDefaultWriter represents a default writer for writing to a WritableStream
#external
pub type WritableStreamDefaultWriter

///|
pub fn WritableStreamDefaultWriter::as_any(
  self : WritableStreamDefaultWriter,
) -> @core.Any = "%identity"

///|
/// Write a chunk to the stream
pub async fn WritableStreamDefaultWriter::write(
  self : WritableStreamDefaultWriter,
  chunk : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @core.any(self)
    ._call("write", [chunk])
    .cast()
  promise.wait()
}

///|
/// Close the writer
pub async fn WritableStreamDefaultWriter::close(
  self : WritableStreamDefaultWriter,
) -> Unit {
  let promise : @js.Promise[Unit] = @core.any(self)._call("close", []).cast()
  promise.wait()
}

///|
/// Abort the writer
pub async fn WritableStreamDefaultWriter::abort(
  self : WritableStreamDefaultWriter,
  reason? : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = match reason {
    Some(r) => @core.any(self)._call("abort", [r]).cast()
    None => @core.any(self)._call("abort", []).cast()
  }
  promise.wait()
}

///|
/// Release the writer's lock on the stream
#alias(release_lock)
pub fn WritableStreamDefaultWriter::releaseLock(
  self : WritableStreamDefaultWriter,
) -> Unit {
  @core.any(self)._call("releaseLock", []) |> ignore
}

///|
/// Get the closed promise
pub fn WritableStreamDefaultWriter::closed(
  self : WritableStreamDefaultWriter,
) -> @js.Promise[Unit] {
  @core.any(self)["closed"].cast()
}

///|
/// Get the ready promise
pub fn WritableStreamDefaultWriter::ready(
  self : WritableStreamDefaultWriter,
) -> @js.Promise[Unit] {
  @core.any(self)["ready"].cast()
}

///|
/// Get the desired size
pub fn WritableStreamDefaultWriter::desiredSize(
  self : WritableStreamDefaultWriter,
) -> @core.Any {
  @core.any(self)["desiredSize"]
}

///|
/// TransformStream represents a transform stream for piping data through a transformation
#external
pub type TransformStream

///|
pub fn TransformStream::as_any(self : TransformStream) -> @core.Any = "%identity"

///|
/// Create a new TransformStream
extern "js" fn ffi_new_transform_stream(
  transformer : @core.Any,
) -> TransformStream =
  #|(transformer) => new TransformStream(transformer)

///|
/// Create a new TransformStream with a transformer
pub fn TransformStream::new(transformer : @core.Any) -> TransformStream {
  ffi_new_transform_stream(transformer)
}

///|
/// Create a new identity TransformStream (passes data through unmodified)
extern "js" fn ffi_new_identity_transform_stream() -> TransformStream =
  #|() => new TransformStream()

///|
/// Create a new identity TransformStream
#alias(newIdentity)
pub fn TransformStream::new_identity() -> TransformStream {
  ffi_new_identity_transform_stream()
}

///|
/// Get the readable side of the transform stream
pub fn TransformStream::readable(self : TransformStream) -> ReadableStream {
  @core.any(self)["readable"].cast()
}

///|
/// Get the writable side of the transform stream
pub fn TransformStream::writable(self : TransformStream) -> WritableStream {
  @core.any(self)["writable"].cast()
}
