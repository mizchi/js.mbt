///|
pub(all) struct URLSearchParams {
  size : Int
}

///|
impl JsImpl for URLSearchParams

///|
impl Eq for URLSearchParams with equal(self, other) {
  self.to_js() == other.to_js()
}

///|
impl Show for URLSearchParams with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub fn URLSearchParams::get(self : URLSearchParams, name : String) -> String? {
  self.call("get", [name]) |> @js.unsafe_cast_option
}

///|
#alias(getAll)
pub fn URLSearchParams::get_all(
  self : URLSearchParams,
  name : String,
) -> Array[String] {
  self.call("getAll", [name]) |> unsafe_cast
}

///|
pub fn URLSearchParams::has(self : URLSearchParams, name : String) -> Bool {
  self.call("has", [name]) |> unsafe_cast
}

///|
pub fn URLSearchParams::set(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.call2("set", name, value) |> unsafe_cast
}

///|
pub fn URLSearchParams::append(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.call2("append", name, value) |> unsafe_cast
}

///|
pub fn URLSearchParams::delete(self : URLSearchParams, name : String) -> Unit {
  self.call("delete", [name]) |> unsafe_cast
}

///|
pub fn URLSearchParams::sort(self : URLSearchParams) -> Unit {
  self.call0("sort") |> unsafe_cast
}

///|
#alias(toString)
pub fn URLSearchParams::to_string(self : URLSearchParams) -> String {
  self.call0("toString") |> unsafe_cast
}
