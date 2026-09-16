// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Serializer(..)` constructor.
#deprecated("use `Serializer(..)` instead")
pub fn Serializer::new() -> Serializer {
  Serializer()
}

///|
/// Deprecated alias for the `Deserializer(..)` constructor.
#deprecated("use `Deserializer(..)` instead")
pub fn Deserializer::new(buffer : @buffer.Buffer) -> Deserializer {
  Deserializer(buffer)
}
