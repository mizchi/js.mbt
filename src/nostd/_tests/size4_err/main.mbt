///|
/// nostd error handling test
/// Demonstrates bidirectional error conversion: JS <-> MoonBit

///|
extern "js" fn get_console() -> @nostd.Any =
  #| () => console

///|
/// JS operation that throws an error
extern "js" fn js_throwing_op() -> @nostd.Any =
  #| () => { throw new Error("JS error!"); }

///|
/// JS operation that succeeds
extern "js" fn js_succeeding_op() -> @nostd.Any =
  #| () => ({ result: 42 })

///|
/// JS function that calls MoonBit and catches errors
extern "js" fn js_catch_call(op : () -> @nostd.Any) -> @nostd.Any =
  #| (op) => { try { return { ok: true, value: op() }; } catch (e) { return { ok: false, msg: e.message }; } }

///|
suberror AppError String derive(Show)

///|
fn moonbit_throwing_op() -> @nostd.Any raise AppError {
  raise AppError("MoonBit error!")
}

///|
fn log(con : @nostd.Any, msg : String) -> Unit {
  con._call("log", [@nostd.any(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()

  // Test 1: JS -> MoonBit (try_sync catches JS exception)
  log(con, "=== JS -> MoonBit ===")
  try {
    let result = @nostd.try_sync(js_succeeding_op)
    let value : Int = result["result"].cast()
    log(con, "Success: " + value.to_string())
  } catch {
    @nostd.JsError(msg) => log(con, "Error: " + msg)
  }
  try {
    let _ = @nostd.try_sync(js_throwing_op)
    log(con, "Should not reach here")
  } catch {
    @nostd.JsError(msg) => log(con, "Caught JS error: " + msg)
  }

  // Test 2: MoonBit -> JS (export_sync converts MoonBit error to JS exception)
  log(con, "=== MoonBit -> JS ===")
  let result = js_catch_call(fn() { @nostd.export_sync(moonbit_throwing_op) })
  let ok : Bool = result["ok"].cast()
  if ok {
    log(con, "Should not reach here")
  } else {
    let msg : String = result["msg"].cast()
    log(con, "JS caught MoonBit error: " + msg)
  }
}
