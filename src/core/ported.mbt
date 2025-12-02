// // ///|
// // /// JS: Array.isArray(v)
// // pub fn[T] is_array(v : T) -> Bool {
// //   ffi_is_array(identity(v))
// // }

// // ///|
// // /// JS: typeof v === "object" && v !== null && !Array.isArray(v)
// // pub fn[T] is_object(v : T) -> Bool {
// //   ffi_is_object(identity(v))
// // }

// // @js.new_object()

// ///|
// /// JS: v instanceof cls
// pub extern "js" fn instanceof_(v : Any, cls : Any) -> Bool =
//   #|(v, cls) => v instanceof cls

// ///|
// /// JS: typeof v
// pub extern "js" fn typeof_(v : Any) -> String =
//   #|(v) => typeof v

// ///|
// /// JS: new cls(...args)
// pub extern "js" fn new_(cls : Any, args : Array[Any]) -> Any =
//   #|(cls, args) => new cls(...args)

// ///|
// // extern "js" fn ffi_is_array(value : Any) -> Bool =
// //   #| (value) => Array.isArray(value)

// // ///|
// // extern "js" fn ffi_is_object(value : Any) -> Bool =
// //   #| (value) => typeof value === "object" && value !== null

// // ///|
// // extern "js" fn ffi_is_nan(value : Any) -> Bool =
// //   #| (value) => Number.isNaN(value)
