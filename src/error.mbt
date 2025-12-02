///|
pub(all) struct JsError {
  message : String
  stack : String
}

///|
pub extern "js" fn JsError::isError(value : @nostd.Any) -> Bool =
  #| (value) => Error.isError(value)

///|
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  let args : Array[@nostd.Any] = if cause is Some(cause) {
    [
      @nostd.any(message).cast(),
      @nostd.from_entries([("cause", cause |> @nostd.any)]).cast(),
    ]
  } else {
    [@nostd.any(message).cast()]
  }
  ffi_new_error(args)
}

///|
extern "js" fn ffi_new_error(args : Array[@nostd.Any]) -> JsError =
  #| (args) => new Error(...args)

///|
pub suberror ThrowError Any

///|
pub impl Show for ThrowError with output(self, logger) {
  logger.write_string("@js.Error: ")
  let ThrowError(inner) = self
  logger.write_object(inner)
}
