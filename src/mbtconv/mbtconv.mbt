///|
/// MoonBit to JavaScript conversion utilities
///
/// This module provides functions to convert MoonBit built-in types to JavaScript values.
/// These conversions have runtime overhead due to iteration and recursive processing.
///
/// For zero-cost conversions, use @core.identity() or @core.any() instead.
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
/// let obj = @mbtconv.from_map({ "name": @core.any("Alice"), "age": @core.any(30) })
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_map(map : Map[String, @core.Any]) -> @core.Any {
  let obj = ffi_create_object()
  for k, v in map {
    ffi_set_property(obj, k, v)
  }
  obj
}

///|
extern "js" fn ffi_create_object() -> @core.Any =
  #| () => ({})

///|
extern "js" fn ffi_set_property(
  obj : @core.Any,
  key : String,
  val : @core.Any,
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
///   "name": Some(@core.any("Alice")),
///   "age": Some(@core.any(30)),
///   "email": None,
/// })
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_option_map(map : Map[String, @core.Any?]) -> @core.Any {
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
extern "js" fn ffi_is_nullish(v : @core.Any) -> Bool =
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
///   "retries": None,
/// })
/// // JavaScript: undefined
///
/// // Some values - returns object
///
/// let result = @mbtconv.from_option_map_or_undefined({
///   "timeout": Some(@core.any(5000)),
///   "retries": None,
/// })
/// // JavaScript: { timeout: 5000 }
/// ```
pub fn from_option_map_or_undefined(map : Map[String, @core.Any?]) -> @core.Any {
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
extern "js" fn ffi_undefined() -> @core.Any =
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
///
/// let js_obj = @mbtconv.from_json(json)
/// ```
pub fn from_json(j : Json) -> @core.Any {
  match j {
    Null => ffi_null()
    String(s) => @core.any(s)
    Number(n, ..) => @core.any(n)
    True => @core.any(true)
    False => @core.any(false)
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
extern "js" fn ffi_null() -> @core.Any =
  #| () => null

///|
extern "js" fn ffi_create_array() -> @core.Any =
  #| () => []

///|
extern "js" fn ffi_array_push(arr : @core.Any, val : @core.Any) -> Unit =
  #| (arr, val) => { arr.push(val) }

///|
/// Convert a JavaScript value to MoonBit's `Json` type.
///
/// # Example
///
/// ```moonbit
/// let js_obj = @core.any({ "name": "Alice" })
///
/// let json = @mbtconv.to_json(js_obj)
/// ```
pub fn to_json(v : @core.Any) -> Json {
  if ffi_is_nullish(v) {
    return Json::null()
  }
  match ffi_typeof(v) {
    "boolean" => {
      let b : Bool = @core.identity(v)
      return b.to_json()
    }
    "number" => {
      let n : Double = @core.identity(v)
      return n.to_json()
    }
    "string" => {
      let s : String = @core.identity(v)
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
      let k : String = @core.identity(ffi_get_index(keys, i))
      let val = ffi_get_property(v, k)
      out[k] = to_json(val)
    }
    return out.to_json()
  }
  return Json::object({})
}

///|
extern "js" fn ffi_typeof(v : @core.Any) -> String =
  #| (v) => typeof v

///|
extern "js" fn ffi_is_array(v : @core.Any) -> Bool =
  #| (v) => Array.isArray(v)

///|
extern "js" fn ffi_get_length(v : @core.Any) -> Int =
  #| (v) => v.length

///|
extern "js" fn ffi_get_index(v : @core.Any, i : Int) -> @core.Any =
  #| (v, i) => v[i]

///|
extern "js" fn ffi_object_keys(v : @core.Any) -> @core.Any =
  #| (v) => Object.keys(v)

///|
extern "js" fn ffi_get_property(obj : @core.Any, key : String) -> @core.Any =
  #| (obj, key) => obj[key]

///|
/// Convert an Option to @core.Any, mapping None to null and Some(v) to v.
///
/// # Usage
///
/// - `Some(@core.any(42)) |> from_option` returns 42
/// - `None |> from_option` returns null
pub fn from_option(opt : @core.Any?) -> @core.Any {
  match opt {
    Some(v) => v
    None => ffi_null()
  }
}

///|
/// Safely convert a JavaScript value to an Option type.
///
/// Converts JavaScript `null` or `undefined` to `None`, otherwise returns `Some(value)`.
pub fn[A] to_option(v : @core.Any) -> A? {
  if ffi_is_nullish(v) {
    None
  } else {
    Some(@core.identity(v))
  }
}
