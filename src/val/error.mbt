///|
suberror JsError ErrorObject

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
  self.to_js().get("message").cast()
}

///|
pub fn ErrorObject::stack(self : Self) -> String {
  self.to_js().get("stack").cast()
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
  let v = try? global_this().call_method_raise("nonexistentMethod", [])
  guard v is Err(JsError(e))
  assert_true(e.is_error())
}
