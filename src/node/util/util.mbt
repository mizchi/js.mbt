///|
#external
pub type Util

///|
pub impl JsImpl for Util

///|
pub fn Util::require() -> Self {
  @node.require("node:util") |> @js.unsafe_cast
}

///|
pub fn inspect_(
  value : Js,
  depth? : Int,
  colors? : Bool,
  compact? : Bool,
  sorted? : Bool,
  break_length? : Int,
  max_array_length? : Int,
  max_string_length? : Int,
) -> String {
  let util = Util::require()
  util.inspect(
    value,
    depth?,
    colors?,
    compact?,
    sorted?,
    breakLength?=break_length,
    maxArrayLength?=max_array_length,
    maxStringLength?=max_string_length,
  )
}

///|
pub fn Util::inspect(
  self : Self,
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
    "depth": depth |> safe_js,
    "colors": colors |> safe_js,
    "compact": compact |> safe_js,
    "sorted": sorted |> safe_js,
    "breakLength": breakLength |> safe_js,
    "maxArrayLength": maxArrayLength |> safe_js,
    "maxStringLength": maxStringLength |> safe_js,
  })
  unsafe_cast(self.get("inspect").invoke_self([value, opt]))
}
