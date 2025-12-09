///|
/// @deprecated No longer needed - Fragment/StrictMode/Suspense use Symbol.for
pub fn init_react_api(
  _val : @core.Any,
  global_key? : String = "__ReactApi",
) -> Unit {
  let _ = global_key
  // No-op: all React symbols now use Symbol.for directly
}

///|
/// @deprecated No longer needed - React is now imported via #module("react")
/// This function is kept for backward compatibility but does nothing.
pub async fn dynamic_import() -> Unit {
  // No-op: React is now imported directly via #module
}

///|
/// @deprecated No longer needed
#alias(initReactAsync)
pub async fn init_react_async() -> Unit {
  // No-op
}
