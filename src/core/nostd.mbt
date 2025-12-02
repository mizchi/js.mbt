// Lightweight JS interop without trait vtable overhead

///|
/// Opaque type for JavaScript values
#external
pub type Any

///|
pub impl Eq for Any with equal(self, other) -> Bool {
  equal(self, other)
}

///|
#external
pub type Object

///|
pub extern "js" fn Object::new() -> Any =
  #| () => ({})

///|
/// JS: Object.keys(obj)
pub extern "js" fn Object::keys(obj : Any) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
/// JS: Object.values(obj)
pub extern "js" fn Object::values(obj : Any) -> Array[Any] =
  #| (obj) => Object.values(obj)

///|
/// JS: Object.entries(obj) - returns array of [key, value] pairs
pub extern "js" fn Object::entries(obj : Any) -> Array[Any] =
  #| (obj) => Object.entries(obj)

///|
/// JS: Object.assign(target, ...sources)
pub extern "js" fn Object::assign(target : Any, source : Any) -> Any =
  #| (target, source) => Object.assign(target, source)

///|
/// JS: Object.freeze(obj)
pub extern "js" fn Object::freeze(obj : Any) -> Any =
  #| (obj) => Object.freeze(obj)

///|
/// JS: Object.hasOwn(obj, key) or obj.hasOwnProperty(key)
pub extern "js" fn Object::has_own(obj : Any, key : String) -> Bool =
  #| (obj, key) => Object.hasOwn(obj, key)

///| JSON functions

///|
/// JS: JSON.stringify(value)
pub extern "js" fn json_stringify(value : Any) -> String =
  #| (value) => JSON.stringify(value)

///|
/// JS: JSON.stringify(value, null, space)
pub extern "js" fn json_stringify_pretty(value : Any, space : Int) -> String =
  #| (value, space) => JSON.stringify(value, null, space)

///|
/// JS: JSON.parse(text)
pub extern "js" fn json_parse(text : String) -> Any =
  #| (text) => JSON.parse(text)

///| Console functions

///|
/// JS: console.log(...args)
pub extern "js" fn console_log(value : Any) -> Unit =
  #| (value) => console.log(value)

///|
/// JS: console.error(...args)
pub extern "js" fn console_error(value : Any) -> Unit =
  #| (value) => console.error(value)

///|
/// JS: console.warn(...args)
pub extern "js" fn console_warn(value : Any) -> Unit =
  #| (value) => console.warn(value)

///|
/// JS: console.info(...args)
pub extern "js" fn console_info(value : Any) -> Unit =
  #| (value) => console.info(value)

///|
/// JS: console.debug(...args)
pub extern "js" fn console_debug(value : Any) -> Unit =
  #| (value) => console.debug(value)

///| Zero-cost type conversions using %identity
/// These are compile-time only and produce no runtime code

///|
pub fn[A, B] identity(value : A) -> B = "%identity"

///|
pub fn[T] any(value : T) -> Any = "%identity"

///|
pub fn[T] Any::cast(self : Any) -> T = "%identity"

///|
/// Convert Option[Any] to Any (None becomes undefined)
/// Note: Any? is boxed, so we need FFI to extract the value
pub extern "js" fn as_any(opt : Any?) -> Any =
  #| (opt) => opt?._0

///|
/// Convert Option[T] to Any (None becomes undefined)
/// Zero-cost: concrete Option[T] compiles to T | undefined in JS
/// Usage: from_entries([("key", nullable(maybe_value))])
pub fn[T] nullable(opt : T?) -> Any = "%identity"

///| JsValue methods

///|
/// Set property: obj["key"] = value
/// Enables syntax: obj["key"] = val
#alias("_[_]=_")
pub extern "js" fn Any::_set(self : Any, key : String, value : Any) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
/// Call method: obj._call("method", [arg1, arg2])
pub extern "js" fn Any::_call(
  self : Any,
  key : String,
  args : Array[Any],
) -> Any =
  #| (obj, key, args) => obj[key](...args)

// ///|
// /// Convenience method call: obj.call1("method", arg)
// pub fn Any::call1(self : Any, key : String, arg1 : Any) -> Any {
//   self._call(key, [arg1])
// }

// ///|
// /// Convenience method call: obj.call0("method")
// pub fn Any::call0(self : Any, key : String) -> Any {
//   self._call(key, [])
// }

// ///|
// /// Convenience method call: obj.call2("method", a, b)
// pub fn Any::call2(self : Any, key : String, arg1 : Any, arg2 : Any) -> Any {
//   self._call(key, [arg1, arg2])
// }

///|
/// Call function: func._invoke([arg1, arg2])
pub extern "js" fn Any::_invoke(self : Any, args : Array[Any]) -> Any =
  #| (func, args) => func(...args)

///|
/// JS: value[key]
/// Enables syntax: obj["key"]
#alias("_[_]")
pub extern "js" fn Any::_get(self : Any, key : String) -> Any =
  #| (obj, key) => obj[key]

///|
/// JS: value[key]
/// Enables syntax: obj[index]
pub extern "js" fn Any::_get_by_index(self : Any, key : Int) -> Any =
  #| (obj, key) => obj[key]

///| Global functions

///|
pub extern "js" fn global_this() -> Any =
  #| () => globalThis

///|
pub extern "js" fn undefined() -> Any =
  #| () => undefined

///|
pub extern "js" fn null() -> Any =
  #| () => null

///|
/// Check if value is null or undefined
pub extern "js" fn is_nullish(v : Any) -> Bool =
  #|(v) => v == null

///|
/// Check if value is null
pub extern "js" fn is_null(v : Any) -> Bool =
  #|(v) => v === null

///|
/// Check if value is null
pub extern "js" fn is_undefined(v : Any) -> Bool =
  #|(v) => v === undefined

///|
/// Check if value is null or undefined
pub extern "js" fn equal(a : Any, b : Any) -> Bool =
  #|(a, b) => a === b

///|
/// Check if value is an array
pub extern "js" fn is_array(v : Any) -> Bool =
  #|(v) => Array.isArray(v)

///|
/// JS: typeof value
pub extern "js" fn type_of(value : Any) -> String =
  #|(value) => typeof value

///|
/// JS: new cls(...args)
pub extern "js" fn new(cls : Any, args : Array[Any]) -> Any =
  #|(cls, args) => new cls(...args)

///| Function wrappers

///|
/// Wrap MoonBit function as JS function (0 args)
pub fn[A] from_fn0(f : () -> A) -> Any = "%identity"

///|
/// Wrap MoonBit function as JS function (1 arg)
pub fn[A, B] from_fn1(f : (A) -> B) -> Any = "%identity"

///|
/// Wrap MoonBit function as JS function (2 args)
pub fn[A, B, C] from_fn2(f : (A, B) -> C) -> Any = "%identity"

///|
/// Wrap MoonBit function as JS function (3 args)
pub fn[A, B, C, D] from_fn3(f : (A, B, C) -> D) -> Any = "%identity"

///| Timer functions

///|
/// Convert Array of tuples to JS Object using Object.fromEntries
/// Tuples compile to {_0, _1} objects, which are converted to [key, value] in FFI
pub extern "js" fn from_entries(entries : Array[(String, Any)]) -> Any =
  #| (entries) => Object.fromEntries(entries.map(e => [e._0, e._1]))

///|
/// Convert Any to string representation
pub extern "js" fn Any::to_string(self : Any) -> String =
  #| (self) => self == null ? String(self) : self.toString()

///|
pub impl Show for Any with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
/// Safely convert a JavaScript value to an Option type.
///
/// Converts JavaScript `null` or `undefined` to `None`, otherwise returns `Some(value)`.
/// This is essential for FFI because accessing properties on null/undefined will crash.
///
/// # Common Patterns
///
/// - DOM API nullable returns: `node._get("parentNode") |> identity_option()`
/// - Optional object properties: `obj._get("name") |> identity_option()`
/// - Converting back to Js: use `from_option(opt)`
///
/// # Related Functions
/// - `from_option(A?) -> Js` - Inverse conversion (Option to Js)
/// - `@js.Nullable[T]` - For FFI struct fields that need explicit null handling
pub fn[T] identity_option(v : Any) -> T? {
  if is_nullish(v) {
    None
  } else {
    Some(identity(v))
  }
}

///|
#external
pub type JsArray

///|
pub extern "js" fn JsArray::new() -> Any =
  #| () => []

///|
/// Convert an Option to Any, mapping None to null and Some(v) to v.
///
/// This is the inverse of `identity_option`. Use this when you need to pass
/// MoonBit Option values back to JavaScript APIs.
///
/// # Usage
///
/// - `Some(42) |> from_option` returns Js(42)
/// - `None |> from_option` returns Js(null)
/// - Use with match to set optional properties on objects
///
/// # See Also
/// - `identity_option(Js) -> A?` - Inverse conversion (Js to Option)
pub fn[A] from_option(opt : A?) -> Any {
  match opt {
    Some(v) => identity(v)
    None => null()
  }
}
