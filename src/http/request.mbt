///|
extern "js" fn ffi_request_new(url : String) -> Val =
  #| (url) => new Request(url)

///|
#external
pub type Request

///|
pub impl JsImpl for Request

///|
pub fn Request::new(url : String) -> Request {
  let req = ffi_request_new(url)
  unsafe_cast(req)
}

///|
#alias(bodyUsed)
pub fn Request::body_used(self : Request) -> Bool {
  unsafe_cast(self.get("bodyUsed"))
}

///|
pub fn Request::url(self : Request) -> String {
  unsafe_cast(self.get("url"))
}

///|
pub fn Request::method_(self : Request) -> String {
  unsafe_cast(self.get("method"))
}

///|
pub fn Request::credentials(self : Request) -> String {
  unsafe_cast(self.get("credentials"))
}

///|
pub fn Request::clone(self : Request) -> Request {
  self.invoke("clone", []) |> unsafe_cast
}

///|
pub fn Request::json(self : Request) -> Promise[Val] {
  self.invoke("json", []) |> unsafe_cast
}

///|
pub fn Request::text(self : Request) -> Promise[String] {
  self.invoke("text", []) |> unsafe_cast
}

///|
pub fn Request::arraybuffer(
  self : Request,
) -> Promise[@arraybuffer.ArrayBuffer] {
  self.invoke("arrayBuffer", []) |> unsafe_cast
}

///|
pub fn Request::blob(self : Request) -> Promise[Val] {
  self.invoke("blob", []) |> unsafe_cast
}

///|
pub fn Request::bytes(self : Request) -> Promise[Val] {
  self.invoke("bytes", []) |> unsafe_cast
}
