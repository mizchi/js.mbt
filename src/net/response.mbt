///|
#external
pub type Response

///|
pub impl Js for Response with to_js(self) {
  self |> js
}

///|
pub extern "js" fn Response::json(self : Response) -> Promise[Val] =
  #| (v) => v.json()

///|
pub extern "js" fn Response::text(self : Response) -> Promise[String] =
  #| (v) => v.text()
