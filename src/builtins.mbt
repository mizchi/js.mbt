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
/// let obj = new_empty_object()
/// obj.set("name", "Alice")
/// obj.set("age", 30)
/// ```
pub fn new_empty_object() -> Val {
  ffi_new_empty_object()
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
/// let obj = from_builtin_map(map)
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_builtin_map(map : @builtin.Map[String, Val]) -> Val {
  let obj = new_empty_object()
  for k, v in map {
    let v : Val = Js::to_js(v)
    obj.set(k, v)
  }
  obj
}

///|
/// Convert a MoonBit Array to a JavaScript array.
///
/// # Safety
///
/// This uses `unsafe_cast` to directly convert the array representation.
///
/// # Parameters
///
/// - `arr`: A MoonBit Array of any type
///
/// # Returns
///
/// A JavaScript array with the same elements
///
/// # Example
///
/// ```moonbit
/// let arr = [1, 2, 3, 4, 5]
/// let js_arr = from_builtin_array(arr)
/// // JavaScript: [1, 2, 3, 4, 5]
/// ```
pub fn[T] from_builtin_array(arr : @builtin.Array[T]) -> Val {
  arr |> unsafe_cast
}

///|
/// Create a new empty JavaScript array.
///
/// Equivalent to JavaScript's `[]` or `new Array()`.
///
/// # Returns
///
/// A new empty array as a Val
///
/// # Example
///
/// ```moonbit
/// let arr = new_empty_array()
/// arr.set(0, "first")
/// arr.set(1, "second")
/// ```
pub fn new_empty_array() -> Val {
  ffi_new_empty_array()
}

///|
/// Get the global object (globalThis in JavaScript).
///
/// In browsers, this is `window`. In Node.js, this is `global`.
///
/// # Returns
///
/// The global object as a Val
///
/// # Example
///
/// ```moonbit skip
/// let global = global_this()
/// let console = global.get("console")
/// console.call_method("log", ["Hello, World!"]) |> ignore
/// ```
pub fn global_this() -> Val {
  ffi_global_this()
}

///|
/// Get the JavaScript `null` value.
///
/// # Returns
///
/// The null value as a Val
///
/// # Example
///
/// ```moonbit
/// let n = null_()
/// assert_true(@js.is_null(n))
/// ```
pub fn null_() -> Val {
  ffi_null()
}

///|
/// Convert an array-like or iterable JavaScript object to an Array.
///
/// Wraps JavaScript's `Array.from()` function.
///
/// # Parameters
///
/// - `v`: An array-like or iterable object (e.g., NodeList, HTMLCollection)
///
/// # Returns
///
/// An Array[Val] containing the elements
///
/// # Example
///
/// ```moonbit no-check
/// // Convert a NodeList to an Array
/// let node_list = element.child_nodes()  // Returns NodeList
/// let children = array_from(node_list)   // Returns Array[Val]
/// ```
pub fn array_from(v : Val) -> Array[Val] {
  ffi_array_from(v)
}

///|
/// Create a new JavaScript Symbol with a description.
///
/// # Parameters
///
/// - `name`: The description for the symbol
///
/// # Returns
///
/// A new Symbol
///
/// # Example
///
/// ```moonbit
/// let sym = symbol("mySymbol")
/// let obj = new_empty_object()
/// obj.set(sym, "value")
/// ```
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
/// Get the well-known Symbol.iterator symbol.
///
/// Used to make objects iterable in JavaScript.
///
/// # Returns
///
/// The Symbol.iterator symbol
///
/// # Example
///
/// ```moonbit
/// let iter_sym = symbol_iterator()
/// // Use to implement custom iterators
/// ```
pub fn symbol_iterator() -> Symbol {
  ffi_symbol_iterator()
}

///|
/// Get the well-known Symbol.dispose symbol.
///
/// Used for explicit resource management (using statement).
///
/// # Returns
///
/// The Symbol.dispose symbol
pub fn symbol_dispose() -> Symbol {
  ffi_symbol_dispose()
}

///|
/// Get the well-known Symbol.asyncDispose symbol.
///
/// Used for asynchronous resource management.
///
/// # Returns
///
/// The Symbol.asyncDispose symbol
pub fn symbol_async_dispose() -> Symbol {
  ffi_symbol_async_dispose()
}

///|
/// Create a new JavaScript Error object.
///
/// Equivalent to JavaScript's `new Error(message, { cause })`.
///
/// # Parameters
///
/// - `message`: The error message
/// - `cause`: Optional cause of the error (another ErrorObject)
///
/// # Returns
///
/// A new ErrorObject
///
/// # Example
///
/// ```moonbit
/// let error = new_error("Something went wrong")
/// let caused_error = new_error("Failed operation", cause=error)
/// ```
pub fn new_error(message : String, cause? : ErrorObject) -> ErrorObject {
  let args : Array[Val] = if cause is Some(cause) {
    [js(message), from_builtin_map({ "cause": cause |> unsafe_cast() })]
  } else {
    [js(message)]
  }
  ffi_new_error(args)
}

///|
fn[T] is_builtin_trait(v : T) -> Bool {
  let v : Val = v |> unsafe_cast
  v.has_own_property("self") && v.has_own_property("method_0")
}

///|
test "is_builtin_trait" {
  let show : &Show = "hello"
  assert_true(is_builtin_trait(show))
}
