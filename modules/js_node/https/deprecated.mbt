// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Agent(..)` constructor.
#deprecated("use `Agent(..)` instead")
pub fn Agent::new(
  max_cached_sessions? : Int,
  servername? : String,
  keep_alive? : Bool,
  keep_alive_msecs? : Int,
  max_sockets? : Int,
  max_free_sockets? : Int,
  timeout? : Int,
) -> Agent {
  Agent(
    max_cached_sessions?,
    servername?,
    keep_alive?,
    keep_alive_msecs?,
    max_sockets?,
    max_free_sockets?,
    timeout?,
  )
}
