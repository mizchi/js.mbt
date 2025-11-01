///|
#external
pub type URLSearchParams

///|
impl Js for URLSearchParams with to_js(self) {
  self |> js
}

///|
pub fn URLSearchParams::get(self : URLSearchParams, name : String) -> String? {
  self.to_js().get("get").call([name]).cast_option()
}

///|
pub fn URLSearchParams::get_all(
  self : URLSearchParams,
  name : String,
) -> Array[String] {
  self.to_js().get("getAll").call([name]).cast()
}

///|
pub fn URLSearchParams::has(self : URLSearchParams, name : String) -> Bool {
  self.to_js().get("has").call([name]).cast()
}

///|
pub fn URLSearchParams::set(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.to_js().get("set").call([name, value]).cast()
}
