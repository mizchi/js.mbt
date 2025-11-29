///|
fn main {
  // Simple test using lightweight JsValue API (no trait vtable)
  // Uses @nostd package for direct FFI methods
  let global = @nostd.global_this()
  let console = global["console"]

  // Call console.log with a string (using method syntax)
  console._call("log", [
    @nostd.JsValue::from("Hello from MoonBit with lightweight JsValue!"),
  ])
  |> ignore

  // Simple object property access
  let process = global["process"]
  if @nostd.is_nullish(process) == false {
    let version = process["version"]
    console._call("log", [version]) |> ignore
  }
}
