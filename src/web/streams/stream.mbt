///|
/// ReadableStream represents a readable stream of byte data
/// https://developer.mozilla.org/ja/docs/Web/API/ReadableStream
pub(all) struct ReadableStream {
  locked : Bool
}

///|
pub impl JsImpl for ReadableStream

///|
/// Create a new ReadableStream (typically constructed from JavaScript)
extern "js" fn ffi_new_readable_stream(underlying_source : Js) -> Js =
  #|(source) => new ReadableStream(source)

///|
/// Create a new ReadableStream with an underlying source
pub fn ReadableStream::new(underlying_source : Js) -> ReadableStream {
  unsafe_cast(ffi_new_readable_stream(underlying_source))
}

///|
/// Cancel the stream
pub fn ReadableStream::cancel(self : Self, reason? : Js) -> Promise[Unit] {
  match reason {
    Some(r) => self.call("cancel", [r]) |> unsafe_cast
    None => self.call0("cancel") |> unsafe_cast
  }
}

///|
/// Get a reader for this stream
#alias(get_reader)
pub fn ReadableStream::getReader(self : Self) -> ReadableStreamDefaultReader {
  self.call0("getReader") |> unsafe_cast
}

///|
/// Pipe this stream to a WritableStream
#alias(pipe_to)
pub fn ReadableStream::pipeTo(
  self : Self,
  destination : WritableStream,
  options? : Js,
) -> Promise[Unit] {
  match options {
    Some(opts) => self.call2("pipeTo", destination, opts) |> unsafe_cast
    None => self.call("pipeTo", [destination]) |> unsafe_cast
  }
}

///|
/// Pipe through a transform stream
#alias(pipe_through)
pub fn ReadableStream::pipeThrough(
  self : Self,
  transform : Js,
  options? : Js,
) -> ReadableStream {
  match options {
    Some(opts) => self.call2("pipeThrough", transform, opts) |> unsafe_cast
    None => self.call("pipeThrough", [transform]) |> unsafe_cast
  }
}

///|
extern "js" fn ffi_array_get(arr : Js, index : Int) -> Js =
  #|(arr, i) => arr[i]

///|
/// Tee this stream into two branches
pub fn ReadableStream::tee(self : Self) -> (ReadableStream, ReadableStream) {
  let result = self.call0("tee")
  let first : ReadableStream = unsafe_cast(ffi_array_get(result, 0))
  let second : ReadableStream = unsafe_cast(ffi_array_get(result, 1))
  (first, second)
}

///|
/// ReadableStreamDefaultReader represents a default reader for reading from a ReadableStream
pub(all) struct ReadableStreamDefaultReader {
  closed : Promise[Unit]
}

///|
pub impl JsImpl for ReadableStreamDefaultReader

///|
/// Read a chunk from the stream
pub fn ReadableStreamDefaultReader::read(self : Self) -> Promise[Js] {
  self.call0("read") |> unsafe_cast
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
  reason? : Js,
) -> Promise[Unit] {
  match reason {
    Some(r) => self.call("cancel", [r]) |> unsafe_cast
    None => self.call0("cancel") |> unsafe_cast
  }
}

///|
/// WritableStream represents a writable stream
pub(all) struct WritableStream {
  locked : Bool
}

///|
pub impl JsImpl for WritableStream

///|
/// Create a new WritableStream
extern "js" fn ffi_new_writable_stream(underlying_sink : Js) -> Js =
  #|(sink) => new WritableStream(sink)

///|
/// Create a new WritableStream with an underlying sink
pub fn WritableStream::new(underlying_sink : Js) -> WritableStream {
  unsafe_cast(ffi_new_writable_stream(underlying_sink))
}

///|
/// Abort the stream
pub fn WritableStream::abort(self : Self, reason? : Js) -> Promise[Unit] {
  match reason {
    Some(r) => self.call("abort", [r]) |> unsafe_cast
    None => self.call0("abort") |> unsafe_cast
  }
}

///|
/// Close the stream
pub fn WritableStream::close(self : Self) -> Promise[Unit] {
  self.call0("close") |> unsafe_cast
}

///|
/// Get a writer for this stream
#alias(get_writer)
pub fn WritableStream::getWriter(self : Self) -> WritableStreamDefaultWriter {
  self.call0("getWriter") |> unsafe_cast
}

///|
/// WritableStreamDefaultWriter represents a default writer for writing to a WritableStream
pub(all) struct WritableStreamDefaultWriter {
  closed : Promise[Unit]
  ready : Promise[Unit]
  desiredSize : Nullable[Int]
}

///|
pub impl JsImpl for WritableStreamDefaultWriter

///|
/// Write a chunk to the stream
pub fn WritableStreamDefaultWriter::write(
  self : Self,
  chunk : Js,
) -> Promise[Unit] {
  self.call("write", [chunk]) |> unsafe_cast
}

///|
/// Close the writer
pub fn WritableStreamDefaultWriter::close(self : Self) -> Promise[Unit] {
  self.call0("close") |> unsafe_cast
}

///|
/// Abort the writer
pub fn WritableStreamDefaultWriter::abort(
  self : Self,
  reason? : Js,
) -> Promise[Unit] {
  match reason {
    Some(r) => self.call("abort", [r]) |> unsafe_cast
    None => self.call0("abort") |> unsafe_cast
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
pub impl JsImpl for TransformStream

///|
/// Create a new TransformStream
extern "js" fn ffi_new_transform_stream(transformer : Js) -> Js =
  #|(transformer) => new TransformStream(transformer)

///|
/// Create a new TransformStream with a transformer
pub fn TransformStream::new(transformer : Js) -> TransformStream {
  ffi_new_transform_stream(transformer) |> @js.unsafe_cast
}

///|
/// Create a new identity TransformStream (passes data through unmodified)
extern "js" fn ffi_new_identity_transform_stream() -> Js =
  #|() => new TransformStream()

///|
/// Create a new identity TransformStream
#alias(newIdentity)
pub fn TransformStream::new_identity() -> TransformStream {
  ffi_new_identity_transform_stream() |> @js.unsafe_cast
}
