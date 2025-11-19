///|
#external
pub type Util

///|
pub impl JsImpl for Util

///|
fn util() -> Util {
  @node.require("node:util") |> @js.unsafe_cast
}

///|
/// util.inspect
pub fn inspect(
  value : Js,
  depth? : Int,
  colors? : Bool,
  compact? : Bool,
  sorted? : Bool,
  breakLength? : Int,
  maxArrayLength? : Int,
  maxStringLength? : Int,
) -> String {
  let opt = @js.from_map({
    "depth": depth |> js,
    "colors": colors |> js,
    "compact": compact |> js,
    "sorted": sorted |> js,
    "breakLength": breakLength |> js,
    "maxArrayLength": maxArrayLength |> js,
    "maxStringLength": maxStringLength |> js,
  })
  unsafe_cast(util().get("inspect").call_self([value, opt]))
}
