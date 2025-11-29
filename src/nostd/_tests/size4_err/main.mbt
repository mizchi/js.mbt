///|
/// nostd error handling test
/// Measures size of JS exception wrapping pattern

///|
extern "js" fn get_console() -> @nostd.Any =
  #| () => console

///|
/// Wrap JS operation with try-catch, call on_ok or on_error callback
extern "js" fn wrap_ffi(
  op : () -> @nostd.Any,
  on_ok : (@nostd.Any) -> Unit,
  on_error : (@nostd.Any) -> Unit,
) -> Unit =
  #| (op, on_ok, on_error) => { try { on_ok(op()); } catch (e) { on_error(e); } }

///|
/// JS operation that throws an error
extern "js" fn throwing_op() -> @nostd.Any =
  #| () => { throw new Error("Something went wrong!"); }

///|
/// JS operation that succeeds
extern "js" fn succeeding_op() -> @nostd.Any =
  #| () => ({ result: 42 })

///|
/// Custom error type for JS exceptions
suberror JsError String

///|
/// Safe wrapper that converts JS exceptions to MoonBit errors
fn try_call(op : () -> @nostd.Any) -> @nostd.Any raise JsError {
  let result : Ref[@nostd.Any?] = { val: None }
  let error : Ref[String?] = { val: None }
  wrap_ffi(
    op,
    fn(v) { result.val = Some(v) },
    fn(e) {
      // Get error message from JS Error object
      let msg : String = e["message"].cast()
      error.val = Some(msg)
    },
  )
  match error.val {
    Some(msg) => raise JsError(msg)
    None =>
      match result.val {
        Some(v) => v
        None => raise JsError("No result")
      }
  }
}

///|
fn log(con : @nostd.Any, msg : String) -> Unit {
  con._call("log", [@nostd.any(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()

  // Test 1: Succeeding operation
  try {
    let result = try_call(succeeding_op)
    let value : Int = result["result"].cast()
    log(con, "Success: " + value.to_string())
  } catch {
    JsError(msg) => log(con, "Unexpected error: " + msg)
  }

  // Test 2: Throwing operation
  try {
    let _ = try_call(throwing_op)
    log(con, "Should not reach here")
  } catch {
    JsError(msg) => log(con, "Caught error: " + msg)
  }
}
