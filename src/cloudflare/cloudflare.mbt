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
  self.get("cf") |> @js.unsafe_cast
}

///|
pub fn CloudflareRequest::url(self : CloudflareRequest) -> String {
  self.get("url") |> @js.unsafe_cast
}

///|
#alias(waitUntil)
pub fn CloudflareContext::wait_until(
  self : CloudflareContext,
  promise : @js.Promise[Unit],
) -> Unit {
  @js.unsafe_cast(self.get("waitUntil").call_self([promise |> @js.unsafe_cast]))
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
