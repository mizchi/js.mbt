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
extern "js" fn ffi_new_readable_stream(underlying_source : @js.Js) -> @js.Js =
  #|(source) => new ReadableStream(source)

///|
/// Create a new ReadableStream with an underlying source
pub fn ReadableStream::new(underlying_source : @js.Js) -> ReadableStream {
  @js.identity(ffi_new_readable_stream(underlying_source))
}

///|
/// Cancel the stream
pub fn ReadableStream::cancel(
  self : Self,
  reason? : @js.Js,
) -> @js.Promise[Unit] {
  match reason {
    Some(r) => self.call("cancel", [r]).cast()
    None => self.call0("cancel").cast()
  }
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
pub fn ReadableStream::pipeTo(
  self : Self,
  destination : WritableStream,
  options? : @js.Js,
) -> @js.Promise[Unit] {
  match options {
    Some(opts) => self.call2("pipeTo", destination, opts).cast()
    None => self.call("pipeTo", [destination]).cast()
  }
}

///|
/// Pipe through a transform stream
#alias(pipe_through)
pub fn ReadableStream::pipeThrough(
  self : Self,
  transform : @js.Js,
  options? : @js.Js,
) -> ReadableStream {
  match options {
    Some(opts) => self.call2("pipeThrough", transform, opts).cast()
    None => self.call("pipeThrough", [transform]).cast()
  }
}

///|
extern "js" fn ffi_array_get(arr : @js.Js, index : Int) -> @js.Js =
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
pub fn ReadableStreamDefaultReader::read(self : Self) -> @js.Promise[@js.Js] {
  self.call0("read").cast()
}

///|
/// Release the reader's lock on the stream
#alias(release_lock)
pub fn ReadableStreamDefaultReader::releaseLock(self : Self) -> Unit {
  self.call0("releaseLock") |> ignore
}

///|
/// Cancel the stream
pub fn ReadableStreamDefaultReader::cancel(
  self : Self,
  reason? : @js.Js,
) -> @js.Promise[Unit] {
  match reason {
    Some(r) => self.call("cancel", [r]).cast()
    None => self.call0("cancel").cast()
  }
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
extern "js" fn ffi_new_writable_stream(underlying_sink : @js.Js) -> @js.Js =
  #|(sink) => new WritableStream(sink)

///|
/// Create a new WritableStream with an underlying sink
pub fn WritableStream::new(underlying_sink : @js.Js) -> WritableStream {
  @js.identity(ffi_new_writable_stream(underlying_sink))
}

///|
/// Abort the stream
pub fn WritableStream::abort(
  self : Self,
  reason? : @js.Js,
) -> @js.Promise[Unit] {
  match reason {
    Some(r) => self.call("abort", [r]).cast()
    None => self.call0("abort").cast()
  }
}

///|
/// Close the stream
pub fn WritableStream::close(self : Self) -> @js.Promise[Unit] {
  self.call0("close").cast()
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
pub fn WritableStreamDefaultWriter::write(
  self : Self,
  chunk : @js.Js,
) -> @js.Promise[Unit] {
  self.call("write", [chunk]).cast()
}

///|
/// Close the writer
pub fn WritableStreamDefaultWriter::close(self : Self) -> @js.Promise[Unit] {
  self.call0("close").cast()
}

///|
/// Abort the writer
pub fn WritableStreamDefaultWriter::abort(
  self : Self,
  reason? : @js.Js,
) -> @js.Promise[Unit] {
  match reason {
    Some(r) => self.call("abort", [r]).cast()
    None => self.call0("abort").cast()
  }
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
extern "js" fn ffi_new_transform_stream(transformer : @js.Js) -> @js.Js =
  #|(transformer) => new TransformStream(transformer)

///|
/// Create a new TransformStream with a transformer
pub fn TransformStream::new(transformer : @js.Js) -> TransformStream {
  ffi_new_transform_stream(transformer).cast()
}

///|
/// Create a new identity TransformStream (passes data through unmodified)
extern "js" fn ffi_new_identity_transform_stream() -> @js.Js =
  #|() => new TransformStream()

///|
/// Create a new identity TransformStream
#alias(newIdentity)
pub fn TransformStream::new_identity() -> TransformStream {
  ffi_new_identity_transform_stream().cast()
}
