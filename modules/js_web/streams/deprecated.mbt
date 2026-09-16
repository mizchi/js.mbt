// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `ReadableStream(..)` constructor.
#deprecated("use `ReadableStream(..)` instead")
pub fn ReadableStream::new(underlying_source : @core.Any) -> ReadableStream {
  ReadableStream(underlying_source)
}

///|
/// Deprecated alias for the `WritableStream(..)` constructor.
#deprecated("use `WritableStream(..)` instead")
pub fn WritableStream::new(underlying_sink : @core.Any) -> WritableStream {
  WritableStream(underlying_sink)
}

///|
/// Deprecated alias for the `TransformStream(..)` constructor.
#deprecated("use `TransformStream(..)` instead")
pub fn TransformStream::new(transformer : @core.Any) -> TransformStream {
  TransformStream(transformer)
}

///|
/// Deprecated alias for the `CompressionStream(..)` constructor.
#deprecated("use `CompressionStream(..)` instead")
pub fn CompressionStream::new(format : String) -> CompressionStream {
  CompressionStream(format)
}

///|
/// Deprecated alias for the `DecompressionStream(..)` constructor.
#deprecated("use `DecompressionStream(..)` instead")
pub fn DecompressionStream::new(format : String) -> DecompressionStream {
  DecompressionStream(format)
}

///|
/// Deprecated alias for `TransformStream::identity()`.
#deprecated("use `TransformStream::identity()` instead")
pub fn TransformStream::new_identity() -> TransformStream {
  TransformStream::identity()
}
