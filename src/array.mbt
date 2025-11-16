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
  ffi_new_empty_array() |> unsafe_cast
}

///|
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> unsafe_cast
}

///|
pub fn array_from(v : Val) -> Array[Val] {
  ffi_array_from(v)
}
