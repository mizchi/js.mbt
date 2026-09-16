// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `GPUExtent3D(..)` constructor.
#deprecated("use `GPUExtent3D(..)` instead")
pub fn GPUExtent3D::new(
  width : Int,
  height? : Int,
  depth_or_array_layers? : Int,
) -> GPUExtent3D {
  GPUExtent3D(width, height?, depth_or_array_layers?)
}
