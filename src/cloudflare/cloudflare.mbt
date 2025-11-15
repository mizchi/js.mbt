// WIP

///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @async {type Promise}

///|
using @net {type Request, type Response}

///|
#external
pub type CloudflareEnv

///|
#external
pub type CloudflareContext

///|
impl Js for CloudflareContext with to_js(self) {
  self |> js
}

///|
#external
pub type CloudflareRequest

///|
pub impl Js for CloudflareRequest with to_js(self) {
  self |> js
}

///|
pub fn CloudflareRequest::cf(self : CloudflareRequest) -> CloudflareContext {
  self.to_js().get("cf").cast()
}

///|
pub fn CloudflareRequest::url(self : CloudflareRequest) -> String {
  self.to_js().get("url").cast()
}

///|
#alias(waitUntil)
pub fn CloudflareContext::wait_until(
  self : CloudflareContext,
  promise : Promise[Unit],
) -> Unit {
  self.to_js().get("waitUntil").invoke_self([promise |> js]).cast()
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
