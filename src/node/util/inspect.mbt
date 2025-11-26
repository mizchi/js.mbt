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
  let opt = @js.from_map({
    "depth": depth |> @js.any,
    "colors": colors |> @js.any,
    "compact": compact |> @js.any,
    "sorted": sorted |> @js.any,
    "breakLength": breakLength |> @js.any,
    "maxArrayLength": maxArrayLength |> @js.any,
    "maxStringLength": maxStringLength |> @js.any,
  })
  @js.identity(util().get("inspect").call_self([value.to_any(), opt]))
}
