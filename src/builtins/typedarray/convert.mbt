// Conversion utilities between MoonBit Bytes and JavaScript Uint8Array
//
// In MoonBit's JavaScript backend, the built-in Bytes type and Uint8Array
// share the same underlying representation, allowing for zero-cost conversions.

///|
/// Convert MoonBit Bytes to JavaScript Uint8Array
///
/// This is a zero-cost conversion on the JS backend, as both types
/// share the same underlying representation.
///
/// Example:
/// ```moonbit
/// let bytes = Bytes::from_array([1, 2, 3, 4, 5])
/// let uint8array = bytes_to_uint8array(bytes)
/// assert_eq(uint8array.length(), 5)
/// ```
pub fn bytes_to_uint8array(bytes : Bytes) -> Uint8Array {
  @js.identity(bytes)
}

///|
/// Convert JavaScript Uint8Array to MoonBit Bytes
///
/// This is a zero-cost conversion on the JS backend, as both types
/// share the same underlying representation.
///
/// Example:
/// ```moonbit
/// let uint8array = Uint8Array::from_array([1, 2, 3, 4, 5])
/// let bytes = uint8array_to_bytes(uint8array)
/// assert_eq(bytes.length(), 5)
/// ```
pub fn uint8array_to_bytes(uint8array : Uint8Array) -> Bytes {
  @js.identity(uint8array)
}

///|
/// Create a Uint8Array from a Bytes value (alias for bytes_to_uint8array)
pub fn Uint8Array::from_bytes(bytes : Bytes) -> Uint8Array {
  bytes_to_uint8array(bytes)
}

///|
/// Convert Uint8Array to Bytes (alias for uint8array_to_bytes)
pub fn Uint8Array::to_bytes(self : Uint8Array) -> Bytes {
  uint8array_to_bytes(self)
}
