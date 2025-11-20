// EcmaScript global APIs

///| Global Objects

///|
/// JS: globalThis
#alias(global_this)
pub fn globalThis() -> Js {
  ffi_global_this()
}

///|
/// JS: undefined
pub fn undefined() -> Js {
  ffi_undefined()
}

///| Type Checking

///|
/// JS: isNaN(v)
pub fn[T : JsImpl] isNaN(v : T) -> Bool {
  ffi_is_nan(v.to_js())
}

///| String Encoding (Base64)

///|
/// JS: atob(encodedData)
pub fn atob(encoded_data : String) -> String {
  ffi_atob(encoded_data)
}

///|
/// JS: btoa(data)
pub fn btoa(data : String) -> String {
  ffi_btoa(data)
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
pub fn dynamicImport(module_name : String) -> Js {
  ffi_dynamic_import(module_name)
}

///| Timers

///|
/// JS: setTimeout(f, duration)
#alias(set_timeout)
pub fn setTimeout(f : () -> Unit, duration : Int) -> JsTimer {
  ffi_set_timeout(f, duration)
}

///|
/// JS: clearTimeout(timer)
#alias(clear_timeout)
pub fn clearTimeout(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
/// JS: setInterval(f, duration)
#alias(set_interval)
pub fn setInterval(f : () -> Unit noraise, duration : Int) -> JsTimer {
  ffi_set_interval(f, duration)
}

///|
/// JS: clearInterval(timer)
#alias(clear_interval)
pub fn clearInterval(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///| JSON

///|
/// JavaScript: JSON
#external
pub type JSON

///|
/// JS: JSON.stringify(v, replacer, space)
pub fn JSON::stringify(
  v : Js,
  replacer? : Js = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_js(), replacer, space |> js)
}

///|
/// JS: JSON.parse(s, reviver)
pub fn JSON::parse(s : String, reviver? : Js? = None) -> Js raise JsThrowError {
  throwable(() => ffi_json_parse(s, reviver?))
}

///| AbortController and AbortSignal

///|
/// JavaScript: AbortController
#external
pub type AbortController

///|
pub impl JsImpl for AbortController

///|
/// JS: new AbortController()
pub extern "js" fn AbortController::new() -> AbortController =
  #| () => new AbortController()

///|
/// JS: abortController.abort()
pub fn AbortController::abort(self : Self) -> AbortController {
  self.call0("abort") |> unsafe_cast
}

///|
/// JavaScript: AbortSignal
#external
pub type AbortSignal

///|
pub impl JsImpl for AbortSignal

///|
/// JS: abortController.signal
pub fn AbortController::signal(self : Self) -> AbortSignal {
  self.get("signal") |> unsafe_cast
}
