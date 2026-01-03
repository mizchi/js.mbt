// core_wasm.mbt - WASM-GC target implementation
// Requires: use-js-builtin-string: true in moon.pkg.json

// ============================================
// WASM imports from "jscore" namespace
// ============================================

///|
extern "wasm" fn wasm_get(obj : Any, key : String) -> Any = "jscore" "get"

///|
extern "wasm" fn wasm_get_by_index(obj : Any, index : Int) -> Any = "jscore" "get_by_index"

///|
extern "wasm" fn wasm_set(obj : Any, key : String, value : Any) -> Unit = "jscore" "set"

// Fixed-arity call functions (WASM can't use Array in extern)

///|
extern "wasm" fn wasm_call0(obj : Any, name : String) -> Any = "jscore" "call0"

///|
extern "wasm" fn wasm_call1(obj : Any, name : String, a1 : Any) -> Any = "jscore" "call1"

///|
extern "wasm" fn wasm_call2(
  obj : Any,
  name : String,
  a1 : Any,
  a2 : Any,
) -> Any = "jscore" "call2"

///|
extern "wasm" fn wasm_call3(
  obj : Any,
  name : String,
  a1 : Any,
  a2 : Any,
  a3 : Any,
) -> Any = "jscore" "call3"

///|
extern "wasm" fn wasm_call4(
  obj : Any,
  name : String,
  a1 : Any,
  a2 : Any,
  a3 : Any,
  a4 : Any,
) -> Any = "jscore" "call4"

// Fixed-arity invoke functions

///|
extern "wasm" fn wasm_invoke0(fn_ : Any) -> Any = "jscore" "invoke0"

///|
extern "wasm" fn wasm_invoke1(fn_ : Any, a1 : Any) -> Any = "jscore" "invoke1"

///|
extern "wasm" fn wasm_invoke2(fn_ : Any, a1 : Any, a2 : Any) -> Any = "jscore" "invoke2"

///|
extern "wasm" fn wasm_invoke3(fn_ : Any, a1 : Any, a2 : Any, a3 : Any) -> Any = "jscore" "invoke3"

///|
extern "wasm" fn wasm_invoke4(
  fn_ : Any,
  a1 : Any,
  a2 : Any,
  a3 : Any,
  a4 : Any,
) -> Any = "jscore" "invoke4"

// Fixed-arity new functions

///|
extern "wasm" fn wasm_new0(cls : Any) -> Any = "jscore" "new0"

///|
extern "wasm" fn wasm_new1(cls : Any, a1 : Any) -> Any = "jscore" "new1"

///|
extern "wasm" fn wasm_new2(cls : Any, a1 : Any, a2 : Any) -> Any = "jscore" "new2"

///|
extern "wasm" fn wasm_new3(cls : Any, a1 : Any, a2 : Any, a3 : Any) -> Any = "jscore" "new3"

///|
extern "wasm" fn wasm_new4(
  cls : Any,
  a1 : Any,
  a2 : Any,
  a3 : Any,
  a4 : Any,
) -> Any = "jscore" "new4"

// Utility imports

///|
extern "wasm" fn wasm_typeof(v : Any) -> String = "jscore" "typeof"

///|
extern "wasm" fn wasm_is_nullish(v : Any) -> Bool = "jscore" "is_nullish"

///|
extern "wasm" fn wasm_is_null(v : Any) -> Bool = "jscore" "is_null"

///|
extern "wasm" fn wasm_is_undefined(v : Any) -> Bool = "jscore" "is_undefined"

///|
extern "wasm" fn wasm_is_array(v : Any) -> Bool = "jscore" "is_array"

///|
extern "wasm" fn wasm_is_object(v : Any) -> Bool = "jscore" "is_object"

///|
extern "wasm" fn wasm_instanceof(v : Any, cls : Any) -> Bool = "jscore" "instanceof"

///|
extern "wasm" fn wasm_equal(a : Any, b : Any) -> Bool = "jscore" "equal"

///|
extern "wasm" fn wasm_to_string(v : Any) -> String = "jscore" "to_string"

///|
extern "wasm" fn wasm_global_this() -> Any = "jscore" "global_this"

///|
extern "wasm" fn wasm_undefined() -> Any = "jscore" "undefined"

///|
extern "wasm" fn wasm_null() -> Any = "jscore" "null"

///|
extern "wasm" fn wasm_new_object() -> Any = "jscore" "new_object"

///|
extern "wasm" fn wasm_new_array() -> Any = "jscore" "new_array"

// Array-returning functions: return Any, convert in MoonBit

///|
extern "wasm" fn wasm_object_keys_any(obj : Any) -> Any = "jscore" "object_keys"

///|
extern "wasm" fn wasm_object_values_any(obj : Any) -> Any = "jscore" "object_values"

///|
extern "wasm" fn wasm_array_from_any(v : Any) -> Any = "jscore" "array_from"

///|
extern "wasm" fn wasm_array_length(arr : Any) -> Int = "jscore" "array_length"

///|
extern "wasm" fn wasm_object_assign(target : Any, source : Any) -> Any = "jscore" "object_assign"

///|
extern "wasm" fn wasm_object_has_own(obj : Any, key : String) -> Bool = "jscore" "object_has_own"

///|
extern "wasm" fn wasm_json_stringify(value : Any) -> String = "jscore" "json_stringify"

///|
extern "wasm" fn wasm_json_stringify_pretty(value : Any, space : Int) -> String = "jscore" "json_stringify_pretty"

///|
extern "wasm" fn wasm_json_parse(text : String) -> Any = "jscore" "json_parse"

///|
extern "wasm" fn wasm_log(message : Any) -> Unit = "jscore" "log"

///|
extern "wasm" fn wasm_throw(value : Any) -> Unit = "jscore" "throw"

///|
extern "wasm" fn wasm_from(v : Any) -> Any = "jscore" "from"

// ============================================
// Core operations (public API)
// ============================================

///|
/// Get property: obj[key]
#alias("_[_]")
pub fn Any::_get(self : Any, key : String) -> Any {
  wasm_get(self, key)
}

///|
/// Get by index: obj[index]
pub fn Any::_get_by_index(self : Any, key : Int) -> Any {
  wasm_get_by_index(self, key)
}

///|
/// Set property: obj[key] = value
#alias("_[_]=_")
pub fn Any::_set(self : Any, key : String, value : Any) -> Unit {
  wasm_set(self, key, value)
}

///|
/// Call method: obj._call("method", [arg1, arg2])
pub fn Any::_call(self : Any, key : String, args : Array[Any]) -> Any {
  match args.length() {
    0 => wasm_call0(self, key)
    1 => wasm_call1(self, key, args[0])
    2 => wasm_call2(self, key, args[0], args[1])
    3 => wasm_call3(self, key, args[0], args[1], args[2])
    4 => wasm_call4(self, key, args[0], args[1], args[2], args[3])
    _ => abort("_call: too many arguments (max 4)")
  }
}

///|
/// Call function: func._invoke([arg1, arg2])
pub fn Any::_invoke(self : Any, args : Array[Any]) -> Any {
  match args.length() {
    0 => wasm_invoke0(self)
    1 => wasm_invoke1(self, args[0])
    2 => wasm_invoke2(self, args[0], args[1])
    3 => wasm_invoke3(self, args[0], args[1], args[2])
    4 => wasm_invoke4(self, args[0], args[1], args[2], args[3])
    _ => abort("_invoke: too many arguments (max 4)")
  }
}

///|
/// JS: new cls(...args)
pub fn new(cls : Any, args : Array[Any]) -> Any {
  match args.length() {
    0 => wasm_new0(cls)
    1 => wasm_new1(cls, args[0])
    2 => wasm_new2(cls, args[0], args[1])
    3 => wasm_new3(cls, args[0], args[1], args[2])
    4 => wasm_new4(cls, args[0], args[1], args[2], args[3])
    _ => abort("new: too many arguments (max 4)")
  }
}

// ============================================
// Global values
// ============================================

///|
pub fn global_this() -> Any {
  wasm_global_this()
}

///|
pub fn undefined() -> Any {
  wasm_undefined()
}

///|
pub fn null() -> Any {
  wasm_null()
}

// ============================================
// Type checks
// ============================================

///|
pub fn is_object(v : Any) -> Bool {
  wasm_is_object(v)
}

///|
pub fn is_nullish(v : Any) -> Bool {
  wasm_is_nullish(v)
}

///|
pub fn is_null(v : Any) -> Bool {
  wasm_is_null(v)
}

///|
pub fn is_undefined(v : Any) -> Bool {
  wasm_is_undefined(v)
}

///|
pub fn is_array(v : Any) -> Bool {
  wasm_is_array(v)
}

///|
pub fn typeof_(v : Any) -> String {
  wasm_typeof(v)
}

///|
pub fn instanceof_(v : Any, cls : Any) -> Bool {
  wasm_instanceof(v, cls)
}

///|
pub fn equal(a : Any, b : Any) -> Bool {
  wasm_equal(a, b)
}

// ============================================
// Object operations
// ============================================

///|
pub fn new_object() -> Any {
  wasm_new_object()
}

///|
pub fn new_array() -> Any {
  wasm_new_array()
}

///|
/// Convert JS array (Any) to MoonBit Array[String]
fn js_array_to_strings(js_arr : Any) -> Array[String] {
  let len = wasm_array_length(js_arr)
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    result.push(wasm_get_by_index(js_arr, i) |> Any::cast())
  }
  result
}

///|
/// Convert JS array (Any) to MoonBit Array[Any]
fn js_array_to_any_array(js_arr : Any) -> Array[Any] {
  let len = wasm_array_length(js_arr)
  let result : Array[Any] = []
  for i = 0; i < len; i = i + 1 {
    result.push(wasm_get_by_index(js_arr, i))
  }
  result
}

///|
pub fn object_keys(obj : Any) -> Array[String] {
  js_array_to_strings(wasm_object_keys_any(obj))
}

///|
pub fn object_values(obj : Any) -> Array[Any] {
  js_array_to_any_array(wasm_object_values_any(obj))
}

///|
pub fn array_from(v : Any) -> Array[Any] {
  js_array_to_any_array(wasm_array_from_any(v))
}

///|
pub fn object_assign(target : Any, source : Any) -> Any {
  wasm_object_assign(target, source)
}

///|
pub fn object_has_own(obj : Any, key : String) -> Bool {
  wasm_object_has_own(obj, key)
}

// ============================================
// JSON
// ============================================

///|
pub fn json_stringify(value : Any) -> String {
  wasm_json_stringify(value)
}

///|
pub fn json_stringify_pretty(value : Any, space : Int) -> String {
  wasm_json_stringify_pretty(value, space)
}

///|
pub fn json_parse(text : String) -> Any {
  wasm_json_parse(text)
}

// ============================================
// Utility
// ============================================

///|
pub fn Any::to_string(self : Any) -> String {
  wasm_to_string(self)
}

///|
pub fn log(message : Any) -> Unit {
  wasm_log(message)
}

///|
pub fn throw_(value : Any) -> Unit {
  wasm_throw(value)
}

// Note: as_any and from_entries need special handling in WASM
// For now, they are not supported in WASM target
