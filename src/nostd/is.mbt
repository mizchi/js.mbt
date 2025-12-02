///|
pub extern "js" fn is_object(v : Any) -> Bool =
  #| (v) => typeof v === "object" && v !== null

// ///|
// /// JS: v === null
// pub extern "js" fn is_null(v : Any) -> Bool =
//   #| (v) => v === null

// ///|
// /// JS: v === undefined
// pub extern "js" fn is_undefined(v : Any) -> Bool =
//   #| (v) => v === undefined

// ///|
// /// JS: v == undefined
// pub extern "js" fn is_nullish(v : Any) -> Bool =
//   #| (v) => v == undefined
