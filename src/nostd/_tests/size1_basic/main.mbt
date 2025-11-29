///|
extern "js" fn get_console() -> @nostd.Any =
  #| () => console

///|
extern "js" fn get_process_info() -> @nostd.Any =
  #| () => ({ version: typeof process !== 'undefined' ? process.version : null })

///|
priv struct ProcessInfo {
  version : @nostd.Nullish[String]
}

///|
fn main {
  let con = get_console()

  // Basic console.log
  con._call("log", [@nostd.any("Hello from MoonBit!")]) |> ignore

  // Test Nullish[T] with struct cast
  let info : ProcessInfo = get_process_info().cast()

  // Use Nullish[T]::to_option - demonstrates null handling
  match info.version.to_option() {
    Some(v) => con._call("log", [@nostd.any(v)]) |> ignore
    None => ()
  }
}
