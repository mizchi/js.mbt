///|
/// Response type for Playwright
/// https://playwright.dev/docs/api/class-response

///|
/// Response instance
#external
pub type Response

///|
pub fn Response::as_any(self : Response) -> @js.Any = "%identity"

// Internal helper for method calls

///|
fn Response::call(
  self : Response,
  name : String,
  args : Array[&@js.JsImpl],
) -> @js.Any {
  self.as_any().call(name, args)
}

///| Response Methods

///|
/// Get response URL
pub fn Response::url(self : Response) -> String {
  self.call("url", []).cast()
}

///|
/// Get response status
pub fn Response::status(self : Response) -> Int {
  self.call("status", []).cast()
}

///|
/// Get response status text
pub fn Response::statusText(self : Response) -> String {
  self.call("statusText", []).cast()
}

///|
/// Check if response is OK (status 200-299)
pub fn Response::ok(self : Response) -> Bool {
  self.call("ok", []).cast()
}

///|
/// Get response headers
pub fn Response::headers(self : Response) -> @js.Any {
  self.call("headers", [])
}

///|
/// Get all response headers
pub async fn Response::allHeaders(self : Response) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call("allHeaders", []))
  promise.wait()
}

///|
/// Get response body as text
pub async fn Response::text(self : Response) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("text", []))
  promise.wait()
}

///|
/// Get response body as JSON
pub async fn Response::json(self : Response) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call("json", []))
  promise.wait()
}

///|
/// Get response body as buffer
pub async fn Response::body(self : Response) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call("body", []))
  promise.wait()
}

///|
/// Get request associated with response
pub fn Response::request(self : Response) -> Request {
  @js.identity(self.call("request", []))
}

///|
/// Get frame associated with response
pub fn Response::frame(self : Response) -> Frame {
  @js.identity(self.call("frame", []))
}

///|
/// Check if response was served from cache
pub fn Response::fromCache(self : Response) -> Bool {
  self.call("fromCache", []).cast()
}

///|
/// Check if response was served from service worker
pub fn Response::fromServiceWorker(self : Response) -> Bool {
  self.call("fromServiceWorker", []).cast()
}

///| Request type

///|
/// Request instance
#external
pub type Request

///|
pub fn Request::as_any(self : Request) -> @js.Any = "%identity"

// Internal helper for method calls

///|
fn Request::call(
  self : Request,
  name : String,
  args : Array[&@js.JsImpl],
) -> @js.Any {
  self.as_any().call(name, args)
}

///|
/// Get request URL
pub fn Request::url(self : Request) -> String {
  self.call("url", []).cast()
}

///|
/// Get request method
pub fn Request::method_(self : Request) -> String {
  self.call("method", []).cast()
}

///|
/// Get request headers
pub fn Request::headers(self : Request) -> @js.Any {
  self.call("headers", [])
}

///|
/// Get all request headers
pub async fn Request::allHeaders(self : Request) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call("allHeaders", []))
  promise.wait()
}

///|
/// Get request post data
pub fn Request::postData(self : Request) -> String? {
  let result = self.call("postData", [])
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get request post data as JSON
pub fn Request::postDataJSON(self : Request) -> @js.Any {
  self.call("postDataJSON", [])
}

///|
/// Get resource type
pub fn Request::resourceType(self : Request) -> String {
  self.call("resourceType", []).cast()
}

///|
/// Check if request is navigation request
pub fn Request::isNavigationRequest(self : Request) -> Bool {
  self.call("isNavigationRequest", []).cast()
}

///|
/// Get response for this request
pub async fn Request::response(self : Request) -> Response? {
  let promise : @js.Promise[@js.Any] = @js.identity(self.call("response", []))
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///| Frame type

///|
/// Frame instance
#external
pub type Frame

///|
pub fn Frame::as_any(self : Frame) -> @js.Any = "%identity"

// Internal helper for method calls

///|
fn Frame::call(
  self : Frame,
  name : String,
  args : Array[&@js.JsImpl],
) -> @js.Any {
  self.as_any().call(name, args)
}

///|
/// Get frame URL
pub fn Frame::url(self : Frame) -> String {
  self.call("url", []).cast()
}

///|
/// Get frame name
pub fn Frame::name(self : Frame) -> String {
  self.call("name", []).cast()
}

///|
/// Get frame title
pub async fn Frame::title(self : Frame) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("title", []))
  promise.wait()
}

///|
/// Get frame content
pub async fn Frame::content(self : Frame) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("content", []))
  promise.wait()
}

///|
/// Get parent frame
pub fn Frame::parentFrame(self : Frame) -> Frame? {
  let result = self.call("parentFrame", [])
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Get child frames
pub fn Frame::childFrames(self : Frame) -> Array[Frame] {
  @js.identity(self.call("childFrames", []))
}

///|
/// Check if frame is detached
pub fn Frame::isDetached(self : Frame) -> Bool {
  self.call("isDetached", []).cast()
}

///|
/// Get locator in frame
pub fn Frame::locator(self : Frame, selector : String) -> Locator {
  @js.identity(self.call("locator", [selector]))
}

///|
/// Navigate frame to URL
pub async fn Frame::goto(
  self : Frame,
  url : String,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("goto", [@js.any(url), options.as_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}
