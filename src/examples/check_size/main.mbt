///|
fn main {
  // Simple test using lightweight JsValue API (no trait vtable)
  // Uses @nostd package for direct FFI methods
  let global = @nostd.global_this()
  let console = global["console"]

  // Call console.log with a string (using method syntax)
  let msg = @nostd.JsValue::from("Hello from MoonBit with lightweight JsValue!")
  let args = @nostd.JsArray::new()
  args._push(msg)
  let _ = console._call("log", args)

  // Simple object property access
  let process = global["process"]
  if @nostd.is_nullish(process) == false {
    let version = process["version"]
    let args2 = @nostd.JsArray::new()
    args2._push(version)
    let _ = console._call("log", args2)

  }
}
