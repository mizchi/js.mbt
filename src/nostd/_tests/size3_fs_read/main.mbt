///|
/// nostd fs_promises.readFile implementation test
/// Measures size of a practical Node.js file reading use case

///|
extern "js" fn get_console() -> @nostd.JsValue =
  #| () => console

///|
/// node:fs/promises module
extern "js" fn fs_promises() -> @nostd.JsValue =
  #| () => require("node:fs/promises")

///|
/// MoonBit builtin %async.suspend
async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
/// MoonBit builtin %async.run
fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// Await a JS Promise using suspend
async fn[T] wait(promise : @nostd.JsValue) -> T {
  suspend(fn(resolve, reject) {
    promise._call("then", [@nostd.JsValue::from(resolve)]) |> ignore
    promise._call("catch", [@nostd.JsValue::from(reject)]) |> ignore
  })
}

///|
/// nostd version of fs_promises.readFile
async fn read_file(path : String, encoding : String) -> String {
  let fs = fs_promises()
  let promise = fs._call("readFile", [
    @nostd.JsValue::from(path),
    @nostd.JsValue::from(encoding),
  ])
  wait(promise)
}

///|
fn log(con : @nostd.JsValue, msg : String) -> Unit {
  con._call("log", [@nostd.JsValue::from(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()
  run_async(async fn() noraise {
    // Read package.json (exists in project root)
    let content : String = read_file("package.json", "utf-8") catch {
      _ => "read error"
    }
    // Just log content length to verify it works
    let len_msg = "Content length: " + content.length().to_string()
    log(con, len_msg)
  })
}
