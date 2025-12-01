///|
/// Response type for Playwright
/// https://playwright.dev/docs/api/class-response

///|
/// Response instance
#external
pub type Response

///|
pub fn Response::to_any(self : Response) -> @nostd.Any = "%identity"

///| Response Methods

///|
/// Get response URL
pub fn Response::url(self : Response) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// Get response status
pub fn Response::status(self : Response) -> Int {
  self.to_any()._call("status", []).cast()
}

///|
/// Get response status text
pub fn Response::statusText(self : Response) -> String {
  self.to_any()._call("statusText", []).cast()
}

///|
/// Check if response is OK (status 200-299)
pub fn Response::ok(self : Response) -> Bool {
  self.to_any()._call("ok", []).cast()
}

///|
/// Get response headers
pub fn Response::headers(self : Response) -> @nostd.Any {
  self.to_any()._call("headers", []) |> @js.identity
}

///|
/// Get all response headers
pub async fn Response::allHeaders(self : Response) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("allHeaders", [])
    |> @js.identity
  promise.wait()
}

///|
/// Get response body as text
pub async fn Response::text(self : Response) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("text", [])
    |> @js.identity
  promise.wait()
}

///|
/// Get response body as JSON
pub async fn Response::json(self : Response) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("json", [])
    |> @js.identity
  promise.wait()
}

///|
/// Get response body as buffer
pub async fn Response::body(self : Response) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("body", [])
    |> @js.identity
  promise.wait()
}

///|
/// Get request associated with response
pub fn Response::request(self : Response) -> Request {
  self.to_any()._call("request", []) |> @nostd.identity
}

///|
/// Get frame associated with response
pub fn Response::frame(self : Response) -> Frame {
  self.to_any()._call("frame", []) |> @nostd.identity
}

///|
/// Check if response was served from cache
pub fn Response::fromCache(self : Response) -> Bool {
  self.to_any()._call("fromCache", []).cast()
}

///|
/// Check if response was served from service worker
pub fn Response::fromServiceWorker(self : Response) -> Bool {
  self.to_any()._call("fromServiceWorker", []).cast()
}

///| Request type

///|
/// Request instance
#external
pub type Request

///|
pub fn Request::to_any(self : Request) -> @nostd.Any = "%identity"

///|
/// Get request URL
pub fn Request::url(self : Request) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// Get request method
pub fn Request::method_(self : Request) -> String {
  self.to_any()._call("method", []).cast()
}

///|
/// Get request headers
pub fn Request::headers(self : Request) -> @nostd.Any {
  self.to_any()._call("headers", []) |> @js.identity
}

///|
/// Get all request headers
pub async fn Request::allHeaders(self : Request) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("allHeaders", [])
    |> @js.identity
  promise.wait()
}

///|
/// Get request post data
pub fn Request::postData(self : Request) -> String? {
  let result = self.to_any()._call("postData", [])
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get request post data as JSON
pub fn Request::postDataJSON(self : Request) -> @nostd.Any {
  self.to_any()._call("postDataJSON", []) |> @js.identity
}

///|
/// Get resource type
pub fn Request::resourceType(self : Request) -> String {
  self.to_any()._call("resourceType", []).cast()
}

///|
/// Check if request is navigation request
pub fn Request::isNavigationRequest(self : Request) -> Bool {
  self.to_any()._call("isNavigationRequest", []).cast()
}

///|
/// Get response for this request
pub async fn Request::response(self : Request) -> Response? {
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("response", [])
    |> @js.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
  }
}

///| Frame type

///|
/// Frame instance
#external
pub type Frame

///|
pub fn Frame::to_any(self : Frame) -> @nostd.Any = "%identity"

///|
/// Get frame URL
pub fn Frame::url(self : Frame) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// Get frame name
pub fn Frame::name(self : Frame) -> String {
  self.to_any()._call("name", []).cast()
}

///|
/// Get frame title
pub async fn Frame::title(self : Frame) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("title", [])
    |> @js.identity
  promise.wait()
}

///|
/// Get frame content
pub async fn Frame::content(self : Frame) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("content", [])
    |> @js.identity
  promise.wait()
}

///|
/// Get parent frame
pub fn Frame::parentFrame(self : Frame) -> Frame? {
  let result = self.to_any()._call("parentFrame", [])
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
  }
}

///|
/// Get child frames
pub fn Frame::childFrames(self : Frame) -> Array[Frame] {
  self.to_any()._call("childFrames", []) |> @nostd.identity
}

///|
/// Check if frame is detached
pub fn Frame::isDetached(self : Frame) -> Bool {
  self.to_any()._call("isDetached", []).cast()
}

///|
/// Get locator in frame
pub fn Frame::locator(self : Frame, selector : String) -> Locator {
  self.to_any()._call("locator", [@nostd.any(selector)]) |> @nostd.identity
}

///|
/// Navigate frame to URL
pub async fn Frame::goto(
  self : Frame,
  url : String,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("goto", [@nostd.any(url), options])
    |> @js.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
  }
}
