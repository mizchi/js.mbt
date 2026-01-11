///|
/// nostd fs_promises.readFile implementation test
/// Measures size of a practical Node.js file reading use case

///|
extern "js" fn get_console() -> @core.Any =
  #| () => console

///|
/// node:fs/promises module
extern "js" fn fs_promises() -> @core.Any =
  #| () => require("node:fs/promises")

///|
/// nostd version of fs_promises.readFile
async fn read_file(path : String, encoding : String) -> String {
  let fs = fs_promises()
  let promise : @core.Promise[String] = fs._call("readFile", [
      @core.any(path),
      @core.any(encoding),
    ])
    |> @core.identity
  promise.wait()
}

///|
fn log(con : @core.Any, msg : String) -> Unit {
  con._call("log", [@core.any(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()
  @core.run_async(async fn() noraise {
    // Read package.json (exists in project root)
    let content : String = read_file("package.json", "utf-8") catch {
      _ => "read error"
    }
    // Just log content length to verify it works
    let len_msg = "Content length: " + content.length().to_string()
    log(con, len_msg)
  })
}
