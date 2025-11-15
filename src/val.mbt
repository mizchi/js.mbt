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
/// Safely cast a JavaScript value to an Option type.
///
/// This is a safer alternative to `cast()` that checks if the value is `null`
/// or `undefined` before casting.
///
/// # Parameters
///
/// - `self`: The Val to cast
///
/// # Returns
///
/// - `Some(value)` if the Val is not null or undefined
/// - `None` if the Val is null or undefined
///
/// # Example
///
/// ```moonbit
/// let some_val = js("hello")
/// let result : String? = some_val.cast_option()
/// // result == Some("hello")
///
/// let none_val = undefined()
/// let result : String? = none_val.cast_option()
/// // result == None
/// ```
///
/// # Note
///
/// This still performs an unsafe cast for the inner value, but at least
/// handles the null/undefined cases safely.
pub fn[T] Val::cast_option(self : Val) -> T? {
  if self.is_some() {
    Some(unsafe_cast(self))
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
/// Get a property value from a JavaScript object.
///
/// Equivalent to JavaScript's `obj[key]` or `obj.key` syntax.
///
/// # Parameters
///
/// - `self`: The object to get the property from
/// - `key`: The property key (String, Int, or Symbol)
///
/// # Returns
///
/// The property value as a Val, or `undefined` if the property doesn't exist
///
/// # Example
///
/// ```moonbit
/// let obj = new_empty_object()
/// obj.set("name", "Alice")
/// let name = obj.get("name")        // Using alias syntax: obj["name"]
/// let age = obj.get("age")          // Returns undefined
/// ```
#alias("_[_]")
pub fn Val::get(self : Val, key : &PropertyKey) -> Val {
  ffi_get(self, key.to_key() |> unsafe_cast)
}

///|
/// Set a property value on a JavaScript object.
///
/// Equivalent to JavaScript's `obj[key] = value` or `obj.key = value` syntax.
///
/// # Parameters
///
/// - `self`: The object to set the property on
/// - `key`: The property key (String, Int, or Symbol)
/// - `value`: The value to set (must implement Js trait)
///
/// # Example
///
/// ```moonbit
/// let obj = new_empty_object()
/// obj.set("name", "Alice")          // Using alias syntax: obj["name"] = "Alice"
/// obj.set("age", 30)
/// obj.set(0, "first")               // Array index access
/// ```
#alias("_[_]=_")
pub fn Val::set(self : Val, key : &PropertyKey, value : &Js) -> Unit {
  ffi_set(self, key.to_key() |> unsafe_cast, value.to_js())
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
test {
  let obj = new_empty_object()
  let undef : Val? = Some(undefined())
  obj.set_if_exists("a", undef)
  let none_val : Val? = None
  obj.set_if_exists("b", none_val)
  obj.set_if_exists("c", Some(js(42)))
  assert_true(obj.get("a").is_undefined())

  // assert_eq(unsafe_cast(obj.get("a")), 42)
  // obj.set_if_exists("b", None)
  // assert_true(obj.get("b").is_undefined())
  // obj.set_if_exists("c", Some(undefined()))
  // assert_true(obj.get("c").is_undefined())
}

///|
/// Call a JavaScript function.
///
/// Equivalent to JavaScript's `func(...args)` syntax.
///
/// # Parameters
///
/// - `self`: The function to call
/// - `args`: Array of arguments (must implement Js trait)
///
/// # Returns
///
/// The return value of the function as a Val
///
/// # Example
///
/// ```moonbit
/// let parse_int = global_this().get("parseInt")
/// let result = parse_int.invoke_self(["42"])
/// let num : Int = unsafe_cast(result)  // 42
/// ```
pub fn Val::invoke_self(self : Self, args : Array[&Js]) -> Val {
  ffi_call(self, args.map(_.to_js()))
}

///|
/// Call a JavaScript function with error handling.
///
/// Like `call()` but converts JavaScript exceptions into MoonBit's error handling.
///
/// # Parameters
///
/// - `self`: The function to call
/// - `args`: Array of arguments
///
/// # Returns
///
/// The return value of the function as a Val
///
/// # Raises
///
/// Converts JavaScript exceptions to MoonBit errors
///
/// # Example
///
/// ```moonbit no-check
/// let func = js(some_js_function)
/// let result = func.call_raise(["arg1", "arg2"])!  // Handle with !
/// ```
#deprecated("Use impl Js::invoke_self_throwable instead")
pub fn Val::invoke_self_with_raise(self : Self, args : Array[&Js]) -> Val raise {
  throwable(() => self.invoke_self(args.map(_.to_js())))
}

///|
/// Call a method on a JavaScript object.
///
/// Equivalent to JavaScript's `obj.method(...args)` or `obj[key](...args)` syntax.
///
/// # Parameters
///
/// - `self`: The object to call the method on
/// - `key`: The method name
/// - `args`: Array of arguments
///
/// # Returns
///
/// The return value of the method as a Val
///
/// # Example
///
/// ```moonbit
/// let arr = from_builtin_array([1, 2, 3])
/// let result = arr.invoke("push", [4])
/// // arr is now [1, 2, 3, 4]
/// ```
// pub fn Val::invoke(self : Val, key : &PropertyKey, args : Array[&Js]) -> Val {
//   ffi_call_method(self, key.to_key() |> unsafe_cast, args.map(_.to_js()))
// }

///|
// #deprecated("Use impl Js::invoke_throwable instead")
// pub fn Val::invoke_with_raise(
//   self : Val,
//   key : String,
//   args : Array[&Js],
// ) -> Val raise {
//   throwable(() => ffi_call_method(self, key, args.map(_.to_js())))
// }

///|
/// Delete a property from a JavaScript object.
///
/// Equivalent to JavaScript's `delete obj[k]` syntax.
///
/// # Parameters
///
/// - `self`: The object to delete the property from
/// - `k`: The property key to delete
///
/// # Example
///
/// ```moonbit
/// let obj = new_empty_object()
/// obj.set("name", "Alice")
/// obj.delete("name") |> ignore
/// // obj no longer has "name" property
/// ```
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
