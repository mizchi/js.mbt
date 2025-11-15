///|
using @js {trait Js, type Val, js}

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
  ffi_new_readable_stream(underlying_source).cast()
}

///|
/// Returns whether the stream is locked to a reader
pub fn ReadableStream::locked(self : Self) -> Bool {
  self.to_js().get("locked").cast()
}

///|
/// Cancel the stream
pub fn ReadableStream::cancel(self : Self, reason? : Val) -> Promise[Unit] {
  match reason {
    Some(r) => self.to_js().invoke("cancel", [r]).cast()
    None => self.to_js().invoke("cancel", []).cast()
  }
}

///|
/// Get a reader for this stream
#alias(getReader)
pub fn ReadableStream::get_reader(self : Self) -> ReadableStreamDefaultReader {
  self.to_js().invoke("getReader", []).cast()
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
    Some(opts) => self.to_js().invoke("pipeTo", [destination, opts]).cast()
    None => self.to_js().invoke("pipeTo", [destination]).cast()
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
    Some(opts) => self.to_js().invoke("pipeThrough", [transform, opts]).cast()
    None => self.to_js().invoke("pipeThrough", [transform]).cast()
  }
}

///|
extern "js" fn ffi_array_get(arr : Val, index : Int) -> Val =
  #|(arr, i) => arr[i]

///|
/// Tee this stream into two branches
pub fn ReadableStream::tee(self : Self) -> (ReadableStream, ReadableStream) {
  let result = self.to_js().invoke("tee", [])
  let first : ReadableStream = ffi_array_get(result, 0).cast()
  let second : ReadableStream = ffi_array_get(result, 1).cast()
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
  self.to_js().invoke("read", []).cast()
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
    Some(r) => self.to_js().invoke("cancel", [r]).cast()
    None => self.to_js().invoke("cancel", []).cast()
  }
}

///|
/// Get the closed promise
pub fn ReadableStreamDefaultReader::closed(self : Self) -> Promise[Unit] {
  self.to_js().get("closed").cast()
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
  ffi_new_writable_stream(underlying_sink).cast()
}

///|
/// Returns whether the stream is locked to a writer
pub fn WritableStream::locked(self : Self) -> Bool {
  self.to_js().get("locked").cast()
}

///|
/// Abort the stream
pub fn WritableStream::abort(self : Self, reason? : Val) -> Promise[Unit] {
  match reason {
    Some(r) => self.to_js().invoke("abort", [r]).cast()
    None => self.to_js().invoke("abort", []).cast()
  }
}

///|
/// Close the stream
pub fn WritableStream::close(self : Self) -> Promise[Unit] {
  self.to_js().invoke("close", []).cast()
}

///|
/// Get a writer for this stream
#alias(getWriter)
pub fn WritableStream::get_writer(self : Self) -> WritableStreamDefaultWriter {
  self.to_js().invoke("getWriter", []).cast()
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
  self.to_js().invoke("write", [chunk]).cast()
}

///|
/// Close the writer
pub fn WritableStreamDefaultWriter::close(self : Self) -> Promise[Unit] {
  self.to_js().invoke("close", []).cast()
}

///|
/// Abort the writer
pub fn WritableStreamDefaultWriter::abort(
  self : Self,
  reason? : Val,
) -> Promise[Unit] {
  match reason {
    Some(r) => self.to_js().invoke("abort", [r]).cast()
    None => self.to_js().invoke("abort", []).cast()
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
  self.to_js().get("closed").cast()
}

///|
/// Get the ready promise
pub fn WritableStreamDefaultWriter::ready(self : Self) -> Promise[Unit] {
  self.to_js().get("ready").cast()
}

///|
/// Get the desired size
#alias(desiredSize)
pub fn WritableStreamDefaultWriter::desired_size(self : Self) -> Int? {
  self.to_js().get("desiredSize").cast_option()
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
  ffi_new_transform_stream(transformer).cast()
}

///|
/// Create a new identity TransformStream (passes data through unmodified)
extern "js" fn ffi_new_identity_transform_stream() -> Val =
  #|() => new TransformStream()

///|
/// Create a new identity TransformStream
#alias(newIdentity)
pub fn TransformStream::new_identity() -> TransformStream {
  ffi_new_identity_transform_stream().cast()
}

///|
/// Get the readable side of the transform stream
pub fn TransformStream::readable(self : Self) -> ReadableStream {
  self.to_js().get("readable").cast()
}

///|
/// Get the writable side of the transform stream
pub fn TransformStream::writable(self : Self) -> WritableStream {
  self.to_js().get("writable").cast()
}
