///|
#external
pub type FormData

///|
pub impl JsImpl for FormData

///|
pub fn FormData::append(self : Self, name : String, value : String) -> Unit {
  self.invoke("append", [name, value]) |> unsafe_cast
}

///|
pub fn FormData::delete(self : Self, name : String) -> Unit {
  self.invoke("delete", [name]) |> unsafe_cast
}

///|
pub fn FormData::get(self : Self, name : String) -> String {
  self.invoke("get", [name]) |> unsafe_cast
}
