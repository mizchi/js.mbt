///|
using @js {trait Js, type Val, js}

///|
#external
pub type WeakMap[K, V]

///|
pub impl[K, V] Js for WeakMap[K, V]

///|
extern "js" fn ffi_new_weakmap() -> Val =
  #| () => new WeakMap()

///|
pub fn[K : Js, V : Js] WeakMap::new() -> WeakMap[K, V] {
  ffi_new_weakmap().cast()
}

///|
pub fn[K : Js, V : Js] WeakMap::delete(self : WeakMap[K, V], key : K) -> Bool {
  self.to_js().invoke("delete", [key]).cast()
}

///|
pub fn[K : Js, V : Js] WeakMap::get(self : WeakMap[K, V], key : K) -> V? {
  let result = self.to_js().invoke("get", [key])
  if result.is_undefined() {
    None
  } else {
    Some(result.cast())
  }
}

///|
pub fn[K : Js, V : Js] WeakMap::has(self : WeakMap[K, V], key : K) -> Bool {
  self.to_js().invoke("has", [key]).cast()
}

///|
pub fn[K : Js, V : Js] WeakMap::set(
  self : WeakMap[K, V],
  key : K,
  value : V,
) -> WeakMap[K, V] {
  self.to_js().invoke("set", [key, value]).cast()
}

///|
#external
pub type WeakSet[T]

///|
pub impl[T] Js for WeakSet[T]

///|
extern "js" fn ffi_new_weakset() -> Val =
  #| () => new WeakSet()

///|
pub fn[T : Js] WeakSet::new() -> WeakSet[T] {
  ffi_new_weakset().cast()
}

///|
pub fn[T : Js] WeakSet::add(self : WeakSet[T], value : T) -> WeakSet[T] {
  self.to_js().invoke("add", [value]).cast()
}

///|
pub fn[T : Js] WeakSet::delete(self : WeakSet[T], value : T) -> Bool {
  self.to_js().invoke("delete", [value]).cast()
}

///|
pub fn[T : Js] WeakSet::has(self : WeakSet[T], value : T) -> Bool {
  self.to_js().invoke("has", [value]).cast()
}

///|
#external
pub type WeakRef[T]

///|
pub impl[T] Js for WeakRef[T]

///|
extern "js" fn ffi_new_weakref(target : Val) -> Val =
  #| (target) => new WeakRef(target)

///|
pub fn[T : Js] WeakRef::new(target : T) -> WeakRef[T] {
  ffi_new_weakref(target.to_js()).cast()
}

///|
pub fn[T] WeakRef::deref(self : WeakRef[T]) -> T? {
  let result = self.to_js().invoke("deref", [])
  if result.is_undefined() {
    None
  } else {
    Some(result.cast())
  }
}

///|
#external
pub type FinalizationRegistry[T]

///|
pub impl[T] Js for FinalizationRegistry[T]

///|
extern "js" fn ffi_new_finalization_registry(
  cleanup_callback : (Val) -> Unit,
) -> Val =
  #| (callback) => new FinalizationRegistry(callback)

///|
pub fn[T : Js] FinalizationRegistry::new(
  cleanup_callback : (T) -> Unit,
) -> FinalizationRegistry[T] {
  ffi_new_finalization_registry(fn(val) { cleanup_callback(val.cast()) }).cast()
}

///|
pub fn[T : Js, U : Js] FinalizationRegistry::register(
  self : FinalizationRegistry[T],
  target : U,
  held_value : T,
  unregister_token? : Val,
) -> Unit {
  match unregister_token {
    Some(token) =>
      self.to_js().invoke("register", [target, held_value, token]) |> ignore
    None => self.to_js().invoke("register", [target, held_value]) |> ignore
  }
}

///|
pub fn[T] FinalizationRegistry::unregister(
  self : FinalizationRegistry[T],
  unregister_token : Val,
) -> Bool {
  self.to_js().invoke("unregister", [unregister_token]).cast()
}
