// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `WebAssemblyMemory(..)` constructor.
#deprecated("use `WebAssemblyMemory(..)` instead")
pub fn WebAssemblyMemory::new(
  descriptor : MemoryDescriptor,
) -> WebAssemblyMemory {
  WebAssemblyMemory(descriptor)
}

///|
/// Deprecated alias for the `WebAssemblyTable(..)` constructor.
#deprecated("use `WebAssemblyTable(..)` instead")
pub fn WebAssemblyTable::new(descriptor : TableDescriptor) -> WebAssemblyTable {
  WebAssemblyTable(descriptor)
}

///|
/// Deprecated alias for the `WebAssemblyGlobal(..)` constructor.
#deprecated("use `WebAssemblyGlobal(..)` instead")
pub fn WebAssemblyGlobal::new(
  descriptor : GlobalDescriptor,
  value : @core.Any,
) -> WebAssemblyGlobal {
  WebAssemblyGlobal(descriptor, value)
}
