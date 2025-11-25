// This module provides conversion utilities between MoonBit and JavaScript types.
//
// Main functions:
// - from_array() - Convert MoonBit Array to JS Array
// - from_map() - Convert MoonBit Map to JS Object
// - from_entries() - Convert tuple array to JS Object
// - from_entries_option() - Convert optional tuple array to JS Object
// - from_fn0/1/2/3() - Convert MoonBit functions to JS functions
// - from_json() - Convert MoonBit Json type to JS Object
// - to_json() / to_any() - Bidirectional conversion between Json and Js

///| JsImpl implementations for MoonBit primitive types

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
pub impl JsImpl for BigInt

///|
/// Convert an Array of Js-implementing types to a JavaScript array.
pub impl JsImpl for Array[&JsImpl] with to_any(self) {
  from_array(self)
}

///|
pub impl JsImpl for Map[String, &JsImpl] with to_any(self) {
  let v = Object::new()
  for k, val in self {
    v.set(k, val.to_any())
  }
  v.to_any()
}

///|
/// Convert an Option to a JavaScript value.
pub impl[T] JsImpl for T? with to_any(self) {
  identity(self)
}

///| Conversion functions

///|
/// Cast a MoonBit Array to a JavaScript array.
pub fn[T : JsImpl] from_array(v : Array[T]) -> Any {
  identity(v.map(_.to_any()))
}

///|
/// Convert a MoonBit Map to a JavaScript object.
///
/// # Example
///
/// ```moonbit
/// let _obj = from_map({ "name": @js.any("Alice"), "age": @js.any(30) })
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_map(map : Map[String, Any]) -> Any {
  let obj = Object::new()
  for k, v in map {
    let v : Any = JsImpl::to_any(v)
    obj.set(k, v)
  }
  obj.to_any()
}

///|
/// Convert an array of tuples to a JavaScript object.
///
/// # Example
///
/// ```moonbit
/// let _obj = from_entries([("name", "Alice"), ("age", 30)])
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_entries(entries : Array[(String, &JsImpl)]) -> Any {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    obj.set(k, v.to_any())
  }
  obj.to_any()
}

///|
/// Convert an array of tuples with optional values to a JavaScript object.
/// Only sets properties where the value is Some.
///
/// **Use this when values have mixed types (String, Int, Bool, etc).**
/// For single-type values, use `from_entries_option_cast` which has better type inference.
///
/// # Example
///
/// ```moonbit
/// let _obj = from_entries_option([
///   ("name", Some("Alice")),  // String
///   ("age", Some(30)),        // Int
///   ("active", Some(true)),   // Bool - mixed types!
///   ("email", None)
/// ])
/// // JavaScript: { name: "Alice", age: 30, active: true }
/// ```
pub fn from_entries_option(entries : Array[(String, &JsImpl?)]) -> Any {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    match v {
      Some(val) => obj.set(k, val.to_any())
      None => ()
    }
  }
  obj.to_any()
}

///|
/// Convert an array of tuples with optional values to a JavaScript object.
/// Accepts Option[T] where T: JsImpl directly without requiring .map().
/// Only sets properties where the value is Some.
///
/// # Example
///
/// ```moonbit
/// // All values are Bool - use this function!
/// let _obj = from_entries_option_cast([
///   ("open", Some(true)),
///   ("readOnly", Some(false)),
///   ("timeout", None)
/// ])
/// // JavaScript: { open: true, readOnly: false }
/// ```
pub fn[T : JsImpl] from_entries_option_cast(
  entries : Array[(String, T?)],
) -> Any {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    match v {
      Some(val) => obj.set(k, val.to_any())
      None => ()
    }
  }
  obj.to_any()
}

///|
/// Cast a MoonBit function with 0 arguments to a JavaScript function Val.
pub fn[R] from_fn0(f : () -> R) -> Any {
  identity(f)
}

///|
/// Cast a MoonBit function with 1 argument to a JavaScript function Val.
pub fn[A, R] from_fn1(f : (A) -> R) -> Any {
  identity(f)
}

///|
/// Cast a MoonBit function with 2 arguments to a JavaScript function Val.
pub fn[A, B, R] from_fn2(f : (A, B) -> R) -> Any {
  identity(f)
}

///|
/// Cast a MoonBit function with 3 arguments to a JavaScript function Val.
pub fn[A, B, C, R] from_fn3(f : (A, B, C) -> R) -> Any {
  identity(f)
}

///|
/// Convert MoonBit's builtin `Json` type to JavaScript `Js` value.
///
/// **Important**: This converts MoonBit's `Json` type (from `@json` package),
/// NOT JavaScript's JSON string. For parsing JSON strings, use `JSON.parse()`.
///
/// # Example
///
/// ```moonbit
/// // Convert MoonBit Json to Js
/// let json : Json = { "name": "Alice", "age": 30 }
/// let _js_obj = from_json(json)
/// ```
///
/// For JSON string parsing, use JavaScript's `JSON.parse()` directly:
///
/// ```moonbit no-check
/// let json_str = "{\"name\":\"Alice\"}"
/// let js_obj = JSON.parse(json_str)
/// ```
pub fn from_json(j : Json) -> Any {
  JsImpl::to_any(j)
}

///|
pub impl ToJson for Any with to_json(self) -> Json {
  if is_nullish(self) {
    return null
  }
  match typeof_(self) {
    "boolean" => {
      // let v : Bool = identity(self)
      let v : Bool = identity(self)
      return v.to_json()
    }
    "number" => {
      let v : Double = identity(self)
      return v.to_json()
    }
    "string" => {
      let v : String = identity(self)
      return v.to_json()
    }
    _ => ()
  }
  if is_array(self) {
    let len : Int = self.call0("length") |> identity
    let arr : Array[Json] = []
    for i = 0; i < len; i = i + 1 {
      let v = self.get(i.to_string())
      arr.push(v.to_json())
    }
    return arr.to_json()
  }
  if typeof_(self) == "object" {
    let out : Map[String, Json] = {}
    let keys = self |> ffi_object_keys()
    for k in keys {
      let v = self.get(k)
      out[k] = v.to_json()
    }
    return out.to_json()
  }
  return {}
}

///|
pub impl JsImpl for Json with to_any(self) -> Any {
  match self {
    Null => null_()
    String(s) => any(s)
    Number(n, ..) => any(n)
    True => any(true)
    False => any(false)
    Object(o) => {
      let obj = Object::new()
      for k, v in o {
        let v : Any = JsImpl::to_any(v)
        obj.set(k, v)
      }
      obj.to_any()
    }
    Array(a) => {
      let arr = JsArray::new()
      for v in a {
        let v : Any = JsImpl::to_any(v)
        arr.call("push", [v]) |> ignore
      }
      arr.to_any()
    }
  }
}

///|
extern "js" fn ffi_wrap_sync(
  f : Any,
  ok : (Any) -> Result[Any, Any],
  err : (Any) -> Result[Any, Any],
) -> Result[Any, Any] =
  #|(f, ok, err) => {
  #|  try {
  #|    return ok(f())
  #|  } catch(e) {
  #|    return err(e)
  #|  }
  #|}

///|
/// Unsafely cast a value from one type to another.
/// When you cast to `Js`, use `js(v)` or `unsafe_any(v)` instead.
pub fn[A, B] identity(v : A) -> B = "%identity"

///|
/// Cast any JsImpl type to a JavaScript Val safely.
/// When you can not, use `unsafe_any()`.
pub fn any(a : &JsImpl) -> Any {
  identity(a.to_any())
}

///|
/// Convert any MoonBit value to a JavaScript Val.
/// Use `unsafe_any()` if you can
pub fn[T] unsafe_any(v : T) -> Any {
  identity(v)
}

///|
/// Safely convert a JavaScript value to an Option type.
///
/// Converts JavaScript `null` or `undefined` to `None`, otherwise returns `Some(value)`.
/// This is essential for FFI because accessing properties on null/undefined will crash.
///
/// # Common Patterns
///
/// - DOM API nullable returns: `node.get("parentNode") |> identity_option()`
/// - Optional object properties: `obj.get("name") |> identity_option()`
/// - Converting back to Js: use `from_option(opt)`
///
/// # Related Functions
/// - `from_option(A?) -> Js` - Inverse conversion (Option to Js)
/// - `@js.Nullable[T]` - For FFI struct fields that need explicit null handling
pub fn[A] identity_option(v : Any) -> A? {
  if ffi_is_nullish(v) {
    None
  } else {
    Some(identity(v))
  }
}

///|
/// Convert an Option to Any, mapping None to null and Some(v) to v.
///
/// This is the inverse of `identity_option`. Use this when you need to pass
/// MoonBit Option values back to JavaScript APIs.
///
/// # Usage
///
/// - `Some(42) |> from_option` returns Js(42)
/// - `None |> from_option` returns Js(null)
/// - Use with match to set optional properties on objects
///
/// # See Also
/// - `identity_option(Js) -> A?` - Inverse conversion (Js to Option)
pub fn[A : JsImpl] from_option(opt : A?) -> Any {
  match opt {
    Some(v) => v.to_any()
    None => ffi_null()
  }
}

///|
/// JS: Array.isArray(v)
pub fn[T : JsImpl] is_array(v : T) -> Bool {
  ffi_is_array(v.to_any())
}

///|
/// JS: typeof v === "object" && v !== null && !Array.isArray(v)
pub fn[T : JsImpl] is_object(v : T) -> Bool {
  ffi_is_object(v.to_any())
}

///|
/// JS: v === null
pub fn[T : JsImpl] is_null(v : T) -> Bool {
  ffi_is_null(v.to_any())
}

///|
/// JS: v === undefined
pub fn[T : JsImpl] is_undefined(v : T) -> Bool {
  ffi_is_undefined(v.to_any())
}

///|
/// JS: v == undefined
pub fn[T : JsImpl] is_nullish(v : T) -> Bool {
  ffi_is_nullish(v.to_any())
}

///|
pub fn[T] is_builtin_trait(v : T) -> Bool {
  let v : Any = v |> identity
  v.hasOwnProperty("self") && v.hasOwnProperty("method_0")
}

///|
/// Wraps a synchronous function call, converting any thrown JS errors into ThrowError
/// ```moonbit skip
/// let result = throwable(() => {
///   undefined().call_self([])
/// })
/// ```
pub fn[T] throwable(f : () -> T raise?) -> T raise ThrowError {
  match throwable_result(f |> identity) {
    Ok(result) => result |> identity
    Err(e) => {
      if ffi_is_error(e) {
        let error : JsError = identity(e)
        let error_type = ffi_get_error_type(e)
        match error_type {
          "TypeError" => raise ThrowError::TypeError(error)
          "RangeError" => raise ThrowError::RangeError(error)
          "ReferenceError" => raise ThrowError::ReferenceError(error)
          "SyntaxError" => raise ThrowError::SyntaxError(error)
          "URIError" => raise ThrowError::URIError(error)
          "EvalError" => raise ThrowError::EvalError(error)
          "AggregateError" => raise ThrowError::AggregateError(error)
          _ => raise ThrowError::Error(error)
        }
      }
      raise ThrowError::Value(e |> identity)
    }
  }
}

///|
/// Wraps a synchronous function call that returns Result, converting any thrown JS errors into JsError
fn throwable_result(f : () -> Result[Any, Any]) -> Result[Any, Any] {
  ffi_wrap_sync(identity(f), Ok(_), Err(_))
}

///|
/// JS: console.log(v)
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> identity]) |> ignore
}

///|
/// JS: console.log(a, b)
pub fn[T, U] log2(a : T, b : U) -> Unit {
  ffi_console_log([a |> identity, b |> identity]) |> ignore
}
