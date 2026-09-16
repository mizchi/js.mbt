// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Worker(..)` constructor.
#deprecated("use `Worker(..)` instead")
pub fn Worker::new(script_url : String, type_? : String) -> Worker {
  Worker(script_url, type_?)
}
