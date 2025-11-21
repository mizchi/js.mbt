///|
/// JavaScript Error
// pub type JsError

// #external
pub(all) struct JsError {
  message : String
  stack : String
}

///|
pub impl JsImpl for JsError

///|
pub suberror JsThrowError {
  // TODO: Differentiate error types
  // TypeError
  // ReferenceError
  // SyntaxError
  // RangeError
  // etc.
  Error(JsError)
  Value(Js)
}

///|
pub impl JsImpl for JsThrowError

///|
pub impl Show for JsThrowError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for JsThrowError with to_string(self) {
  match self {
    Error(err) => err.message
    Value(val) => val.to_string()
  }
}

///|
pub impl Show for JsError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for JsError with to_string(self) {
  self.message
}

///|
/// JS: error.message
// pub fn JsError::message(self : Self) -> String {
//   self.get("message") |> unsafe_cast
// }

///|
/// JS: error.stack
// pub fn JsError::stack(self : Self) -> String {
//   self.get("stack") |> unsafe_cast
// }

///|
/// JS: Error.isError(value)
pub fn JsError::isError(val : &JsImpl) -> Bool {
  ffi_is_error(val.to_js())
}

///|
/// Throws a JavaScript error/value
/// ```nocheck
/// throw_js(new_error("Something went wrong"))
/// ```
pub fn throw_(v : &JsImpl) -> Unit {
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
/// let error = JsError::new("Something went wrong")
/// let _caused_error = JsError::new("Failed operation", cause=error)
/// ```
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  let args : Array[Js] = if cause is Some(cause) {
    [message |> js, from_map({ "cause": cause |> unsafe_cast() })]
  } else {
    [message |> js]
  }
  ffi_new_error(args)
}
