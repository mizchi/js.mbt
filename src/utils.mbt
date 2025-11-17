
///|
/// Wraps a synchronous function call, converting any thrown JS errors into JsError
/// ```moonbit skip
/// let result = throwable(() => {
///   undefined().invoke_self([])
/// })
/// ```
pub fn[T] throwable(f : () -> T raise?) -> T raise JsThrowError {
  match throwable_result(f |> unsafe_cast) {
    Ok(result) => result |> unsafe_cast
    Err(e) => {
      if ffi_is_error(e) {
        raise JsThrowError::Error(unsafe_cast(e))
      }
      raise JsThrowError::Value(e |> unsafe_cast)
    }
  }
}

///|
/// Wraps a synchronous function call that returns Result, converting any thrown JS errors into JsError
fn throwable_result(f : () -> Result[Val, Val]) -> Result[Val, Val] {
  ffi_wrap_sync(unsafe_cast(f), Ok(_), Err(_))
}
