// Lightweight JS interop without trait vtable overhead

///|
/// Opaque type for JavaScript values
#external
pub type Any

///|
#external
pub type Object

///|
pub extern "js" fn Object::new() -> Any =
  #| () => ({})

///| Zero-cost type conversions using %identity
/// These are compile-time only and produce no runtime code

///|
pub fn[A, B] identity(value : A) -> B = "%identity"

///|
pub fn[T] any(value : T) -> Any = "%identity"

///|
pub fn[T] Any::cast(self : Any) -> T = "%identity"

///| JsValue methods

///|
/// Set property: obj["key"] = value
/// Enables syntax: obj["key"] = val
#alias("_[_]=_")
pub extern "js" fn Any::_set(self : Any, key : String, value : Any) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
/// Call method: obj._call("method", [arg1, arg2])
pub extern "js" fn Any::_call(
  self : Any,
  key : String,
  args : Array[Any],
) -> Any =
  #| (obj, key, args) => obj[key](...args)

///|
/// Call function: func._invoke([arg1, arg2])
pub extern "js" fn Any::_invoke(self : Any, args : Array[Any]) -> Any =
  #| (func, args) => func(...args)

///|
/// JS: value[key]
/// Enables syntax: obj["key"]
#alias("_[_]")
pub extern "js" fn Any::_get(self : Any, key : String) -> Any =
  #| (obj, key) => obj[key]

///| Global functions

///|
pub extern "js" fn global_this() -> Any =
  #| () => globalThis

///|
pub extern "js" fn undefined() -> Any =
  #| () => undefined

///|
pub extern "js" fn null() -> Any =
  #| () => null

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
/// Check if value is null or undefined
pub extern "js" fn equal(a : Any, b : Any) -> Bool =
  #|(a, b) => a === b

///|
/// JS: typeof value
pub extern "js" fn type_of(value : Any) -> String =
  #|(value) => typeof value

///|
/// JS: value instanceof cls
pub extern "js" fn instance_of(value : Any, cls : Any) -> Bool =
  #|(value, cls) => value instanceof cls

///|
/// JS: new cls(...args)
pub extern "js" fn new(cls : Any, args : Array[Any]) -> Any =
  #|(cls, args) => new cls(...args)
