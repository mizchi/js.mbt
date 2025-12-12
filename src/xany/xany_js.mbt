// xany_js.mbt - JS専用実装

// ============================================
// Core operations
// ============================================

///|
/// Get property: obj[key]
#alias("_[_]")
pub extern "js" fn Xany::_get(self : Xany, key : String) -> Xany =
  #| (obj, key) => obj[key]

///|
/// Get by index: obj[index]
pub extern "js" fn Xany::_get_by_index(self : Xany, index : Int) -> Xany =
  #| (obj, index) => obj[index]

///|
/// Set property: obj[key] = value
#alias("_[_]=_")
pub extern "js" fn Xany::_set(self : Xany, key : String, value : Xany) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
/// Call method: obj.method_name(...args)
pub extern "js" fn Xany::_call(
  self : Xany,
  method_name : String,
  args : Array[Xany],
) -> Xany =
  #| (obj, method_name, args) => obj[method_name](...args)

///|
/// Invoke function: fn(...args)
pub extern "js" fn Xany::_invoke(self : Xany, args : Array[Xany]) -> Xany =
  #| (fn, args) => fn(...args)

///|
/// Constructor call: new cls(...args)
pub extern "js" fn new(cls : Xany, args : Array[Xany]) -> Xany =
  #| (cls, args) => new cls(...args)

// ============================================
// Type conversions (zero-cost %identity)
// ============================================

///|
/// Wrap a value of type T in an Xany container.
/// This is zero-cost in JS backend (%identity).
/// API compatible with tonyfettes/any::Any::of
#as_free_fn
pub fn[T] Xany::of(value : T) -> Xany = "%identity"

// ============================================
// Global values
// ============================================

///|
pub extern "js" fn global_this() -> Xany =
  #| () => globalThis

///|
pub extern "js" fn undefined() -> Xany =
  #| () => undefined

///|
pub extern "js" fn null() -> Xany =
  #| () => null

// ============================================
// Utility
// ============================================

///|
pub extern "js" fn typeof_(v : Xany) -> String =
  #| (v) => typeof v

///|
pub extern "js" fn is_nullish(v : Xany) -> Bool =
  #| (v) => v == null

///|
pub extern "js" fn Xany::to_string(self : Xany) -> String =
  #| (self) => self == null ? String(self) : self.toString()

///|
pub extern "js" fn instanceof_(v : Xany, cls : Xany) -> Bool =
  #| (v, cls) => v instanceof cls

///|
pub extern "js" fn equal(a : Xany, b : Xany) -> Bool =
  #| (a, b) => a === b

// ============================================
// Tests
// ============================================

///|
test "Xany::of and unsafe_coerce" {
  let x = Xany::of(42)
  let v : Int = x.unsafe_coerce()
  assert_eq!(v, 42)
}

///|
test "null and undefined" {
  assert_true!(is_nullish(null()))
  assert_true!(is_nullish(undefined()))
}

///|
test "global_this exists" {
  let g = global_this()
  assert_false!(is_nullish(g))
}

///|
test "_get property" {
  let g = global_this()
  let math = g["Math"]
  assert_false!(is_nullish(math))
}
