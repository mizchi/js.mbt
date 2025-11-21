///|
/// https://developer.mozilla.org/ja/docs/Web/API/FormData
#external
pub type FormData

///|
pub impl JsImpl for FormData

///|
pub fn FormData::append(self : Self, name : String, value : String) -> Unit {
  self.call2("append", name, value) |> unsafe_cast
}

///|
pub fn FormData::delete(self : Self, name : String) -> Unit {
  self.call("delete", [name]) |> unsafe_cast
}

///|
pub fn FormData::get(self : Self, name : String) -> String {
  self.call("get", [name]) |> unsafe_cast
}
