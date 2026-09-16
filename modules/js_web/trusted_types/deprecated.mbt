// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `TrustedTypePolicyOptions(..)` constructor.
#deprecated("use `TrustedTypePolicyOptions(..)` instead")
pub fn TrustedTypePolicyOptions::new(
  create_html? : ((String) -> String)? = None,
  create_script? : ((String) -> String)? = None,
  create_script_url? : ((String) -> String)? = None,
) -> TrustedTypePolicyOptions {
  TrustedTypePolicyOptions(create_html~, create_script~, create_script_url~)
}
