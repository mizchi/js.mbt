///|
/// Trait for types that can be safely converted to JavaScript values.
///
/// This trait provides a type-safe way to convert MoonBit values to JavaScript
/// values (Val). Unlike the unsafe `js()` function, implementations of this trait
/// should ensure the conversion is well-defined and safe.
///
/// # Implementations
///
/// The trait is implemented for:
/// - Primitive types: `Int`, `Double`, `Float`, `Bool`, `String`
/// - `Val` itself (identity conversion)
/// - `Array[&Js]` (recursively converts elements)
/// - `Option[T]` where T implements Js (None becomes undefined)
///
/// # Example
///
/// ```moonbit
/// // Using the trait explicitly
/// let val : Val = Js::to_js("hello")
/// let num : Val = Js::to_js(42)
///
/// // Using with polymorphic functions
/// fn create_object(name : &Js, age : &Js) -> Val {
///   let obj = new_empty_object()
///   obj.set("name", name)
///   obj.set("age", age)
///   obj
/// }
/// let obj = create_object("Alice", 30)  // Strings and Ints implement Js
/// ```
///
/// # Custom Implementations
///
/// You can implement this trait for your own types to control
/// how they are converted to JavaScript values.
pub(open) trait Js {
  to_js(Self) -> Val
}

///|
/// Identity implementation for Val.
///
/// Since Val already represents a JavaScript value, this just returns itself.
pub impl Js for Val with to_js(self) -> Val {
  self
}

///|
/// Convert a MoonBit String to a JavaScript string value.
///
/// # Example
///
/// ```moonbit
/// let val = Js::to_js("hello")
/// // JavaScript: "hello"
/// ```
pub impl Js for String with to_js(self) -> Val {
  js(self)
}

///|
/// Convert a MoonBit Double to a JavaScript number value.
///
/// # Example
///
/// ```moonbit
/// let val = Js::to_js(3.14)
/// // JavaScript: 3.14
/// ```
pub impl Js for Double with to_js(self) -> Val {
  js(self)
}

///|
/// Convert a MoonBit Float to a JavaScript number value.
///
/// Float is first converted to Double, then to JavaScript number.
///
/// # Example
///
/// ```moonbit
/// let val = Js::to_js(2.5)
/// // JavaScript: 2.5
/// ```
pub impl Js for Float with to_js(self) -> Val {
  js(self.to_double())
}

///|
/// Convert a MoonBit Int to a JavaScript number value.
///
/// # Example
///
/// ```moonbit
/// let val = Js::to_js(42)
/// // JavaScript: 42
/// ```
pub impl Js for Int with to_js(self) -> Val {
  js(self)
}

///|
/// Convert a MoonBit Bool to a JavaScript boolean value.
///
/// # Example
///
/// ```moonbit
/// let val = Js::to_js(true)
/// // JavaScript: true
/// ```
pub impl Js for Bool with to_js(self) -> Val {
  js(self)
}

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
pub impl Js for UInt with to_js(self) -> Val {
  js(self.to_int())
}

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
pub impl Js for Array[&Js] with to_js(self) -> Val {
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
