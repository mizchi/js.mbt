// core_js.mbt - JS target implementation

// ============================================
// Core operations
// ============================================

///|
/// Get property: obj[key]
#alias("_[_]")
pub extern "js" fn Any::_get(self : Any, key : String) -> Any =
  #| (obj, key) => obj[key]

///|
/// Get by index: obj[index]
pub extern "js" fn Any::_get_by_index(self : Any, key : Int) -> Any =
  #| (obj, key) => obj[key]

///|
/// Set property: obj[key] = value
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
/// JS: new cls(...args)
pub extern "js" fn new(cls : Any, args : Array[Any]) -> Any =
  #|(cls, args) => new cls(...args)

// ============================================
// Global values
// ============================================

///|
pub extern "js" fn global_this() -> Any =
  #| () => globalThis

///|
pub extern "js" fn undefined() -> Any =
  #| () => undefined

///|
pub extern "js" fn null() -> Any =
  #| () => null

// ============================================
// Type checks
// ============================================

///|
pub extern "js" fn is_object(v : Any) -> Bool =
  #| (v) => typeof v === "object" && v !== null

///|
pub extern "js" fn is_nullish(v : Any) -> Bool =
  #|(v) => v == null

///|
pub extern "js" fn is_null(v : Any) -> Bool =
  #|(v) => v === null

///|
pub extern "js" fn is_undefined(v : Any) -> Bool =
  #|(v) => v === undefined

///|
pub extern "js" fn is_array(v : Any) -> Bool =
  #|(v) => Array.isArray(v)

///|
pub extern "js" fn typeof_(v : Any) -> String =
  #|(v) => typeof v

///|
pub extern "js" fn instanceof_(v : Any, cls : Any) -> Bool =
  #|(v, cls) => v instanceof cls

///|
pub extern "js" fn equal(a : Any, b : Any) -> Bool =
  #|(a, b) => a === b

// ============================================
// Object operations
// ============================================

///|
pub extern "js" fn new_object() -> Any =
  #| () => ({})

///|
pub extern "js" fn new_array() -> Any =
  #| () => []

///|
pub extern "js" fn object_keys(obj : Any) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
pub extern "js" fn object_values(obj : Any) -> Array[Any] =
  #| (obj) => Object.values(obj)

///|
pub extern "js" fn object_assign(target : Any, source : Any) -> Any =
  #| (target, source) => Object.assign(target, source)

///|
pub extern "js" fn object_has_own(obj : Any, key : String) -> Bool =
  #| (obj, key) => Object.hasOwn(obj, key)

///|
pub extern "js" fn from_entries(entries : Array[(String, Any)]) -> Any =
  #| (entries) => Object.fromEntries(entries.map(e => [e._0, e._1]))

///|
pub extern "js" fn array_from(v : Any) -> Array[Any] =
  #| (v) => Array.from(v)

// ============================================
// JSON
// ============================================

///|
pub extern "js" fn json_stringify(value : Any) -> String =
  #| (value) => JSON.stringify(value)

///|
pub extern "js" fn json_stringify_pretty(value : Any, space : Int) -> String =
  #| (value, space) => JSON.stringify(value, null, space)

///|
pub extern "js" fn json_parse(text : String) -> Any =
  #| (text) => JSON.parse(text)

// ============================================
// Utility
// ============================================

///|
pub extern "js" fn Any::to_string(self : Any) -> String =
  #| (self) => self == null ? String(self) : self.toString()

///|
pub extern "js" fn as_any(opt : Any?) -> Any =
  #| (opt) => opt?._0

///|
pub extern "js" fn log(message : Any) -> Unit =
  #| (message) => { console.log(message); }

///|
pub extern "js" fn throw_(value : Any) -> Unit =
  #| (value) => { throw value }
