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
/// # Example
///
/// ```moonbit
/// let num = js(42)            // Int -> Val
/// let str = js("hello")       // String -> Val
/// let bool = js(true)         // Bool -> Val
/// let arr = js([1, 2, 3])     // Array -> Val
/// ```
///
#deprecated
pub fn[T] js(v : T) -> Val {
  unsafe_cast(v)
}

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
/// # Example
///
/// ```moonbit
/// let map = { "name": js("Alice"), "age": js(30) }
/// let obj = from_map(map)
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_map(map : Map[String, Val]) -> Val {
  let obj = Object::new()
  for k, v in map {
    let v : Val = Js::to_js(v)
    obj.set(k, v)
  }
  obj.to_js()
}

///|
/// Cast a MoonBit function with 0 arguments to a JavaScript function Val.
pub fn[R] from_fn0(f : () -> R) -> Val {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 1 argument to a JavaScript function Val.
pub fn[A, R] from_fn1(f : (A) -> R) -> Val {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 2 arguments to a JavaScript function Val.
pub fn[A, B, R] from_fn2(f : (A, B) -> R) -> Val {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 3 arguments to a JavaScript function Val.
pub fn[A, B, C, R] from_fn3(f : (A, B, C) -> R) -> Val {
  unsafe_cast(f)
}

///|
/// Identity implementation for Val.
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
pub impl Js for Bool

///|
/// Convert a MoonBit UInt to a JavaScript number value.
pub impl Js for UInt

///|
/// Convert an Array of Js-implementing types to a JavaScript array.
pub impl[T : Js] Js for Array[T] with to_js(self) -> Val {
  js(self.map(_.to_js()))
}

///|
pub impl[T : Js] Js for Map[String, T] with to_js(self) -> Val {
  let v = Object::new()
  for k, val in self {
    v.set(k, val.to_js())
  }
  v.to_js()
}

///|
/// Convert an Option to a JavaScript value.
pub impl[T] Js for T? with to_js(self) -> Val {
  js(self)
}
