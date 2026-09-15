///|
/// JavaScript: JSON
#external
pub type JSON

///|
extern "js" fn ffi_json_stringify(
  value : @core.Any,
  replacer : @core.Any,
  space : @core.Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_json_parse(json : String, reviver? : @core.Any) -> @core.Any =
  #| (json, reviver) => JSON.parse(json, reviver)

///|
/// JS: JSON.stringify(v, replacer, space)
pub fn JSON::stringify(
  v : @core.Any,
  replacer? : @core.Any = @core.undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v |> @core.identity, replacer, space |> @core.any)
}

///|
/// JS: JSON.parse(s, reviver)
pub fn[T] JSON::parse(s : String, reviver? : @core.Any? = None) -> T {
  ffi_json_parse(s, reviver?) |> @core.identity
}
