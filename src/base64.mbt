///|
pub fn atob(encoded_data : String) -> String {
  ffi_atob(encoded_data)
}

///|
pub fn btoa(data : String) -> String {
  ffi_btoa(data)
}
