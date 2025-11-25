// WIP

///|
#external
pub type CloudflareEnv

///|
pub impl @js.JsImpl for CloudflareEnv

///|
#external
pub type CloudflareContext

///|
impl @js.JsImpl for CloudflareContext

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
