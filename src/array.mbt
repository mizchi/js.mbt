///|
/// JavaScript Array
#external
pub type JsArray

///|
pub impl JsImpl for JsArray

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///|
/// JS: Array.from(items)
pub fn[T] JsArray::from(items : Array[T]) -> JsArray {
  ffi_array_from(items |> unsafe_cast) |> unsafe_cast
}

///|
/// JS: new Array()
pub fn JsArray::new() -> JsArray {
  ffi_new_empty_array() |> unsafe_cast
}

///|
/// JS: array.push(item)
pub fn JsArray::push(self : JsArray, item : &JsImpl) -> Unit {
  self.as_builtin_array().push(item.to_js())
}

///|
/// cast to builtin Array
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> unsafe_cast
}

///|
/// JS: Array.isArray(v)
pub fn[T: JsImpl] JsArray::isArray(v : T) -> Bool {
  ffi_is_array(v.to_js())
}

///|
pub fn array_from(v : Js) -> Array[Js] {
  ffi_array_from(v)
}
