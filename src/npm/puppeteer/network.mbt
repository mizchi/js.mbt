///|
/// Network interception support for Puppeteer
/// See: https://pptr.dev/guides/network-interception

///|
/// HTTPRequest type
/// See: https://pptr.dev/api/puppeteer.httprequest
#external
pub type HTTPRequest

///|
pub impl @js.JsImpl for HTTPRequest

///|
/// HTTPResponse type
/// See: https://pptr.dev/api/puppeteer.httpresponse
#external
pub type HTTPResponse

///|
pub impl @js.JsImpl for HTTPResponse

///| Page methods (network interception)

///|
/// Page: Enable request interception
/// JS: page.setRequestInterception(value)
/// See: https://pptr.dev/guides/network-interception
pub async fn Page::setRequestInterception(self : Page, value : Bool) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setRequestInterception", [value]),
  )
  promise.wait()
}

///| HTTPRequest methods

///|
/// HTTPRequest: Abort the request
/// JS: request.abort()
pub async fn HTTPRequest::abort(self : HTTPRequest) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("abort", []))
  promise.wait()
}

///|
/// HTTPRequest: Continue the request
/// JS: request.continue()
pub async fn HTTPRequest::continue_(self : HTTPRequest) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("continue", []))
  promise.wait()
}

///|
/// HTTPRequest: Continue with overrides
/// JS: request.continue(overrides)
pub async fn HTTPRequest::continue_with(
  self : HTTPRequest,
  overrides : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("continue", [overrides]),
  )
  promise.wait()
}

///|
/// HTTPRequest: Respond to the request
/// JS: request.respond(response)
pub async fn HTTPRequest::respond(
  self : HTTPRequest,
  response : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("respond", [response]),
  )
  promise.wait()
}

///|
/// HTTPRequest: Check if interception is already handled
/// JS: request.isInterceptResolutionHandled()
pub fn HTTPRequest::isInterceptResolutionHandled(self : HTTPRequest) -> Bool {
  self.call("isInterceptResolutionHandled", []).cast()
}

///|
/// HTTPRequest: Get request URL
/// JS: request.url()
pub fn HTTPRequest::url(self : HTTPRequest) -> String {
  self.call("url", []).cast()
}

///|
/// HTTPRequest: Get request method
/// JS: request.method()
pub fn HTTPRequest::method_(self : HTTPRequest) -> String {
  self.call("method", []).cast()
}

///|
/// HTTPRequest: Get request headers
/// JS: request.headers()
pub fn HTTPRequest::headers(self : HTTPRequest) -> @js.Any {
  self.call("headers", [])
}

///|
/// HTTPRequest: Get resource type
/// JS: request.resourceType()
pub fn HTTPRequest::resourceType(self : HTTPRequest) -> String {
  self.call("resourceType", []).cast()
}

///|
/// HTTPRequest: Check if navigation request
/// JS: request.isNavigationRequest()
pub fn HTTPRequest::isNavigationRequest(self : HTTPRequest) -> Bool {
  self.call("isNavigationRequest", []).cast()
}

///|
/// HTTPRequest: Get response
/// JS: request.response()
pub fn HTTPRequest::response(self : HTTPRequest) -> HTTPResponse? {
  self.call("response", []).cast()
}

///|
/// HTTPRequest: Get redirect chain
/// JS: request.redirectChain()
pub fn HTTPRequest::redirectChain(self : HTTPRequest) -> Array[HTTPRequest] {
  self.call("redirectChain", []).cast()
}

///|
/// HTTPRequest: Check if has POST data
/// JS: request.hasPostData()
pub fn HTTPRequest::hasPostData(self : HTTPRequest) -> Bool {
  self.call("hasPostData", []).cast()
}

///|
/// HTTPRequest: Fetch POST data
/// JS: request.fetchPostData()
pub async fn HTTPRequest::fetchPostData(self : HTTPRequest) -> String {
  let promise : @js.Promise[String] = @js.identity(
    self.call("fetchPostData", []),
  )
  promise.wait()
}

///| HTTPResponse methods

///|
/// HTTPResponse: Get response URL
/// JS: response.url()
pub fn HTTPResponse::url(self : HTTPResponse) -> String {
  self.call("url", []).cast()
}

///|
/// HTTPResponse: Get status code
/// JS: response.status()
pub fn HTTPResponse::status(self : HTTPResponse) -> Int {
  self.call("status", []).cast()
}

///|
/// HTTPResponse: Get status text
/// JS: response.statusText()
pub fn HTTPResponse::statusText(self : HTTPResponse) -> String {
  self.call("statusText", []).cast()
}

///|
/// HTTPResponse: Check if response is OK (200-299)
/// JS: response.ok()
pub fn HTTPResponse::ok(self : HTTPResponse) -> Bool {
  self.call("ok", []).cast()
}

///|
/// HTTPResponse: Get response headers
/// JS: response.headers()
pub fn HTTPResponse::headers(self : HTTPResponse) -> @js.Any {
  self.call("headers", [])
}

///|
/// HTTPResponse: Get response body as text
/// JS: response.text()
pub async fn HTTPResponse::text(self : HTTPResponse) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("text", []))
  promise.wait()
}

///|
/// HTTPResponse: Get response body as JSON
/// JS: response.json()
pub async fn HTTPResponse::json(self : HTTPResponse) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call("json", []))
  promise.wait()
}

///|
/// HTTPResponse: Get response body as buffer
/// JS: response.buffer()
pub async fn HTTPResponse::buffer(self : HTTPResponse) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call("buffer", []))
  promise.wait()
}

///|
/// HTTPResponse: Check if served from cache
/// JS: response.fromCache()
pub fn HTTPResponse::fromCache(self : HTTPResponse) -> Bool {
  self.call("fromCache", []).cast()
}

///|
/// HTTPResponse: Check if served from service worker
/// JS: response.fromServiceWorker()
pub fn HTTPResponse::fromServiceWorker(self : HTTPResponse) -> Bool {
  self.call("fromServiceWorker", []).cast()
}

///|
/// HTTPResponse: Get request
/// JS: response.request()
pub fn HTTPResponse::request(self : HTTPResponse) -> HTTPRequest {
  self.call("request", []).cast()
}

///|
/// HTTPResponse: Get remote address
/// JS: response.remoteAddress()
pub fn HTTPResponse::remoteAddress(self : HTTPResponse) -> String {
  self.call("remoteAddress", []).cast()
}
