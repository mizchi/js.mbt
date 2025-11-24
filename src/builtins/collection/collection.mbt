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
pub impl[K, V] @js.JsImpl for JsMap[K, V]

///|
/// JS: new Map()
pub fn[K, V] JsMap::new() -> JsMap[K, V] {
  ffi_new_map() |> @js.identity
}

///|
extern "js" fn ffi_new_map() -> @js.Js =
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
  self
  |> @js.identity
  |> @js.Js::call("set", [@js.unsafe_js(key), @js.unsafe_js(value)])
  |> @js.identity
}

///|
/// JS: map.get(key)
pub fn[K, V] JsMap::get(self : JsMap[K, V], key : K) -> V? {
  let result : @js.Js = self
    |> @js.identity
    |> @js.Js::call("get", [@js.unsafe_js(key)])
    |> @js.identity
  if @js.is_undefined(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// JS: map.has(key)
pub fn[K, V] JsMap::has(self : JsMap[K, V], key : K) -> Bool {
  self
  |> @js.identity
  |> @js.Js::call("has", [@js.unsafe_js(key)])
  |> @js.identity
}

///|
/// JS: map.delete(key)
pub fn[K, V] JsMap::delete(self : JsMap[K, V], key : K) -> Bool {
  self
  |> @js.identity
  |> @js.Js::call("delete", [@js.unsafe_js(key)])
  |> @js.identity
}

///|
/// JS: map.clear()
pub fn[K, V] JsMap::clear(self : JsMap[K, V]) -> Unit {
  self |> @js.identity |> @js.Js::call0("clear") |> ignore
}

///|
/// JS: map.size
pub fn[K, V] JsMap::size(self : JsMap[K, V]) -> Int {
  self |> @js.identity |> @js.Js::get("size") |> @js.identity
}

///|
/// JS: map.keys()
pub fn[K, V] JsMap::keys(self : JsMap[K, V]) -> @js.JsIterator[K] {
  self |> @js.identity |> @js.Js::call0("keys") |> @js.identity
}

///|
/// JS: map.values()
pub fn[K, V] JsMap::values(self : JsMap[K, V]) -> @js.JsIterator[V] {
  self |> @js.identity |> @js.Js::call0("values") |> @js.identity
}

///|
/// JS: map.entries()
pub fn[K, V] JsMap::entries(self : JsMap[K, V]) -> @js.JsIterator[(K, V)] {
  self |> @js.identity |> @js.Js::call0("entries") |> @js.identity
}

///|
/// JS: map.forEach(callback)
pub fn[K, V] JsMap::forEach(
  self : JsMap[K, V],
  callback : (V, K) -> Unit,
) -> Unit {
  self
  |> @js.identity
  |> @js.Js::call("forEach", [@js.unsafe_js(callback)])
  |> ignore
}

///| JsSet

///|
/// JavaScript Set
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set
#external
pub type JsSet[T]

///|
pub impl[T] @js.JsImpl for JsSet[T]

///|
/// JS: new Set()
pub fn[T] JsSet::new() -> JsSet[T] {
  ffi_new_set() |> @js.identity
}

///|
extern "js" fn ffi_new_set() -> @js.Js =
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
  self
  |> @js.identity
  |> @js.Js::call("add", [@js.unsafe_js(value)])
  |> @js.identity
}

///|
/// JS: set.has(value)
pub fn[T] JsSet::has(self : JsSet[T], value : T) -> Bool {
  self
  |> @js.identity
  |> @js.Js::call("has", [@js.unsafe_js(value)])
  |> @js.identity
}

///|
/// JS: set.delete(value)
pub fn[T] JsSet::delete(self : JsSet[T], value : T) -> Bool {
  self
  |> @js.identity
  |> @js.Js::call("delete", [@js.unsafe_js(value)])
  |> @js.identity
}

///|
/// JS: set.clear()
pub fn[T] JsSet::clear(self : JsSet[T]) -> Unit {
  self |> @js.identity |> @js.Js::call0("clear") |> ignore
}

///|
/// JS: set.size
pub fn[T] JsSet::size(self : JsSet[T]) -> Int {
  self |> @js.identity |> @js.Js::get("size") |> @js.identity
}

///|
/// JS: set.values()
pub fn[T] JsSet::values(self : JsSet[T]) -> @js.JsIterator[T] {
  self |> @js.identity |> @js.Js::call0("values") |> @js.identity
}

///|
/// JS: set.keys() - Same as values() for Set
pub fn[T] JsSet::keys(self : JsSet[T]) -> @js.JsIterator[T] {
  self |> @js.identity |> @js.Js::call0("keys") |> @js.identity
}

///|
/// JS: set.entries() - Returns [value, value] pairs for compatibility
pub fn[T] JsSet::entries(self : JsSet[T]) -> @js.JsIterator[(T, T)] {
  self |> @js.identity |> @js.Js::call0("entries") |> @js.identity
}

///|
/// JS: set.forEach(callback)
pub fn[T] JsSet::forEach(self : JsSet[T], callback : (T) -> Unit) -> Unit {
  self
  |> @js.identity
  |> @js.Js::call("forEach", [@js.unsafe_js(callback)])
  |> ignore
}
