///|
using @js {type Js, trait JsImpl, unsafe_cast, is_undefined}

///|
#external
pub type WeakMap[K, V]

///|
pub impl[K, V] JsImpl for WeakMap[K, V]

///|
extern "js" fn ffi_new_weakmap() -> Js =
  #| () => new WeakMap()

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::new() -> WeakMap[K, V] {
  ffi_new_weakmap() |> unsafe_cast
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::delete(
  self : WeakMap[K, V],
  key : K,
) -> Bool {
  self.call1("delete", key) |> unsafe_cast
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::get(
  self : WeakMap[K, V],
  key : K,
) -> V? {
  let result = self.call1("get", key)
  if is_undefined(result) {
    None
  } else {
    Some(result |> unsafe_cast)
  }
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::has(
  self : WeakMap[K, V],
  key : K,
) -> Bool {
  self.call1("has", key) |> unsafe_cast
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::set(
  self : WeakMap[K, V],
  key : K,
  value : V,
) -> WeakMap[K, V] {
  self.call2("set", key, value) |> unsafe_cast
}

///|
#external
pub type WeakSet[T]

///|
pub impl[T] JsImpl for WeakSet[T]

///|
extern "js" fn ffi_new_weakset() -> Js =
  #| () => new WeakSet()

///|
pub fn[T : JsImpl] WeakSet::new() -> WeakSet[T] {
  ffi_new_weakset() |> unsafe_cast
}

///|
pub fn[T : JsImpl] WeakSet::add(self : Self[T], value : T) -> WeakSet[T] {
  self.call1("add", value) |> unsafe_cast
}

///|
pub fn[T : JsImpl] WeakSet::delete(self : Self[T], value : T) -> Bool {
  self.call1("delete", value) |> unsafe_cast
}

///|
pub fn[T : JsImpl] WeakSet::has(self : Self[T], value : T) -> Bool {
  self.call1("has", value) |> unsafe_cast
}

///|
/// JavaScript WeakRef
#external
pub type WeakRef[T]

///|
pub impl[T] JsImpl for WeakRef[T]

///|
extern "js" fn ffi_new_weakref(target : Js) -> Js =
  #| (target) => new WeakRef(target)

///|
pub fn[T : JsImpl] WeakRef::new(target : T) -> WeakRef[T] {
  ffi_new_weakref(target.to_js()) |> unsafe_cast
}

///|
pub fn[T] WeakRef::deref(self : WeakRef[T]) -> T? {
  let result = self.call0("deref")
  if is_undefined(result) {
    None
  } else {
    Some(result |> unsafe_cast)
  }
}

///|
#external
pub type FinalizationRegistry[T]

///|
pub impl[T] JsImpl for FinalizationRegistry[T]

///|
extern "js" fn ffi_new_finalization_registry(
  cleanup_callback : (Js) -> Unit,
) -> Js =
  #| (callback) => new FinalizationRegistry(callback)

///|
pub fn[T : JsImpl] FinalizationRegistry::new(
  cleanup_callback : (T) -> Unit,
) -> FinalizationRegistry[T] {
  ffi_new_finalization_registry(fn(val) { cleanup_callback(val |> unsafe_cast) })
  |> unsafe_cast
}

///|
pub fn[T : JsImpl, U : JsImpl] FinalizationRegistry::register(
  self : FinalizationRegistry[T],
  target : U,
  held_value : T,
  unregister_token? : Js,
) -> Unit {
  match unregister_token {
    Some(token) =>
      self.to_js().call("register", [target, held_value, token]) |> ignore
    None => self.to_js().call2("register", target, held_value) |> ignore
  }
}

///|
pub fn[T] FinalizationRegistry::unregister(
  self : FinalizationRegistry[T],
  unregister_token : Js,
) -> Bool {
  self.to_js().call("unregister", [unregister_token]) |> unsafe_cast
}
