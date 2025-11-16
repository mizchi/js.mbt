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
pub fn object_keys(v : Val) -> Array[String] {
  ffi_object_keys(v)
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
/// let values = object_values(obj.to_js())
/// // values contains [Val("Alice"), Val(30)] (order not guaranteed)
/// ```
pub fn object_values(v : Val) -> Array[Val] {
  ffi_object_values(v)
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
pub fn object_entries(v : Val) -> Array[(String, Val)] {
  let entries = ffi_object_entries(v)
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
/// let result = object_assign(target.to_js(), source.to_js())
/// // result.a == 1, result.b == 2, result.c == 3
/// ```
///
/// # Note
///
/// This mutates the target object and returns it.
pub fn object_assign(target : Val, source : Val) -> Val {
  ffi_object_assign(target, source)
}
