// EcmaScript global functions
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects

///| Global Objects

///|
/// JS: globalThis
pub extern "js" fn global_this() -> @nostd.Any =
  #| () => globalThis

///|
/// JS: undefined
pub extern "js" fn undefined() -> @nostd.Any =
  #| () => undefined

///| Type Checking

///|
/// JS: isNaN(v)
pub extern "js" fn is_nan(v : @nostd.Any) -> Bool =
  #| (v) => isNaN(v)

///|
/// JS: isFinite(v)
pub extern "js" fn is_finite(v : Double) -> Bool =
  #| (v) => isFinite(v)

///| Number Parsing

///|
extern "js" fn ffi_parse_int(string : String, radix : Int) -> @nostd.Any =
  #| (string, radix) => parseInt(string, radix)

///|
extern "js" fn ffi_parse_float(string : String) -> @nostd.Any =
  #| (string) => parseFloat(string)

///|
/// JS: parseInt(string, radix)
///
/// Parse a string and return an integer.
/// If radix is not provided, it defaults to 10 (or 16 if string starts with "0x").
pub fn parse_int(string : String, radix? : Int = 10) -> Int? {
  let result = ffi_parse_int(string, radix)
  if is_nan(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// JS: parseFloat(string)
///
/// Parse a string and return a floating point number.
/// Returns None if the string cannot be parsed as a number.
pub fn parse_float(string : String) -> Double? {
  let result = ffi_parse_float(string)
  if is_nan(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///| String Encoding (Base64)

///|
extern "js" fn ffi_atob(encoded_data : String) -> String =
  #| (encodedData) => atob(encodedData)

///|
extern "js" fn ffi_btoa(data : String) -> String =
  #| (data) => btoa(data)

///|
/// JS: atob(encodedData)
///
/// Decodes a string of data which has been encoded using Base64 encoding.
pub fn atob(encoded_data : String) -> String {
  ffi_atob(encoded_data)
}

///|
/// JS: btoa(data)
///
/// Creates a Base64-encoded ASCII string from a binary string.
pub fn btoa(data : String) -> String {
  ffi_btoa(data)
}

///| URI Encoding

///|
/// JS: encodeURI(uri)
pub extern "js" fn encode_uri(uri : String) -> String =
  #| (uri) => encodeURI(uri)

///|
/// JS: decodeURI(encodedURI)
pub extern "js" fn decode_uri(encoded_uri : String) -> String =
  #| (encodedUri) => decodeURI(encodedUri)

///|
/// JS: encodeURIComponent(str)
pub extern "js" fn encode_uri_component(str : String) -> String =
  #| (str) => encodeURIComponent(str)

///|
/// JS: decodeURIComponent(encodedStr)
pub extern "js" fn decode_uri_component(encoded_str : String) -> String =
  #| (encodedStr) => decodeURIComponent(encodedStr)

///| Module Loading

///|
/// Dynamic import (ES modules)
/// Note: Returns a Promise<Module>
pub extern "js" fn dynamic_import(module_name : String) -> @nostd.Any =
  #| (moduleName) => import(moduleName)
