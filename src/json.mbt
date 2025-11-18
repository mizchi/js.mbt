///|
#external
pub type JSON

///|
pub fn JSON::stringify(
  v : Js,
  replacer? : Js = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_js(), replacer, space |> js)
}

///|
pub fn JSON::parse(s : String, reviver? : Js? = None) -> Js raise JsThrowError {
  throwable(() => ffi_json_parse(s, reviver?))
}
