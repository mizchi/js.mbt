///|
#external
pub type Util

///|
pub impl @js.JsImpl for Util

///|
fn util() -> Util {
  @node.require("node:util") |> @js.identity
}

///|
/// util.inspect
pub fn inspect(
  value : @js.Any,
  depth? : Int,
  colors? : Bool,
  compact? : Bool,
  sorted? : Bool,
  breakLength? : Int,
  maxArrayLength? : Int,
  maxStringLength? : Int,
) -> String {
  let opt = @js.from_map({
    "depth": depth |> @js.js,
    "colors": colors |> @js.js,
    "compact": compact |> @js.js,
    "sorted": sorted |> @js.js,
    "breakLength": breakLength |> @js.js,
    "maxArrayLength": maxArrayLength |> @js.js,
    "maxStringLength": maxStringLength |> @js.js,
  })
  @js.identity(util().get("inspect").call_self([value, opt]))
}
