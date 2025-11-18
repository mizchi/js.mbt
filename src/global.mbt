// EcmaScript global APIs

///|
/// JS: globalThis
#alias(global_this)
pub fn globalThis() -> Val {
  ffi_global_this()
}

///|
/// Get the JavaScript `undefined` value.
///
/// # Returns
///
/// The undefined value as a Val
///
/// # Example
///
/// ```moonbit
/// let undef = undefined()
/// assert_true(@js.is_undefined(undef))
/// ```
pub fn undefined() -> Val {
  ffi_undefined()
}

///|
/// Get the JavaScript `null` value.
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
pub fn atob(encoded_data : String) -> String {
  ffi_atob(encoded_data)
}

///|
pub fn btoa(data : String) -> String {
  ffi_btoa(data)
}

///|
/// Encode a URI by escaping special characters.
///
/// Equivalent to JavaScript's `encodeURI()` function.
/// Encodes a URI by replacing certain characters with escape sequences.
/// Does not encode: A-Z a-z 0-9 ; , / ? : @ & = + $ - _ . ! ~ * ' ( ) #
///
/// # Parameters
///
/// - `uri`: The complete URI to encode
///
/// # Returns
///
/// The encoded URI
///
/// # Example
///
/// ```moonbit
/// let uri = encodeURI("https://example.com/path?name=John Doe")
/// // Returns: "https://example.com/path?name=John%20Doe"
/// ```
#alias(encode_uri)
pub fn encodeURI(uri : String) -> String {
  ffi_encode_uri(uri)
}

///|
/// Decode a URI that was encoded using encodeURI().
///
/// Equivalent to JavaScript's `decodeURI()` function.
///
/// # Parameters
///
/// - `encoded_uri`: The encoded URI to decode
///
/// # Returns
///
/// The decoded URI
///
/// # Example
///
/// ```moonbit
/// let uri = decodeURI("https://example.com/path?name=John%20Doe")
/// // Returns: "https://example.com/path?name=John Doe"
/// ```
#alias(decode_uri)
pub fn decodeURI(encoded_uri : String) -> String {
  ffi_decode_uri(encoded_uri)
}

///|
/// Encode a URI component by escaping special characters.
///
/// Equivalent to JavaScript's `encodeURIComponent()` function.
/// Encodes all characters except: A-Z a-z 0-9 - _ . ! ~ * ' ( )
/// Use this for encoding query string parameters or path segments.
///
/// # Parameters
///
/// - `str`: The string to encode as a URI component
///
/// # Returns
///
/// The encoded string
///
/// # Example
///
/// ```moonbit
/// let param = encodeURIComponent("Hello World & Friends")
/// // Returns: "Hello%20World%20%26%20Friends"
/// ```
#alias(encode_uri_component)
pub fn encodeURIComponent(str : String) -> String {
  ffi_encode_uri_component(str)
}

///|
/// Decode a URI component that was encoded using encodeURIComponent().
///
/// Equivalent to JavaScript's `decodeURIComponent()` function.
///
/// # Parameters
///
/// - `encoded_str`: The encoded string to decode
///
/// # Returns
///
/// The decoded string
///
/// # Example
///
/// ```moonbit
/// let param = decodeURIComponent("Hello%20World%20%26%20Friends")
/// // Returns: "Hello World & Friends"
/// ```
#alias(decode_uri_component)
pub fn decodeURIComponent(encoded_str : String) -> String {
  ffi_decode_uri_component(encoded_str)
}

///|
/// Do not use vite env
#alias(dynamic_import)
pub fn dynamicImport(module_name : String) -> Val {
  ffi_dynamic_import(module_name)
}

///|
pub fn[T: JsImpl] isNaN(v : T) -> Bool {
  ffi_is_nan(v.to_js())
}

///|
#alias(set_timeout)
pub fn setTimeout(f : () -> Unit, duration : Int) -> JsTimer {
  ffi_set_timeout(f, duration)
}

///|
#alias(clear_timeout)
pub fn clearTimeout(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
#alias(set_interval)
pub fn setInterval(f : () -> Unit noraise, duration : Int) -> JsTimer {
  ffi_set_interval(f, duration)
}

///|
#alias(clear_interval)
pub fn clearInterval(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}
