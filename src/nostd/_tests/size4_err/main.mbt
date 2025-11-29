///|
/// nostd error handling test
/// Measures size of JS exception wrapping pattern using @nostd.try_sync

///|
extern "js" fn get_console() -> @nostd.Any =
  #| () => console

///|
/// JS operation that throws an error
extern "js" fn throwing_op() -> @nostd.Any =
  #| () => { throw new Error("Something went wrong!"); }

///|
/// JS operation that succeeds
extern "js" fn succeeding_op() -> @nostd.Any =
  #| () => ({ result: 42 })

///|
fn log(con : @nostd.Any, msg : String) -> Unit {
  con._call("log", [@nostd.any(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()

  // Test 1: Succeeding operation
  try {
    let result = @nostd.try_sync(succeeding_op)
    let value : Int = result["result"].cast()
    log(con, "Success: " + value.to_string())
  } catch {
    @nostd.JsError(msg) => log(con, "Unexpected error: " + msg)
  }

  // Test 2: Throwing operation
  try {
    let _ = @nostd.try_sync(throwing_op)
    log(con, "Should not reach here")
  } catch {
    @nostd.JsError(msg) => log(con, "Caught error: " + msg)
  }
}
