///|
/// JS operation wrapper with try-catch
pub extern "js" fn ffi_wrap_sync(
  op : () -> Any,
  on_ok : (Any) -> Unit,
  on_error : (Any) -> Unit,
) -> Unit =
  #| (op, on_ok, on_error) => { try { on_ok(op()); } catch (e) { on_error(e); } }

///|
/// Generic JS error type
pub suberror JsError String

///|
/// Safe wrapper that converts JS exceptions to MoonBit errors
pub fn try_sync(op : () -> Any) -> Any raise JsError {
  let result : Ref[Any?] = { val: None }
  let error : Ref[String?] = { val: None }
  ffi_wrap_sync(op, fn(v) { result.val = Some(v) }, fn(e) {
    let msg : String = e["message"].cast()
    error.val = Some(msg)
  })
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
/// Throw a JS Error with the given message
pub extern "js" fn throw_error(msg : String) -> Unit =
  #| (msg) => { throw new Error(msg); }

///|
/// Wrap a MoonBit operation that may raise, converting errors to JS exceptions
/// Usage: export_sync(fn() { may_raise_error() })
pub fn[E : Show + Error] export_sync(op : () -> Any raise E) -> Any {
  op() catch {
    e => {
      throw_error(e.to_string())
      undefined()
    }
  }
}

///|
/// Test helper: assert that op throws a JS exception
/// Returns the error message if thrown, fails if no exception
pub fn assert_throws(op : () -> Any) -> String raise JsError {
  try_sync(op) |> ignore
  raise JsError("Expected exception but none was thrown")
}

///|
/// Test helper: assert that op throws with specific message (contains check)
pub fn assert_throws_with(op : () -> Any, expected_msg : String) -> Unit {
  let msg = assert_throws(op) catch { JsError(m) => m }
  if not(msg.contains(expected_msg)) {
    let _ = throw_error(
      "Expected error containing \"" +
      expected_msg +
      "\" but got \"" +
      msg +
      "\"",
    )

  }
}
