///|
#external
pub type Util

///|
pub impl Js for Util

///|
pub fn Util::require() -> Self {
  @node.require("node:util") |> @js.unsafe_cast
}

///|
pub fn inspect_(
  value : Val,
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
    break_length?,
    max_array_length?,
    max_string_length?,
  )
}

///|
pub fn Util::inspect(
  self : Self,
  value : Val,
  depth? : Int,
  colors? : Bool,
  compact? : Bool,
  sorted? : Bool,
  break_length? : Int,
  max_array_length? : Int,
  max_string_length? : Int,
) -> String {
  let opt = @js.from_builtin_map({
    "depth": depth |> js,
    "colors": colors |> js,
    "compact": compact |> js,
    "sorted": sorted |> js,
    "breakLength": break_length |> js,
    "maxArrayLength": max_array_length |> js,
    "maxStringLength": max_string_length |> js,
  })
  unsafe_cast(self.to_js().get("inspect").invoke_self([value, opt]))
}

///|
test "util:inspect" {
  let util = Util::require()
  let obj : Json = {
    "xxx": "------------------------",
    "a": 1,
    "b": [1, 2, 3],
    "c": { "d": "hello" },
  }
  let s = util.inspect(
    @js.from_builtin_json(obj),
    depth=2,
    colors=false,
    compact=true,
    sorted=true,
    break_length=80,
    max_array_length=10,
    max_string_length=50,
  )
  @builtin.inspect(
    s,
    content="{ a: 1, b: [ 1, 2, 3 ], c: { d: 'hello' }, xxx: '------------------------' }",
  )
}
