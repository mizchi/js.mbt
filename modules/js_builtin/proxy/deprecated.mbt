// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Proxy(..)` constructor.
#deprecated("use `Proxy(..)` instead")
pub fn Proxy::new(
  target : @core.Any,
  get? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  set? : (@core.Any, @core.Any, @core.Any, @core.Any) -> Bool,
  has? : (@core.Any, @core.Any) -> Bool,
  deleteProperty? : (@core.Any, @core.Any) -> Bool,
  apply? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  construct? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  ownKeys? : (@core.Any) -> @core.Any,
  getPrototypeOf? : (@core.Any) -> @core.Any,
  setPrototypeOf? : (@core.Any, @core.Any) -> Bool,
  isExtensible? : (@core.Any) -> Bool,
  preventExtensions? : (@core.Any) -> Bool,
  getOwnPropertyDescriptor? : (@core.Any, @core.Any) -> @core.Any,
  defineProperty? : (@core.Any, @core.Any, @core.Any) -> Bool,
) -> Proxy {
  Proxy(
    target,
    get?,
    set?,
    has?,
    deleteProperty?,
    apply?,
    construct?,
    ownKeys?,
    getPrototypeOf?,
    setPrototypeOf?,
    isExtensible?,
    preventExtensions?,
    getOwnPropertyDescriptor?,
    defineProperty?,
  )
}
