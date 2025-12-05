///|
extern "js" fn util_module() -> @core.Any =
  #| () => require("node:util")

///|
#external
pub type Util

///|
pub fn Util::as_any(self : Util) -> @core.Any = "%identity"

///|
fn util() -> Util {
  util_module() |> @core.identity
}

///|
/// util.inspect
pub fn inspect(
  value : @core.Any,
  depth? : Int,
  colors? : Bool,
  compact? : Bool,
  sorted? : Bool,
  breakLength? : Int,
  maxArrayLength? : Int,
  maxStringLength? : Int,
) -> String {
  let entries : Array[(String, @core.Any)] = []
  if depth is Some(v) {
    entries.push(("depth", @core.any(v)))
  }
  if colors is Some(v) {
    entries.push(("colors", @core.any(v)))
  }
  if compact is Some(v) {
    entries.push(("compact", @core.any(v)))
  }
  if sorted is Some(v) {
    entries.push(("sorted", @core.any(v)))
  }
  if breakLength is Some(v) {
    entries.push(("breakLength", @core.any(v)))
  }
  if maxArrayLength is Some(v) {
    entries.push(("maxArrayLength", @core.any(v)))
  }
  if maxStringLength is Some(v) {
    entries.push(("maxStringLength", @core.any(v)))
  }
  let opt : @core.Any = @core.from_entries(entries)
  util().as_any()["inspect"]._invoke([value, opt]).cast()
}
