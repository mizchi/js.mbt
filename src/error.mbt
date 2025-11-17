///|
/// JavaScript Error
#external
pub type JsError

///|
pub impl Js for JsError

///|
pub suberror JsThrowError {
  // TODO: Differentiate error types
  // TypeError
  // ReferenceError
  // SyntaxError
  // RangeError
  // etc.
  Error(JsError)
  Value(Val)
}

///|
pub impl Js for JsThrowError

///|
extern "js" fn ffi_wrap_sync(
  f : Val,
  ok : (Val) -> Result[Val, Val],
  err : (Val) -> Result[Val, Val],
) -> Result[Val, Val] =
  #|(f, ok, err) => {
  #|  try {
  #|    return ok(f())
  #|  } catch(e) {
  #|    return err(e)
  #|  }
  #|}

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
fn throwable_result(f : () -> Result[Val, Val]) -> Result[Val, Val] {
  ffi_wrap_sync(unsafe_cast(f), Ok(_), Err(_))
}

///|
pub impl Show for JsThrowError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
impl Show for JsError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
impl Show for JsError with to_string(self) {
  self.message()
}

///|
pub fn JsError::message(self : Self) -> String {
  unsafe_cast(self.get("message"))
}

///|
pub fn JsError::stack(self : Self) -> String {
  unsafe_cast(self.get("stack"))
}

///|
pub fn JsError::isError(val : &Js) -> Bool {
  ffi_is_error(val.to_js())
}

///|
/// Throws a JavaScript error/value
/// ```nocheck
/// throw_js(new_error("Something went wrong"))
/// ```
pub fn throw_(v : &Js) -> Unit {
  ffi_throw(v.to_js())
}

///|
/// Create a new JavaScript Error object.
///
/// Equivalent to JavaScript's `new Error(message, { cause })`.
///
/// # Parameters
///
/// - `message`: The error message
/// - `cause`: Optional cause of the error (another ErrorObject)
///
/// # Returns
///
/// A new ErrorObject
///
/// # Example
///
/// ```moonbit
/// let error = new_error("Something went wrong")
/// let caused_error = new_error("Failed operation", cause=error)
/// ```
pub fn new_error(message : String, cause? : JsError) -> JsError {
  let args : Array[Val] = if cause is Some(cause) {
    [js(message), from_map({ "cause": cause |> unsafe_cast() })]
  } else {
    [js(message)]
  }
  ffi_new_error(args)
}
