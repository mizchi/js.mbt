///|
#external
pub type JSON

///|
pub fn JSON::stringify(
  v : Val,
  replacer? : Val = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_js(), replacer, space |> safe_js)
}

///|
pub fn JSON::parse(
  s : String,
  reviver? : Val? = None,
) -> Val raise JsThrowError {
  throwable(() => ffi_json_parse(s, reviver?))
}
