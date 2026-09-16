// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `ArrayBuffer(..)` constructor.
#deprecated("use `ArrayBuffer(..)` instead")
pub fn ArrayBuffer::new(
  byte_length : Int,
  max_byte_length? : Int,
) -> ArrayBuffer {
  ArrayBuffer(byte_length, max_byte_length?)
}

///|
/// Deprecated alias for the `SharedArrayBuffer(..)` constructor.
#deprecated("use `SharedArrayBuffer(..)` instead")
pub fn SharedArrayBuffer::new(byte_length : Int) -> SharedArrayBuffer {
  SharedArrayBuffer(byte_length)
}

///|
/// Deprecated alias for the `DataView(..)` constructor.
#deprecated("use `DataView(..)` instead")
pub fn DataView::new(
  buffer : ArrayBuffer,
  byte_offset? : Int = 0,
  byte_length? : Int,
) -> DataView {
  DataView(buffer, byte_offset~, byte_length?)
}
