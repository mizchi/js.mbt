// xany_wasm.mbt - WASM-GC専用実装
// Requires: use-js-builtin-string: true in moon.pkg.json

// ============================================
// WASM imports from "xany" namespace
// ============================================

///|
extern "wasm" fn wasm_get(obj : Xany, key : String) -> Xany = "xany" "get"

///|
extern "wasm" fn wasm_get_by_index(obj : Xany, index : Int) -> Xany = "xany" "get_by_index"

///|
extern "wasm" fn wasm_set(obj : Xany, key : String, value : Xany) -> Unit = "xany" "set"

// Fixed-arity call functions (WASM can't use Array in extern)

///|
extern "wasm" fn wasm_call0(obj : Xany, name : String) -> Xany = "xany" "call0"

///|
extern "wasm" fn wasm_call1(obj : Xany, name : String, a1 : Xany) -> Xany = "xany" "call1"

///|
extern "wasm" fn wasm_call2(
  obj : Xany,
  name : String,
  a1 : Xany,
  a2 : Xany,
) -> Xany = "xany" "call2"

///|
extern "wasm" fn wasm_call3(
  obj : Xany,
  name : String,
  a1 : Xany,
  a2 : Xany,
  a3 : Xany,
) -> Xany = "xany" "call3"

///|
extern "wasm" fn wasm_call4(
  obj : Xany,
  name : String,
  a1 : Xany,
  a2 : Xany,
  a3 : Xany,
  a4 : Xany,
) -> Xany = "xany" "call4"

// Fixed-arity invoke functions

///|
extern "wasm" fn wasm_invoke0(fn_ : Xany) -> Xany = "xany" "invoke0"

///|
extern "wasm" fn wasm_invoke1(fn_ : Xany, a1 : Xany) -> Xany = "xany" "invoke1"

///|
extern "wasm" fn wasm_invoke2(fn_ : Xany, a1 : Xany, a2 : Xany) -> Xany = "xany" "invoke2"

///|
extern "wasm" fn wasm_invoke3(
  fn_ : Xany,
  a1 : Xany,
  a2 : Xany,
  a3 : Xany,
) -> Xany = "xany" "invoke3"

///|
extern "wasm" fn wasm_invoke4(
  fn_ : Xany,
  a1 : Xany,
  a2 : Xany,
  a3 : Xany,
  a4 : Xany,
) -> Xany = "xany" "invoke4"

// Fixed-arity new functions

///|
extern "wasm" fn wasm_new0(cls : Xany) -> Xany = "xany" "new0"

///|
extern "wasm" fn wasm_new1(cls : Xany, a1 : Xany) -> Xany = "xany" "new1"

///|
extern "wasm" fn wasm_new2(cls : Xany, a1 : Xany, a2 : Xany) -> Xany = "xany" "new2"

///|
extern "wasm" fn wasm_new3(cls : Xany, a1 : Xany, a2 : Xany, a3 : Xany) -> Xany = "xany" "new3"

///|
extern "wasm" fn wasm_new4(
  cls : Xany,
  a1 : Xany,
  a2 : Xany,
  a3 : Xany,
  a4 : Xany,
) -> Xany = "xany" "new4"

///|
extern "wasm" fn wasm_typeof(v : Xany) -> String = "xany" "typeof"

///|
extern "wasm" fn wasm_is_nullish(v : Xany) -> Bool = "xany" "is_nullish"

///|
extern "wasm" fn wasm_instanceof(v : Xany, cls : Xany) -> Bool = "xany" "instanceof"

///|
extern "wasm" fn wasm_equal(a : Xany, b : Xany) -> Bool = "xany" "equal"

///|
extern "wasm" fn wasm_to_string(v : Xany) -> String = "xany" "to_string"

///|
extern "wasm" fn wasm_global_this() -> Xany = "xany" "global_this"

///|
extern "wasm" fn wasm_undefined() -> Xany = "xany" "undefined"

///|
extern "wasm" fn wasm_null() -> Xany = "xany" "null"

///|
extern "wasm" fn wasm_from(v : Xany) -> Xany = "xany" "from"

// ============================================
// Core operations (public API - same as JS)
// ============================================

///|
/// Get property: obj[key]
#alias("_[_]")
pub fn Xany::_get(self : Xany, key : String) -> Xany {
  wasm_get(self, key)
}

///|
/// Get by index: obj[index]
pub fn Xany::_get_by_index(self : Xany, index : Int) -> Xany {
  wasm_get_by_index(self, index)
}

///|
/// Set property: obj[key] = value
#alias("_[_]=_")
pub fn Xany::_set(self : Xany, key : String, value : Xany) -> Unit {
  wasm_set(self, key, value)
}

///|
/// Call method: obj.method_name(...args)
/// Dispatches to fixed-arity wasm_callN based on array length
pub fn Xany::_call(
  self : Xany,
  method_name : String,
  args : Array[Xany],
) -> Xany {
  match args.length() {
    0 => wasm_call0(self, method_name)
    1 => wasm_call1(self, method_name, args[0])
    2 => wasm_call2(self, method_name, args[0], args[1])
    3 => wasm_call3(self, method_name, args[0], args[1], args[2])
    4 => wasm_call4(self, method_name, args[0], args[1], args[2], args[3])
    _ => abort("_call: too many arguments (max 4)")
  }
}

///|
/// Invoke function: fn(...args)
pub fn Xany::_invoke(self : Xany, args : Array[Xany]) -> Xany {
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
/// Constructor call: new cls(...args)
pub fn new(cls : Xany, args : Array[Xany]) -> Xany {
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
// Type conversions
// ============================================

///|
/// Wrap a value of type T in an Xany container.
/// In WASM, this goes through FFI; in JS it's zero-cost %identity.
/// API compatible with tonyfettes/any::Any::of
#as_free_fn
pub fn[T] Xany::of(value : T) -> Xany {
  wasm_from(Xany::cast_internal(value))
}

///|
fn[T] Xany::cast_internal(value : T) -> Xany = "%identity"

// ============================================
// Global values
// ============================================

///|
pub fn global_this() -> Xany {
  wasm_global_this()
}

///|
pub fn undefined() -> Xany {
  wasm_undefined()
}

///|
pub fn null() -> Xany {
  wasm_null()
}

// ============================================
// Utility
// ============================================

///|
pub fn typeof_(v : Xany) -> String {
  wasm_typeof(v)
}

///|
pub fn is_nullish(v : Xany) -> Bool {
  wasm_is_nullish(v)
}

///|
pub fn Xany::to_string(self : Xany) -> String {
  wasm_to_string(self)
}

///|
pub fn instanceof_(v : Xany, cls : Xany) -> Bool {
  wasm_instanceof(v, cls)
}

///|
pub fn equal(a : Xany, b : Xany) -> Bool {
  wasm_equal(a, b)
}

// ============================================
// Tests (run via _test with deno)
// ============================================
// WASM-GC tests require host runtime, see _test/run.ts
