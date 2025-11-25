///|
extern "js" fn ffi_request_new(url : String) -> @js.Any =
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
pub async fn Request::json(self : Request) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call0("json").cast()
  promise.wait()
}

///|
pub async fn Request::text(self : Request) -> String {
  let promise : @js.Promise[String] = self.call0("text").cast()
  promise.wait()
}

///|
pub async fn Request::arraybuffer(self : Request) -> @js.ArrayBuffer {
  let promise : @js.Promise[@js.ArrayBuffer] = self.call0("arrayBuffer").cast()
  promise.wait()
}

///|
pub async fn Request::blob(self : Request) -> @blob.Blob {
  let promise : @js.Promise[@blob.Blob] = self.call0("blob").cast()
  promise.wait()
}

///|
pub async fn Request::bytes(self : Request) -> @typedarray.Uint8Array {
  let promise : @js.Promise[@typedarray.Uint8Array] = self.call0("bytes").cast()
  promise.wait()
}
