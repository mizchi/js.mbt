///|
pub fn new_empty_object() -> Val {
  ffi_new_object()
}

///|
pub fn from_builtin_map(map : @builtin.Map[String, Val]) -> Val {
  let obj = new_empty_object()
  for k, v in map {
    let v : Val = Js::to_js(v)
    obj.set(k, v)
  }
  obj
}

///|
pub fn[T] from_builtin_array(arr : @builtin.Array[T]) -> Val {
  arr |> unsafe_cast
}

///|
pub fn new_empty_array() -> Val {
  ffi_new_empty_array()
}

///|
pub fn global_this() -> Val {
  ffi_global_this()
}

///|
pub fn undefined() -> Val {
  ffi_undefined()
}

///|
pub fn null_() -> Val {
  ffi_null()
}

///|
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
pub fn symbol_iterator() -> Symbol {
  ffi_symbol_iterator()
}

///|
pub fn symbol_dispose() -> Symbol {
  ffi_symbol_dispose()
}

///|
pub fn symbol_async_dispose() -> Symbol {
  ffi_symbol_async_dispose()
}

///|
pub fn new_map() -> Val {
  ffi_new_map()
}

///|
pub fn new_weak_map() -> Val {
  ffi_new_weak_map()
}

///|
pub fn new_set() -> Val {
  ffi_new_set()
}

///|
pub fn new_weak_set() -> Val {
  ffi_new_weak_set()
}

///|
pub fn new_error(message : String, cause? : ErrorObject) -> ErrorObject {
  let args : Array[Val] = if cause is Some(cause) {
    [js(message), from_builtin_map({ "cause": cause |> unsafe_cast() })]
  } else {
    [js(message)]
  }
  ffi_new_error(args)
}

///|
pub fn object_create() -> Val {
  ffi_object_create()
}

///|
fn[T] is_builtin_map(v : T) -> Bool {
  let v : Val = v |> unsafe_cast
  v.has_own_property("entries") && v.has_own_property("capacity")
}

///|
fn[T] is_builtin_trait(v : T) -> Bool {
  let v : Val = v |> unsafe_cast
  v.has_own_property("self") && v.has_own_property("method_0")
}

///|
/// Check whether the value is a built-in struct like Result, Tuple, Enum, or user-defined struct.
fn[T] is_builtin_struct(v : T) -> Bool {
  let v : Val = v |> unsafe_cast
  v.has_own_property("_0")
}

///|
pub fn[T] is_builtin(v : T) -> Bool {
  is_builtin_map(v) || is_builtin_struct(v) || is_builtin_trait(v)
}

///|
test "is_builtin_trait" {
  let js : Val = js({ "a": 1 }) |> unsafe_cast()
  assert_true(is_builtin_map(js))
  let show : &Show = "hello"
  assert_true(is_builtin_trait(show))
}

///|
test "is_builtin_struct" {
  enum E {
    A(Int)
  }
  let r1 : Result[Int, String] = Ok(10)
  assert_true(is_builtin_struct(r1))
  let t = (10, "hello")
  assert_true(is_builtin_struct(t))
  let e = E::A(10)
  assert_true(is_builtin_struct(e))
}
