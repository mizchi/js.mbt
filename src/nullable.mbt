///|
/// Nullable type for explicit null handling in FFI struct fields.
///
/// Use `Nullable[T]` when you need to represent JavaScript fields that can be `null`.
/// Unlike `T?` which treats both `null` and `undefined` as `None`, `Nullable[T]`
/// only checks for `null` specifically.
///
/// # When to Use
///
/// **Use `Nullable[T]` for:**
/// - FFI struct fields that can be explicitly null
/// - When you need to distinguish between null and undefined
///
/// **Use `T?` (Option) for:**
/// - Function parameters and return values
/// - General nullable handling where null/undefined distinction doesn't matter
///
/// # Example
///
/// Define FFI struct with nullable fields:
/// - `result : Nullable[ArrayBuffer]` - Can be null during reading
/// - `error : Nullable[JsError]` - Can be null when no error
///
/// Check if null: `reader.result.is_null()`
/// Convert to Option: `reader.result.to_option()`
///
/// # See Also
/// - `identity_option(Js) -> A?` - For converting Js to Option
/// - `from_option(A?) -> Js` - For converting Option to Js
#external
pub type Nullable[T]

///|
pub fn[T] Nullable::to_option(self : Nullable[T]) -> T? {
  let js_value : Js = self |> identity
  if ffi_is_null(js_value) {
    None
  } else {
    Some(self |> identity)
  }
}

///|
pub fn[T] Nullable::is_null(self : Nullable[T]) -> Bool {
  let js_value : Js = self |> identity
  ffi_is_null(js_value)
}
