// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `SpawnOptions(..)` constructor.
#deprecated("use `SpawnOptions(..)` instead")
pub fn SpawnOptions::new(cmd : Array[String]) -> SpawnOptions {
  SpawnOptions(cmd)
}

///|
/// Deprecated alias for the `CryptoHasher(..)` constructor.
#deprecated("use `CryptoHasher(..)` instead")
pub fn CryptoHasher::new(algorithm : String) -> CryptoHasher {
  CryptoHasher(algorithm)
}

///|
/// Deprecated alias for the `Glob(..)` constructor.
#deprecated("use `Glob(..)` instead")
pub fn Glob::new(pattern : String) -> Glob {
  Glob(pattern)
}
