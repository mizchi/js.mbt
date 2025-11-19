///|
fn main {
  let obj = @js.Object::new()
  obj.set("name", "MoonBit")
  @js.log(obj)
  obj.hasOwnProperty("name") |> @js.log
  obj.call("hasOwnProperty", ["nothing"]) |> @js.log
}
