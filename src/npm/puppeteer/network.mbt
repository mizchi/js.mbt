///|
/// Network interception support for Puppeteer
/// See: https://pptr.dev/guides/network-interception

///|
/// HTTPRequest type
/// See: https://pptr.dev/api/puppeteer.httprequest
#external
pub type HTTPRequest

///|
pub fn HTTPRequest::as_any(self : HTTPRequest) -> @js.Any = "%identity"

///|
/// HTTPResponse type
/// See: https://pptr.dev/api/puppeteer.httpresponse
#external
pub type HTTPResponse

///|
pub fn HTTPResponse::as_any(self : HTTPResponse) -> @js.Any = "%identity"

// Internal helper functions for method calls

///|
fn HTTPRequest::call0(self : HTTPRequest, name : String) -> @js.Any {
  self.as_any().call(name, [])
}

///|
fn[T] HTTPRequest::call1(self : HTTPRequest, name : String, arg : T) -> @js.Any {
  self.as_any().call(name, [@js.identity(arg)])
}

///|
fn HTTPResponse::call0(self : HTTPResponse, name : String) -> @js.Any {
  self.as_any().call(name, [])
}

///| Page methods (network interception)

///|
/// Page: Enable request interception
/// JS: page.setRequestInterception(value)
/// See: https://pptr.dev/guides/network-interception
pub async fn Page::setRequestInterception(self : Page, value : Bool) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call1("setRequestInterception", value),
  )
  promise.wait()
}

///| HTTPRequest methods

///|
/// HTTPRequest: Abort the request
/// JS: request.abort()
pub async fn HTTPRequest::abort(self : HTTPRequest) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call0("abort"))
  promise.wait()
}

///|
/// HTTPRequest: Continue the request
/// JS: request.continue()
pub async fn HTTPRequest::continue_(self : HTTPRequest) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call0("continue"))
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
    self.call1("continue", overrides),
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
    self.call1("respond", response),
  )
  promise.wait()
}

///|
/// HTTPRequest: Check if interception is already handled
/// JS: request.isInterceptResolutionHandled()
pub fn HTTPRequest::isInterceptResolutionHandled(self : HTTPRequest) -> Bool {
  self.call0("isInterceptResolutionHandled").cast()
}

///|
/// HTTPRequest: Get request URL
/// JS: request.url()
pub fn HTTPRequest::url(self : HTTPRequest) -> String {
  self.call0("url").cast()
}

///|
/// HTTPRequest: Get request method
/// JS: request.method()
pub fn HTTPRequest::method_(self : HTTPRequest) -> String {
  self.call0("method").cast()
}

///|
/// HTTPRequest: Get request headers
/// JS: request.headers()
pub fn HTTPRequest::headers(self : HTTPRequest) -> @js.Any {
  self.call0("headers")
}

///|
/// HTTPRequest: Get resource type
/// JS: request.resourceType()
pub fn HTTPRequest::resourceType(self : HTTPRequest) -> String {
  self.call0("resourceType").cast()
}

///|
/// HTTPRequest: Check if navigation request
/// JS: request.isNavigationRequest()
pub fn HTTPRequest::isNavigationRequest(self : HTTPRequest) -> Bool {
  self.call0("isNavigationRequest").cast()
}

///|
/// HTTPRequest: Get response
/// JS: request.response()
pub fn HTTPRequest::response(self : HTTPRequest) -> HTTPResponse? {
  self.call0("response").cast()
}

///|
/// HTTPRequest: Get redirect chain
/// JS: request.redirectChain()
pub fn HTTPRequest::redirectChain(self : HTTPRequest) -> Array[HTTPRequest] {
  self.call0("redirectChain").cast()
}

///|
/// HTTPRequest: Check if has POST data
/// JS: request.hasPostData()
pub fn HTTPRequest::hasPostData(self : HTTPRequest) -> Bool {
  self.call0("hasPostData").cast()
}

///|
/// HTTPRequest: Fetch POST data
/// JS: request.fetchPostData()
pub async fn HTTPRequest::fetchPostData(self : HTTPRequest) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call0("fetchPostData"))
  promise.wait()
}

///| HTTPResponse methods

///|
/// HTTPResponse: Get response URL
/// JS: response.url()
pub fn HTTPResponse::url(self : HTTPResponse) -> String {
  self.call0("url").cast()
}

///|
/// HTTPResponse: Get status code
/// JS: response.status()
pub fn HTTPResponse::status(self : HTTPResponse) -> Int {
  self.call0("status").cast()
}

///|
/// HTTPResponse: Get status text
/// JS: response.statusText()
pub fn HTTPResponse::statusText(self : HTTPResponse) -> String {
  self.call0("statusText").cast()
}

///|
/// HTTPResponse: Check if response is OK (200-299)
/// JS: response.ok()
pub fn HTTPResponse::ok(self : HTTPResponse) -> Bool {
  self.call0("ok").cast()
}

///|
/// HTTPResponse: Get response headers
/// JS: response.headers()
pub fn HTTPResponse::headers(self : HTTPResponse) -> @js.Any {
  self.call0("headers")
}

///|
/// HTTPResponse: Get response body as text
/// JS: response.text()
pub async fn HTTPResponse::text(self : HTTPResponse) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call0("text"))
  promise.wait()
}

///|
/// HTTPResponse: Get response body as JSON
/// JS: response.json()
pub async fn HTTPResponse::json(self : HTTPResponse) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call0("json"))
  promise.wait()
}

///|
/// HTTPResponse: Get response body as buffer
/// JS: response.buffer()
pub async fn HTTPResponse::buffer(self : HTTPResponse) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call0("buffer"))
  promise.wait()
}

///|
/// HTTPResponse: Check if served from cache
/// JS: response.fromCache()
pub fn HTTPResponse::fromCache(self : HTTPResponse) -> Bool {
  self.call0("fromCache").cast()
}

///|
/// HTTPResponse: Check if served from service worker
/// JS: response.fromServiceWorker()
pub fn HTTPResponse::fromServiceWorker(self : HTTPResponse) -> Bool {
  self.call0("fromServiceWorker").cast()
}

///|
/// HTTPResponse: Get request
/// JS: response.request()
pub fn HTTPResponse::request(self : HTTPResponse) -> HTTPRequest {
  self.call0("request").cast()
}

///|
/// HTTPResponse: Get remote address
/// JS: response.remoteAddress()
pub fn HTTPResponse::remoteAddress(self : HTTPResponse) -> String {
  self.call0("remoteAddress").cast()
}
