// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Blob(..)` constructor.
#deprecated("use `Blob(..)` instead")
pub fn Blob::new(data : Array[@core.Any], content_type? : String) -> Blob {
  Blob(data, content_type?)
}
