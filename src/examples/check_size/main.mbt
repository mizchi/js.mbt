///|
fn main {
  // Simple test using lightweight JsValue API (no trait vtable)
  // Uses @nostd package for direct FFI methods
  @nostd.console_log("[check_size] Starting...")

  // Get global object and access console
  let global = @nostd.global_this()
  let console = global["console"]

  // Call console.log with a string (using method syntax)
  let msg = @nostd.str("Hello from MoonBit with lightweight JsValue!")
  let args = @nostd.array_new()
  @nostd.array_push(args, msg)
  let _ = console._call("log", args)

  // Simple object property access
  let process = global["process"]
  if @nostd.is_nullish(process) == false {
    let version = process["version"]
    let args2 = @nostd.array_new()
    @nostd.array_push(args2, version)
    let _ = console._call("log", args2)

  }
  @nostd.console_log("[check_size] Done!")
}
