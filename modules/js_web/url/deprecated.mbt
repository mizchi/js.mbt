// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `URLPattern(..)` constructor.
#deprecated("use `URLPattern(..)` instead")
pub fn URLPattern::new(pattern : String, base? : String) -> URLPattern {
  URLPattern(pattern, base?)
}

///|
/// Deprecated alias for the `URL(..)` constructor.
#deprecated("use `URL(..)` instead")
pub fn URL::new(url : String, base? : String) -> URL raise @core.JsError {
  URL(url, base?)
}

///|
/// Deprecated alias for `URLPattern::from_object(..)`.
#alias(new_from_object)
#deprecated("use `URLPattern::from_object(..)` instead")
pub fn URLPattern::newFromObject(
  pattern : @core.Any,
  base? : String,
) -> URLPattern {
  URLPattern::from_object(pattern, base?)
}
