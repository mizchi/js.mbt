// xany_native.mbt - Native専用実装
// of/unsafe_coerce のみ実装、JS操作系は panic

// ============================================
// Core operations (panic - not supported on native)
// ============================================

///|
/// Get property: obj[key]
/// Not supported on native backend.
#alias("_[_]")
pub fn Xany::_get(self : Xany, _key : String) -> Xany {
  let _ = self
  abort("Xany::_get is not supported on native backend")
}

///|
/// Get by index: obj[index]
/// Not supported on native backend.
pub fn Xany::_get_by_index(self : Xany, _index : Int) -> Xany {
  let _ = self
  abort("Xany::_get_by_index is not supported on native backend")
}

///|
/// Set property: obj[key] = value
/// Not supported on native backend.
#alias("_[_]=_")
pub fn Xany::_set(self : Xany, _key : String, _value : Xany) -> Unit {
  let _ = self
  abort("Xany::_set is not supported on native backend")
}

///|
/// Call method: obj.method_name(...args)
/// Not supported on native backend.
pub fn Xany::_call(
  self : Xany,
  _method_name : String,
  _args : Array[Xany],
) -> Xany {
  let _ = self
  abort("Xany::_call is not supported on native backend")
}

///|
/// Invoke function: fn(...args)
/// Not supported on native backend.
pub fn Xany::_invoke(self : Xany, _args : Array[Xany]) -> Xany {
  let _ = self
  abort("Xany::_invoke is not supported on native backend")
}

///|
/// Constructor call: new cls(...args)
/// Not supported on native backend.
pub fn new(_cls : Xany, _args : Array[Xany]) -> Xany {
  abort("new is not supported on native backend")
}

// ============================================
// Type conversions (not supported on native)
// ============================================

///|
/// Wrap a value of type T in an Xany container.
/// Not supported on native backend - use JS or WASM-GC.
#as_free_fn
pub fn[T] Xany::of(_value : T) -> Xany {
  abort("Xany::of is not supported on native backend")
}

// ============================================
// Global values (panic - not supported on native)
// ============================================

///|
/// Not supported on native backend.
pub fn global_this() -> Xany {
  abort("global_this is not supported on native backend")
}

///|
/// Returns null pointer (same as null on native).
pub fn undefined() -> Xany {
  null()
}

///|
/// Returns null pointer (C NULL).
pub fn null() -> Xany {
  let zero : UInt64 = 0
  zero.unsafe_as_xany()
}

///|
fn UInt64::unsafe_as_xany(self : UInt64) -> Xany = "%identity"

// ============================================
// Utility (partial support)
// ============================================

///|
/// Not supported on native backend.
pub fn typeof_(_v : Xany) -> String {
  abort("typeof_ is not supported on native backend")
}

///|
/// Checks if value is null pointer.
pub fn is_nullish(v : Xany) -> Bool {
  let ptr : UInt64 = v.unsafe_coerce()
  ptr == 0
}

///|
/// Returns a string representation.
/// On native, uses Show trait if available.
pub fn Xany::to_string(self : Xany) -> String {
  let _ = self
  "<Xany:native>"
}

///|
/// Not supported on native backend.
pub fn instanceof_(_v : Xany, _cls : Xany) -> Bool {
  abort("instanceof_ is not supported on native backend")
}

///|
/// Compares two Xany values.
/// On native, uses pointer equality.
pub fn equal(a : Xany, b : Xany) -> Bool {
  // Use %identity to compare as raw values
  let a_ptr : UInt64 = a.unsafe_coerce()
  let b_ptr : UInt64 = b.unsafe_coerce()
  a_ptr == b_ptr
}

// ============================================
// Tests
// ============================================

///|
test "null returns null pointer" {
  let n = null()
  assert_true!(is_nullish(n))
}

///|
test "undefined returns null pointer" {
  let u = undefined()
  assert_true!(is_nullish(u))
}

///|
test "null and undefined are equal" {
  assert_true!(equal(null(), undefined()))
}
