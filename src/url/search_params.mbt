///|
#external
pub type URLSearchParams

///|
impl Js for URLSearchParams

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
  self.invoke("get", [name]) |> unsafe_option
}

///|
#alias(getAll)
pub fn URLSearchParams::get_all(
  self : URLSearchParams,
  name : String,
) -> Array[String] {
  self.invoke("getAll", [name]) |> unsafe_cast
}

///|
pub fn URLSearchParams::has(self : URLSearchParams, name : String) -> Bool {
  self.invoke("has", [name]) |> unsafe_cast
}

///|
pub fn URLSearchParams::set(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.invoke("set", [name, value]) |> unsafe_cast
}

///|
pub fn URLSearchParams::append(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.invoke("append", [name, value]) |> unsafe_cast
}

///|
pub fn URLSearchParams::delete(self : URLSearchParams, name : String) -> Unit {
  self.invoke("delete", [name]) |> unsafe_cast
}

///|
pub fn URLSearchParams::sort(self : URLSearchParams) -> Unit {
  self.invoke("sort", []) |> unsafe_cast
}

///|
pub fn URLSearchParams::size(self : URLSearchParams) -> Int {
  unsafe_cast(self.to_js().get("size"))
}

///|
#alias(toString)
pub fn URLSearchParams::to_string(self : URLSearchParams) -> String {
  self.invoke("toString", []) |> unsafe_cast
}
