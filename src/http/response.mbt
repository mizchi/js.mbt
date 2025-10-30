///|
using @js {
  type Value,
  type Promise,
  trait ToJs,
  to_js,
  new_object,
  run_async,
  console_error,
  log
}

///|
#external
pub type Response

///|
pub impl ToJs for Response with to_js(self) {
  self |> to_js
}

///|
pub extern "js" fn Response::json(self : Response) -> Promise[Value] =
  #| (v) => v.json()

///|
pub extern "js" fn Response::text(self : Response) -> Promise[String] =
  #| (v) => v.text()
