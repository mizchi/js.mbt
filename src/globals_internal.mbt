// Internal global functions for @js package
// These are kept here to avoid circular dependencies with @global package

///|
/// JS: globalThis (internal use)
pub fn globalThis() -> Any {
  ffi_global_this()
}

///|
/// JS: undefined (internal use)
pub fn undefined() -> Any {
  ffi_undefined()
}
