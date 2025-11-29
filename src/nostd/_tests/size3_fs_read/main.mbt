///|
/// nostd fs_promises.readFile implementation test
/// Measures size of a practical Node.js file reading use case

///|
extern "js" fn get_console() -> @nostd.Any =
  #| () => console

///|
/// node:fs/promises module
extern "js" fn fs_promises() -> @nostd.Any =
  #| () => require("node:fs/promises")

///|
/// nostd version of fs_promises.readFile
async fn read_file(path : String, encoding : String) -> String {
  let fs = fs_promises()
  let promise : @nostd.Promise[String] = fs._call("readFile", [
      @nostd.any(path),
      @nostd.any(encoding),
    ])
    |> @nostd.identity
  promise.wait()
}

///|
fn log(con : @nostd.Any, msg : String) -> Unit {
  con._call("log", [@nostd.any(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()
  @nostd.run_async(async fn() noraise {
    // Read package.json (exists in project root)
    let content : String = read_file("package.json", "utf-8") catch {
      _ => "read error"
    }
    // Just log content length to verify it works
    let len_msg = "Content length: " + content.length().to_string()
    log(con, len_msg)
  })
}
