///|
#external
pub type JsArray

///|
pub impl Js for JsArray

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///|
pub fn[T] JsArray::from(items : Array[T]) -> JsArray {
  ffi_array_from(items |> unsafe_cast) |> unsafe_cast
}

///|
pub fn JsArray::new() -> JsArray {
  ffi_new_empty_array() |> unsafe_cast
}

///|
pub fn JsArray::push(self : JsArray, item : &Js) -> Unit {
  self.as_builtin_array().push(item.to_js())
}

///|
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> unsafe_cast
}

///|
pub fn[T : Js] JsArray::isArray(v : T) -> Bool {
  ffi_is_array(v.to_js())
}

///|
pub fn array_from(v : Val) -> Array[Val] {
  ffi_array_from(v)
}
