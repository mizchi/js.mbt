// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Script(..)` constructor.
#deprecated("use `Script(..)` instead")
pub fn Script::new(
  code : String,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  cachedData? : @buffer.Buffer,
  produceCachedData? : Bool,
) -> Script {
  Script(
    code,
    filename?,
    lineOffset?,
    columnOffset?,
    cachedData?,
    produceCachedData?,
  )
}
