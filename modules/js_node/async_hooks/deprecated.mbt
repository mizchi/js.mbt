// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `AsyncLocalStorage(..)` constructor.
#deprecated("use `AsyncLocalStorage(..)` instead")
pub fn[T] AsyncLocalStorage::new() -> AsyncLocalStorage[T] {
  AsyncLocalStorage()
}
