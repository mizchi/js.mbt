// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `WeakMap(..)` constructor.
#deprecated("use `WeakMap(..)` instead")
pub fn[K, V] WeakMap::new() -> WeakMap[K, V] {
  WeakMap()
}

///|
/// Deprecated alias for the `WeakSet(..)` constructor.
#deprecated("use `WeakSet(..)` instead")
pub fn[T] WeakSet::new() -> WeakSet[T] {
  WeakSet()
}

///|
/// Deprecated alias for the `WeakRef(..)` constructor.
#deprecated("use `WeakRef(..)` instead")
pub fn[T] WeakRef::new(target : T) -> WeakRef[T] {
  WeakRef(target)
}

///|
/// Deprecated alias for the `FinalizationRegistry(..)` constructor.
#deprecated("use `FinalizationRegistry(..)` instead")
pub fn[T] FinalizationRegistry::new(
  cleanup_callback : (T) -> Unit,
) -> FinalizationRegistry[T] {
  FinalizationRegistry(cleanup_callback)
}
