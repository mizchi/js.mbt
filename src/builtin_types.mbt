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

///| Object - Most frequently used builtin type

///|
/// JavaScript Object
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
/// get the Object class
fn object_class() -> @nostd.Any {
  ffi_get(@nostd.global_this(), "Object")
}

///|
/// JS: Object.keys(v)
///
/// Returns an array of a given object's own enumerable property names.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::keys(v : @nostd.Any) -> Array[String] {
  @nostd.any(object_class())._call("keys", [v]) |> identity
}

///|
/// JS: Object.values(v)
///
/// Returns an array of a given object's own enumerable property values.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::values(v : @nostd.Any) -> Array[Any] {
  @nostd.any(object_class())._call("values", [v]) |> identity
}

///|
/// JS: Object.entries(v)
///
/// Returns an array of a given object's own enumerable property [key, value] pairs.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::entries(v : @nostd.Any) -> Array[(String, Any)] {
  let entries = ffi_object_entries(v |> identity)
  entries.map(entry => (
    @nostd.any(entry)["0"] |> identity,
    @nostd.any(entry)["1"] |> identity,
  ))
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : @nostd.Any, source : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("assign", [target, source]) |> identity
}

///|
/// JS: Object.create(v)
pub fn Object::create(v : @nostd.Any) -> Any {
  @nostd.any(object_class())._call("create", [v]) |> identity
}

///|
/// JS: Object.is(a, b)
/// Determines whether two values are the same value
pub fn Object::is_(a : @nostd.Any, b : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("is", [a, b]) |> identity
}

///|
/// JS: Object.freeze(obj)
/// Freezes an object, preventing new properties from being added and existing properties from being removed or changed
pub fn Object::freeze(obj : @nostd.Any) -> Any {
  @nostd.any(object_class())._call("freeze", [obj]) |> identity
}

///|
/// JS: Object.seal(obj)
/// Seals an object, preventing new properties from being added and marking all existing properties as non-configurable
pub fn Object::seal(obj : @nostd.Any) -> Any {
  @nostd.any(object_class())._call("seal", [obj]) |> identity
}

///|
/// JS: Object.isFrozen(obj)
/// Determines if an object is frozen
pub fn Object::isFrozen(obj : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("isFrozen", [obj]) |> identity
}

///|
/// JS: Object.isSealed(obj)
/// Determines if an object is sealed
pub fn Object::isSealed(obj : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("isSealed", [obj]) |> identity
}

///|
/// JS: Object.preventExtensions(obj)
/// Prevents new properties from being added to an object
pub fn Object::preventExtensions(obj : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("preventExtensions", [obj]) |> identity
}

///|
/// JS: Object.isExtensible(obj)
/// Determines if an object is extensible
pub fn Object::isExtensible_static(obj : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("isExtensible", [obj]) |> identity
}

///|
/// JS: object.propertyIsEnumerable(k)
pub fn Object::propertyIsEnumerable(self : Self, key : String) -> Bool {
  ffi_property_is_enumerable(self |> identity, key |> identity)
}

///|
/// JS: object.isPrototypeOf(target)
pub fn Object::isPrototypeOf(self : Self, target : @nostd.Any) -> Bool {
  ffi_is_prototype_of(self.to_any() |> identity, target |> identity)
}

///|
pub fn Object::hasOwnProperty(self : Self, key : String) -> Bool {
  ffi_has_own_property(self |> identity, key |> identity)
}

///|
/// JS: Object.isExtensible(obj)
/// Instance method that calls the static Object.isExtensible
pub fn Object::isExtensible(self : Self) -> Bool {
  @nostd.any(object_class())._call("isExtensible", [self.to_any()]) |> identity
}

///|
pub fn Object::to_string(self : Self) -> String {
  ffi_json_stringify(
    self.to_any() |> identity,
    @nostd.undefined(),
    @nostd.undefined(),
  )
}

///| Array - Second most frequently used builtin type

///|
/// JavaScript Array
/// NonGeneric Array only for Array[Any]
/// Use builtin Array[T] for generic array and JsArray::from(array)
#external
pub type JsArray

///|
pub fn JsArray::to_any(self : JsArray) -> @nostd.Any = "%identity"

///|
pub fn JsArray::_get(self : JsArray, key : String) -> @nostd.Any {
  self.to_any()._get(key)
}

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(
    self.to_any() |> identity,
    @nostd.undefined(),
    @nostd.undefined(),
  )
}

///|
/// JS: Array.from(items)
pub fn[T] JsArray::from(items : Array[T]) -> JsArray {
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

///| Function

///|
/// JavaScript Function
#external
pub type Function

///|
pub fn Function::to_any(self : Function) -> @nostd.Any = "%identity"

///|
/// JS: function.toString()
/// Returns a string representing the source code of the function
pub fn Function::to_string(self : Self) -> String {
  self.to_any()._call("toString", []) |> identity
}

///|
/// JS: function.name
pub fn Function::name(self : Self) -> String {
  self.to_any()["name"] |> identity
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
pub fn JsError::to_any(self : JsError) -> @nostd.Any = "%identity"

///|
pub fn JsError::as_any(self : JsError) -> @nostd.Any = "%identity"

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
pub fn JsError::isError(val : @nostd.Any) -> Bool {
  ffi_is_error(val |> identity)
}

///|
/// Throws a JavaScript error/value
pub fn throw_(v : @nostd.Any) -> Unit {
  ffi_throw(v |> identity)
}

///|
/// Create a new JavaScript Error object.
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  let args : Array[Any] = if cause is Some(cause) {
    [
      @nostd.any(message).cast(),
      @nostd.from_entries([("cause", cause.to_any())]).cast(),
    ]
  } else {
    [@nostd.any(message).cast()]
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
  /// SuppressedError - Error suppressed during disposal
  SuppressedError(JsError)
  /// Generic JavaScript Error including custom errors
  Error(JsError)
  /// Non-error value thrown
  Value(Any)
}

///|
pub fn ThrowError::to_any(self : ThrowError) -> @nostd.Any = "%identity"

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
    | AggregateError(err)
    | SuppressedError(err) => err.message
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
/// let js_error = globalThis()._get("TypeError")
///
/// let throw_error = ThrowError::from(js_error)
/// // Returns ThrowError::TypeError(...)
/// ```
pub fn ThrowError::from(value : @nostd.Any) -> ThrowError {
  let global = @nostd.global_this()

  // Check specific error types first (most specific to least specific)
  if @nostd.instanceof_(value, ffi_get(global, "TypeError")) {
    ThrowError::TypeError(identity(value))
  } else if @nostd.instanceof_(value, ffi_get(global, "RangeError")) {
    ThrowError::RangeError(identity(value))
  } else if @nostd.instanceof_(value, ffi_get(global, "ReferenceError")) {
    ThrowError::ReferenceError(identity(value))
  } else if @nostd.instanceof_(value, ffi_get(global, "SyntaxError")) {
    ThrowError::SyntaxError(identity(value))
  } else if @nostd.instanceof_(value, ffi_get(global, "URIError")) {
    ThrowError::URIError(identity(value))
  } else if @nostd.instanceof_(value, ffi_get(global, "EvalError")) {
    ThrowError::EvalError(identity(value))
  } else if @nostd.instanceof_(value, ffi_get(global, "AggregateError")) {
    ThrowError::AggregateError(identity(value))
  } else if @nostd.instanceof_(value, ffi_get(global, "SuppressedError")) {
    ThrowError::SuppressedError(identity(value))
  } else if JsError::isError(@nostd.any(value)) {
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
    @nostd.any(from_array(values)),
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
    @nostd.any(from_array(values)),
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
