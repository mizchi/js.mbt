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
pub fn atob(encoded_data : String) -> String {
  ffi_atob(encoded_data)
}

///|
pub fn btoa(data : String) -> String {
  ffi_btoa(data)
}

///|
/// Create a new object using Object.create().
///
/// Creates an object with an empty prototype chain.
///
/// # Returns
///
/// A new object created with Object.create({})
pub fn object_create() -> Val {
  ffi_object_create()
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
/// let uri = encode_uri("https://example.com/path?name=John Doe")
/// // Returns: "https://example.com/path?name=John%20Doe"
/// ```
pub fn encode_uri(uri : String) -> String {
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
/// let uri = decode_uri("https://example.com/path?name=John%20Doe")
/// // Returns: "https://example.com/path?name=John Doe"
/// ```
pub fn decode_uri(encoded_uri : String) -> String {
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
/// let param = encode_uri_component("Hello World & Friends")
/// // Returns: "Hello%20World%20%26%20Friends"
/// ```
pub fn encode_uri_component(str : String) -> String {
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
/// let param = decode_uri_component("Hello%20World%20%26%20Friends")
/// // Returns: "Hello World & Friends"
/// ```
pub fn decode_uri_component(encoded_str : String) -> String {
  ffi_decode_uri_component(encoded_str)
}
