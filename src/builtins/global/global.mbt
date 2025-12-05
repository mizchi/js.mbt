// EcmaScript global functions
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects

///| Global Objects

///|
/// JS: globalThis
pub extern "js" fn globalThis() -> @core.Any =
  #| () => globalThis

///|
pub fn global_this() -> @core.Any {
  globalThis()
}

///|
/// JS: undefined
pub extern "js" fn undefined() -> @core.Any =
  #| () => undefined

///| Type Checking

///|
/// JS: isNaN(v)
pub extern "js" fn isNaN(v : @core.Any) -> Bool =
  #| (v) => isNaN(v)

///|
pub fn is_nan(v : @core.Any) -> Bool {
  isNaN(v)
}

///|
/// JS: isFinite(v)
pub extern "js" fn isFinite(v : Double) -> Bool =
  #| (v) => isFinite(v)

///|
pub fn is_finite(v : Double) -> Bool {
  isFinite(v)
}

///| Number Parsing

///|
extern "js" fn ffi_parse_int(string : String, radix : Int) -> @core.Any =
  #| (string, radix) => parseInt(string, radix)

///|
extern "js" fn ffi_parse_float(string : String) -> @core.Any =
  #| (string) => parseFloat(string)

///|
/// JS: parseInt(string, radix)
///
/// Parse a string and return an integer.
/// If radix is not provided, it defaults to 10 (or 16 if string starts with "0x").
pub fn parseInt(string : String, radix? : Int = 10) -> Int? {
  let result = ffi_parse_int(string, radix)
  if isNaN(result) {
    None
  } else {
    Some(@core.identity(result))
  }
}

///|
pub fn parse_int(string : String, radix? : Int = 10) -> Int? {
  parseInt(string, radix~)
}

///|
/// JS: parseFloat(string)
///
/// Parse a string and return a floating point number.
/// Returns None if the string cannot be parsed as a number.
pub fn parseFloat(string : String) -> Double? {
  let result = ffi_parse_float(string)
  if isNaN(result) {
    None
  } else {
    Some(@core.identity(result))
  }
}

///|
pub fn parse_float(string : String) -> Double? {
  parseFloat(string)
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
pub fn atob(encoded_data : String) -> String raise {
  @core.throwable(() => ffi_atob(encoded_data))
}

///|
/// JS: btoa(data)
///
/// Creates a Base64-encoded ASCII string from a binary string.
pub fn btoa(data : String) -> String raise {
  @core.throwable(() => ffi_btoa(data))
}

///| URI Encoding

///|
/// JS: encodeURI(uri)
#alias(encode_uri)
pub extern "js" fn encodeURI(uri : String) -> String =
  #| (uri) => encodeURI(uri)

///|
/// JS: decodeURI(encodedURI)
#alias(docode_uri)
pub extern "js" fn decodeURI(encoded_uri : String) -> String =
  #| (encodedUri) => decodeURI(encodedUri)

///|
/// JS: encodeURIComponent(str)
#alias(encode_uri_component)
pub extern "js" fn encodeURIComponent(str : String) -> String =
  #| (str) => encodeURIComponent(str)

///|
/// JS: decodeURIComponent(encodedStr)
#alias(decode_uri_component)
pub extern "js" fn decodeURIComponent(encoded_str : String) -> String =
  #| (encodedStr) => decodeURIComponent(encodedStr)

///| Object Cloning

///|
/// JS: structuredClone(value)
///
/// Creates a deep clone of a value using the structured clone algorithm.
/// This can clone complex objects including nested objects, arrays, dates, etc.
#alias(structured_clone)
pub extern "js" fn structuredClone(value : @core.Any) -> @core.Any =
  #| (value) => structuredClone(value)

///| Module Loading

///|
/// Dynamic import (ES modules)
/// Note: Returns a Promise<Module>
pub extern "js" fn dynamic_import(module_name : String) -> @core.Any =
  #| (moduleName) => import(moduleName)
