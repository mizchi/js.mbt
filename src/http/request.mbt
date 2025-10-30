///|
extern "js" fn ffi_request_new(url : String) -> @js.Value =
  #| (url) => new Request(url)

///|
#external
pub type Request

///|
pub impl ToJs for Request with to_js(self) {
  self |> to_js
}

///|
pub fn Request::new(url : String) -> Request {
  let req = ffi_request_new(url)
  req.cast()
}

///|
pub fn body_used(self : Request) -> Bool {
  self.to_js().get("bodyUsed").cast()
}

///|
pub fn url(self : Request) -> String {
  self.to_js().get("url").cast()
}

///|
pub fn method_(self : Request) -> String {
  self.to_js().get("method").cast()
}

///|
pub fn credentials(self : Request) -> String {
  self.to_js().get("credentials").cast()
}

///|
pub fn clone(self : Request) -> Request {
  self.to_js().call_property("clone", []).cast()
}

///|
pub fn json(self : Request) -> Promise[@js.Value] {
  self.to_js().call_property0("json").cast()
}

///|
pub fn text(self : Request) -> Promise[String] {
  self.to_js().call_property0("text").cast()
}

///|
pub fn array_buffer(self : Request) -> Promise[@js.Value] {
  self.to_js().call_property0("arrayBuffer").cast()
}

///|
pub fn blob(self : Request) -> Promise[@js.Value] {
  self.to_js().call_property0("blob").cast()
}

///|
pub fn bytes(self : Request) -> Promise[@js.Value] {
  self.to_js().call_property0("bytes").cast()
}
