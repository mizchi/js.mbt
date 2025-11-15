///|
/// Represents an unsafe JavaScript value.
///
/// `Val` is the core type for FFI operations between MoonBit and JavaScript.
/// It can hold any JavaScript value including primitives, objects, arrays, functions, etc.
///
/// # Safety
///
/// This type bypasses MoonBit's type system when converting to/from JavaScript values.
/// Users must ensure type correctness manually.
///
/// # Example
///
/// ```moonbit
/// let num = js(42)                 // MoonBit Int -> Val
/// let str = js("hello")            // MoonBit String -> Val
/// let val : Int = unsafe_cast(num) // Val -> MoonBit Int (unsafe)
/// ```
#external
pub type Val

///|
/// Convert any MoonBit value to a JavaScript Val.
///
/// # Safety
///
/// This function performs **no type checking**. It's a direct identity cast
/// that wraps the value as a JavaScript Val. The value's representation in
/// JavaScript depends on the MoonBit type:
///
/// - Primitives (Int, Double, String, Bool) map directly to JS primitives
/// - Structs become JS objects
/// - Arrays become JS arrays
/// - Functions become JS functions
///
/// # Parameters
///
/// - `v`: The MoonBit value to convert
///
/// # Returns
///
/// A Val representing the JavaScript value
///
/// # Example
///
/// ```moonbit
/// let num = js(42)            // Int -> Val
/// let str = js("hello")       // String -> Val
/// let bool = js(true)         // Bool -> Val
/// let arr = js([1, 2, 3])     // Array -> Val
/// ```
///
/// # Note
///
/// For type-safe conversion, prefer using the `Js` trait via `to_js()`.
pub fn[T] js(v : T) -> Val = "%identity"

///|
/// Unsafely cast between any two types without validation.
///
/// # Safety
///
/// This is the most dangerous cast function. It performs **absolutely no type checking**
/// and will blindly reinterpret type A as type B. This can lead to:
/// - Memory corruption
/// - Segmentation faults
/// - Undefined behavior
/// - Silent data corruption
///
/// **Use this only when you are absolutely certain about the type compatibility.**
///
/// # Parameters
///
/// - `a`: The value to cast from type A
///
/// # Returns
///
/// The value reinterpreted as type B (without any validation)
///
/// # Example
///
/// ```moonbit
/// // Converting between compatible FFI types
/// let val : Val = js(42)
/// let sym : Symbol = unsafe_cast(symbol("test"))
/// let sym_val : Val = unsafe_cast(sym)  // Symbol -> Val
///
/// // Dangerous: converting between incompatible types
/// let num = 42
/// let str : String = unsafe_cast(num)  // UNSAFE! Will cause errors
/// ```
///
/// # When to Use
///
/// - Converting between known-compatible FFI types (e.g., ErrorObject -> Val)
/// - Working with trait objects where the underlying type is known
/// - Performance-critical code where type safety is guaranteed by other means
///
/// # Alternatives
///
/// - Use `cast()` for Val to MoonBit type conversion
/// - Use `js()` for MoonBit to Val conversion
/// - Use `Js` trait's `to_js()` for type-safe conversion
pub fn[A, B] unsafe_cast(a : A) -> B = "%identity"

///|
/// Safely convert a JavaScript Val to an Option type.
/// Without check, Moonbit FFI will touch (null).toString() and crash.
pub fn[A] to_option(v : Val) -> A? {
  if v.is_some() {
    Some(unsafe_cast(v))
  } else {
    None
  }
}

///|
pub impl Show for Val with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for Val with to_string(self) {
  if self.is_array() {
    return ffi_json_stringify(self, undefined(), undefined())
  }
  if self.is_object() {
    return ffi_json_stringify(self, undefined(), undefined())
  }
  ffi_to_string(self)
}

///|
pub impl Eq for Val with equal(self, other) -> Bool {
  ffi_object_is(self, other)
}

///|
/// Conditionally set a property value if the value exists and is not undefined.
///
/// This is useful for optional parameters or conditional property assignment.
///
/// # Parameters
///
/// - `self`: The object to set the property on
/// - `key`: The property key
/// - `value`: Optional value to set
///
/// # Behavior
///
/// - Does nothing if `value` is `None`
/// - Does nothing if `value` is `Some(undefined())`
/// - Sets the property if `value` is `Some(v)` where v is defined
///
/// # Example
///
/// ```moonbit
/// let obj = new_empty_object()
/// obj.set_if_exists("name", Some("Alice"))     // Sets property
/// obj.set_if_exists("city", Some(undefined())) // Does nothing
/// ```
pub fn[T : Js] Val::set_if_exists(
  self : Val,
  key : &PropertyKey,
  value : T?,
) -> Unit {
  guard value is Some(val) else { return }
  let val = val.to_js()
  if val.is_undefined() {
    return
  }
  ffi_set(self, key.to_key() |> unsafe_cast, val.to_js())
}

///|
pub fn Val::delete(self : Self, k : String) -> Unit {
  ffi_delete(self, k)
}

///|
/// Check if an object has a property as its own (not inherited).
///
/// Equivalent to JavaScript's `obj.hasOwnProperty(k)`.
///
/// # Parameters
///
/// - `self`: The object to check
/// - `k`: The property key
///
/// # Returns
///
/// `true` if the object has the property as its own, `false` otherwise
///
/// # Example
///
/// ```moonbit
/// let obj = new_empty_object()
/// obj.set("name", "Alice")
/// assert_true(obj.has_own_property("name"))      // true
/// assert_false(obj.has_own_property("toString"))  // false (inherited)
/// ```
pub fn Val::has_own_property(self : Self, k : String) -> Bool {
  ffi_has_own_property(self, k)
}

///|
pub fn Val::property_is_enumerable(self : Self, k : String) -> Bool {
  ffi_property_is_enumerable(self, k)
}

///|
pub extern "js" fn Val::is_array(self : Self) -> Bool =
  #| (v) => Array.isArray(v)

///|
pub extern "js" fn Val::is_object(self : Self) -> Bool =
  #| (v) => typeof v === "object" && v !== null

///|
pub extern "js" fn Val::is_null(self : Self) -> Bool =
  #| (v) => v === null

///|
pub extern "js" fn Val::is_undefined(self : Self) -> Bool =
  #| (v) => v === undefined

///|
pub extern "js" fn Val::is_nan(self : Self) -> Bool =
  #| (v) => Number.isNaN(v)

///|
pub extern "js" fn Val::instance_of(self : Self, cls : Val) -> Bool =
  #| (v, cls) => v instanceof cls

///|
pub extern "js" fn Val::type_of(self : Val) -> String =
  #| (v) => typeof v

///|
/// Check if a value is neither undefined nor null.
///
/// # Returns
///
/// `true` if the value is defined and not null, `false` otherwise
///
/// # Example
///
/// ```moonbit
/// assert_true(js(42).is_some())        // true
/// assert_true(js("hello").is_some())   // true
/// assert_false(undefined().is_some())   // false
/// assert_false(null_().is_some())       // false
/// ```
pub fn Val::is_some(self : Self) -> Bool {
  !self.is_undefined() && !self.is_null()
}

///|
/// Check if a value is undefined or null.
///
/// # Returns
///
/// `true` if the value is undefined or null, `false` otherwise
///
/// # Example
///
/// ```moonbit
/// assert_true(undefined().is_none())   // true
/// assert_true(null_().is_none())       // true
/// assert_false(js(42).is_none())        // false
/// assert_false(js("hello").is_none())   // false
/// ```
pub fn Val::is_none(self : Self) -> Bool {
  self.is_undefined() || self.is_null()
}

///|
/// Create a new instance of a JavaScript class.
///
/// Equivalent to JavaScript's `new Class(...args)` syntax.
///
/// # Parameters
///
/// - `cls`: The constructor function/class
/// - `args`: Array of constructor arguments
///
/// # Returns
///
/// A new instance of the class as a Val
///
/// # Example
///
/// ```moonbit
/// let date_constructor = global_this().get("Date")
/// let date = new_(date_constructor, [2024, 0, 1])
/// // Creates: new Date(2024, 0, 1)
/// ```
pub fn new_(cls : Val, args : Array[&Js]) -> Val {
  ffi_new(cls, args.map(_.to_js()))
}

///|
/// Log a value to the console (JavaScript console.log).
///
/// This is a convenience function for debugging.
///
/// # Parameters
///
/// - `v`: The value to log (any type)
///
/// # Example
///
/// ```moonbit skip
/// log("Hello, World!")
/// log(42)
/// log([1, 2, 3])
/// ```
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast]) |> ignore
}
