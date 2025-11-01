///|
pub fn object_keys(v : Val) -> Array[String] {
  ffi_object_keys(v)
}

///|
pub fn object_values(v : Val) -> Array[Val] {
  ffi_object_values(v)
}

///|
pub fn object_entries(v : Val) -> Array[(String, Val)] {
  let entries = ffi_object_entries(v)
  entries.map(entry => (entry.get(0).cast(), entry.get(1).cast()))
}

///|
pub fn object_assign(target : Val, source : Val) -> Val {
  ffi_object_assign(target, source)
}
