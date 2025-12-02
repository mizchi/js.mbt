///|
pub(all) struct URLSearchParams {
  size : Int
}

///|
pub fn URLSearchParams::as_any(self : URLSearchParams) -> @core.Any = "%identity"

///|
impl Eq for URLSearchParams with equal(self, other) {
  @core.equal(self.as_any(), other.as_any())
}

///|
impl Show for URLSearchParams with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub fn URLSearchParams::get(self : URLSearchParams, name : String) -> String? {
  self.as_any()._call("get", [@core.any(name)]) |> @core.identity_option
}

///|
#alias(get_all)
pub fn URLSearchParams::getAll(
  self : URLSearchParams,
  name : String,
) -> Array[String] {
  self.as_any()._call("getAll", [@core.any(name)]).cast()
}

///|
pub fn URLSearchParams::has(self : URLSearchParams, name : String) -> Bool {
  self.as_any()._call("has", [@core.any(name)]).cast()
}

///|
pub fn URLSearchParams::set(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("set", [@core.any(name), @core.any(value)]) |> ignore
}

///|
pub fn URLSearchParams::append(
  self : URLSearchParams,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("append", [@core.any(name), @core.any(value)]) |> ignore
}

///|
pub fn URLSearchParams::delete(self : URLSearchParams, name : String) -> Unit {
  self.as_any()._call("delete", [@core.any(name)]) |> ignore
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
