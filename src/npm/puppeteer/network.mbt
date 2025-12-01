///|
/// Network interception support for Puppeteer
/// See: https://pptr.dev/guides/network-interception

///|
/// HTTPRequest type
/// See: https://pptr.dev/api/puppeteer.httprequest
#external
pub type HTTPRequest

///|
pub fn HTTPRequest::to_any(self : HTTPRequest) -> @nostd.Any = "%identity"

///|
/// HTTPResponse type
/// See: https://pptr.dev/api/puppeteer.httpresponse
#external
pub type HTTPResponse

///|
pub fn HTTPResponse::to_any(self : HTTPResponse) -> @nostd.Any = "%identity"

///| Page methods (network interception)

///|
/// Page: Enable request interception
/// JS: page.setRequestInterception(value)
/// See: https://pptr.dev/guides/network-interception
pub async fn Page::setRequestInterception(self : Page, value : Bool) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setRequestInterception", [@nostd.any(value)])
    |> @js.identity
  promise.wait()
}

///| HTTPRequest methods

///|
/// HTTPRequest: Abort the request
/// JS: request.abort()
pub async fn HTTPRequest::abort(self : HTTPRequest) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("abort", [])
    |> @js.identity
  promise.wait()
}

///|
/// HTTPRequest: Continue the request
/// JS: request.continue()
pub async fn HTTPRequest::continue_(self : HTTPRequest) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("continue", [])
    |> @js.identity
  promise.wait()
}

///|
/// HTTPRequest: Continue with overrides
/// JS: request.continue(overrides)
pub async fn HTTPRequest::continue_with(
  self : HTTPRequest,
  overrides : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("continue", [@nostd.any(overrides)])
    |> @js.identity
  promise.wait()
}

///|
/// HTTPRequest: Respond to the request
/// JS: request.respond(response)
pub async fn HTTPRequest::respond(
  self : HTTPRequest,
  response : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("respond", [@nostd.any(response)])
    |> @js.identity
  promise.wait()
}

///|
/// HTTPRequest: Check if interception is already handled
/// JS: request.isInterceptResolutionHandled()
pub fn HTTPRequest::isInterceptResolutionHandled(self : HTTPRequest) -> Bool {
  self.to_any()._call("isInterceptResolutionHandled", []).cast()
}

///|
/// HTTPRequest: Get request URL
/// JS: request.url()
pub fn HTTPRequest::url(self : HTTPRequest) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// HTTPRequest: Get request method
/// JS: request.method()
pub fn HTTPRequest::method_(self : HTTPRequest) -> String {
  self.to_any()._call("method", []).cast()
}

///|
/// HTTPRequest: Get request headers
/// JS: request.headers()
pub fn HTTPRequest::headers(self : HTTPRequest) -> @nostd.Any {
  self.to_any()._call("headers", []) |> @js.identity
}

///|
/// HTTPRequest: Get resource type
/// JS: request.resourceType()
pub fn HTTPRequest::resourceType(self : HTTPRequest) -> String {
  self.to_any()._call("resourceType", []).cast()
}

///|
/// HTTPRequest: Check if navigation request
/// JS: request.isNavigationRequest()
pub fn HTTPRequest::isNavigationRequest(self : HTTPRequest) -> Bool {
  self.to_any()._call("isNavigationRequest", []).cast()
}

///|
/// HTTPRequest: Get response
/// JS: request.response()
pub fn HTTPRequest::response(self : HTTPRequest) -> HTTPResponse? {
  self.to_any()._call("response", []).cast()
}

///|
/// HTTPRequest: Get redirect chain
/// JS: request.redirectChain()
pub fn HTTPRequest::redirectChain(self : HTTPRequest) -> Array[HTTPRequest] {
  self.to_any()._call("redirectChain", []).cast()
}

///|
/// HTTPRequest: Check if has POST data
/// JS: request.hasPostData()
pub fn HTTPRequest::hasPostData(self : HTTPRequest) -> Bool {
  self.to_any()._call("hasPostData", []).cast()
}

///|
/// HTTPRequest: Fetch POST data
/// JS: request.fetchPostData()
pub async fn HTTPRequest::fetchPostData(self : HTTPRequest) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("fetchPostData", [])
    |> @js.identity
  promise.wait()
}

///| HTTPResponse methods

///|
/// HTTPResponse: Get response URL
/// JS: response.url()
pub fn HTTPResponse::url(self : HTTPResponse) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// HTTPResponse: Get status code
/// JS: response.status()
pub fn HTTPResponse::status(self : HTTPResponse) -> Int {
  self.to_any()._call("status", []).cast()
}

///|
/// HTTPResponse: Get status text
/// JS: response.statusText()
pub fn HTTPResponse::statusText(self : HTTPResponse) -> String {
  self.to_any()._call("statusText", []).cast()
}

///|
/// HTTPResponse: Check if response is OK (200-299)
/// JS: response.ok()
pub fn HTTPResponse::ok(self : HTTPResponse) -> Bool {
  self.to_any()._call("ok", []).cast()
}

///|
/// HTTPResponse: Get response headers
/// JS: response.headers()
pub fn HTTPResponse::headers(self : HTTPResponse) -> @nostd.Any {
  self.to_any()._call("headers", []) |> @js.identity
}

///|
/// HTTPResponse: Get response body as text
/// JS: response.text()
pub async fn HTTPResponse::text(self : HTTPResponse) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("text", [])
    |> @js.identity
  promise.wait()
}

///|
/// HTTPResponse: Get response body as JSON
/// JS: response.json()
pub async fn HTTPResponse::json(self : HTTPResponse) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("json", [])
    |> @js.identity
  promise.wait()
}

///|
/// HTTPResponse: Get response body as buffer
/// JS: response.buffer()
pub async fn HTTPResponse::buffer(self : HTTPResponse) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("buffer", [])
    |> @js.identity
  promise.wait()
}

///|
/// HTTPResponse: Check if served from cache
/// JS: response.fromCache()
pub fn HTTPResponse::fromCache(self : HTTPResponse) -> Bool {
  self.to_any()._call("fromCache", []).cast()
}

///|
/// HTTPResponse: Check if served from service worker
/// JS: response.fromServiceWorker()
pub fn HTTPResponse::fromServiceWorker(self : HTTPResponse) -> Bool {
  self.to_any()._call("fromServiceWorker", []).cast()
}

///|
/// HTTPResponse: Get request
/// JS: response.request()
pub fn HTTPResponse::request(self : HTTPResponse) -> HTTPRequest {
  self.to_any()._call("request", []).cast()
}

///|
/// HTTPResponse: Get remote address
/// JS: response.remoteAddress()
pub fn HTTPResponse::remoteAddress(self : HTTPResponse) -> String {
  self.to_any()._call("remoteAddress", []).cast()
}
