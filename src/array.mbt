///|
#external
pub type JsArray[T]

///|
pub impl[T] Js for JsArray[T]

///|
pub fn[T] JsArray::from(items : Array[T]) -> JsArray[T] {
  ffi_array_from(items |> unsafe_cast) |> unsafe_cast
}

///|
pub fn array_from(v : Val) -> Array[Val] {
  ffi_array_from(v)
}
