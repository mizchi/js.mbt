///|

///|
#external
pub type WeakMap[K, V]

///|
pub impl[K, V] @js.JsImpl for WeakMap[K, V]

///|
extern "js" fn ffi_new_weakmap() -> @js.Js =
  #| () => new WeakMap()

///|
pub fn[K : @js.JsImpl, V : @js.JsImpl] WeakMap::new() -> WeakMap[K, V] {
  ffi_new_weakmap().cast()
}

///|
pub fn[K : @js.JsImpl, V : @js.JsImpl] WeakMap::delete(
  self : WeakMap[K, V],
  key : K,
) -> Bool {
  self.call1("delete", key).cast()
}

///|
pub fn[K : @js.JsImpl, V : @js.JsImpl] WeakMap::get(
  self : WeakMap[K, V],
  key : K,
) -> V? {
  let result = self.call1("get", key)
  if @js.is_undefined(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
pub fn[K : @js.JsImpl, V : @js.JsImpl] WeakMap::has(
  self : WeakMap[K, V],
  key : K,
) -> Bool {
  self.call1("has", key).cast()
}

///|
pub fn[K : @js.JsImpl, V : @js.JsImpl] WeakMap::set(
  self : WeakMap[K, V],
  key : K,
  value : V,
) -> WeakMap[K, V] {
  self.call2("set", key, value).cast()
}

///|
#external
pub type WeakSet[T]

///|
pub impl[T] @js.JsImpl for WeakSet[T]

///|
extern "js" fn ffi_new_weakset() -> @js.Js =
  #| () => new WeakSet()

///|
pub fn[T : @js.JsImpl] WeakSet::new() -> WeakSet[T] {
  ffi_new_weakset().cast()
}

///|
pub fn[T : @js.JsImpl] WeakSet::add(self : Self[T], value : T) -> WeakSet[T] {
  self.call1("add", value).cast()
}

///|
pub fn[T : @js.JsImpl] WeakSet::delete(self : Self[T], value : T) -> Bool {
  self.call1("delete", value).cast()
}

///|
pub fn[T : @js.JsImpl] WeakSet::has(self : Self[T], value : T) -> Bool {
  self.call1("has", value).cast()
}

///|
/// JavaScript WeakRef
#external
pub type WeakRef[T]

///|
pub impl[T] @js.JsImpl for WeakRef[T]

///|
extern "js" fn ffi_new_weakref(target : @js.Js) -> @js.Js =
  #| (target) => new WeakRef(target)

///|
pub fn[T : @js.JsImpl] WeakRef::new(target : T) -> WeakRef[T] {
  ffi_new_weakref(target.to_js()).cast()
}

///|
pub fn[T] WeakRef::deref(self : WeakRef[T]) -> T? {
  let result = self.call0("deref")
  if @js.is_undefined(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
#external
pub type FinalizationRegistry[T]

///|
pub impl[T] @js.JsImpl for FinalizationRegistry[T]

///|
extern "js" fn ffi_new_finalization_registry(
  cleanup_callback : (@js.Js) -> Unit,
) -> @js.Js =
  #| (callback) => new FinalizationRegistry(callback)

///|
pub fn[T : @js.JsImpl] FinalizationRegistry::new(
  cleanup_callback : (T) -> Unit,
) -> FinalizationRegistry[T] {
  ffi_new_finalization_registry(fn(val) { cleanup_callback(val.cast()) }).cast()
}

///|
pub fn[T : @js.JsImpl, U : @js.JsImpl] FinalizationRegistry::register(
  self : FinalizationRegistry[T],
  target : U,
  held_value : T,
  unregister_token? : @js.Js,
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
  unregister_token : @js.Js,
) -> Bool {
  self.to_js().call("unregister", [unregister_token]).cast()
}
