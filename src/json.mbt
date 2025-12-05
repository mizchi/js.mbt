///|
/// JavaScript: JSON
#external
pub type JSON

///|
/// JS: JSON.stringify(v, replacer, space)
pub fn JSON::stringify(
  v : @core.Any,
  replacer? : Any = @core.undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v |> identity, replacer, space |> any)
}

///|
/// JS: JSON.parse(s, reviver)
pub fn[T] JSON::parse(s : String, reviver? : Any? = None) -> T raise ThrowError {
  throwable(() => ffi_json_parse(s, reviver?) |> identity)
}
