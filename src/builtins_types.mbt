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
/// JS: null
pub fn null_() -> Js {
  ffi_null()
}

///|
/// property key for js object access
/// obj[0], obj["name"], obj[symbol]
pub trait PropertyKey {
  to_key(Self) -> Js = _
}

///|
impl PropertyKey with to_key(self) -> Js {
  self |> unsafe_cast
}

///|
pub impl PropertyKey for String

///|
pub impl PropertyKey for Int

///|
pub impl PropertyKey for Symbol

///| Object - Most frequently used builtin type

///|
/// JavaScript Object
#external
pub type Object

///|
pub impl JsImpl for Object

///|
/// JS: new Object()
pub fn Object::new() -> Self {
  ffi_new_object() |> unsafe_cast
}

///|
/// get the Object class
fn object_class() -> Js {
  unsafe_cast(globalThis().get("Object"))
}

///|
/// JS: Object.keys(v)
///
/// Returns an array of a given object's own enumerable property names.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::keys(v : &JsImpl) -> Array[String] {
  object_class().call("keys", [v.to_js()]) |> unsafe_cast
}

///|
/// JS: Object.values(v)
///
/// Returns an array of a given object's own enumerable property values.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::values(v : &JsImpl) -> Array[Js] {
  object_class().call("values", [v.to_js()]) |> unsafe_cast
}

///|
/// JS: Object.entries(v)
///
/// Returns an array of a given object's own enumerable property [key, value] pairs.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::entries(v : &JsImpl) -> Array[(String, Js)] {
  let entries = ffi_object_entries(v.to_js())
  entries.map(entry => (
    entry.get(0) |> unsafe_cast,
    entry.get(1) |> unsafe_cast,
  ))
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : &JsImpl, source : &JsImpl) -> Js {
  object_class().call2("assign", target.to_js(), source.to_js()) |> unsafe_cast
}

///|
/// JS: Object.create(v)
pub fn Object::create(v : &JsImpl) -> Js {
  object_class().call1("create", v) |> unsafe_cast
}

///|
/// JS: Object.is(a, b)
/// Determines whether two values are the same value
pub fn Object::is_(a : &JsImpl, b : &JsImpl) -> Bool {
  object_class().call2("is", a, b) |> unsafe_cast
}

///|
/// JS: Object.freeze(obj)
/// Freezes an object, preventing new properties from being added and existing properties from being removed or changed
pub fn Object::freeze(obj : &JsImpl) -> Js {
  object_class().call1("freeze", obj) |> unsafe_cast
}

///|
/// JS: Object.seal(obj)
/// Seals an object, preventing new properties from being added and marking all existing properties as non-configurable
pub fn Object::seal(obj : &JsImpl) -> Js {
  object_class().call1("seal", obj) |> unsafe_cast
}

///|
/// JS: Object.isFrozen(obj)
/// Determines if an object is frozen
pub fn Object::isFrozen(obj : &JsImpl) -> Bool {
  object_class().call1("isFrozen", obj) |> unsafe_cast
}

///|
/// JS: Object.isSealed(obj)
/// Determines if an object is sealed
pub fn Object::isSealed(obj : &JsImpl) -> Bool {
  object_class().call1("isSealed", obj) |> unsafe_cast
}

///|
/// JS: Object.preventExtensions(obj)
/// Prevents new properties from being added to an object
pub fn Object::preventExtensions(obj : &JsImpl) -> Js {
  object_class().call1("preventExtensions", obj) |> unsafe_cast
}

///|
/// JS: Object.isExtensible(obj)
/// Determines if an object is extensible
pub fn Object::isExtensible_static(obj : &JsImpl) -> Bool {
  object_class().call1("isExtensible", obj) |> unsafe_cast
}

///|
/// JS: object.propertyIsEnumerable(k)
pub fn Object::propertyIsEnumerable(self : Self, key : &PropertyKey) -> Bool {
  ffi_property_is_enumerable(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
/// JS: object.isPrototypeOf(target)
pub fn Object::isPrototypeOf(self : Self, target : Js) -> Bool {
  ffi_is_prototype_of(self.to_js(), target)
}

///|
pub fn Object::hasOwnProperty(self : Self, key : &PropertyKey) -> Bool {
  ffi_has_own_property(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
/// JS: Object.isExtensible(obj)
/// Instance method that calls the static Object.isExtensible
pub fn Object::isExtensible(self : Self) -> Bool {
  object_class().call1("isExtensible", self) |> unsafe_cast
}

///|
pub fn Object::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///| Array - Second most frequently used builtin type

///|
/// JavaScript Array
/// NonGeneric Array only for Array[Js]
/// Use builtin Array[T] for generic array and JsArray::from(array)
#external
pub type JsArray

///|
pub impl JsImpl for JsArray

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///|
/// JS: Array.from(items)
pub fn[T] JsArray::from(items : Array[T]) -> JsArray {
  ffi_array_from(items |> unsafe_cast) |> unsafe_cast
}

///|
/// JS: new Array()
pub fn JsArray::new() -> JsArray {
  ffi_new_array() |> unsafe_cast
}

///|
/// JS: array.push(item)
pub fn JsArray::push(self : JsArray, item : &JsImpl) -> Unit {
  self.as_builtin_array().push(item.to_js())
}

///|
/// cast to builtin Array
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> unsafe_cast
}

///|
/// JS: Array.isArray(v)
pub fn[T : JsImpl] JsArray::isArray(v : T) -> Bool {
  ffi_is_array(v.to_js())
}

///|
/// Array.from(v)
pub fn array_from(v : Js) -> Array[Js] {
  ffi_array_from(v)
}

///| Function

///|
/// JavaScript Function
#external
pub type Function

///|
pub impl JsImpl for Function

///|
/// JS: function.toString()
/// Returns a string representing the source code of the function
pub fn Function::to_string(self : Self) -> String {
  self.call0("toString") |> unsafe_cast
}

///|
/// JS: function.name
pub fn Function::name(self : Self) -> String {
  self.get("name") |> unsafe_cast
}

///|
/// JS: function.apply
pub extern "js" fn Function::apply(
  self : Self,
  caller : Js,
  args : Array[Js],
) -> Js =
  #|(self, args) => self.apply(caller, args)

///|
/// JS: function.bind(caller)
pub extern "js" fn Function::bind(self : Self, caller : Js) -> Js =
  #|(self, caller) => self.bind(caller)

///|
/// JS: function.length
pub extern "js" fn Function::length(self : Self) -> Js =
  #|(self) => self.length

///| Error - Error handling

///|
/// JavaScript Error
// pub type JsError
// #external
pub(all) struct JsError {
  message : String
  stack : String
}

///|
pub impl JsImpl for JsError

///|
pub impl Show for JsError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for JsError with to_string(self) {
  self.message
}

///|
/// JS: Error.isError(value)
pub fn JsError::isError(val : &JsImpl) -> Bool {
  ffi_is_error(val.to_js())
}

///|
/// Throws a JavaScript error/value
pub fn throw_(v : &JsImpl) -> Unit {
  ffi_throw(v.to_js())
}

///|
/// Create a new JavaScript Error object.
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  let args : Array[Js] = if cause is Some(cause) {
    [message |> js, from_map({ "cause": cause |> unsafe_cast() })]
  } else {
    [message |> js]
  }
  ffi_new_error(args)
}

///|
/// Wraps JavaScript errors thrown during runtime.
/// This type represents errors that can be raised when calling JavaScript functions
/// that may throw exceptions.
pub suberror ThrowError {
  // TODO: Differentiate error types
  // TypeError
  // ReferenceError
  // SyntaxError
  // RangeError
  // etc.
  Error(JsError)
  Value(Js)
}

///|
pub impl JsImpl for ThrowError

///|
pub impl Show for ThrowError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for ThrowError with to_string(self) {
  match self {
    Error(err) => err.message
    Value(val) => val.to_string()
  }
}

///| JSON - Serialization

///|
/// JavaScript: JSON
#external
pub type JSON

///|
/// JS: JSON.stringify(v, replacer, space)
pub fn JSON::stringify(
  v : Js,
  replacer? : Js = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_js(), replacer, space |> js)
}

///|
/// JS: JSON.parse(s, reviver)
pub fn JSON::parse(s : String, reviver? : Js? = None) -> Js raise ThrowError {
  throwable(() => ffi_json_parse(s, reviver?))
}

///| Symbol - Used for special properties

///|
/// JavaScript Symbol
#external
pub type Symbol

///|
pub impl JsImpl for Symbol

///|
extern "js" fn symbol_class() -> Js =
  #| () => Symbol

///|
/// JS: Symbol(name)
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
/// JS: Symbol.for(name)
pub fn Symbol::for_(name : String) -> Symbol {
  symbol_class().call("for", [name]) |> unsafe_cast
}

///|
/// JS: Symbol.iterator
pub fn Symbol::iterator() -> Symbol {
  symbol_class().get("iterator") |> unsafe_cast
}

///|
/// JS: Symbol.asyncIterator
pub fn Symbol::asyncIterator() -> Symbol {
  symbol_class().get("asyncIterator") |> unsafe_cast
}

///|
/// JS: Symbol.dispose
pub fn Symbol::dispose() -> Symbol {
  symbol_class().get("dispose") |> unsafe_cast
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::asyncDispose() -> Symbol {
  symbol_class().get("asyncDispose") |> unsafe_cast
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::toStringTag() -> Symbol {
  symbol_class().get("toStringTag") |> unsafe_cast
}

///| JsString - String utilities

///|
#external
pub type JsString

///|
pub impl JsImpl for JsString

///|
fn string_instance() -> JsString {
  unsafe_cast(globalThis().get("String"))
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCharCode(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_char_code = string_class.get("fromCharCode")
  from_char_code.call2("apply", string_class, values |> from_array)
  |> unsafe_cast
}

///|
/// JS: String.fromCodePoint(...values)
pub fn JsString::fromCodePoint(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_code_point = string_class.get("fromCodePoint")
  from_code_point.call2("apply", string_class, values |> from_array)
  |> unsafe_cast
}

///| Iterator - Iteration protocol

///|
/// JavaScript Iterator
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator
#external
pub(all) type JsIterator[T]

///|
pub impl[T] JsImpl for JsIterator[T]

///|
extern "js" fn ffi_iterator_from(v : Js) -> Js =
  #|(v) => Iterator.from(v)

///|
/// JS: Iterator.from(v)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/from
pub fn[T] JsIterator::from(v : Js) -> JsIterator[T] {
  ffi_iterator_from(v) |> unsafe_cast
}

///|
/// JS: iterator.next()
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v : Js = self.call0("next") |> unsafe_cast
  if (v.get("done") |> unsafe_cast) {
    None
  } else {
    Some(v.get("value") |> unsafe_cast)
  }
}

///|
/// JS: iterator.drop(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/drop
pub fn[T] JsIterator::drop(self : Self[T], limit : Int) -> Self[T] {
  self.call("drop", [limit]) |> unsafe_cast
}

///|
/// JS: iterator.take(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/take
pub fn[T] JsIterator::take(self : Self[T], limit : Int) -> Self[T] {
  self.call("take", [limit]) |> unsafe_cast
}

///|
/// JS: iterator.toArray()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/toArray
pub fn[T] JsIterator::toArray(self : Self[T]) -> Array[T] {
  self.call0("toArray") |> unsafe_cast
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
pub impl[T] JsImpl for AsyncIterator[T]

///|
/// JS: asyncIterator.next()
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : Promise[Js] = self.call0("next") |> unsafe_cast
  let v : Js = v.unwrap()
  if (v.get("done") |> unsafe_cast) {
    None
  } else {
    Some(v.get("value") |> unsafe_cast)
  }
}

// TODO: test with async test {}

///| AbortController and AbortSignal - Async control

///|
/// JavaScript: AbortController
#external
pub type AbortController

///|
pub impl JsImpl for AbortController

///|
/// JS: new AbortController()
pub extern "js" fn AbortController::new() -> AbortController =
  #| () => new AbortController()

///|
/// JS: abortController.abort()
pub fn AbortController::abort(self : Self) -> AbortController {
  self.call0("abort") |> unsafe_cast
}

///|
/// JavaScript: AbortSignal
#external
pub type AbortSignal

///|
pub impl JsImpl for AbortSignal

///|
/// JS: abortController.signal
pub fn AbortController::signal(self : Self) -> AbortSignal {
  self.get("signal") |> unsafe_cast
}
