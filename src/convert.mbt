// This module provides conversion utilities between MoonBit and JavaScript types.
//
// Main functions:
// - from_array() - Convert MoonBit Array to JS Array
// - from_map() - Convert MoonBit Map to JS Object
// - from_entries() - Convert tuple array to JS Object
// - from_entries_option() - Convert optional tuple array to JS Object
// - from_fn0/1/2/3() - Convert MoonBit functions to JS functions
// - from_json() - Convert MoonBit Json type to JS Object
// - to_json() / to_js() - Bidirectional conversion between Json and Js

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
pub impl JsImpl for Array[&JsImpl] with to_js(self) {
  from_array(self)
}

///|
pub impl JsImpl for Map[String, &JsImpl] with to_js(self) {
  let v = Object::new()
  for k, val in self {
    v.set(k, val.to_js())
  }
  v.to_js()
}

///|
/// Convert an Option to a JavaScript value.
pub impl[T] JsImpl for T? with to_js(self) {
  unsafe_cast(self)
}

///| Conversion functions

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
/// let _obj = from_map({ "name": js("Alice"), "age": js(30) })
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
/// Convert an array of tuples to a JavaScript object.
///
/// # Example
///
/// ```moonbit
/// let _obj = from_entries([("name", "Alice"), ("age", 30)])
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_entries(entries : Array[(String, &JsImpl)]) -> Js {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    obj.set(k, v.to_js())
  }
  obj.to_js()
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
pub fn from_entries_option(entries : Array[(String, &JsImpl?)]) -> Js {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    match v {
      Some(val) => obj.set(k, val.to_js())
      None => ()
    }
  }
  obj.to_js()
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
) -> Js {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    match v {
      Some(val) => obj.set(k, val.to_js())
      None => ()
    }
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
/// Cast a MoonBit function with 3 arguments to a JavaScript function Val.
pub fn[A, B, C, R] from_fn3(f : (A, B, C) -> R) -> Js {
  unsafe_cast(f)
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
pub fn from_json(j : Json) -> Js {
  JsImpl::to_js(j)
}

///|
pub impl ToJson for Js with to_json(self) -> Json {
  if is_nullish(self) {
    return null
  }
  match typeof_(self) {
    "boolean" => {
      // let v : Bool = unsafe_cast(self)
      let v : Bool = unsafe_cast(self)
      return v.to_json()
    }
    "number" => {
      let v : Double = unsafe_cast(self)
      return v.to_json()
    }
    "string" => {
      let v : String = unsafe_cast(self)
      return v.to_json()
    }
    _ => ()
  }
  if is_array(self) {
    let len : Int = self.call0("length") |> unsafe_cast
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
pub impl JsImpl for Json with to_js(self) -> Js {
  match self {
    Null => null_()
    String(s) => js(s)
    Number(n, ..) => js(n)
    True => js(true)
    False => js(false)
    Object(o) => {
      let obj = Object::new()
      for k, v in o {
        let v : Js = JsImpl::to_js(v)
        obj.set(k, v)
      }
      obj.to_js()
    }
    Array(a) => {
      let arr = JsArray::new()
      for v in a {
        let v : Js = JsImpl::to_js(v)
        arr.call("push", [v]) |> ignore
      }
      arr.to_js()
    }
  }
}

///|
extern "js" fn ffi_wrap_sync(
  f : Js,
  ok : (Js) -> Result[Js, Js],
  err : (Js) -> Result[Js, Js],
) -> Result[Js, Js] =
  #|(f, ok, err) => {
  #|  try {
  #|    return ok(f())
  #|  } catch(e) {
  #|    return err(e)
  #|  }
  #|}

///|
/// Unsafely cast a value from one type to another.
/// When you cast to `Js`, use `js(v)` or `unsafe_js(v)` instead.
pub fn[A, B] unsafe_cast(v : A) -> B = "%identity"

///|
/// Cast any JsImpl type to a JavaScript Val safely.
/// When you can not, use `unsafe_js()`.
pub fn js(a : &JsImpl) -> Js {
  unsafe_cast(a.to_js())
}

///|
/// Convert any MoonBit value to a JavaScript Val.
/// Use `unsafe_js()` if you can
pub fn[T] unsafe_js(v : T) -> Js {
  unsafe_cast(v)
}

///|
/// Safely convert a JavaScript value to an Option type.
///
/// Converts JavaScript `null` or `undefined` to `None`, otherwise returns `Some(value)`.
/// This is essential for FFI because accessing properties on null/undefined will crash.
///
/// # Common Patterns
///
/// - DOM API nullable returns: `node.get("parentNode") |> unsafe_cast_option()`
/// - Optional object properties: `obj.get("name") |> unsafe_cast_option()`
/// - Converting back to Js: use `from_option(opt)`
///
/// # Related Functions
/// - `from_option(A?) -> Js` - Inverse conversion (Option to Js)
/// - `@js.Nullable[T]` - For FFI struct fields that need explicit null handling
pub fn[A] unsafe_cast_option(v : Js) -> A? {
  if ffi_is_nullish(v) {
    None
  } else {
    Some(unsafe_cast(v))
  }
}

///|
/// Convert an Option to Js, mapping None to null and Some(v) to v.
///
/// This is the inverse of `unsafe_cast_option`. Use this when you need to pass
/// MoonBit Option values back to JavaScript APIs.
///
/// # Usage
///
/// - `Some(42) |> from_option` returns Js(42)
/// - `None |> from_option` returns Js(null)
/// - Use with match to set optional properties on objects
///
/// # See Also
/// - `unsafe_cast_option(Js) -> A?` - Inverse conversion (Js to Option)
pub fn[A : JsImpl] from_option(opt : A?) -> Js {
  match opt {
    Some(v) => v.to_js()
    None => ffi_null()
  }
}

///|
/// JS: Array.isArray(v)
pub fn[T : JsImpl] is_array(v : T) -> Bool {
  ffi_is_array(v.to_js())
}

///|
/// JS: typeof v === "object" && v !== null && !Array.isArray(v)
pub fn[T : JsImpl] is_object(v : T) -> Bool {
  ffi_is_object(v.to_js())
}

///|
/// JS: v === null
pub fn[T : JsImpl] is_null(v : T) -> Bool {
  ffi_is_null(v.to_js())
}

///|
/// JS: v === undefined
pub fn[T : JsImpl] is_undefined(v : T) -> Bool {
  ffi_is_undefined(v.to_js())
}

///|
pub fn[T : JsImpl] is_nullish(v : T) -> Bool {
  ffi_is_nullish(v.to_js())
}

///|
pub fn[T : JsImpl] is_builtin_trait(v : T) -> Bool {
  let v : Js = v |> unsafe_cast
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
  match throwable_result(f |> unsafe_cast) {
    Ok(result) => result |> unsafe_cast
    Err(e) => {
      if ffi_is_error(e) {
        let error : JsError = unsafe_cast(e)
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
      raise ThrowError::Value(e |> unsafe_cast)
    }
  }
}

///|
/// Wraps a synchronous function call that returns Result, converting any thrown JS errors into JsError
fn throwable_result(f : () -> Result[Js, Js]) -> Result[Js, Js] {
  ffi_wrap_sync(unsafe_cast(f), Ok(_), Err(_))
}

///|
/// JS: console.log(v)
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast]) |> ignore
}

///|
/// JS: console.log(a, b)
pub fn[T, U] log2(a : T, b : U) -> Unit {
  ffi_console_log([a |> unsafe_cast, b |> unsafe_cast]) |> ignore
}
