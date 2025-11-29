///|
extern "js" fn get_console() -> @nostd.JsValue =
  #| () => console

///|
fn main {
  // Get console directly via extern
  let con = get_console()

  // Call console.log with a string
  let msg = @nostd.JsValue::from("Hello from MoonBit with lightweight JsValue!")
  let args = @nostd.JsArray::new()
  args._push(msg)
  let _ = con._call("log", args)

  // Check process.version if available
  let global = @nostd.global_this()
  let process = global["process"]

  // Test is_null, is_undefined, is_nullish, equal
  if @nostd.is_null(process) {
    let _ = con._call("log", args)

  }
  if @nostd.is_undefined(process) {
    let _ = con._call("log", args)

  }
  if @nostd.is_nullish(process) == false {
    let version = process["version"]
    let args2 = @nostd.JsArray::new()
    args2._push(version)
    let _ = con._call("log", args2)

  }
  // Test equal
  let undef = @nostd.undefined()
  if @nostd.equal(process, undef) == false {
    let _ = con._call("log", args)

  }
}
