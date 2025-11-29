// Lightweight JS interop without trait vtable overhead
// Works with --nostd by using custom JsArray instead of Array

///|
/// Opaque type for JavaScript values
#external
pub type JsValue

///|
#external
pub type Object

///|
pub extern "js" fn Object::new() -> JsValue =
  #| () => {}

///| Zero-cost type conversions using %identity
/// These are compile-time only and produce no runtime code

///|
pub fn[A, B] identity(value : A) -> B = "%identity"

///|
pub fn[T] JsValue::from(value : T) -> JsValue = "%identity"

///|
pub fn[T] JsValue::cast(self : JsValue) -> T = "%identity"

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
/// Call method: obj._call("method", [arg1, arg2])
pub extern "js" fn JsValue::_call(
  self : JsValue,
  key : String,
  args : Array[JsValue],
) -> JsValue =
  #| (obj, key, args) => obj[key](...args)

///|
/// Call function: func._invoke([arg1, arg2])
pub extern "js" fn JsValue::_invoke(
  self : JsValue,
  args : Array[JsValue],
) -> JsValue =
  #| (func, args) => func(...args)

///|
/// JS: value[key]
/// Enables syntax: obj["key"]
#alias("_[_]")
pub extern "js" fn JsValue::_get(self : JsValue, key : String) -> JsValue =
  #| (obj, key) => obj[key]

///| Global functions

///|
pub extern "js" fn global_this() -> JsValue =
  #| () => globalThis

///|
pub extern "js" fn undefined() -> JsValue =
  #| () => undefined

///|
pub extern "js" fn null() -> JsValue =
  #| () => null

///|
/// Check if value is null or undefined
pub extern "js" fn is_nullish(v : JsValue) -> Bool =
  #|(v) => v == null

///|
/// Check if value is null
pub extern "js" fn is_null(v : JsValue) -> Bool =
  #|(v) => v === null

///|
/// Check if value is null
pub extern "js" fn is_undefined(v : JsValue) -> Bool =
  #|(v) => v === undefined

///|
/// Check if value is null or undefined
pub extern "js" fn equal(a : JsValue, b : JsValue) -> Bool =
  #|(a, b) => a === b
