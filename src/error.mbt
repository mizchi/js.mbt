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
/// JS: error.message
pub fn JsError::message(self : Self) -> String {
  unsafe_cast(self.get("message"))
}

///|
/// JS: error.stack
pub fn JsError::stack(self : Self) -> String {
  unsafe_cast(self.get("stack"))
}

///|
/// JS: Error.isError(value)
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
