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
/// ```moonbit nocheck
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
/// ```moonbit nocheck
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
/// ```moonbit nocheck
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
/// ```moonbit nocheck
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
/// ```moonbit nocheck
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

///|
/// ## Result Type Utilities
///
/// MoonBit's Result[T, E] is compiled to JavaScript as:
/// - `Ok(value)` → `{ _0: value }` with constructor name containing "Ok"
/// - `Err(error)` → `{ _0: error }` with constructor name containing "Err"
///
/// Use constructor.name.includes("Ok") or .includes("Err") to distinguish.

///|
extern "js" fn ffi_get_constructor_name(v : @core.Any) -> String =
  #|(v) => v?.constructor?.name ?? ""

///|
/// Check if a MoonBit Result value is Ok variant.
///
/// # Example
///
/// ```moonbit nocheck
/// let ok_result : Result[Int, String] = Ok(42)
///
/// let is_ok = @mbtconv.is_result_ok(@core.any(ok_result)) // true
/// ```
pub fn is_result_ok(v : @core.Any) -> Bool {
  ffi_get_constructor_name(v).contains("Ok")
}

///|
/// Check if a MoonBit Result value is Err variant.
///
/// # Example
///
/// ```moonbit nocheck
/// let err_result : Result[Int, String] = Err("error")
///
/// let is_err = @mbtconv.is_result_err(@core.any(err_result)) // true
/// ```
pub fn is_result_err(v : @core.Any) -> Bool {
  ffi_get_constructor_name(v).contains("Err")
}

///|
/// Unwrap the inner value from Ok variant.
/// Returns the inner value if Ok, otherwise returns undefined.
///
/// # Example
///
/// ```moonbit nocheck
/// let ok_result : Result[Int, String] = Ok(42)
///
/// let value : Int = @mbtconv.unwrap_ok(@core.any(ok_result)) // 42
/// ```
pub fn[T] unwrap_ok(v : @core.Any) -> T {
  @core.identity(v["_0"])
}

///|
/// Unwrap the inner value from Err variant.
/// Returns the inner value if Err, otherwise returns undefined.
///
/// # Example
///
/// ```moonbit nocheck
/// let err_result : Result[Int, String] = Err("error")
///
/// let error : String = @mbtconv.unwrap_err(@core.any(err_result)) // "error"
/// ```
pub fn[E] unwrap_err(v : @core.Any) -> E {
  @core.identity(v["_0"])
}

///|
/// Convert a JS value (MoonBit Result) back to MoonBit Result type.
///
/// # Example
///
/// ```moonbit nocheck
/// let ok_result : Result[Int, String] = Ok(42)
///
/// let js_val = @core.any(ok_result)
///
/// let back : Result[Int, String] = @mbtconv.to_result(js_val)
/// ```
pub fn[T, E] to_result(v : @core.Any) -> Result[T, E] {
  if is_result_ok(v) {
    Ok(unwrap_ok(v))
  } else {
    Err(unwrap_err(v))
  }
}

///|
/// ## Enum Type Utilities
///
/// MoonBit enums are compiled to JavaScript as:
/// - Unit variants (no args): `{ $tag: n, $name: "VariantName" }`
/// - Tuple variants: `{ _0: arg0, _1: arg1, ... }` with constructor name "EnumName$VariantName"

///|
/// Get the enum variant name from a MoonBit enum value.
/// Works for both unit variants ($name property) and tuple variants (constructor name).
///
/// # Example
///
/// ```moonbit nocheck
/// // For unit variant: returns "Red"
/// // For tuple variant: returns "Rgb" (parsed from "Color$Rgb")
/// ```
pub fn get_enum_variant_name(v : @core.Any) -> String {
  // Try $name property first (unit variants)
  let name_prop = v["$name"]
  if not(ffi_is_nullish(name_prop)) {
    return @core.identity(name_prop)
  }
  // Fall back to constructor name (tuple variants)
  let ctor_name = ffi_get_constructor_name(v)
  // Parse "EnumName$VariantName" to get "VariantName"
  let parts : Array[String] = ffi_split(ctor_name, "$")
  let len = parts.length()
  if len > 1 {
    parts[len - 1]
  } else {
    ctor_name
  }
}

///|
extern "js" fn ffi_split(s : String, sep : String) -> Array[String] =
  #|(s, sep) => s.split(sep)

///|
/// Get the $tag index from an enum variant.
/// All enum variants (both unit and tuple) have a $tag property.
/// Returns -1 if not an enum.
pub fn get_enum_tag(v : @core.Any) -> Int {
  let tag = v["$tag"]
  if ffi_is_nullish(tag) {
    -1
  } else {
    @core.identity(tag)
  }
}

///|
/// ## Safe Serialization for JSON Roundtrip
///
/// These functions serialize MoonBit types with explicit type tags,
/// allowing safe JSON roundtrip without losing type information.

///|
/// Serialize a Result with type tag preserved.
/// Output format: `{ "_tag": "Ok" | "Err", "_0": value }`
///
/// # Example
///
/// ```moonbit nocheck
/// let result : Result[Int, String] = Ok(42)
///
/// let serialized = @mbtconv.serialize_result(result)
/// // JavaScript: { "_tag": "Ok", "_0": 42 }
/// ```
pub fn[T, E] serialize_result(result : Result[T, E]) -> @core.Any {
  let obj = @core.new_object()
  match result {
    Ok(v) => {
      obj["_tag"] = @core.any("Ok")
      obj["_0"] = @core.any(v)
    }
    Err(e) => {
      obj["_tag"] = @core.any("Err")
      obj["_0"] = @core.any(e)
    }
  }
  obj
}

///|
/// Deserialize a Result from serialized form.
///
/// # Example
///
/// ```moonbit nocheck
/// let serialized = json_parse("{\"_tag\":\"Ok\",\"_0\":42}")
///
/// let result : Result[Int, String] = @mbtconv.deserialize_result(serialized)
/// ```
pub fn[T, E] deserialize_result(v : @core.Any) -> Result[T, E] {
  let tag : String = @core.identity(v["_tag"])
  if tag == "Ok" {
    Ok(@core.identity(v["_0"]))
  } else {
    Err(@core.identity(v["_0"]))
  }
}

///|
/// Serialize an Option with explicit None representation.
/// Output format: `{ "_some": true, "_0": value }` or `{ "_some": false }`
///
/// # Example
///
/// ```moonbit nocheck
/// let some_val : Int? = Some(42)
///
/// let serialized = @mbtconv.serialize_option(some_val)
/// // JavaScript: { "_some": true, "_0": 42 }
/// ```
pub fn[T] serialize_option(opt : T?) -> @core.Any {
  let obj = @core.new_object()
  match opt {
    Some(v) => {
      obj["_some"] = @core.any(true)
      obj["_0"] = @core.any(v)
    }
    None => obj["_some"] = @core.any(false)
  }
  obj
}

///|
/// Deserialize an Option from serialized form.
///
/// # Example
///
/// ```moonbit nocheck
/// let serialized = json_parse("{\"_some\":true,\"_0\":42}")
///
/// let opt : Int? = @mbtconv.deserialize_option(serialized)
/// ```
pub fn[T] deserialize_option(v : @core.Any) -> T? {
  let is_some : Bool = @core.identity(v["_some"])
  if is_some {
    Some(@core.identity(v["_0"]))
  } else {
    None
  }
}
