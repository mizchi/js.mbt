///|

///|
#external
pub type WeakMap[K, V]

///|
extern "js" fn ffi_new_weakmap() -> @core.Any =
  #| () => new WeakMap()

///|
pub fn[K, V] WeakMap::new() -> WeakMap[K, V] {
  ffi_new_weakmap().cast()
}

///|
pub fn[K, V] WeakMap::delete(self : WeakMap[K, V], key : K) -> Bool {
  @core.any(self)._call("delete", [@core.any(key)]).cast()
}

///|
pub fn[K, V] WeakMap::get(self : WeakMap[K, V], key : K) -> V? {
  let result = @core.any(self)._call("get", [@core.any(key)])
  if @core.is_undefined(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
pub fn[K, V] WeakMap::has(self : WeakMap[K, V], key : K) -> Bool {
  @core.any(self)._call("has", [@core.any(key)]).cast()
}

///|
pub fn[K, V] WeakMap::set(
  self : WeakMap[K, V],
  key : K,
  value : V,
) -> WeakMap[K, V] {
  @core.any(self)._call("set", [@core.any(key), @core.any(value)]).cast()
}

///|
#external
pub type WeakSet[T]

///|
extern "js" fn ffi_new_weakset() -> @core.Any =
  #| () => new WeakSet()

///|
pub fn[T] WeakSet::new() -> WeakSet[T] {
  ffi_new_weakset().cast()
}

///|
pub fn[T] WeakSet::add(self : WeakSet[T], value : T) -> WeakSet[T] {
  @core.any(self)._call("add", [@core.any(value)]).cast()
}

///|
pub fn[T] WeakSet::delete(self : WeakSet[T], value : T) -> Bool {
  @core.any(self)._call("delete", [@core.any(value)]).cast()
}

///|
pub fn[T] WeakSet::has(self : WeakSet[T], value : T) -> Bool {
  @core.any(self)._call("has", [@core.any(value)]).cast()
}

///|
/// JavaScript WeakRef
#external
pub type WeakRef[T]

///|
extern "js" fn ffi_new_weakref(target : @core.Any) -> @core.Any =
  #| (target) => new WeakRef(target)

///|
pub fn[T] WeakRef::new(target : T) -> WeakRef[T] {
  ffi_new_weakref(@core.any(target)).cast()
}

///|
pub fn[T] WeakRef::deref(self : WeakRef[T]) -> T? {
  let result = @core.any(self)._call("deref", [])
  if @core.is_undefined(result) {
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
  cleanup_callback : (@core.Any) -> Unit,
) -> @core.Any =
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
  unregister_token? : @core.Any,
) -> Unit {
  match unregister_token {
    Some(token) =>
      @core.any(self)._call("register", [
        @core.any(target),
        @core.any(held_value),
        token,
      ])
      |> ignore
    None =>
      @core.any(self)._call("register", [
        @core.any(target),
        @core.any(held_value),
      ])
      |> ignore
  }
}

///|
pub fn[T] FinalizationRegistry::unregister(
  self : FinalizationRegistry[T],
  unregister_token : @core.Any,
) -> Bool {
  @core.any(self)._call("unregister", [unregister_token]).cast()
}
