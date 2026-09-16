// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `DisposableStack(..)` constructor.
#deprecated("use `DisposableStack(..)` instead")
pub fn DisposableStack::new() -> DisposableStack {
  DisposableStack()
}

///|
/// Deprecated alias for the `AsyncDisposableStack(..)` constructor.
#deprecated("use `AsyncDisposableStack(..)` instead")
pub fn AsyncDisposableStack::new() -> AsyncDisposableStack {
  AsyncDisposableStack()
}
