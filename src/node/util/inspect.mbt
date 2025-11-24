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
    "depth": depth |> @js.any,
    "colors": colors |> @js.any,
    "compact": compact |> @js.any,
    "sorted": sorted |> @js.any,
    "breakLength": breakLength |> @js.any,
    "maxArrayLength": maxArrayLength |> @js.any,
    "maxStringLength": maxStringLength |> @js.any,
  })
  @js.identity(util().get("inspect").call_self([value, opt]))
}
