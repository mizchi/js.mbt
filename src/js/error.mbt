///|
pub suberror JsError Value

// https://www.moonbitlang.com/pearls/moonbit-jsffi
///|
pub impl Show for JsError with output(self, logger) {
  logger.write_string("@js.Error: ")
  let JsError(inner) = self
  logger.write_object(inner)
}

///|
pub fn[T] try_call(f : () -> T) -> T raise JsError {
  let f : Value = to_js(f)
  match ffi_try_call(() => ffi_call(f, [])) {
    Err(e) => raise JsError(e)
    Ok(v) => v.cast()
  }
}

