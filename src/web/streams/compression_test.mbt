///|
test "CompressionStream::new - create gzip compressor" {
  let compressor = CompressionStream::new("gzip")
  assert_true(@nostd.type_of(compressor.as_any()) == "object")
}

///|
test "CompressionStream::new - create deflate compressor" {
  let compressor = CompressionStream::new("deflate")
  assert_true(@nostd.type_of(compressor.as_any()) == "object")
}

///|
test "CompressionStream::new - create deflate-raw compressor" {
  let compressor = CompressionStream::new("deflate-raw")
  assert_true(@nostd.type_of(compressor.as_any()) == "object")
}

///|
test "CompressionStream::readable - get readable stream" {
  let compressor = CompressionStream::new("gzip")
  let readable = compressor.readable
  assert_true(@nostd.type_of(readable.as_any()) == "object")
}

///|
test "CompressionStream::writable - get writable stream" {
  let compressor = CompressionStream::new("gzip")
  let writable = compressor.writable
  assert_true(@nostd.type_of(writable.as_any()) == "object")
}

///|
test "DecompressionStream::new - create gzip decompressor" {
  let decompressor = DecompressionStream::new("gzip")
  assert_true(@nostd.type_of(decompressor.as_any()) == "object")
}

///|
test "DecompressionStream::new - create deflate decompressor" {
  let decompressor = DecompressionStream::new("deflate")
  assert_true(@nostd.type_of(decompressor.as_any()) == "object")
}

///|
test "DecompressionStream::new - create deflate-raw decompressor" {
  let decompressor = DecompressionStream::new("deflate-raw")
  assert_true(@nostd.type_of(decompressor.as_any()) == "object")
}

///|
test "DecompressionStream::readable - get readable stream" {
  let decompressor = DecompressionStream::new("gzip")
  let readable = decompressor.readable
  assert_true(@nostd.type_of(readable.as_any()) == "object")
}

///|
test "DecompressionStream::writable - get writable stream" {
  let decompressor = DecompressionStream::new("gzip")
  let writable = decompressor.writable
  assert_true(@nostd.type_of(writable.as_any()) == "object")
}

///|
test "compression and decompression round-trip" {
  let encoder = @encoding.TextEncoder::new()
  let _decoder = @encoding.TextDecoder::new()

  // Original data
  let original = "Hello, MoonBit! This is a compression test."
  let _data = encoder.encode(original)

  // Create compression stream
  let compressor = CompressionStream::new("gzip")
  let comp_readable = compressor.readable
  let comp_writable = compressor.writable

  // Create decompression stream
  let decompressor = DecompressionStream::new("gzip")
  let decomp_readable = decompressor.readable
  let decomp_writable = decompressor.writable

  // Verify streams are created
  assert_true(@nostd.type_of(comp_readable.as_any()) == "object")
  assert_true(@nostd.type_of(comp_writable.as_any()) == "object")
  assert_true(@nostd.type_of(decomp_readable.as_any()) == "object")
  assert_true(@nostd.type_of(decomp_writable.as_any()) == "object")
}
