///|
extern "js" fn util_module() -> @js.Any =
  #| () => require("node:util")

///|
#external
pub type Util

///|
pub fn Util::as_any(self : Util) -> @nostd.Any = "%identity"

///|
fn util() -> Util {
  util_module() |> @js.identity
}

///|
/// util.inspect
pub fn inspect(
  value : @nostd.Any,
  depth? : Int,
  colors? : Bool,
  compact? : Bool,
  sorted? : Bool,
  breakLength? : Int,
  maxArrayLength? : Int,
  maxStringLength? : Int,
) -> String {
  let opt : @nostd.Any = @mbtconv.from_option_map({
    "depth": depth.map(fn(x) { @nostd.any(x) }),
    "colors": colors.map(fn(x) { @nostd.any(x) }),
    "compact": compact.map(fn(x) { @nostd.any(x) }),
    "sorted": sorted.map(fn(x) { @nostd.any(x) }),
    "breakLength": breakLength.map(fn(x) { @nostd.any(x) }),
    "maxArrayLength": maxArrayLength.map(fn(x) { @nostd.any(x) }),
    "maxStringLength": maxStringLength.map(fn(x) { @nostd.any(x) }),
  })
  util().as_any()["inspect"]._invoke([value, opt]).cast()
}
