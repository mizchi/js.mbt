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
  unsafe_cast(ffi_new_weakmap())
}

///|
pub fn[K : Js, V : Js] WeakMap::delete(self : WeakMap[K, V], key : K) -> Bool {
  self.invoke("delete", [key]) |> unsafe_cast
}

///|
pub fn[K : Js, V : Js] WeakMap::get(self : WeakMap[K, V], key : K) -> V? {
  let result = self.invoke("get", [key])
  if is_undefined(result) {
    None
  } else {
    Some(unsafe_cast(result))
  }
}

///|
pub fn[K : Js, V : Js] WeakMap::has(self : WeakMap[K, V], key : K) -> Bool {
  self.invoke("has", [key]) |> unsafe_cast
}

///|
pub fn[K : Js, V : Js] WeakMap::set(
  self : WeakMap[K, V],
  key : K,
  value : V,
) -> WeakMap[K, V] {
  self.invoke("set", [key, value]) |> unsafe_cast
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
  unsafe_cast(ffi_new_weakset())
}

///|
pub fn[T : Js] WeakSet::add(self : Self[T], value : T) -> WeakSet[T] {
  self.invoke("add", [value]) |> unsafe_cast
}

///|
pub fn[T : Js] WeakSet::delete(self : Self[T], value : T) -> Bool {
  self.invoke("delete", [value]) |> unsafe_cast
}

///|
pub fn[T : Js] WeakSet::has(self : Self[T], value : T) -> Bool {
  self.invoke("has", [value]) |> unsafe_cast
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
  unsafe_cast(ffi_new_weakref(target.to_js()))
}

///|
pub fn[T] WeakRef::deref(self : WeakRef[T]) -> T? {
  let result = self.invoke("deref", [])
  if is_undefined(result) {
    None
  } else {
    Some(unsafe_cast(result))
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
  unsafe_cast(
    ffi_new_finalization_registry(fn(val) { cleanup_callback(unsafe_cast(val)) }),
  )
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
      self.invoke("register", [target, held_value, token]) |> ignore
    None => self.invoke("register", [target, held_value]) |> ignore
  }
}

///|
pub fn[T] FinalizationRegistry::unregister(
  self : FinalizationRegistry[T],
  unregister_token : Val,
) -> Bool {
  self.invoke("unregister", [unregister_token]) |> unsafe_cast
}
