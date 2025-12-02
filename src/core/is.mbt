///|
pub extern "js" fn is_object(v : Any) -> Bool =
  #| (v) => typeof v === "object" && v !== null

///|
/// Check if value is null or undefined
pub extern "js" fn is_nullish(v : Any) -> Bool =
  #|(v) => v == null

///|
/// Check if value is null
pub extern "js" fn is_null(v : Any) -> Bool =
  #|(v) => v === null

///|
/// Check if value is null
pub extern "js" fn is_undefined(v : Any) -> Bool =
  #|(v) => v === undefined

///|
/// Check if value is an array
pub extern "js" fn is_array(v : Any) -> Bool =
  #|(v) => Array.isArray(v)
