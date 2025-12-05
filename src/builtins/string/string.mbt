///|
#external
pub type JsString

///|
pub fn JsString::to_any(self : JsString) -> @core.Any = "%identity"

///|
fn string_instance() -> JsString {
  @core.global_this()._get("String").cast()
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCharCode(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_char_code = string_class.to_any()["fromCharCode"]
  from_char_code._call("apply", [
    string_class.to_any(),
    @core.any(@core.any(values)),
  ])
  |> @core.identity
}

///|
/// JS: String.fromCodePoint(...values)
pub fn JsString::fromCodePoint(values : Array[Int]) -> String {
  let string_class = string_instance()
  let from_code_point = string_class.to_any()["fromCodePoint"]
  from_code_point._call("apply", [
    string_class.to_any(),
    @core.any(@core.any(values)),
  ])
  |> @core.identity
}
