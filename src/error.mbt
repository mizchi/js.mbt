///|
/// Error
#external
pub type ErrorObject

///|
pub suberror JsError ErrorObject

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
/// ```nocheck
/// let result = wrap(() => {
///   undefined().call([])
/// })
/// ```
pub fn[T] throwable(f : () -> T raise?) -> T raise JsError {
  match wrap_result(f |> unsafe_cast) {
    Ok(result) => result |> unsafe_cast
    Err(e) => raise JsError(e |> unsafe_cast)
  }
}

///|
pub fn wrap_result(f : () -> Result[Val, Val]) -> Result[Val, Val] {
  ffi_wrap_sync(unsafe_cast(f), Ok(_), Err(_))
}

///|
pub impl Show for JsError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Js for JsError

///|
impl Js for ErrorObject

///|
impl Show for ErrorObject with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
impl Show for ErrorObject with to_string(self) {
  self.message()
}

///|
pub fn ErrorObject::message(self : Self) -> String {
  unsafe_cast(self.get("message"))
}

///|
pub fn ErrorObject::stack(self : Self) -> String {
  unsafe_cast(self.get("stack"))
}

///|
pub fn ErrorObject::is_error(self : Self) -> Bool {
  self |> ffi_is_error
}

///|
/// Throws a JavaScript error/value
/// ```nocheck
/// throw_js(new_error("Something went wrong"))
/// ```
pub fn throw_js(v : Val) -> Unit {
  ffi_throw(v)
}

///|
test "is_error" {
  let e = new_error("myerr")
  assert_eq(e.message(), "myerr")
  assert_true(e.is_error())
}

///|
test "call_method_raise" {
  let v = try? global_this().invoke_throwable("nonexistentMethod", [])
  guard v is Err(JsError(e))
  assert_true(e.is_error())
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
pub fn new_error(message : String, cause? : ErrorObject) -> ErrorObject {
  let args : Array[Val] = if cause is Some(cause) {
    [js(message), from_builtin_map({ "cause": cause |> unsafe_cast() })]
  } else {
    [js(message)]
  }
  ffi_new_error(args)
}
