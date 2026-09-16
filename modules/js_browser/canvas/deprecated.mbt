// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `OffscreenCanvas(..)` constructor.
#deprecated("use `OffscreenCanvas(..)` instead")
pub fn OffscreenCanvas::new(width : Int, height : Int) -> OffscreenCanvas {
  OffscreenCanvas(width, height)
}

///|
/// Deprecated alias for the `ImageData(..)` constructor.
#deprecated("use `ImageData(..)` instead")
pub fn ImageData::new(width : Int, height : Int) -> ImageData {
  ImageData(width, height)
}
