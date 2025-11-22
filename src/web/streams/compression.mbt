///|
/// Compression Stream API
/// https://wicg.github.io/compression/

///|
/// CompressionStream is a TransformStream that compresses data using gzip, deflate, or deflate-raw
/// https://developer.mozilla.org/en-US/docs/Web/API/CompressionStream
pub(all) struct CompressionStream {
  readable : ReadableStream
  writable : WritableStream
}

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
  new_compression_stream(format) |> @js.unsafe_cast
}

///|
extern "js" fn new_compression_stream(format : String) -> Js =
  #|(format) => new CompressionStream(format)

///|
/// DecompressionStream is a TransformStream that decompresses data using gzip, deflate, or deflate-raw
/// https://developer.mozilla.org/en-US/docs/Web/API/DecompressionStream
pub(all) struct DecompressionStream {
  readable : ReadableStream
  writable : WritableStream
}

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
  new_decompression_stream(format) |> @js.unsafe_cast
}

///|
extern "js" fn new_decompression_stream(format : String) -> Js =
  #|(format) => new DecompressionStream(format)
