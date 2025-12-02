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
