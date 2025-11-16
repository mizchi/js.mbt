///|
#external
pub type JsArray

///|
pub impl Js for JsArray

///|
pub fn[T] JsArray::from(items : Array[T]) -> JsArray {
  ffi_array_from(items |> unsafe_cast) |> unsafe_cast
}

///|
pub fn JsArray::new() -> JsArray {
  new_empty_array() |> unsafe_cast
}

///|
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> unsafe_cast
}

///|
/// Create a new empty JavaScript array.
///
/// Equivalent to JavaScript's `[]` or `new Array()`.
///
/// # Returns
///
/// A new empty array as a Val
///
/// # Example
///
/// ```moonbit
/// let arr = new_empty_array()
/// arr.set(0, "first")
/// arr.set(1, "second")
/// ```
pub fn new_empty_array() -> Val {
  ffi_new_empty_array()
}

///|
pub fn array_from(v : Val) -> Array[Val] {
  ffi_array_from(v)
}
