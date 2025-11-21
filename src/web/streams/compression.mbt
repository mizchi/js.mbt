///|
/// Compression Stream API
/// https://wicg.github.io/compression/

///|
/// CompressionStream is a TransformStream that compresses data using gzip, deflate, or deflate-raw
/// https://developer.mozilla.org/en-US/docs/Web/API/CompressionStream
#external
pub type CompressionStream

///|
pub impl JsImpl for CompressionStream

///|
/// Create a new CompressionStream with the specified format
///
/// Supported formats:
/// - "gzip" - GZIP compression
/// - "deflate" - DEFLATE compression (with zlib wrapper)
/// - "deflate-raw" - DEFLATE compression (without wrapper)
///
/// Example:
/// ```moonbit
/// let compressor = CompressionStream::new("gzip")
/// ```
pub fn CompressionStream::new(format : String) -> CompressionStream {
  new_compression_stream(format)
}

///|
extern "js" fn new_compression_stream(format : String) -> CompressionStream =
  #|(format) => new CompressionStream(format)

///|
/// Get the readable side of the compression stream
pub fn CompressionStream::readable(self : CompressionStream) -> ReadableStream {
  self.get("readable") |> unsafe_cast
}

///|
/// Get the writable side of the compression stream
pub fn CompressionStream::writable(self : CompressionStream) -> WritableStream {
  self.get("writable") |> unsafe_cast
}

///|
/// DecompressionStream is a TransformStream that decompresses data using gzip, deflate, or deflate-raw
/// https://developer.mozilla.org/en-US/docs/Web/API/DecompressionStream
#external
pub type DecompressionStream

///|
pub impl JsImpl for DecompressionStream

///|
/// Create a new DecompressionStream with the specified format
///
/// Supported formats:
/// - "gzip" - GZIP decompression
/// - "deflate" - DEFLATE decompression (with zlib wrapper)
/// - "deflate-raw" - DEFLATE decompression (without wrapper)
///
/// Example:
/// ```moonbit
/// let decompressor = DecompressionStream::new("gzip")
/// ```
pub fn DecompressionStream::new(format : String) -> DecompressionStream {
  new_decompression_stream(format)
}

///|
extern "js" fn new_decompression_stream(format : String) -> DecompressionStream =
  #|(format) => new DecompressionStream(format)

///|
/// Get the readable side of the decompression stream
pub fn DecompressionStream::readable(
  self : DecompressionStream
) -> ReadableStream {
  self.get("readable") |> unsafe_cast
}

///|
/// Get the writable side of the decompression stream
pub fn DecompressionStream::writable(
  self : DecompressionStream
) -> WritableStream {
  self.get("writable") |> unsafe_cast
}
