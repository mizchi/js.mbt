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
pub fn null_() -> Any {
  ffi_null()
}

///|
/// property key for js object access
/// obj[0], obj["name"], obj[symbol]
pub trait PropertyKey {
  to_key(Self) -> Any = _
}

///|
impl PropertyKey with to_key(self) -> Any {
  self |> identity
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
  ffi_new_object() |> identity
}

///|
/// get the Object class
fn object_class() -> Any {
  identity(globalThis().get("Object"))
}

///|
/// JS: Object.keys(v)
///
/// Returns an array of a given object's own enumerable property names.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::keys(v : &JsImpl) -> Array[String] {
  object_class().call("keys", [v.to_any()]) |> identity
}

///|
/// JS: Object.values(v)
///
/// Returns an array of a given object's own enumerable property values.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::values(v : &JsImpl) -> Array[Any] {
  object_class().call("values", [v.to_any()]) |> identity
}

///|
/// JS: Object.entries(v)
///
/// Returns an array of a given object's own enumerable property [key, value] pairs.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::entries(v : &JsImpl) -> Array[(String, Any)] {
  let entries = ffi_object_entries(v.to_any())
  entries.map(entry => (entry.get(0) |> identity, entry.get(1) |> identity))
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : &JsImpl, source : &JsImpl) -> Any {
  object_class().call2("assign", target.to_any(), source.to_any())
}

///|
/// JS: Object.create(v)
pub fn Object::create(v : &JsImpl) -> Any {
  object_class().call1("create", v)
}

///|
/// JS: Object.is(a, b)
/// Determines whether two values are the same value
pub fn Object::is_(a : &JsImpl, b : &JsImpl) -> Bool {
  object_class().call2("is", a, b) |> identity
}

///|
/// JS: Object.freeze(obj)
/// Freezes an object, preventing new properties from being added and existing properties from being removed or changed
pub fn Object::freeze(obj : &JsImpl) -> Any {
  object_class().call1("freeze", obj)
}

///|
/// JS: Object.seal(obj)
/// Seals an object, preventing new properties from being added and marking all existing properties as non-configurable
pub fn Object::seal(obj : &JsImpl) -> Any {
  object_class().call1("seal", obj)
}

///|
/// JS: Object.isFrozen(obj)
/// Determines if an object is frozen
pub fn Object::isFrozen(obj : &JsImpl) -> Bool {
  object_class().call1("isFrozen", obj) |> identity
}

///|
/// JS: Object.isSealed(obj)
/// Determines if an object is sealed
pub fn Object::isSealed(obj : &JsImpl) -> Bool {
  object_class().call1("isSealed", obj) |> identity
}

///|
/// JS: Object.preventExtensions(obj)
/// Prevents new properties from being added to an object
pub fn Object::preventExtensions(obj : &JsImpl) -> Any {
  object_class().call1("preventExtensions", obj) |> identity
}

///|
/// JS: Object.isExtensible(obj)
/// Determines if an object is extensible
pub fn Object::isExtensible_static(obj : &JsImpl) -> Bool {
  object_class().call1("isExtensible", obj) |> identity
}

///|
/// JS: object.propertyIsEnumerable(k)
pub fn Object::propertyIsEnumerable(self : Self, key : &PropertyKey) -> Bool {
  ffi_property_is_enumerable(self.to_any(), key.to_key() |> identity)
}

///|
/// JS: object.isPrototypeOf(target)
pub fn Object::isPrototypeOf(self : Self, target : Any) -> Bool {
  ffi_is_prototype_of(self.to_any(), target)
}

///|
pub fn Object::hasOwnProperty(self : Self, key : &PropertyKey) -> Bool {
  ffi_has_own_property(self.to_any(), key.to_key() |> identity)
}

///|
/// JS: Object.isExtensible(obj)
/// Instance method that calls the static Object.isExtensible
pub fn Object::isExtensible(self : Self) -> Bool {
  object_class().call1("isExtensible", self) |> identity
}

///|
pub fn Object::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_any(), undefined(), undefined())
}

///| Array - Second most frequently used builtin type

///|
/// JavaScript Array
/// NonGeneric Array only for Array[Any]
/// Use builtin Array[T] for generic array and JsArray::from(array)
#external
pub type JsArray

///|
pub impl JsImpl for JsArray

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_any(), undefined(), undefined())
}

///|
/// JS: Array.from(items)
pub fn[T] JsArray::from(items : Array[T]) -> JsArray {
  ffi_array_from(items |> identity) |> identity
}

///|
/// JS: new Array()
pub fn JsArray::new() -> JsArray {
  ffi_new_array() |> identity
}

///|
/// JS: array.push(item)
pub fn JsArray::push(self : JsArray, item : &JsImpl) -> Unit {
  self.as_builtin_array().push(item.to_any())
}

///|
/// cast to builtin Array
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> identity
}

///|
/// JS: Array.isArray(v)
pub fn[T : JsImpl] JsArray::isArray(v : T) -> Bool {
  ffi_is_array(v.to_any())
}

///|
/// Array.from(v)
pub fn array_from(v : Any) -> Array[Any] {
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
  self.call0("toString") |> identity
}

///|
/// JS: function.name
pub fn Function::name(self : Self) -> String {
  self.get("name") |> identity
}

///|
/// JS: function.apply
pub extern "js" fn Function::apply(
  self : Self,
  caller : Any,
  args : Array[Any],
) -> Any =
  #|(self, args) => self.apply(caller, args)

///|
/// JS: function.bind(caller)
pub extern "js" fn Function::bind(self : Self, caller : Any) -> Any =
  #|(self, caller) => self.bind(caller)

///|
/// JS: function.length
pub extern "js" fn Function::length(self : Self) -> Any =
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
  ffi_is_error(val.to_any())
}

///|
/// Throws a JavaScript error/value
pub fn throw_(v : &JsImpl) -> Unit {
  ffi_throw(v.to_any())
}

///|
/// Create a new JavaScript Error object.
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  let args : Array[Any] = if cause is Some(cause) {
    [message |> js, from_map({ "cause": cause |> identity() })]
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
  /// TypeError - Type-related errors
  TypeError(JsError)
  /// RangeError - Value out of range errors
  RangeError(JsError)
  /// ReferenceError - Invalid reference errors
  ReferenceError(JsError)
  /// SyntaxError - Syntax parsing errors
  SyntaxError(JsError)
  /// URIError - URI handling errors
  URIError(JsError)
  /// EvalError - eval() related errors
  EvalError(JsError)
  /// AggregateError - Multiple errors wrapped together
  AggregateError(JsError)
  /// Generic JavaScript Error including custom errors
  Error(JsError)
  /// Non-error value thrown
  Value(Any)
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
    Error(err)
    | TypeError(err)
    | RangeError(err)
    | ReferenceError(err)
    | SyntaxError(err)
    | URIError(err)
    | EvalError(err)
    | AggregateError(err) => err.message
    Value(val) => val.to_string()
  }
}

///|
/// Convert a JavaScript value to ThrowError by checking its type with instanceof
///
/// This function inspects the error type and returns the appropriate ThrowError variant.
/// If the value is not an Error object, it returns ThrowError::Value.
///
/// # Example
///
/// ```moonbit no-check
/// let js_error = globalThis().get("TypeError")
/// let throw_error = ThrowError::from_js(js_error)
/// // Returns ThrowError::TypeError(...)
/// ```
pub fn ThrowError::from_js(value : Any) -> ThrowError {
  let global = globalThis()

  // Check specific error types first (most specific to least specific)
  if ffi_instance_of(value, global.get("TypeError")) {
    ThrowError::TypeError(identity(value))
  } else if ffi_instance_of(value, global.get("RangeError")) {
    ThrowError::RangeError(identity(value))
  } else if ffi_instance_of(value, global.get("ReferenceError")) {
    ThrowError::ReferenceError(identity(value))
  } else if ffi_instance_of(value, global.get("SyntaxError")) {
    ThrowError::SyntaxError(identity(value))
  } else if ffi_instance_of(value, global.get("URIError")) {
    ThrowError::URIError(identity(value))
  } else if ffi_instance_of(value, global.get("EvalError")) {
    ThrowError::EvalError(identity(value))
  } else if ffi_instance_of(value, global.get("AggregateError")) {
    ThrowError::AggregateError(identity(value))
  } else if JsError::isError(value) {
    // Generic Error or custom error types
    ThrowError::Error(identity(value))
  } else {
    // Non-error value thrown
    ThrowError::Value(value)
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
  v : Any,
  replacer? : Any = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_any(), replacer, space |> js)
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
pub impl JsImpl for Symbol

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
  symbol_class().call("for", [name]) |> identity
}

///|
/// JS: Symbol.iterator
pub fn Symbol::iterator() -> Symbol {
  symbol_class().get("iterator") |> identity
}

///|
/// JS: Symbol.asyncIterator
pub fn Symbol::asyncIterator() -> Symbol {
  symbol_class().get("asyncIterator") |> identity
}

///|
/// JS: Symbol.dispose
pub fn Symbol::dispose() -> Symbol {
  symbol_class().get("dispose") |> identity
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::asyncDispose() -> Symbol {
  symbol_class().get("asyncDispose") |> identity
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::toStringTag() -> Symbol {
  symbol_class().get("toStringTag") |> identity
}

///| JsString - String utilities

///|
#external
pub type JsString

///|
pub impl JsImpl for JsString

///|
fn string_instance() -> JsString {
  identity(globalThis().get("String"))
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCharCode(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_char_code = string_class.get("fromCharCode")
  from_char_code.call2("apply", string_class, values |> from_array) |> identity
}

///|
/// JS: String.fromCodePoint(...values)
pub fn JsString::fromCodePoint(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_code_point = string_class.get("fromCodePoint")
  from_code_point.call2("apply", string_class, values |> from_array) |> identity
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
  let v : Any = self.call0("next") |> identity
  if (v.get("done") |> identity) {
    None
  } else {
    Some(v.get("value") |> identity)
  }
}

///|
/// JS: iterator.drop(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/drop
pub fn[T] JsIterator::drop(self : Self[T], limit : Int) -> Self[T] {
  self.call("drop", [limit]) |> identity
}

///|
/// JS: iterator.take(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/take
pub fn[T] JsIterator::take(self : Self[T], limit : Int) -> Self[T] {
  self.call("take", [limit]) |> identity
}

///|
/// JS: iterator.toArray()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/toArray
pub fn[T] JsIterator::toArray(self : Self[T]) -> Array[T] {
  self.call0("toArray") |> identity
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
  let v : Promise[Any] = self.call0("next") |> identity
  let v : Any = v.wait()
  if (v.get("done") |> identity) {
    None
  } else {
    Some(v.get("value") |> identity)
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
  self.call0("abort") |> identity
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
  self.get("signal") |> identity
}
