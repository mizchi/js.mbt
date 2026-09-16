// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Date(..)` constructor.
#deprecated("use `Date(..)` instead")
pub fn Date::new() -> Date {
  Date()
}
