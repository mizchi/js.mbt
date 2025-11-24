// EcmaScript global APIs

///| Global Objects

///|
/// JS: globalThis
#alias(global_this)
pub fn globalThis() -> Any {
  ffi_global_this()
}

///|
/// JS: undefined
pub fn undefined() -> Any {
  ffi_undefined()
}

///| Type Checking

///|
/// JS: isNaN(v)
pub fn[T : JsImpl] isNaN(v : T) -> Bool {
  ffi_is_nan(v.to_any())
}

///|
/// JS: isFinite(v)
#alias(is_finite)
pub fn isFinite(v : Double) -> Bool {
  ffi_is_finite(v)
}

///| Number Parsing

///|
/// JS: parseInt(string, radix)
///
/// Parse a string and return an integer.
/// If radix is not provided, it defaults to 10 (or 16 if string starts with "0x").
///
/// Example:
/// ```moonbit
/// let _n = parseInt("42") // Some(42)
/// let _hex = parseInt("ff", radix=16) // Some(255)
/// let _invalid = parseInt("hello") // None
/// ```
#alias(parse_int)
pub fn parseInt(string : String, radix? : Int = 10) -> Int? {
  let result = ffi_parse_int(string, radix)
  if isNaN(result) {
    None
  } else {
    Some(result |> identity)
  }
}

///|
/// JS: parseFloat(string)
///
/// Parse a string and return a floating point number.
/// Returns None if the string cannot be parsed as a number.
///
/// Example:
/// ```moonbit
/// let _n = parseFloat("3.14") // Some(3.14)
/// let _invalid = parseFloat("hello") // None
/// ```
#alias(parse_float)
pub fn parseFloat(string : String) -> Double? {
  let result = ffi_parse_float(string)
  if isNaN(result) {
    None
  } else {
    Some(result |> identity)
  }
}

///| String Encoding (Base64)

///|
/// JS: atob(encodedData)
pub fn atob(encoded_data : String) -> String raise ThrowError {
  throwable(fn() { ffi_atob(encoded_data) })
}

///|
/// JS: btoa(data)
pub fn btoa(data : String) -> String raise ThrowError {
  throwable(fn() { ffi_btoa(data) })
}

///| URI Encoding

///|
/// JS: encodeURI(uri)
#alias(encode_uri)
pub fn encodeURI(uri : String) -> String {
  ffi_encode_uri(uri)
}

///|
/// JS: decodeURI(encodedURI)
#alias(decode_uri)
pub fn decodeURI(encoded_uri : String) -> String {
  ffi_decode_uri(encoded_uri)
}

///|
/// JS: encodeURIComponent(str)
#alias(encode_uri_component)
pub fn encodeURIComponent(str : String) -> String {
  ffi_encode_uri_component(str)
}

///|
/// JS: decodeURIComponent(encodedStr)
#alias(decode_uri_component)
pub fn decodeURIComponent(encoded_str : String) -> String {
  ffi_decode_uri_component(encoded_str)
}

///| Module Loading

///|
/// Do not use vite env
#alias(dynamic_import)
pub fn dynamicImport(module_name : String) -> Any {
  ffi_dynamic_import(module_name)
}
