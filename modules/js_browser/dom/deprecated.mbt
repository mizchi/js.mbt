// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `ShadowRootInit(..)` constructor.
#deprecated("use `ShadowRootInit(..)` instead")
pub fn ShadowRootInit::new(
  mode : String,
  delegatesFocus? : Bool = false,
  slotAssignment? : String = "named",
) -> ShadowRootInit {
  ShadowRootInit(mode, delegatesFocus~, slotAssignment~)
}
