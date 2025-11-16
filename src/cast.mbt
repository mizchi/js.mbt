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
// pub fn[T : Js] js(v : T) -> Val {
//   unsafe_cast(v.to_js())
// }

pub fn[T] js(v : T) -> Val {
  unsafe_cast(v)
}

///|
/// Safely convert a MoonBit value that implements the Js trait to a JavaScript Val.
// pub fn[T : Js] js_safe(v : T) -> Val = "%identity"

///|
/// Unsafely cast a value from one type to another.
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
pub fn[T : Js] from_array(v : Array[T]) -> Val {
  unsafe_cast(v.map(_.to_js()))
}

///|
/// Convert a MoonBit Map to a JavaScript object.
///
/// Each key-value pair in the map becomes a property on the resulting object.
///
/// # Parameters
///
/// - `map`: A MoonBit Map with String keys and Val values
///
/// # Returns
///
/// A JavaScript object with the same properties
///
/// # Example
///
/// ```moonbit
/// let map = { "name": js("Alice"), "age": js(30) }
/// let obj = from_map(map)
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_map(map : Map[String, Val]) -> Val {
  let obj = new_empty_object()
  for k, v in map {
    let v : Val = Js::to_js(v)
    obj.set(k, v)
  }
  obj
}

///|
pub fn[R] from_fn0(f : () -> R) -> Val {
  unsafe_cast(f)
}

///|
pub fn[A, R] from_fn1(f : (A) -> R) -> Val {
  unsafe_cast(f)
}

///|
pub fn[A, B, R] from_fn2(f : (A, B) -> R) -> Val {
  unsafe_cast(f)
}

///|
pub fn[A, B, C, R] from_fn3(f : (A, B, C) -> R) -> Val {
  unsafe_cast(f)
}

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
/// This is more type-safe than using `from_array()` because
/// it ensures each element can be safely converted to JavaScript.
pub impl[T : Js] Js for Array[T] with to_js(self) -> Val {
  js(self.map(_.to_js()))
}

///|
pub impl[T : Js] Js for Map[String, T] with to_js(self) -> Val {
  let v = new_empty_object()
  for k, val in self {
    v.set(k, val.to_js())
  }
  v
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
