///|
/// MoonBit to JavaScript conversion utilities
///
/// This module provides functions to convert MoonBit built-in types to JavaScript values.
/// These conversions have runtime overhead due to iteration and recursive processing.
///
/// For zero-cost conversions, use @nostd.identity() or @nostd.any() instead.
///
/// ## Conversion Overhead Summary
/// - Map[String, T] -> JS Object: O(n) iteration + property setting
/// - Json -> JS value: O(n) recursive matching
/// - JS value -> Json: O(n) recursive conversion

///|
/// Convert a MoonBit Map to a JavaScript object.
///
/// # Example
///
/// ```moonbit
/// let obj = @mbtconv.from_map({ "name": @nostd.any("Alice"), "age": @nostd.any(30) })
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_map(map : Map[String, @nostd.Any]) -> @nostd.Any {
  let obj = ffi_create_object()
  for k, v in map {
    ffi_set_property(obj, k, v)
  }
  obj
}

///|
extern "js" fn ffi_create_object() -> @nostd.Any =
  #| () => ({})

///|
extern "js" fn ffi_set_property(
  obj : @nostd.Any,
  key : String,
  val : @nostd.Any,
) -> Unit =
  #| (obj, key, val) => { obj[key] = val }

///|
/// Convert a MoonBit Map with optional values to a JavaScript object.
/// Only sets properties where the value is Some and not nullish.
///
/// # Example
///
/// ```moonbit
/// let _obj = @mbtconv.from_option_map({
///   "name": Some(@nostd.any("Alice")),
///   "age": Some(@nostd.any(30)),
///   "email": None
/// })
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_option_map(map : Map[String, @nostd.Any?]) -> @nostd.Any {
  let obj = ffi_create_object()
  for k, v in map {
    match v {
      Some(val) => if not(ffi_is_nullish(val)) { ffi_set_property(obj, k, val) }
      None => ()
    }
  }
  obj
}

///|
extern "js" fn ffi_is_nullish(v : @nostd.Any) -> Bool =
  #| (v) => v == null

///|
/// Convert a MoonBit Map with optional values to a JavaScript object,
/// returning undefined if all properties are None or nullish.
///
/// This is useful for JS APIs where passing undefined means "use defaults"
/// while passing an empty object `{}` might have different behavior.
///
/// # Example
///
/// ```moonbit
/// // All None - returns undefined
/// let result = @mbtconv.from_option_map_or_undefined({
///   "timeout": None,
///   "retries": None
/// })
/// // JavaScript: undefined
///
/// // Some values - returns object
/// let result = @mbtconv.from_option_map_or_undefined({
///   "timeout": Some(@nostd.any(5000)),
///   "retries": None
/// })
/// // JavaScript: { timeout: 5000 }
/// ```
pub fn from_option_map_or_undefined(
  map : Map[String, @nostd.Any?],
) -> @nostd.Any {
  let obj = ffi_create_object()
  let mut has_value = false
  for k, v in map {
    match v {
      Some(val) =>
        if not(ffi_is_nullish(val)) {
          ffi_set_property(obj, k, val)
          has_value = true
        }
      None => ()
    }
  }
  if has_value {
    obj
  } else {
    ffi_undefined()
  }
}

///|
extern "js" fn ffi_undefined() -> @nostd.Any =
  #| () => undefined

///|
/// Convert MoonBit's builtin `Json` type to JavaScript value.
///
/// **Important**: This converts MoonBit's `Json` type (from `@json` package),
/// NOT JavaScript's JSON string. For parsing JSON strings, use `JSON.parse()`.
///
/// # Example
///
/// ```moonbit
/// // Convert MoonBit Json to JS
/// let json : Json = { "name": "Alice", "age": 30 }
/// let js_obj = @mbtconv.from_json(json)
/// ```
pub fn from_json(j : Json) -> @nostd.Any {
  match j {
    Null => ffi_null()
    String(s) => @nostd.any(s)
    Number(n, ..) => @nostd.any(n)
    True => @nostd.any(true)
    False => @nostd.any(false)
    Object(o) => {
      let obj = ffi_create_object()
      for k, v in o {
        ffi_set_property(obj, k, from_json(v))
      }
      obj
    }
    Array(a) => {
      let arr = ffi_create_array()
      for v in a {
        ffi_array_push(arr, from_json(v))
      }
      arr
    }
  }
}

///|
extern "js" fn ffi_null() -> @nostd.Any =
  #| () => null

///|
extern "js" fn ffi_create_array() -> @nostd.Any =
  #| () => []

///|
extern "js" fn ffi_array_push(arr : @nostd.Any, val : @nostd.Any) -> Unit =
  #| (arr, val) => { arr.push(val) }

///|
/// Convert a JavaScript value to MoonBit's `Json` type.
///
/// # Example
///
/// ```moonbit
/// let js_obj = @nostd.any({ "name": "Alice" })
/// let json = @mbtconv.to_json(js_obj)
/// ```
pub fn to_json(v : @nostd.Any) -> Json {
  if ffi_is_nullish(v) {
    return Json::null()
  }
  match ffi_typeof(v) {
    "boolean" => {
      let b : Bool = @nostd.identity(v)
      return b.to_json()
    }
    "number" => {
      let n : Double = @nostd.identity(v)
      return n.to_json()
    }
    "string" => {
      let s : String = @nostd.identity(v)
      return s.to_json()
    }
    _ => ()
  }
  if ffi_is_array(v) {
    let len : Int = ffi_get_length(v)
    let arr : Array[Json] = []
    for i = 0; i < len; i = i + 1 {
      let item = ffi_get_index(v, i)
      arr.push(to_json(item))
    }
    return arr.to_json()
  }
  if ffi_typeof(v) == "object" {
    let out : Map[String, Json] = {}
    let keys = ffi_object_keys(v)
    let keys_len : Int = ffi_get_length(keys)
    for i = 0; i < keys_len; i = i + 1 {
      let k : String = @nostd.identity(ffi_get_index(keys, i))
      let val = ffi_get_property(v, k)
      out[k] = to_json(val)
    }
    return out.to_json()
  }
  return Json::object({})
}

///|
extern "js" fn ffi_typeof(v : @nostd.Any) -> String =
  #| (v) => typeof v

///|
extern "js" fn ffi_is_array(v : @nostd.Any) -> Bool =
  #| (v) => Array.isArray(v)

///|
extern "js" fn ffi_get_length(v : @nostd.Any) -> Int =
  #| (v) => v.length

///|
extern "js" fn ffi_get_index(v : @nostd.Any, i : Int) -> @nostd.Any =
  #| (v, i) => v[i]

///|
extern "js" fn ffi_object_keys(v : @nostd.Any) -> @nostd.Any =
  #| (v) => Object.keys(v)

///|
extern "js" fn ffi_get_property(obj : @nostd.Any, key : String) -> @nostd.Any =
  #| (obj, key) => obj[key]

///|
/// Convert an Option to @nostd.Any, mapping None to null and Some(v) to v.
///
/// # Usage
///
/// - `Some(@nostd.any(42)) |> from_option` returns 42
/// - `None |> from_option` returns null
pub fn from_option(opt : @nostd.Any?) -> @nostd.Any {
  match opt {
    Some(v) => v
    None => ffi_null()
  }
}

///|
/// Safely convert a JavaScript value to an Option type.
///
/// Converts JavaScript `null` or `undefined` to `None`, otherwise returns `Some(value)`.
pub fn[A] to_option(v : @nostd.Any) -> A? {
  if ffi_is_nullish(v) {
    None
  } else {
    Some(@nostd.identity(v))
  }
}
