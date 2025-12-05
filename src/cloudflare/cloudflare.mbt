// WIP

///|
#external
pub type CloudflareEnv

///|
pub fn CloudflareEnv::as_any(self : CloudflareEnv) -> @core.Any = "%identity"

///|
#external
pub type CloudflareContext

///|
pub fn CloudflareContext::as_any(self : CloudflareContext) -> @core.Any = "%identity"

///|
#alias(wait_until)
pub fn CloudflareContext::waitUntil(
  self : CloudflareContext,
  promise : @core.Promise[Unit],
) -> Unit {
  self.as_any()._call("waitUntil", [@core.any(promise)]) |> ignore
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
pub fn CloudflareRequest::as_any(self : CloudflareRequest) -> @core.Any = "%identity"

///|
/// CloudflareFetchHandler is a type alias for Cloudflare Worker fetch handler
pub type CloudflareFetchHandler = (
  CloudflareRequest,
  CloudflareEnv,
  CloudflareContext,
) -> @core.Promise[@http.Response]
