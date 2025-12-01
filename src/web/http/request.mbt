///|
extern "js" fn ffi_request_new(url : String) -> @js.Any =
  #| (url) => new Request(url)

///|
extern "js" fn ffi_request_new_with_init(
  url : String,
  init : @js.Any,
) -> @js.Any =
  #| (url, init) => new Request(url, init)

///|
/// RequestInit - options for creating a Request or fetch call
/// https://developer.mozilla.org/en-US/docs/Web/API/RequestInit
pub struct RequestInit {
  priv method_ : String?
  priv headers : Headers?
  priv body : @js.Any?
  priv mode : String?
  priv credentials : String?
  priv cache : String?
  priv redirect : String?
  priv referrer : String?
  priv referrerPolicy : String?
  priv integrity : String?
  priv keepalive : Bool?
  priv signal : @js.AbortSignal?
  priv priority : String?
}

///|
pub fn RequestInit::new(
  http_method? : String = "GET",
  headers? : Headers,
  body? : &@js.JsImpl,
  mode? : String,
  credentials? : String,
  cache? : String,
  redirect? : String,
  referrer? : String,
  referrerPolicy? : String,
  integrity? : String,
  keepalive? : Bool,
  signal? : @js.AbortSignal,
  priority? : String,
) -> RequestInit {
  {
    method_: Some(http_method),
    headers,
    body: body.map(fn(b) { b.as_any() }),
    mode,
    credentials,
    cache,
    redirect,
    referrer,
    referrerPolicy,
    integrity,
    keepalive,
    signal,
    priority,
  }
}

///|
pub fn RequestInit::as_any(self : RequestInit) -> @js.Any {
  @mbtconv.from_option_map({
    "method": self.method_.map(fn(x) { @nostd.any(x) }),
    "headers": self.headers.map(fn(x) { @nostd.identity(x.as_any()) }),
    "body": self.body.map(fn(x) { @nostd.identity(x) }),
    "mode": self.mode.map(fn(x) { @nostd.any(x) }),
    "credentials": self.credentials.map(fn(x) { @nostd.any(x) }),
    "cache": self.cache.map(fn(x) { @nostd.any(x) }),
    "redirect": self.redirect.map(fn(x) { @nostd.any(x) }),
    "referrer": self.referrer.map(fn(x) { @nostd.any(x) }),
    "referrerPolicy": self.referrerPolicy.map(fn(x) { @nostd.any(x) }),
    "integrity": self.integrity.map(fn(x) { @nostd.any(x) }),
    "keepalive": self.keepalive.map(fn(x) { @nostd.any(x) }),
    "signal": self.signal.map(fn(x) { @nostd.identity(x) }),
    "priority": self.priority.map(fn(x) { @nostd.any(x) }),
  }).cast()
}

///|
/// Get the HTTP method
pub fn RequestInit::get_method(self : RequestInit) -> String? {
  self.method_
}

///|
/// Get the headers
pub fn RequestInit::get_headers(self : RequestInit) -> Headers? {
  self.headers
}

///|
/// Get the body
pub fn RequestInit::get_body(self : RequestInit) -> @js.Any? {
  self.body
}

///|
/// Get the mode
pub fn RequestInit::get_mode(self : RequestInit) -> String? {
  self.mode
}

///|
/// Get the credentials
pub fn RequestInit::get_credentials(self : RequestInit) -> String? {
  self.credentials
}

///|
/// Get the cache mode
pub fn RequestInit::get_cache(self : RequestInit) -> String? {
  self.cache
}

///|
/// Get the redirect mode
pub fn RequestInit::get_redirect(self : RequestInit) -> String? {
  self.redirect
}

///|
/// Get the referrer
pub fn RequestInit::get_referrer(self : RequestInit) -> String? {
  self.referrer
}

///|
/// Get the referrer policy
pub fn RequestInit::get_referrerPolicy(self : RequestInit) -> String? {
  self.referrerPolicy
}

///|
/// Get the integrity
pub fn RequestInit::get_integrity(self : RequestInit) -> String? {
  self.integrity
}

///|
/// Get the keepalive flag
pub fn RequestInit::get_keepalive(self : RequestInit) -> Bool? {
  self.keepalive
}

///|
/// Get the abort signal
pub fn RequestInit::get_signal(self : RequestInit) -> @js.AbortSignal? {
  self.signal
}

///|
/// Get the priority
pub fn RequestInit::get_priority(self : RequestInit) -> String? {
  self.priority
}

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Request
pub(all) struct Request {
  bodyUsed : Bool
  url : String
  credentials : String
}

///|
pub fn Request::as_any(self : Request) -> @nostd.Any = "%identity"

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Request/Request
pub fn Request::new(url : String) -> Request {
  let req = ffi_request_new(url)
  @js.identity(req)
}

///|
/// Create a new Request with init options
pub fn Request::new_with_init(url : String, init : RequestInit) -> Request {
  let req = ffi_request_new_with_init(url, init.as_any())
  @js.identity(req)
}

///|
/// Get the HTTP method (e.g., "GET", "POST")
/// Note: This is a method because "method" is a reserved word in MoonBit
pub fn Request::method_(self : Request) -> String {
  self.as_any()["method"].cast()
}

///|
pub fn Request::clone(self : Request) -> Request {
  self.as_any()._call("clone", []).cast()
}

///|
pub async fn Request::json(self : Request) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.as_any()._call("json", []).cast()
  promise.wait()
}

///|
pub async fn Request::text(self : Request) -> String {
  let promise : @js.Promise[String] = self.as_any()._call("text", []).cast()
  promise.wait()
}

///|
pub async fn Request::arraybuffer(self : Request) -> @js.ArrayBuffer {
  let promise : @js.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
pub async fn Request::blob(self : Request) -> @blob.Blob {
  let promise : @js.Promise[@blob.Blob] = self.as_any()._call("blob", []).cast()
  promise.wait()
}

///|
pub async fn Request::bytes(self : Request) -> @typedarray.Uint8Array {
  let promise : @js.Promise[@typedarray.Uint8Array] = self
    .as_any()
    ._call("bytes", [])
    .cast()
  promise.wait()
}
