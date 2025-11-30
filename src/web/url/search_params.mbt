///|
pub(all) struct URLSearchParams {
  size : Int
}

///|
pub fn URLSearchParams::as_any(self : URLSearchParams) -> @nostd.Any = "%identity"

///|
impl Eq for URLSearchParams with equal(self, other) {
  @nostd.equal(self.as_any(), other.as_any())
}

///|
impl Show for URLSearchParams with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub fn URLSearchParams::get(self : URLSearchParams, name : String) -> String? {
  self.as_any()._call("get", [@nostd.any(name)]) |> @nostd.identity_option
}

///|
#alias(get_all)
pub fn URLSearchParams::getAll(
  self : URLSearchParams,
  name : String,
) -> Array[String] {
  self.as_any()._call("getAll", [@nostd.any(name)]).cast()
}

///|
pub fn URLSearchParams::has(self : URLSearchParams, name : String) -> Bool {
  self.as_any()._call("has", [@nostd.any(name)]).cast()
}

///|
pub fn URLSearchParams::set(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("set", [@nostd.any(name), @nostd.any(value)]) |> ignore
}

///|
pub fn URLSearchParams::append(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("append", [@nostd.any(name), @nostd.any(value)]) |> ignore
}

///|
pub fn URLSearchParams::delete(self : URLSearchParams, name : String) -> Unit {
  self.as_any()._call("delete", [@nostd.any(name)]) |> ignore
}

///|
pub fn URLSearchParams::sort(self : URLSearchParams) -> Unit {
  self.as_any()._call("sort", []) |> ignore
}

///|
#alias(toString)
pub fn URLSearchParams::to_string(self : URLSearchParams) -> String {
  self.as_any()._call("toString", []).cast()
}
