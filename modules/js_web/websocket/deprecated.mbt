// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `WebSocket(..)` constructor.
#deprecated("use `WebSocket(..)` instead")
pub fn WebSocket::new(
  url : String,
  protocols? : FixedArray[String],
) -> WebSocket {
  WebSocket(url, protocols?)
}
