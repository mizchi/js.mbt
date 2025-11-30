// WIP

///|
#external
pub type CloudflareEnv

///|
pub fn CloudflareEnv::as_any(self : CloudflareEnv) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for CloudflareEnv

///|
#external
pub type CloudflareContext

///|
pub fn CloudflareContext::as_any(self : CloudflareContext) -> @nostd.Any = "%identity"

///|
impl @js.JsImpl for CloudflareContext

///|
#alias(wait_until)
pub fn CloudflareContext::waitUntil(
  self : CloudflareContext,
  promise : @js.Promise[Unit],
) -> Unit {
  self.as_any()._call("waitUntil", [@nostd.any(promise)]) |> ignore
}

///|
#alias(pass_through_exception)
pub fn CloudflareContext::passThroughOnException(
  self : CloudflareContext,
) -> Unit {
  self.as_any()._call("passThroughOnException", []) |> ignore
}

///|
pub(all) struct CloudflareRequest {
  cf : CloudflareContext
  url : String
}

///|
pub impl @js.JsImpl for CloudflareRequest

///|
/// CloudflareFetchHandler is a type alias for Cloudflare Worker fetch handler
pub type CloudflareFetchHandler = (
  CloudflareRequest,
  CloudflareEnv,
  CloudflareContext,
) -> @js.Promise[@http.Response]
