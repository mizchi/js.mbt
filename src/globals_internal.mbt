// Internal global functions for @js package
// These are kept here to avoid circular dependencies with @global package

///|
/// JS: globalThis  (internal use)
// pub fn globalThis() -> @nostd.Any {
//   ffi_global_this()
// }

///|
/// JS: undefined (internal use)
pub fn undefined() -> @nostd.Any {
  ffi_undefined()
}
