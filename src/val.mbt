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
pub impl Show for Val with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for Val with to_string(self) {
  if is_array(self) {
    return ffi_json_stringify(self, undefined(), undefined())
  }
  if is_object(self) {
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
/// let obj = @js.Object::new()
/// obj.to_js().set_if_exists("name", Some("Alice"))     // Sets property
/// obj.to_js().set_if_exists("city", Some(undefined())) // Does nothing
/// ```
pub fn[T : Js] Val::set_if_exists(
  self : Val,
  key : &PropertyKey,
  value : T?,
) -> Unit {
  guard value is Some(val) else { return }
  let val = val.to_js()
  if is_undefined(val) {
    return
  }
  ffi_set(self, key.to_key() |> unsafe_cast, val.to_js())
}

///|
pub fn[T : Js] property_is_enumerable(v : T, k : String) -> Bool {
  ffi_property_is_enumerable(v.to_js(), k)
}

///|
pub fn[T : Js] is_array(v : T) -> Bool {
  ffi_is_array(v.to_js())
}

///|
pub fn[T : Js] is_object(v : T) -> Bool {
  ffi_is_object(v.to_js())
}

///|
extern "js" fn ffi_is_null(v : Val) -> Bool =
  #| (v) => v === null

///|
pub fn[T : Js] is_null(v : T) -> Bool {
  ffi_is_null(v.to_js())
}

///|
pub extern "js" fn ffi_is_undefined(v : Val) -> Bool =
  #| (v) => v === undefined

///|
pub fn[T : Js] is_undefined(v : T) -> Bool {
  ffi_is_undefined(v.to_js())
}

///|
pub fn[T : Js] is_nan(v : T) -> Bool {
  ffi_is_nan(v.to_js())
}

///|
pub fn[T : Js] instance_of(v : T, cls : T) -> Bool {
  ffi_instance_of(v.to_js(), cls.to_js())
}

///|
pub fn[T : Js] type_of(v : T) -> String {
  ffi_type_of(v.to_js())
}

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
#deprecated
pub fn Val::is_some(self : Self) -> Bool {
  !is_undefined(self) && !is_null(self)
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
  is_undefined(self) || is_null(self)
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
