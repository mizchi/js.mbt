///|
using @js {trait Js, type Val, js, unsafe_cast, unsafe_cast_option}

///|
using @async {type Promise}

///|
/// ReadableStream represents a readable stream of byte data
#external
pub type ReadableStream

///|
pub impl Js for ReadableStream with to_js(self) {
  self |> js
}

///|
/// Create a new ReadableStream (typically constructed from JavaScript)
extern "js" fn ffi_new_readable_stream(underlying_source : Val) -> Val =
  #|(source) => new ReadableStream(source)

///|
/// Create a new ReadableStream with an underlying source
pub fn ReadableStream::new(underlying_source : Val) -> ReadableStream {
  unsafe_cast(ffi_new_readable_stream(underlying_source))
}

///|
/// Returns whether the stream is locked to a reader
pub fn ReadableStream::locked(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("locked"))
}

///|
/// Cancel the stream
pub fn ReadableStream::cancel(self : Self, reason? : Val) -> Promise[Unit] {
  match reason {
    Some(r) => self.invoke("cancel", [r]) |> unsafe_cast
    None => self.invoke("cancel", []) |> unsafe_cast
  }
}

///|
/// Get a reader for this stream
#alias(getReader)
pub fn ReadableStream::get_reader(self : Self) -> ReadableStreamDefaultReader {
  self.invoke("getReader", []) |> unsafe_cast
}

///|
/// Pipe this stream to a WritableStream
#alias(pipeTo)
pub fn ReadableStream::pipe_to(
  self : Self,
  destination : WritableStream,
  options? : Val,
) -> Promise[Unit] {
  match options {
    Some(opts) => self.invoke("pipeTo", [destination, opts]) |> unsafe_cast
    None => self.invoke("pipeTo", [destination]) |> unsafe_cast
  }
}

///|
/// Pipe through a transform stream
#alias(pipeThrough)
pub fn ReadableStream::pipe_through(
  self : Self,
  transform : Val,
  options? : Val,
) -> ReadableStream {
  match options {
    Some(opts) => self.invoke("pipeThrough", [transform, opts]) |> unsafe_cast
    None => self.invoke("pipeThrough", [transform]) |> unsafe_cast
  }
}

///|
extern "js" fn ffi_array_get(arr : Val, index : Int) -> Val =
  #|(arr, i) => arr[i]

///|
/// Tee this stream into two branches
pub fn ReadableStream::tee(self : Self) -> (ReadableStream, ReadableStream) {
  let result = self.to_js().invoke("tee", [])
  let first : ReadableStream = unsafe_cast(ffi_array_get(result, 0))
  let second : ReadableStream = unsafe_cast(ffi_array_get(result, 1))
  (first, second)
}

///|
/// ReadableStreamDefaultReader represents a default reader for reading from a ReadableStream
#external
pub type ReadableStreamDefaultReader

///|
pub impl Js for ReadableStreamDefaultReader with to_js(self) {
  self |> js
}

///|
/// Read a chunk from the stream
pub fn ReadableStreamDefaultReader::read(self : Self) -> Promise[Val] {
  self.invoke("read", []) |> unsafe_cast
}

///|
/// Release the reader's lock on the stream
#alias(releaseLock)
pub fn ReadableStreamDefaultReader::release_lock(self : Self) -> Unit {
  self.to_js().invoke("releaseLock", []) |> ignore
}

///|
/// Cancel the stream
pub fn ReadableStreamDefaultReader::cancel(
  self : Self,
  reason? : Val,
) -> Promise[Unit] {
  match reason {
    Some(r) => self.invoke("cancel", [r]) |> unsafe_cast
    None => self.invoke("cancel", []) |> unsafe_cast
  }
}

///|
/// Get the closed promise
pub fn ReadableStreamDefaultReader::closed(self : Self) -> Promise[Unit] {
  unsafe_cast(self.to_js().get("closed"))
}

///|
/// WritableStream represents a writable stream
#external
pub type WritableStream

///|
pub impl Js for WritableStream with to_js(self) {
  self |> js
}

///|
/// Create a new WritableStream
extern "js" fn ffi_new_writable_stream(underlying_sink : Val) -> Val =
  #|(sink) => new WritableStream(sink)

///|
/// Create a new WritableStream with an underlying sink
pub fn WritableStream::new(underlying_sink : Val) -> WritableStream {
  unsafe_cast(ffi_new_writable_stream(underlying_sink))
}

///|
/// Returns whether the stream is locked to a writer
pub fn WritableStream::locked(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("locked"))
}

///|
/// Abort the stream
pub fn WritableStream::abort(self : Self, reason? : Val) -> Promise[Unit] {
  match reason {
    Some(r) => self.invoke("abort", [r]) |> unsafe_cast
    None => self.invoke("abort", []) |> unsafe_cast
  }
}

///|
/// Close the stream
pub fn WritableStream::close(self : Self) -> Promise[Unit] {
  self.invoke("close", []) |> unsafe_cast
}

///|
/// Get a writer for this stream
#alias(getWriter)
pub fn WritableStream::get_writer(self : Self) -> WritableStreamDefaultWriter {
  self.invoke("getWriter", []) |> unsafe_cast
}

///|
/// WritableStreamDefaultWriter represents a default writer for writing to a WritableStream
#external
pub type WritableStreamDefaultWriter

///|
pub impl Js for WritableStreamDefaultWriter with to_js(self) {
  self |> js
}

///|
/// Write a chunk to the stream
pub fn WritableStreamDefaultWriter::write(
  self : Self,
  chunk : Val,
) -> Promise[Unit] {
  self.invoke("write", [chunk]) |> unsafe_cast
}

///|
/// Close the writer
pub fn WritableStreamDefaultWriter::close(self : Self) -> Promise[Unit] {
  self.invoke("close", []) |> unsafe_cast
}

///|
/// Abort the writer
pub fn WritableStreamDefaultWriter::abort(
  self : Self,
  reason? : Val,
) -> Promise[Unit] {
  match reason {
    Some(r) => self.invoke("abort", [r]) |> unsafe_cast
    None => self.invoke("abort", []) |> unsafe_cast
  }
}

///|
/// Release the writer's lock on the stream
#alias(releaseLock)
pub fn WritableStreamDefaultWriter::release_lock(self : Self) -> Unit {
  self.to_js().invoke("releaseLock", []) |> ignore
}

///|
/// Get the closed promise
pub fn WritableStreamDefaultWriter::closed(self : Self) -> Promise[Unit] {
  unsafe_cast(self.to_js().get("closed"))
}

///|
/// Get the ready promise
pub fn WritableStreamDefaultWriter::ready(self : Self) -> Promise[Unit] {
  unsafe_cast(self.to_js().get("ready"))
}

///|
/// Get the desired size
#alias(desiredSize)
pub fn WritableStreamDefaultWriter::desired_size(self : Self) -> Int? {
  self.to_js().get("desiredSize") |> unsafe_cast_option
}

///|
/// TransformStream represents a transform stream for piping data through a transformation
#external
pub type TransformStream

///|
pub impl Js for TransformStream with to_js(self) {
  self |> js
}

///|
/// Create a new TransformStream
extern "js" fn ffi_new_transform_stream(transformer : Val) -> Val =
  #|(transformer) => new TransformStream(transformer)

///|
/// Create a new TransformStream with a transformer
pub fn TransformStream::new(transformer : Val) -> TransformStream {
  unsafe_cast(ffi_new_transform_stream(transformer))
}

///|
/// Create a new identity TransformStream (passes data through unmodified)
extern "js" fn ffi_new_identity_transform_stream() -> Val =
  #|() => new TransformStream()

///|
/// Create a new identity TransformStream
#alias(newIdentity)
pub fn TransformStream::new_identity() -> TransformStream {
  unsafe_cast(ffi_new_identity_transform_stream())
}

///|
/// Get the readable side of the transform stream
pub fn TransformStream::readable(self : Self) -> ReadableStream {
  unsafe_cast(self.to_js().get("readable"))
}

///|
/// Get the writable side of the transform stream
pub fn TransformStream::writable(self : Self) -> WritableStream {
  unsafe_cast(self.to_js().get("writable"))
}
