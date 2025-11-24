///|
extern "js" fn ffi_request_new(url : String) -> @js.Js =
  #| (url) => new Request(url)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Request
pub(all) struct Request {
  bodyUsed : Bool
  url : String
  credentials : String
}

///|
pub impl @js.JsImpl for Request

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Request/Request
pub fn Request::new(url : String) -> Request {
  let req = ffi_request_new(url)
  @js.identity(req)
}

///|
/// Get the HTTP method (e.g., "GET", "POST")
/// Note: This is a method because "method" is a reserved word in MoonBit
pub fn Request::method_(self : Request) -> String {
  self.get("method").cast()
}

///|
pub fn Request::clone(self : Request) -> Request {
  self.call0("clone").cast()
}

///|
pub fn Request::json(self : Request) -> @js.Promise[@js.Js] {
  self.call0("json").cast()
}

///|
pub fn Request::text(self : Request) -> @js.Promise[String] {
  self.call0("text").cast()
}

///|
pub fn Request::arraybuffer(self : Request) -> @js.Promise[@js.ArrayBuffer] {
  self.call0("arrayBuffer").cast()
}

///|
pub fn Request::blob(self : Request) -> @js.Promise[@blob.Blob] {
  self.call0("blob").cast()
}

///|
pub fn Request::bytes(self : Request) -> @js.Promise[@typedarray.Uint8Array] {
  self.call0("bytes").cast()
}
