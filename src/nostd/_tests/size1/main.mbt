///|
extern "js" fn get_console() -> @nostd.JsValue =
  #| () => console

///|
extern "js" fn get_process_info() -> @nostd.JsValue =
  #| () => ({ version: typeof process !== 'undefined' ? process.version : null })

///|
priv struct ProcessInfo {
  version : @nostd.Nullish[String]
}

///|
fn main {
  let con = get_console()

  // Basic console.log
  let msg = @nostd.JsValue::from("Hello from MoonBit!")
  let args = @nostd.JsArray::new()
  args._push(msg)
  let _ = con._call("log", args)

  // Test Nullish[T] with struct cast
  let info : ProcessInfo = get_process_info().cast()

  // Use Nullish[T]::to_option - demonstrates null handling
  match info.version.to_option() {
    Some(v) => {
      let args2 = @nostd.JsArray::new()
      args2._push(@nostd.JsValue::from(v))
      let _ = con._call("log", args2)
    }
    None => ()
  }
}
