// Frequently used JavaScript builtin types
//
// This file contains the most commonly used JavaScript builtin types:
// - Object, Array, Function (core object types)
// - Error (error handling)
// - Symbol, JsString (primitive types)
// - JSON (serialization)
// - Iterator, AsyncIterator (iteration protocols)
// - AbortController, AbortSignal (async control)
//
// For more specialized builtin types, see src/builtins/:
// - arraybuffer/ - ArrayBuffer, TypedArrays, DataView
// - bigint/ - BigInt operations
// - date/ - Date object
// - math/ - Math utilities
// - proxy/ - Proxy and traps
// - reflect/ - Reflect API
// - regexp/ - Regular expressions
// - weak/ - WeakMap, WeakSet, WeakRef

///|
/// property key for js object access
/// obj[0], obj["name"], obj[symbol]

///|
/// Object - Most frequently used builtin type
#external
pub type Object

///|
pub fn Object::to_any(self : Object) -> @nostd.Any = "%identity"

///|
/// JS: new Object()
/// Returns Any directly - use from_map() for creating objects with initial properties
/// Example: `let obj = @js.from_map({ "key": @nostd.any(value) })` for typed object creation
pub fn Object::new() -> @nostd.Any {
  ffi_new_object()
}

///|
pub fn Object::keys(v : @nostd.Any) -> Array[String] {
  let object_class = @nostd.global_this()._get("Object")
  object_class._call("keys", [v]) |> identity
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : @nostd.Any, source : @nostd.Any) -> @nostd.Any {
  let object_class = @nostd.global_this()._get("Object")
  object_class._call("assign", [target, source]) |> identity
}

///| Array - Second most frequently used builtin type

///|
/// JavaScript Array
/// NonGeneric Array only for Array[Any]
/// Use builtin Array[T] for generic array and JsArray::from(array)
#external
pub type JsArray

///|
pub fn JsArray::as_any(self : JsArray) -> @nostd.Any = "%identity"

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(
    self.as_any() |> identity,
    @nostd.undefined(),
    @nostd.undefined(),
  )
}

///|
/// JS: Array.from(items)
pub fn[T] JsArray::from(items : Array[T]) -> @nostd.Any {
  ffi_array_from(items |> identity) |> identity
}

///|
/// cast to builtin Array
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> identity
}

///|
/// JS: Array.isArray(v)
pub fn JsArray::isArray(v : @nostd.Any) -> Bool {
  ffi_is_array(v |> identity)
}

///|
/// Array.from(v)
pub fn array_from(v : Any) -> Array[Any] {
  ffi_array_from(v)
}

///| Error - Error handling

///|
/// Throws a JavaScript error/value
pub fn throw_(v : @nostd.Any) -> Unit {
  ffi_throw(v |> identity)
}

///| JSON - Serialization

///|
/// JavaScript: JSON
#external
pub type JSON

///|
/// JS: JSON.stringify(v, replacer, space)
pub fn JSON::stringify(
  v : @nostd.Any,
  replacer? : Any = @nostd.undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v |> identity, replacer, space |> any)
}

///|
/// JS: JSON.parse(s, reviver)
pub fn JSON::parse(s : String, reviver? : Any? = None) -> Any raise ThrowError {
  throwable(() => ffi_json_parse(s, reviver?))
}

///| Symbol - Used for special properties

///|
/// JavaScript Symbol
#external
pub type Symbol

///|
pub fn Symbol::to_any(self : Symbol) -> @nostd.Any = "%identity"

///|
extern "js" fn symbol_class() -> Any =
  #| () => Symbol

///|
/// JS: Symbol(name)
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
/// JS: Symbol.for(name)
pub fn Symbol::for_(name : String) -> Symbol {
  ffi_call1(symbol_class(), "for", any(name)) |> identity
}

///|
/// JS: Symbol.iterator
pub fn Symbol::iterator() -> Symbol {
  ffi_get(symbol_class(), "iterator") |> identity
}

///|
/// JS: Symbol.asyncIterator
pub fn Symbol::asyncIterator() -> Symbol {
  ffi_get(symbol_class(), "asyncIterator") |> identity
}

///|
/// JS: Symbol.dispose
pub fn Symbol::dispose() -> Symbol {
  ffi_get(symbol_class(), "dispose") |> identity
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::asyncDispose() -> Symbol {
  ffi_get(symbol_class(), "asyncDispose") |> identity
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::toStringTag() -> Symbol {
  ffi_get(symbol_class(), "toStringTag") |> identity
}

///| JsString - String utilities

///|
#external
pub type JsString

///|
pub fn JsString::to_any(self : JsString) -> @nostd.Any = "%identity"

///|
fn string_instance() -> JsString {
  ffi_get(@nostd.global_this(), "String") |> identity
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCharCode(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_char_code = string_class.to_any()["fromCharCode"]
  from_char_code._call("apply", [
    string_class.to_any(),
    @nostd.any(@nostd.any(values)),
  ])
  |> identity
}

///|
/// JS: String.fromCodePoint(...values)
pub fn JsString::fromCodePoint(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_code_point = string_class.to_any()["fromCodePoint"]
  from_code_point._call("apply", [
    string_class.to_any(),
    @nostd.any(@nostd.any(values)),
  ])
  |> identity
}

///| Iterator - Iteration protocol

///|
/// JavaScript Iterator
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator
#external
pub(all) type JsIterator[T]

///|
pub fn[T] JsIterator::to_any(self : JsIterator[T]) -> @nostd.Any = "%identity"

///|
pub fn[T] JsIterator::as_any(self : JsIterator[T]) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_iterator_from(v : Any) -> Any =
  #|(v) => Iterator.from(v)

///|
/// JS: Iterator.from(v)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/from
pub fn[T] JsIterator::from(v : Any) -> JsIterator[T] {
  ffi_iterator_from(v) |> identity
}

///|
/// JS: iterator.next()
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v = self.to_any()._call("next", [])
  if (v["done"] |> identity) {
    None
  } else {
    Some(v["value"] |> identity)
  }
}

///|
/// JS: iterator.drop(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/drop
pub fn[T] JsIterator::drop(self : Self[T], limit : Int) -> Self[T] {
  self.to_any()._call("drop", [@nostd.any(limit)]) |> identity
}

///|
/// JS: iterator.take(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/take
pub fn[T] JsIterator::take(self : Self[T], limit : Int) -> Self[T] {
  self.to_any()._call("take", [@nostd.any(limit)]) |> identity
}

///|
/// JS: iterator.toArray()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/toArray
pub fn[T] JsIterator::toArray(self : Self[T]) -> Array[T] {
  self.to_any()._call("toArray", []) |> identity
}

///|
/// to Moonbit Iterator
pub fn[T] JsIterator::iter(self : JsIterator[T]) -> Iterator[T] {
  Iterator::new(() => self.next())
}

///| AsyncIterator

///|
/// JavaScript AsyncIterator
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/AsyncIterator
#external
pub(all) type AsyncIterator[T]

///|
pub fn[T] AsyncIterator::to_any(self : AsyncIterator[T]) -> @nostd.Any = "%identity"

///|
/// JS: asyncIterator.next()
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : Promise[@nostd.Any] = self.to_any()._call("next", []) |> identity
  let v : @nostd.Any = v.wait()
  if (@nostd.any(v)["done"] |> identity) {
    None
  } else {
    Some(@nostd.any(v)["value"] |> identity)
  }
}
