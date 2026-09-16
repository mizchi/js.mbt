// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `RegExp(..)` constructor.
#deprecated("use `RegExp(..)` instead")
pub fn RegExp::new(pattern : String, flags? : String) -> RegExp {
  RegExp(pattern, flags?)
}
