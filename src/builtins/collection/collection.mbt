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
pub fn JsMap::new[K, V]() -> JsMap[K, V] {
  ffi_new_map() |> @js.unsafe_cast
}

///|
extern "js" fn ffi_new_map() -> @js.Js =
  #| () => new Map()

///|
/// JS: new Map(entries)
pub fn JsMap::from_entries[K, V](entries : Array[(K, V)]) -> JsMap[K, V] {
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
  (self |> @js.unsafe_cast |> @js.Js::call("set", [@js.unsafe_js(key), @js.unsafe_js(value)])) |> @js.unsafe_cast
}

///|
/// JS: map.get(key)
pub fn[K, V] JsMap::get(self : JsMap[K, V], key : K) -> V? {
  let result : @js.Js = (self |> @js.unsafe_cast |> @js.Js::call("get", [@js.unsafe_js(key)])) |> @js.unsafe_cast
  if @js.is_undefined(result) {
    None
  } else {
    Some(@js.unsafe_cast(result))
  }
}

///|
/// JS: map.has(key)
pub fn[K, V] JsMap::has(self : JsMap[K, V], key : K) -> Bool {
  (self |> @js.unsafe_cast |> @js.Js::call("has", [@js.unsafe_js(key)])) |> @js.unsafe_cast
}

///|
/// JS: map.delete(key)
pub fn[K, V] JsMap::delete(self : JsMap[K, V], key : K) -> Bool {
  (self |> @js.unsafe_cast |> @js.Js::call("delete", [@js.unsafe_js(key)])) |> @js.unsafe_cast
}

///|
/// JS: map.clear()
pub fn[K, V] JsMap::clear(self : JsMap[K, V]) -> Unit {
  (self |> @js.unsafe_cast |> @js.Js::call0("clear")) |> ignore
}

///|
/// JS: map.size
pub fn[K, V] JsMap::size(self : JsMap[K, V]) -> Int {
  (self |> @js.unsafe_cast |> @js.Js::get("size")) |> @js.unsafe_cast
}

///|
/// JS: map.keys()
pub fn[K, V] JsMap::keys(self : JsMap[K, V]) -> @js.JsIterator[K] {
  (self |> @js.unsafe_cast |> @js.Js::call0("keys")) |> @js.unsafe_cast
}

///|
/// JS: map.values()
pub fn[K, V] JsMap::values(self : JsMap[K, V]) -> @js.JsIterator[V] {
  (self |> @js.unsafe_cast |> @js.Js::call0("values")) |> @js.unsafe_cast
}

///|
/// JS: map.entries()
pub fn[K, V] JsMap::entries(self : JsMap[K, V]) -> @js.JsIterator[(K, V)] {
  (self |> @js.unsafe_cast |> @js.Js::call0("entries")) |> @js.unsafe_cast
}

///|
/// JS: map.forEach(callback)
pub fn[K, V] JsMap::forEach(self : JsMap[K, V], callback : (V, K) -> Unit) -> Unit {
  (self |> @js.unsafe_cast |> @js.Js::call("forEach", [@js.unsafe_js(callback)])) |> ignore
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
pub fn JsSet::new[T]() -> JsSet[T] {
  ffi_new_set() |> @js.unsafe_cast
}

///|
extern "js" fn ffi_new_set() -> @js.Js =
  #| () => new Set()

///|
/// JS: new Set(values)
pub fn JsSet::from_array[T](values : Array[T]) -> JsSet[T] {
  let set : JsSet[T] = JsSet::new()
  for value in values {
    set.add(value) |> ignore
  }
  set
}

///|
/// JS: set.add(value)
pub fn[T] JsSet::add(self : JsSet[T], value : T) -> JsSet[T] {
  (self |> @js.unsafe_cast |> @js.Js::call("add", [@js.unsafe_js(value)])) |> @js.unsafe_cast
}

///|
/// JS: set.has(value)
pub fn[T] JsSet::has(self : JsSet[T], value : T) -> Bool {
  (self |> @js.unsafe_cast |> @js.Js::call("has", [@js.unsafe_js(value)])) |> @js.unsafe_cast
}

///|
/// JS: set.delete(value)
pub fn[T] JsSet::delete(self : JsSet[T], value : T) -> Bool {
  (self |> @js.unsafe_cast |> @js.Js::call("delete", [@js.unsafe_js(value)])) |> @js.unsafe_cast
}

///|
/// JS: set.clear()
pub fn[T] JsSet::clear(self : JsSet[T]) -> Unit {
  (self |> @js.unsafe_cast |> @js.Js::call0("clear")) |> ignore
}

///|
/// JS: set.size
pub fn[T] JsSet::size(self : JsSet[T]) -> Int {
  (self |> @js.unsafe_cast |> @js.Js::get("size")) |> @js.unsafe_cast
}

///|
/// JS: set.values()
pub fn[T] JsSet::values(self : JsSet[T]) -> @js.JsIterator[T] {
  (self |> @js.unsafe_cast |> @js.Js::call0("values")) |> @js.unsafe_cast
}

///|
/// JS: set.keys() - Same as values() for Set
pub fn[T] JsSet::keys(self : JsSet[T]) -> @js.JsIterator[T] {
  (self |> @js.unsafe_cast |> @js.Js::call0("keys")) |> @js.unsafe_cast
}

///|
/// JS: set.entries() - Returns [value, value] pairs for compatibility
pub fn[T] JsSet::entries(self : JsSet[T]) -> @js.JsIterator[(T, T)] {
  (self |> @js.unsafe_cast |> @js.Js::call0("entries")) |> @js.unsafe_cast
}

///|
/// JS: set.forEach(callback)
pub fn[T] JsSet::forEach(self : JsSet[T], callback : (T) -> Unit) -> Unit {
  (self |> @js.unsafe_cast |> @js.Js::call("forEach", [@js.unsafe_js(callback)])) |> ignore
}
