///|
/// key for js object access
pub trait PropertyKey {
  to_key(Self) -> Val = _
}

///|
impl PropertyKey with to_key(self) -> Val {
  self |> unsafe_cast
}

///|
pub impl PropertyKey for String

///|
pub impl PropertyKey for Int

///|
pub impl PropertyKey for Symbol

///|
#external
pub type Object

///|
pub impl Js for Object

///|
pub fn Object::new() -> Self {
  ffi_new_empty_object() |> unsafe_cast
}

///|
/// Create a new empty JavaScript object.
///
/// Equivalent to JavaScript's `{}` or `new Object()`.
///
/// # Returns
///
/// A new empty object as a Val
///
/// # Example
///
/// ```moonbit
/// let obj = @js.Object::new()
/// obj.set("name", "Alice")
/// obj.set("age", 30)
/// ```
// #deprecated("Use Object::new() instead")
// pub fn new_empty_object() -> Val {
//   ffi_new_empty_object()
// }

///|
/// Get all own enumerable property names of a JavaScript object.
///
/// Equivalent to JavaScript's `Object.keys(obj)`.
///
/// # Parameters
///
/// - `v`: The object to get keys from
///
/// # Returns
///
/// An array of property names (strings)
///
/// # Example
///
/// ```moonbit skip
/// let obj = @js.Object::new()
/// obj.set("name", "Alice")
/// obj.set("age", 30)
/// let keys = object_keys(obj)
/// // keys == ["name", "age"] (order not guaranteed)
/// ```
pub fn Object::keys(v : &Js) -> Array[String] {
  ffi_object_keys(v.to_js())
}

///|
/// Get all own enumerable property values of a JavaScript object.
///
/// Equivalent to JavaScript's `Object.values(obj)`.
///
/// # Parameters
///
/// - `v`: The object to get values from
///
/// # Returns
///
/// An array of property values
///
/// # Example
///
/// ```moonbit
/// let obj = @js.Object::new()
/// obj.set("name", "Alice")
/// obj.set("age", 30)
/// let values = Object::values(obj.to_js())
/// // values contains [Val("Alice"), Val(30)] (order not guaranteed)
/// ```
pub fn Object::values(v : &Js) -> Array[Val] {
  ffi_object_values(v.to_js())
}

///|
/// Get all own enumerable property key-value pairs of a JavaScript object.
///
/// Equivalent to JavaScript's `Object.entries(obj)`.
///
/// # Parameters
///
/// - `v`: The object to get entries from
///
/// # Returns
///
/// An array of (key, value) tuples
///
/// # Example
///
/// ```moonbit skip
/// let obj = @js.Object::new()
/// obj.set("name", "Alice")
/// obj.set("age", 30)
/// let entries = object_entries(obj)
/// // entries == [("name", Val("Alice")), ("age", Val(30))] (order not guaranteed)
/// for entry in entries {
///   let (key, value) = entry
///   log(key)
///   log(value)
/// }
/// ```
pub fn Object::entries(v : &Js) -> Array[(String, Val)] {
  let entries = ffi_object_entries(v.to_js())
  entries.map(entry => (unsafe_cast(entry.get(0)), unsafe_cast(entry.get(1))))
}

///|
/// Copy all enumerable own properties from source to target object.
///
/// Equivalent to JavaScript's `Object.assign(target, source)`.
///
/// # Parameters
///
/// - `target`: The target object to copy properties to
/// - `source`: The source object to copy properties from
///
/// # Returns
///
/// The modified target object
///
/// # Example
///
/// ```moonbit
/// let target = @js.Object::new()
/// target.set("a", 1)
/// let source = @js.Object::new()
/// source.set("b", 2)
/// source.set("c", 3)
/// let result = Object::assign(target, source)
/// // result.a == 1, result.b == 2, result.c == 3
/// ```
///
/// # Note
///
/// This mutates the target object and returns it.
pub fn Object::assign(target : &Js, source : &Js) -> Val {
  ffi_object_assign(target.to_js(), source.to_js())
}
