// JavaScript String
// In this file, we impl only static methods of String.*
// Use builtin String as instance methods.

///|
#external
pub type JsString

///|
pub impl Js for JsString

///|
fn string_instance() -> JsString {
  unsafe_cast(globalThis().get("String"))
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCharCode(values : Array[Int]) -> String {
  string_instance().invoke("fromCharCode", values |> from_array |> unsafe_cast)
  |> unsafe_cast
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCodePoint(values : Array[Int]) -> String {
  string_instance().invoke("fromCodePoint", values |> from_array |> unsafe_cast)
  |> unsafe_cast
}
