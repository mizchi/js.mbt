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
pub fn CompressionStream::as_any(self : CompressionStream) -> @nostd.Any = "%identity"

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
/// let _compressor = CompressionStream::new("gzip")
/// ```
pub fn CompressionStream::new(format : String) -> CompressionStream {
  new_compression_stream(format).cast()
}

///|
extern "js" fn new_compression_stream(format : String) -> @nostd.Any =
  #|(format) => new CompressionStream(format)

///|
/// DecompressionStream is a TransformStream that decompresses data using gzip, deflate, or deflate-raw
/// https://developer.mozilla.org/en-US/docs/Web/API/DecompressionStream
pub(all) struct DecompressionStream {
  readable : ReadableStream
  writable : WritableStream
}

///|
pub fn DecompressionStream::as_any(self : DecompressionStream) -> @nostd.Any = "%identity"

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
/// let _decompressor = DecompressionStream::new("gzip")
/// ```
pub fn DecompressionStream::new(format : String) -> DecompressionStream {
  new_decompression_stream(format).cast()
}

///|
extern "js" fn new_decompression_stream(format : String) -> @nostd.Any =
  #|(format) => new DecompressionStream(format)
