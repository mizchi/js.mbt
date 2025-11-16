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

///|
/// Identity implementation for Val.
///
/// Since Val already represents a JavaScript value, this just returns itself.
pub impl Js for Val

///|
pub impl Js for String

///|
pub impl Js for Double

///|
pub impl Js for Float

///|
pub impl Js for Int

///|
/// Convert a MoonBit Bool to a JavaScript boolean value.
///
/// # Example
///
/// ```moonbit
/// let val = Js::to_js(true)
/// // JavaScript: true
/// ```
pub impl Js for Bool

///|
/// Convert a MoonBit UInt to a JavaScript number value.
///
/// UInt is first converted to Int, then to JavaScript number.
///
/// # Example
///
/// ```moonbit
/// let u : UInt = 42
/// let val = Js::to_js(u)
/// // JavaScript: 42
/// ```
pub impl Js for UInt

///|
/// Convert an Array of Js-implementing types to a JavaScript array.
///
/// Each element in the array is converted using its `to_js()` implementation.
///
/// # Example
///
/// ```moonbit
/// let arr : Array[&Js] = ["hello", 42, true, 3.14]
/// let val = Js::to_js(arr)
/// // JavaScript: ["hello", 42, true, 3.14]
/// ```
///
/// # Type Safety
///
/// This is more type-safe than using `from_builtin_array()` because
/// it ensures each element can be safely converted to JavaScript.
pub impl[T : Js] Js for Array[T] with to_js(self) -> Val {
  js(self.map(_.to_js()))
}

///|
/// Convert an Option to a JavaScript value.
///
/// # Behavior
///
/// - `Some(value)` is converted to the JavaScript representation of the value
/// - `None` is converted to JavaScript `undefined`
///
/// # Example
///
/// ```moonbit
/// let some_val : Int? = Some(42)
/// let val1 = Js::to_js(some_val)
/// // JavaScript: 42
///
/// let none_val : Int? = None
/// let val2 = Js::to_js(none_val)
/// // JavaScript: undefined
/// ```
///
/// # Note
///
/// This is different from JavaScript's `null`. If you need `null`,
/// use `null_()` explicitly.
pub impl[T] Js for T? with to_js(self) -> Val {
  js(self)
}
