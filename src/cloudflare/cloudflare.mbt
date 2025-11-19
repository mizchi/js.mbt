// WIP

///|
#external
pub type CloudflareEnv

///|
#external
pub type CloudflareContext

///|
impl JsImpl for CloudflareContext

///|
#external
pub type CloudflareRequest

///|
pub impl JsImpl for CloudflareRequest

///|
pub fn CloudflareRequest::cf(self : CloudflareRequest) -> CloudflareContext {
  unsafe_cast(self.get("cf"))
}

///|
pub fn CloudflareRequest::url(self : CloudflareRequest) -> String {
  unsafe_cast(self.get("url"))
}

///|
#alias(waitUntil)
pub fn CloudflareContext::wait_until(
  self : CloudflareContext,
  promise : Promise[Unit],
) -> Unit {
  unsafe_cast(self.get("waitUntil").call_self([promise |> unsafe_cast]))
}

///|
#alias(passThroughException)
pub fn CloudflareContext::pass_through_exception(
  self : CloudflareContext,
) -> Unit {
  self.get("passThroughException").call_self([]) |> ignore
}

///|
pub(all) struct CloudflareFetchHandler(
  (CloudflareRequest, CloudflareEnv, CloudflareContext) -> Promise[Response]
)
