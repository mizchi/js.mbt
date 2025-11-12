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
  self.to_js().call_method("clone", []).cast()
}

///|
pub fn Request::json(self : Request) -> Promise[Val] {
  self.to_js().call_method("json", []).cast()
}

///|
pub fn Request::text(self : Request) -> Promise[String] {
  self.to_js().call_method("text", []).cast()
}

///|
pub fn Request::arraybuffer(self : Request) -> Promise[Val] {
  self.to_js().call_method("arrayBuffer", []).cast()
}

///|
pub fn Request::blob(self : Request) -> Promise[Val] {
  self.to_js().call_method("blob", []).cast()
}

///|
pub fn Request::bytes(self : Request) -> Promise[Val] {
  self.to_js().call_method("bytes", []).cast()
}
