///|
extern "js" fn ffi_request_new(url : String) -> Val =
  #| (url) => new Request(url)

///|
#external
pub type Request

///|
pub impl Js for Request with to_js(self) {
  self |> js
}

///|
pub fn Request::new(url : String) -> Request {
  let req = ffi_request_new(url)
  req.cast()
}

///|
#alias(bodyUsed)
pub fn Request::body_used(self : Request) -> Bool {
  self.to_js().get("bodyUsed").cast()
}

///|
pub fn Request::url(self : Request) -> String {
  self.to_js().get("url").cast()
}

///|
pub fn Request::method_(self : Request) -> String {
  self.to_js().get("method").cast()
}

///|
pub fn Request::credentials(self : Request) -> String {
  self.to_js().get("credentials").cast()
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
