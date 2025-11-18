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
  unsafe_cast(ffi_new_weakmap())
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::delete(self : WeakMap[K, V], key : K) -> Bool {
  self.invoke("delete", [key]) |> unsafe_cast
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::get(self : WeakMap[K, V], key : K) -> V? {
  let result = self.invoke("get", [key])
  if is_undefined(result) {
    None
  } else {
    Some(unsafe_cast(result))
  }
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::has(self : WeakMap[K, V], key : K) -> Bool {
  self.invoke("has", [key]) |> unsafe_cast
}

///|
pub fn[K : JsImpl, V : JsImpl] WeakMap::set(
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
pub impl[T] JsImpl for WeakSet[T]

///|
extern "js" fn ffi_new_weakset() -> Js =
  #| () => new WeakSet()

///|
pub fn[T: JsImpl] WeakSet::new() -> WeakSet[T] {
  unsafe_cast(ffi_new_weakset())
}

///|
pub fn[T: JsImpl] WeakSet::add(self : Self[T], value : T) -> WeakSet[T] {
  self.invoke("add", [value]) |> unsafe_cast
}

///|
pub fn[T: JsImpl] WeakSet::delete(self : Self[T], value : T) -> Bool {
  self.invoke("delete", [value]) |> unsafe_cast
}

///|
pub fn[T: JsImpl] WeakSet::has(self : Self[T], value : T) -> Bool {
  self.invoke("has", [value]) |> unsafe_cast
}

///|
#external
pub type WeakRef[T]

///|
pub impl[T] JsImpl for WeakRef[T]

///|
extern "js" fn ffi_new_weakref(target : Js) -> Js =
  #| (target) => new WeakRef(target)

///|
pub fn[T: JsImpl] WeakRef::new(target : T) -> WeakRef[T] {
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
pub impl[T] JsImpl for FinalizationRegistry[T]

///|
extern "js" fn ffi_new_finalization_registry(
  cleanup_callback : (Js) -> Unit,
) -> Js =
  #| (callback) => new FinalizationRegistry(callback)

///|
pub fn[T: JsImpl] FinalizationRegistry::new(
  cleanup_callback : (T) -> Unit,
) -> FinalizationRegistry[T] {
  unsafe_cast(
    ffi_new_finalization_registry(fn(val) { cleanup_callback(unsafe_cast(val)) }),
  )
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
      self.invoke("register", [target, held_value, token]) |> ignore
    None => self.invoke("register", [target, held_value]) |> ignore
  }
}

///|
pub fn[T] FinalizationRegistry::unregister(
  self : FinalizationRegistry[T],
  unregister_token : Js,
) -> Bool {
  self.invoke("unregister", [unregister_token]) |> unsafe_cast
}
