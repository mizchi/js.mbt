// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `MutationObserver(..)` constructor.
#deprecated("use `MutationObserver(..)` instead")
pub fn MutationObserver::new(
  callback : (@core.Any?, MutationObserver) -> Unit,
) -> MutationObserver {
  MutationObserver(callback)
}

///|
/// Deprecated alias for the `IntersectionObserver(..)` constructor.
#deprecated("use `IntersectionObserver(..)` instead")
pub fn IntersectionObserver::new(
  callback : (@core.Any?, IntersectionObserver) -> Unit,
  options? : @core.Any,
) -> IntersectionObserver {
  IntersectionObserver(callback, options?)
}

///|
/// Deprecated alias for the `ResizeObserver(..)` constructor.
#deprecated("use `ResizeObserver(..)` instead")
pub fn ResizeObserver::new(
  callback : (@core.Any?, ResizeObserver) -> Unit,
) -> ResizeObserver {
  ResizeObserver(callback)
}
