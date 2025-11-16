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
pub fn[T : Js] cast_array(a : Array[T]) -> Val = "%identity"

///|
pub fn[R] cast_fn0(f : () -> R) -> Val = "%identity"

///|
pub fn[A, R] cast_fn1(f : (A) -> R) -> Val = "%identity"

///|
pub fn[A, B, R] cast_fn2(f : (A, B) -> R) -> Val = "%identity"

///|
pub fn[A, B, C, R] cast_fn3(f : (A, B, C) -> R) -> Val = "%identity"
