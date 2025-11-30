///|
/// https://developer.mozilla.org/ja/docs/Web/API/FormData
#external
pub type FormData

///|
pub fn FormData::as_any(self : FormData) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for FormData

///|
pub fn FormData::append(self : Self, name : String, value : String) -> Unit {
  self.as_any()._call("append", [@nostd.any(name), @nostd.any(value)]) |> ignore
}

///|
pub fn FormData::delete(self : Self, name : String) -> Unit {
  self.as_any()._call("delete", [@nostd.any(name)]) |> ignore
}

///|
pub fn FormData::get(self : Self, name : String) -> String {
  self.as_any()._call("get", [@nostd.any(name)]).cast()
}
