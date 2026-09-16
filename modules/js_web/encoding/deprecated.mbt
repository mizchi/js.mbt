// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `TextEncoder(..)` constructor.
#deprecated("use `TextEncoder(..)` instead")
pub fn TextEncoder::new() -> TextEncoder {
  TextEncoder()
}

///|
/// Deprecated alias for the `TextDecoder(..)` constructor.
#deprecated("use `TextDecoder(..)` instead")
pub fn TextDecoder::new() -> TextDecoder {
  TextDecoder()
}
