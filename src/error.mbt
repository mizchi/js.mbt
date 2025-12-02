///|
pub(all) struct JsError {
  message : String
  stack : String
}

///|
pub extern "js" fn JsError::isError(value : @core.Any) -> Bool =
  #| (value) => Error.isError(value)

///|
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  let args : Array[@core.Any] = if cause is Some(cause) {
    [
      @core.any(message).cast(),
      @core.from_entries([("cause", cause |> @core.any)]).cast(),
    ]
  } else {
    [@core.any(message).cast()]
  }
  ffi_new_error(args)
}

///|
extern "js" fn ffi_new_error(args : Array[@core.Any]) -> JsError =
  #| (args) => new Error(...args)

///|
pub suberror ThrowError Any

///|
pub impl Show for ThrowError with output(self, logger) {
  logger.write_string("@js.Error: ")
  let ThrowError(inner) = self
  logger.write_object(inner)
}

///|
/// Wraps a synchronous function call, converting any thrown JS errors into ThrowError
/// ```moonbit skip
/// let result = throwable(() => undefined()._invoke([]))
/// ```
pub fn[T] throwable(f : () -> T raise?) -> T raise ThrowError {
  match throwable_result(f |> @core.identity) {
    Ok(result) => result |> @core.identity
    Err(e) => raise ThrowError(e |> @core.identity)
  }
}

///|
/// Wraps a synchronous function call that returns Result, converting any thrown JS errors into JsError
fn throwable_result(f : () -> Result[Any, Any]) -> Result[Any, Any] {
  ffi_wrap_sync(@core.identity(f), Ok(_), Err(_))
}

///|
extern "js" fn ffi_wrap_sync(
  f : Any,
  ok : (Any) -> Result[Any, Any],
  err : (Any) -> Result[Any, Any],
) -> Result[Any, Any] =
  #|(f, ok, err) => {
  #|  try {
  #|    return ok(f())
  #|  } catch(e) {
  #|    return err(e)
  #|  }
  #|}
