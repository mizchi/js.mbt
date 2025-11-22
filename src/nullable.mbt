///|
/// for explicit nullable value for field
/// In many case, Moonbit casting for T? handle undefined correctly,
/// but sometimes we need to distinguish null and undefined.
/// Example:
/// struct FileReader {
///   T : Nullable[T]
/// }
#external
pub type Nullable[T]

///|
pub fn[T] Nullable::to_option(self : Nullable[T]) -> T? {
  let js_value : Js = self |> unsafe_cast
  if ffi_is_null(js_value) {
    None
  } else {
    Some(self |> unsafe_cast)
  }
}

///|
pub fn[T] Nullable::unwrap(self : Nullable[T]) -> T {
  self |> unsafe_cast
}
