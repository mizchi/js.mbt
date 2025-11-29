// Lightweight JS interop without trait vtable overhead
// Works with --nostd by using custom JsArray instead of Array

///|
/// Opaque type for JavaScript values
#external
pub type JsValue

///|
/// Opaque type for JavaScript arrays (for --nostd compatibility)
#external
pub type JsArray

///| Zero-cost type conversions using %identity
/// These are compile-time only and produce no runtime code

///|
pub fn[T] JsValue::from(value : T) -> JsValue = "%identity"

///|
pub fn[T] JsValue::cast(self : JsValue) -> T = "%identity"

///| JsArray operations

///|
extern "js" fn ffi_array_new() -> JsArray =
  #| () => []

///|
extern "js" fn ffi_array_push(arr : JsArray, value : JsValue) -> Unit =
  #| (arr, value) => arr.push(value)

///|
pub fn array_new() -> JsArray {
  ffi_array_new()
}

///|
pub fn array_push(arr : JsArray, value : JsValue) -> Unit {
  ffi_array_push(arr, value)
}

///| JsValue methods

///|
/// Set property: obj["key"] = value
/// Enables syntax: obj["key"] = val
#alias("_[_]=_")
pub extern "js" fn JsValue::_set(
  self : JsValue,
  key : String,
  value : JsValue,
) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
/// Call method: obj._call("method", args)
pub extern "js" fn JsValue::_call(
  self : JsValue,
  key : String,
  args : JsArray,
) -> JsValue =
  #| (obj, key, args) => obj[key](...args)

///|
/// Call function: func.invoke(args)
pub extern "js" fn JsValue::invoke(self : JsValue, args : JsArray) -> JsValue =
  #| (func, args) => func(...args)

///|
/// JS: value[key]
/// Enables syntax: obj["key"]
#alias("_[_]")
pub extern "js" fn JsValue::_get(self : JsValue, key : String) -> JsValue =
  #| (obj, key) => obj[key]

///| Global functions

///|
extern "js" fn ffi_global_this() -> JsValue =
  #| () => globalThis

///|
extern "js" fn ffi_undefined() -> JsValue =
  #| () => undefined

///|
extern "js" fn ffi_null() -> JsValue =
  #| () => null

///|
extern "js" fn ffi_is_nullish(v : JsValue) -> Bool =
  #|(v) => v == null

///|
extern "js" fn ffi_console_log(msg : String) -> Unit =
  #| (msg) => console.log(msg)

///|
pub fn global_this() -> JsValue {
  ffi_global_this()
}

///|
pub fn undefined() -> JsValue {
  ffi_undefined()
}

///|
pub fn null() -> JsValue {
  ffi_null()
}

///|
pub fn is_nullish(v : JsValue) -> Bool {
  ffi_is_nullish(v)
}

///|
pub fn console_log(msg : String) -> Unit {
  ffi_console_log(msg)
}

///|
pub fn str(s : String) -> JsValue {
  JsValue::from(s)
}

///|
pub fn int(n : Int) -> JsValue {
  JsValue::from(n)
}
