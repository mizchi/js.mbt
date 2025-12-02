// JavaScript Map and Set collections
//
// These types use "Js" prefix to avoid conflicts with MoonBit's builtin Map and Set types.

///| JsMap

///|
/// JavaScript Map
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map
#external
pub type JsMap[K, V]

///|
pub fn[K, V] JsMap::to_any(self : JsMap[K, V]) -> @nostd.Any = "%identity"

///|
/// JS: new Map()
pub fn[K, V] JsMap::new() -> JsMap[K, V] {
  ffi_new_map() |> @nostd.identity
}

///|
extern "js" fn ffi_new_map() -> @nostd.Any =
  #| () => new Map()

///|
/// JS: new Map(entries)
pub fn[K, V] JsMap::from_entries(entries : Array[(K, V)]) -> JsMap[K, V] {
  let map : JsMap[K, V] = JsMap::new()
  for entry in entries {
    let (k, v) = entry
    map.set(k, v) |> ignore
  }
  map
}

///|
/// JS: map.set(key, value)
pub fn[K, V] JsMap::set(self : JsMap[K, V], key : K, value : V) -> JsMap[K, V] {
  self.to_any()._call("set", [@nostd.any(key), @nostd.any(value)]).cast()
}

///|
/// JS: map._get(key)
pub fn[K, V] JsMap::get(self : JsMap[K, V], key : K) -> V? {
  let result = self.to_any()._call("get", [@nostd.any(key)])
  if @nostd.is_undefined(result.cast()) {
    None
  } else {
    Some(result.cast())
  }
}

///|
#alias("_[_]")
pub fn[K, V] JsMap::_get(self : JsMap[K, V], key : K) -> V? {
  self.get(key)
}

///|
/// JS: map.has(key)
pub fn[K, V] JsMap::has(self : JsMap[K, V], key : K) -> Bool {
  self.to_any()._call("has", [@nostd.any(key)]).cast()
}

///|
/// JS: map.delete(key)
pub fn[K, V] JsMap::delete(self : JsMap[K, V], key : K) -> Bool {
  self.to_any()._call("delete", [@nostd.any(key)]).cast()
}

///|
/// JS: map.clear()
pub fn[K, V] JsMap::clear(self : JsMap[K, V]) -> Unit {
  self.to_any()._call("clear", []) |> ignore
}

///|
/// JS: map.size
pub fn[K, V] JsMap::size(self : JsMap[K, V]) -> Int {
  self.to_any()["size"].cast()
}

///|
/// JS: map.keys()
pub fn[K, V] JsMap::keys(self : JsMap[K, V]) -> @js.JsIterator[K] {
  self.to_any()._call("keys", []).cast()
}

///|
/// JS: map.values()
pub fn[K, V] JsMap::values(self : JsMap[K, V]) -> @js.JsIterator[V] {
  self.to_any()._call("values", []).cast()
}

///|
/// JS: map.entries()
pub fn[K, V] JsMap::entries(self : JsMap[K, V]) -> @js.JsIterator[(K, V)] {
  self.to_any()._call("entries", []).cast()
}

///|
/// JS: map.forEach(callback)
pub fn[K, V] JsMap::forEach(
  self : JsMap[K, V],
  callback : (V, K) -> Unit,
) -> Unit {
  self.to_any()._call("forEach", [@nostd.any(callback)]) |> ignore
}

///| JsSet

///|
/// JavaScript Set
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set
#external
pub type JsSet[T]

///|
pub fn[T] JsSet::to_any(self : JsSet[T]) -> @nostd.Any = "%identity"

///|
/// JS: new Set()
pub fn[T] JsSet::new() -> JsSet[T] {
  ffi_new_set() |> @nostd.identity
}

///|
extern "js" fn ffi_new_set() -> @nostd.Any =
  #| () => new Set()

///|
/// JS: new Set(values)
pub fn[T] JsSet::from_array(values : Array[T]) -> JsSet[T] {
  let set : JsSet[T] = JsSet::new()
  for value in values {
    set.add(value) |> ignore
  }
  set
}

///|
/// JS: set.add(value)
pub fn[T] JsSet::add(self : JsSet[T], value : T) -> JsSet[T] {
  self.to_any()._call("add", [@nostd.any(value)]).cast()
}

///|
/// JS: set.has(value)
pub fn[T] JsSet::has(self : JsSet[T], value : T) -> Bool {
  self.to_any()._call("has", [@nostd.any(value)]).cast()
}

///|
/// JS: set.delete(value)
pub fn[T] JsSet::delete(self : JsSet[T], value : T) -> Bool {
  self.to_any()._call("delete", [@nostd.any(value)]).cast()
}

///|
/// JS: set.clear()
pub fn[T] JsSet::clear(self : JsSet[T]) -> Unit {
  self.to_any()._call("clear", []) |> ignore
}

///|
/// JS: set.size
pub fn[T] JsSet::size(self : JsSet[T]) -> Int {
  self.to_any()["size"].cast()
}

///|
/// JS: set.values()
pub fn[T] JsSet::values(self : JsSet[T]) -> @js.JsIterator[T] {
  self.to_any()._call("values", []).cast()
}

///|
/// JS: set.keys() - Same as values() for Set
pub fn[T] JsSet::keys(self : JsSet[T]) -> @js.JsIterator[T] {
  self.to_any()._call("keys", []).cast()
}

///|
/// JS: set.entries() - Returns [value, value] pairs for compatibility
pub fn[T] JsSet::entries(self : JsSet[T]) -> @js.JsIterator[(T, T)] {
  self.to_any()._call("entries", []).cast()
}

///|
/// JS: set.forEach(callback)
pub fn[T] JsSet::forEach(self : JsSet[T], callback : (T) -> Unit) -> Unit {
  self.to_any()._call("forEach", [@nostd.any(callback)]) |> ignore
}
