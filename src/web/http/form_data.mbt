///|
/// https://developer.mozilla.org/ja/docs/Web/API/FormData
#external
pub type FormData

///|
pub fn FormData::as_any(self : FormData) -> @core.Any = "%identity"

///|
pub fn FormData::append(self : Self, name : String, value : String) -> Unit {
  self.as_any()._call("append", [@core.any(name), @core.any(value)]) |> ignore
}

///|
pub fn FormData::delete(self : Self, name : String) -> Unit {
  self.as_any()._call("delete", [@core.any(name)]) |> ignore
}

///|
pub fn FormData::get(self : Self, name : String) -> String {
  self.as_any()._call("get", [@core.any(name)]).cast()
}
