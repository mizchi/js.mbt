// Frequently used JavaScript builtin types

///|
/// Object - Most frequently used builtin type

///|
// pub fn Object::keys(v : @core.Any) -> Array[String] {
//   let object_class = @core.global_this()._get("Object")
//   object_class._call("keys", [v]) |> identity
// }

///|
/// JS: Object.assign(target, source)
// pub fn Object::assign(target : @core.Any, source : @core.Any) -> @core.Any {
//   let object_class = @core.global_this()._get("Object")
//   object_class._call("assign", [target, source]) |> identity
// }

///| Array - Second most frequently used builtin type

///|
/// JavaScript Array
/// NonGeneric Array only for Array[Any]
/// Use builtin Array[T] for generic array and JsArray::from(array)
#external
pub type JsArray

///|
pub fn JsArray::as_any(self : JsArray) -> @core.Any = "%identity"

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(
    self.as_any() |> identity,
    @core.undefined(),
    @core.undefined(),
  )
}

///|
/// cast to builtin Array
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> identity
}

///|
/// JS: Array.isArray(v)
pub fn JsArray::isArray(v : @core.Any) -> Bool {
  ffi_is_array(v |> identity)
}

///| Error - Error handling

///|
/// Throws a JavaScript error/value
pub fn throw_(v : @core.Any) -> Unit {
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
  v : @core.Any,
  replacer? : Any = @core.undefined(),
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

///| JsString - String utilities

///|
#external
pub type JsString

///|
pub fn JsString::to_any(self : JsString) -> @core.Any = "%identity"

///|
fn string_instance() -> JsString {
  ffi_get(@core.global_this(), "String") |> identity
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCharCode(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_char_code = string_class.to_any()["fromCharCode"]
  from_char_code._call("apply", [
    string_class.to_any(),
    @core.any(@core.any(values)),
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
    @core.any(@core.any(values)),
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
pub fn[T] JsIterator::to_any(self : JsIterator[T]) -> @core.Any = "%identity"

///|
pub fn[T] JsIterator::as_any(self : JsIterator[T]) -> @core.Any = "%identity"

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
  self.to_any()._call("drop", [@core.any(limit)]) |> identity
}

///|
/// JS: iterator.take(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/take
pub fn[T] JsIterator::take(self : Self[T], limit : Int) -> Self[T] {
  self.to_any()._call("take", [@core.any(limit)]) |> identity
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
pub fn[T] AsyncIterator::to_any(self : AsyncIterator[T]) -> @core.Any = "%identity"

///|
/// JS: asyncIterator.next()
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : Promise[@core.Any] = self.to_any()._call("next", []) |> identity
  let v : @core.Any = v.wait()
  if (@core.any(v)["done"] |> identity) {
    None
  } else {
    Some(@core.any(v)["value"] |> identity)
  }
}
