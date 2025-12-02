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
  let opt : @core.Any = @mbtconv.from_option_map({
    "depth": depth.map(fn(x) { @core.any(x) }),
    "colors": colors.map(fn(x) { @core.any(x) }),
    "compact": compact.map(fn(x) { @core.any(x) }),
    "sorted": sorted.map(fn(x) { @core.any(x) }),
    "breakLength": breakLength.map(fn(x) { @core.any(x) }),
    "maxArrayLength": maxArrayLength.map(fn(x) { @core.any(x) }),
    "maxStringLength": maxStringLength.map(fn(x) { @core.any(x) }),
  })
  util().as_any()["inspect"]._invoke([value, opt]).cast()
}
