///|

///|
#external
pub type WeakMap[K, V]

///|
extern "js" fn ffi_new_weakmap() -> @nostd.Any =
  #| () => new WeakMap()

///|
pub fn[K, V] WeakMap::new() -> WeakMap[K, V] {
  ffi_new_weakmap().cast()
}

///|
pub fn[K, V] WeakMap::delete(self : WeakMap[K, V], key : K) -> Bool {
  @nostd.any(self)._call("delete", [@nostd.any(key)]).cast()
}

///|
pub fn[K, V] WeakMap::get(self : WeakMap[K, V], key : K) -> V? {
  let result = @nostd.any(self)._call("get", [@nostd.any(key)])
  if @nostd.is_undefined(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
pub fn[K, V] WeakMap::has(self : WeakMap[K, V], key : K) -> Bool {
  @nostd.any(self)._call("has", [@nostd.any(key)]).cast()
}

///|
pub fn[K, V] WeakMap::set(
  self : WeakMap[K, V],
  key : K,
  value : V,
) -> WeakMap[K, V] {
  @nostd.any(self)._call("set", [@nostd.any(key), @nostd.any(value)]).cast()
}

///|
#external
pub type WeakSet[T]

///|
extern "js" fn ffi_new_weakset() -> @nostd.Any =
  #| () => new WeakSet()

///|
pub fn[T] WeakSet::new() -> WeakSet[T] {
  ffi_new_weakset().cast()
}

///|
pub fn[T] WeakSet::add(self : WeakSet[T], value : T) -> WeakSet[T] {
  @nostd.any(self)._call("add", [@nostd.any(value)]).cast()
}

///|
pub fn[T] WeakSet::delete(self : WeakSet[T], value : T) -> Bool {
  @nostd.any(self)._call("delete", [@nostd.any(value)]).cast()
}

///|
pub fn[T] WeakSet::has(self : WeakSet[T], value : T) -> Bool {
  @nostd.any(self)._call("has", [@nostd.any(value)]).cast()
}

///|
/// JavaScript WeakRef
#external
pub type WeakRef[T]

///|
extern "js" fn ffi_new_weakref(target : @nostd.Any) -> @nostd.Any =
  #| (target) => new WeakRef(target)

///|
pub fn[T] WeakRef::new(target : T) -> WeakRef[T] {
  ffi_new_weakref(@nostd.any(target)).cast()
}

///|
pub fn[T] WeakRef::deref(self : WeakRef[T]) -> T? {
  let result = @nostd.any(self)._call("deref", [])
  if @nostd.is_undefined(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
#external
pub type FinalizationRegistry[T]

///|
extern "js" fn ffi_new_finalization_registry(
  cleanup_callback : (@nostd.Any) -> Unit,
) -> @nostd.Any =
  #| (callback) => new FinalizationRegistry(callback)

///|
pub fn[T] FinalizationRegistry::new(
  cleanup_callback : (T) -> Unit,
) -> FinalizationRegistry[T] {
  ffi_new_finalization_registry(fn(val) { cleanup_callback(val.cast()) }).cast()
}

///|
pub fn[T, U] FinalizationRegistry::register(
  self : FinalizationRegistry[T],
  target : U,
  held_value : T,
  unregister_token? : @nostd.Any,
) -> Unit {
  match unregister_token {
    Some(token) =>
      @nostd.any(self)._call("register", [
        @nostd.any(target),
        @nostd.any(held_value),
        token,
      ])
      |> ignore
    None =>
      @nostd.any(self)._call("register", [
        @nostd.any(target),
        @nostd.any(held_value),
      ])
      |> ignore
  }
}

///|
pub fn[T] FinalizationRegistry::unregister(
  self : FinalizationRegistry[T],
  unregister_token : @nostd.Any,
) -> Bool {
  @nostd.any(self)._call("unregister", [unregister_token]).cast()
}
