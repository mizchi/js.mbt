// WIP

///|
#external
pub type CloudflareEnv

///|
#external
pub type CloudflareContext

///|
impl Js for CloudflareContext

///|
#external
pub type CloudflareRequest

///|
pub impl Js for CloudflareRequest

///|
pub fn CloudflareRequest::cf(self : CloudflareRequest) -> CloudflareContext {
  unsafe_cast(self.to_js().get("cf"))
}

///|
pub fn CloudflareRequest::url(self : CloudflareRequest) -> String {
  unsafe_cast(self.to_js().get("url"))
}

///|
#alias(waitUntil)
pub fn CloudflareContext::wait_until(
  self : CloudflareContext,
  promise : Promise[Unit],
) -> Unit {
  unsafe_cast(self.to_js().get("waitUntil").invoke_self([promise |> js]))
}

///|
#alias(passThroughException)
pub fn CloudflareContext::pass_through_exception(
  self : CloudflareContext,
) -> Unit {
  self.to_js().get("passThroughException").invoke_self([]) |> ignore
}

///|
pub(all) struct CloudflareFetchHandler(
  (CloudflareRequest, CloudflareEnv, CloudflareContext) -> Promise[Response]
)
