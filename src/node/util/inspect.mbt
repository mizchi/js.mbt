///|
extern "js" fn util_module() -> @js.Any =
  #| () => require("node:util")

///|
#external
pub type Util

///|
pub impl @js.JsImpl for Util

///|
fn util() -> Util {
  util_module() |> @js.identity
}

///|
/// util.inspect
pub fn inspect(
  value : &@js.JsImpl,
  depth? : Int,
  colors? : Bool,
  compact? : Bool,
  sorted? : Bool,
  breakLength? : Int,
  maxArrayLength? : Int,
  maxStringLength? : Int,
) -> String {
  let opt : @js.Any = @mbtconv.from_option_map({
    "depth": depth.map(fn(x) { @nostd.any(x) }),
    "colors": colors.map(fn(x) { @nostd.any(x) }),
    "compact": compact.map(fn(x) { @nostd.any(x) }),
    "sorted": sorted.map(fn(x) { @nostd.any(x) }),
    "breakLength": breakLength.map(fn(x) { @nostd.any(x) }),
    "maxArrayLength": maxArrayLength.map(fn(x) { @nostd.any(x) }),
    "maxStringLength": maxStringLength.map(fn(x) { @nostd.any(x) }),
  }).cast()
  @js.identity(util().get("inspect").call_self([value.as_any(), opt]))
}
