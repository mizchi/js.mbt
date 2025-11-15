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
pub impl Js for JsError with to_js(self) {
  self.to_js()
}

///|
impl Js for ErrorObject with to_js(self) -> Val {
  self |> js
}

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
  unsafe_cast(self.to_js().get("message"))
}

///|
pub fn ErrorObject::stack(self : Self) -> String {
  unsafe_cast(self.to_js().get("stack"))
}

///|
pub fn ErrorObject::is_error(self : Self) -> Bool {
  self |> ffi_is_error
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
