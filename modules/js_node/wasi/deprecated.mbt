// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `WASI(..)` constructor.
#deprecated("use `WASI(..)` instead")
pub fn WASI::new(
  version : String,
  args? : Array[String],
  env? : Map[String, String],
  preopens? : Map[String, String],
  returnOnExit? : Bool,
  stdin? : Int,
  stdout? : Int,
  stderr? : Int,
) -> WASI {
  WASI(version, args?, env?, preopens?, returnOnExit?, stdin?, stdout?, stderr?)
}
