///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
#external
pub type Util

///|
pub impl Js for Util with to_js(self) -> Val {
  self |> js
}

///|
pub fn Util::require() -> Self {
  @node.require("node:util") |> @js.unsafe_cast
}

///|
pub fn inspect(
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
  let opt = @js.from_optional_map({
    "depth": depth |> unsafe_cast,
    "colors": colors |> unsafe_cast,
    "compact": compact |> unsafe_cast,
    "sorted": sorted |> unsafe_cast,
    "breakLength": break_length |> unsafe_cast,
    "maxArrayLength": max_array_length |> unsafe_cast,
    "maxStringLength": max_string_length |> unsafe_cast,
  })
  self.to_js().get("inspect").call([value, opt]).cast()
}

///|
test "inspect" {
  let util = Util::require()
  let obj : Json = {
    "xxx": "------------------------",
    "a": 1,
    "b": [1, 2, 3],
    "c": { "d": "hello" },
  }
  let s = util.inspect(
    Js::to_js(obj),
    depth=2,
    colors=true,
    compact=true,
    sorted=true,
    break_length=80,
    max_array_length=10,
    max_string_length=50,
  )
  // println(s)
  assert_true(s.contains("a: 1"))
  assert_true(s.contains("b: [ 1, 2, 3 ]"))
  assert_true(s.contains("c: { d: 'hello' }"))
}
