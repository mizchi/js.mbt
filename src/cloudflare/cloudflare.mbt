// WIP
///|
using @js {type Val, trait Js, js}

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
  promise : Promise[Val],
) -> Unit {
  self.to_js().get("waitUntil").call([promise |> js]).cast()
}

///|
#alias(passThroughException)
pub fn CloudflareContext::pass_through_exception(
  self : CloudflareContext,
) -> Unit {
  self.to_js().get("passThroughException").call([]) |> ignore
}

///|
pub(all) struct CloudflareFetchHandler(
  (Request, CloudflareEnv, CloudflareContext) -> Promise[Response]
)
