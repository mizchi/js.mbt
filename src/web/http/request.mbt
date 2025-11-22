///|
extern "js" fn ffi_request_new(url : String) -> Js =
  #| (url) => new Request(url)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Request
#external
pub type Request

///|
pub impl JsImpl for Request

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Request/Request
pub fn Request::new(url : String) -> Request {
  let req = ffi_request_new(url)
  unsafe_cast(req)
}

///|
#alias(bodyUsed)
pub fn Request::body_used(self : Request) -> Bool {
  self.get("bodyUsed") |> unsafe_cast
}

///|
pub fn Request::url(self : Request) -> String {
  self.get("url") |> unsafe_cast
}

///|
pub fn Request::method_(self : Request) -> String {
  self.get("method") |> unsafe_cast
}

///|
pub fn Request::credentials(self : Request) -> String {
  self.get("credentials") |> unsafe_cast
}

///|
pub fn Request::clone(self : Request) -> Request {
  self.call0("clone") |> unsafe_cast
}

///|
pub fn Request::json(self : Request) -> Promise[Js] {
  self.call0("json") |> unsafe_cast
}

///|
pub fn Request::text(self : Request) -> Promise[String] {
  self.call0("text") |> unsafe_cast
}

///|
pub fn Request::arraybuffer(self : Request) -> Promise[ArrayBuffer] {
  self.call0("arrayBuffer") |> unsafe_cast
}

///|
pub fn Request::blob(self : Request) -> Promise[@blob.Blob] {
  self.call0("blob") |> unsafe_cast
}

///|
pub fn Request::bytes(self : Request) -> Promise[@typed_array.Uint8Array] {
  self.call0("bytes") |> unsafe_cast
}
