///|
fn main {
  let obj = @js.Object::new()
  obj.set("name", "MoonBit")
  @js.log(obj)
  obj.has_own_property("name") |> @js.log
  obj.invoke("hasOwnProperty", ["nothing"]) |> @js.log
}
