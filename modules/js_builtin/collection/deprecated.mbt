// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `JsMap(..)` constructor.
#deprecated("use `JsMap(..)` instead")
pub fn[K, V] JsMap::new() -> JsMap[K, V] {
  JsMap()
}

///|
/// Deprecated alias for the `JsSet(..)` constructor.
#deprecated("use `JsSet(..)` instead")
pub fn[T] JsSet::new() -> JsSet[T] {
  JsSet()
}
