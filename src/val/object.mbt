///|
pub fn object_keys(v : &Js) -> Array[String] {
  ffi_object_keys(v.to_js().cast())
}

///|
pub fn object_values(v : &Js) -> Array[Val] {
  ffi_object_values(v.to_js().cast())
}
