///|
#external
pub type URLSearchParams

///|
impl Js for URLSearchParams with to_js(self) {
  self |> js
}

///|
impl Eq for URLSearchParams with op_equal(self, other) {
  self.to_js() == other.to_js()
}

///|
impl Show for URLSearchParams with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub fn URLSearchParams::get(self : URLSearchParams, name : String) -> String? {
  self.to_js().invoke("get", [name]).cast_option()
}

///|
#alias(getAll)
pub fn URLSearchParams::get_all(
  self : URLSearchParams,
  name : String,
) -> Array[String] {
  self.to_js().invoke("getAll", [name]).cast()
}

///|
pub fn URLSearchParams::has(self : URLSearchParams, name : String) -> Bool {
  self.to_js().invoke("has", [name]).cast()
}

///|
pub fn URLSearchParams::set(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.to_js().invoke("set", [name, value]).cast()
}

///|
pub fn URLSearchParams::append(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.to_js().invoke("append", [name, value]).cast()
}

///|
pub fn URLSearchParams::delete(self : URLSearchParams, name : String) -> Unit {
  self.to_js().invoke("delete", [name]).cast()
}

///|
pub fn URLSearchParams::sort(self : URLSearchParams) -> Unit {
  self.to_js().invoke("sort", []).cast()
}

///|
pub fn URLSearchParams::size(self : URLSearchParams) -> Int {
  self.to_js().get("size").cast()
}

///|
#alias(toString)
pub fn URLSearchParams::to_string(self : URLSearchParams) -> String {
  self.to_js().invoke("toString", []).cast()
}
