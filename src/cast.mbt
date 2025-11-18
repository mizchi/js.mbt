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
/// let num = js(42)            // Int -> Js
/// let str = js("hello")       // String -> Js
/// let bool = js(true)         // Bool -> Js
/// let arr = js([1, 2, 3])     // Array -> Js
/// ```
///
#deprecated
pub fn[T] js(v : T) -> Js {
  unsafe_cast(v)
}

///|
/// Cast any MoonBit Js-implementing type to a JavaScript Val safely.
pub fn safe_js(a : &JsImpl) -> Js {
  unsafe_cast(a.to_js())
}

///|
/// Unsafely cast a value from one type to another.
pub fn[A, B] unsafe_cast(a : A) -> B = "%identity"

///|
/// Safely convert a JavaScript Val to an Option type.
/// Without check, Moonbit FFI will touch (null).toString() and crash.
pub fn[A] unsafe_option(v : Js) -> A? {
  if v.is_some() {
    Some(unsafe_cast(v))
  } else {
    None
  }
}

///|
/// Cast a MoonBit Array to a JavaScript array.
pub fn[T : JsImpl] from_array(v : Array[T]) -> Js {
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
pub fn from_map(map : Map[String, Js]) -> Js {
  let obj = Object::new()
  for k, v in map {
    let v : Js = JsImpl::to_js(v)
    obj.set(k, v)
  }
  obj.to_js()
}

///|
/// Cast a MoonBit function with 0 arguments to a JavaScript function Val.
pub fn[R] from_fn0(f : () -> R) -> Js {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 1 argument to a JavaScript function Val.
pub fn[A, R] from_fn1(f : (A) -> R) -> Js {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 2 arguments to a JavaScript function Val.
pub fn[A, B, R] from_fn2(f : (A, B) -> R) -> Js {
  unsafe_cast(f)
}

///|
pub fn[A, B] from_tuple2(t : (A, B)) -> Js {
  let arr : Array[Js] = [t.0 |> unsafe_cast, t.1 |> unsafe_cast]
  unsafe_cast(arr)
}

///|
pub fn[A, B, C] from_tuple3(t : (A, B, C)) -> Js {
  let arr : Array[Js] = [
    t.0 |> unsafe_cast,
    t.1 |> unsafe_cast,
    t.2 |> unsafe_cast,
  ]
  unsafe_cast(arr)
}

///|
/// Cast a MoonBit function with 3 arguments to a JavaScript function Val.
pub fn[A, B, C, R] from_fn3(f : (A, B, C) -> R) -> Js {
  unsafe_cast(f)
}

///|
/// Identity implementation for Js.
pub impl JsImpl for Js

///|
pub impl JsImpl for String

///|
pub impl JsImpl for Double

///|
pub impl JsImpl for Float

///|
pub impl JsImpl for Int

///|
/// Convert a MoonBit Bool to a JavaScript boolean value.
pub impl JsImpl for Bool

///|
/// Convert a MoonBit UInt to a JavaScript number value.
pub impl JsImpl for UInt

///|
pub impl JsImpl for Unit

///|
/// Convert an Array of Js-implementing types to a JavaScript array.
pub impl JsImpl for Array[&JsImpl] with to_js(self) -> Js {
  from_array(self)
}

///|
pub impl JsImpl for Map[String, &JsImpl] with to_js(self) -> Js {
  let v = Object::new()
  for k, val in self {
    v.set(k, val.to_js())
  }
  v.to_js()
}

///|
/// Convert an Option to a JavaScript value.
pub impl[T] JsImpl for T? with to_js(self) -> Js {
  unsafe_cast(self)
}
