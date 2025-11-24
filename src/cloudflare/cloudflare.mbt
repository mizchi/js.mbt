// WIP

///|
#external
pub type CloudflareEnv

///|
#external
pub type CloudflareContext

///|
impl @js.JsImpl for CloudflareContext

///|
#external
pub type CloudflareRequest

///|
pub impl @js.JsImpl for CloudflareRequest

///|
pub fn CloudflareRequest::cf(self : CloudflareRequest) -> CloudflareContext {
  self.get("cf").cast()
}

///|
pub fn CloudflareRequest::url(self : CloudflareRequest) -> String {
  self.get("url").cast()
}

///|
#alias(waitUntil)
pub fn CloudflareContext::wait_until(
  self : CloudflareContext,
  promise : @js.Promise[Unit],
) -> Unit {
  @js.identity(self.get("waitUntil").call_self([promise |> @js.identity]))
}

///|
#alias(passThroughException)
pub fn CloudflareContext::pass_through_exception(
  self : CloudflareContext,
) -> Unit {
  self.get("passThroughException").call_self([]) |> ignore
}

///|
/// CloudflareFetchHandler is a type alias for Cloudflare Worker fetch handler
pub type CloudflareFetchHandler = (
  CloudflareRequest,
  CloudflareEnv,
  CloudflareContext,
) -> @js.Promise[@http.Response]
