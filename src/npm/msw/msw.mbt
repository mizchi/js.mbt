///|
/// MSW (Mock Service Worker) bindings for MoonBit
/// https://mswjs.io/
///
/// API mocking library for Node.js testing.

///| Types

///|
/// Request handler
#external
pub type RequestHandler

///|
pub fn RequestHandler::as_any(self : RequestHandler) -> @core.Any = "%identity"

///|
/// WebSocket handler (for future use)
#external
pub type WebSocketHandler

///|
pub fn WebSocketHandler::as_any(self : WebSocketHandler) -> @core.Any = "%identity"

///|
/// HTTP response
#external
pub type HttpResponse

///|
pub fn HttpResponse::as_any(self : HttpResponse) -> @core.Any = "%identity"

///|
/// Request info
#external
pub type RequestInfo

///|
pub fn RequestInfo::as_any(self : RequestInfo) -> @core.Any = "%identity"

///|
/// Response resolver context
///
/// Contains information about the intercepted request:
/// - `request`: The intercepted Request object
/// - `params`: URL path parameters (e.g., from `/user/:id`)
/// - `cookies`: Request cookies
pub(all) struct ResponseResolverInfo {
  request : @core.Any
  params : @core.Any
  cookies : @core.Any
}

///|
pub fn ResponseResolverInfo::as_any(self : ResponseResolverInfo) -> @core.Any = "%identity"

///| HTTP Handler FFI

///|
/// Dynamic import for msw module
extern "js" fn import_msw() -> @core.Promise[@core.Any] =
  #|() => import("msw")

///|
/// Initialize msw globals (http and HttpResponse)
/// Must be called before using any msw functions
pub async fn init_global() -> Unit {
  if @core.is_nullish(get_http()) {
    let msw : @core.Any = import_msw().wait()
    ffi_set_msw_globals(msw._get("http"), msw._get("HttpResponse"))
  }
}

///|
/// Initialize msw globals synchronously using require() (for testing in Node.js)
pub extern "js" fn init_msw(msw : @core.Any) -> Unit =
  #|(msw) => {
  #|  globalThis.__msw_http = msw.http;
  #|  globalThis.__msw_HttpResponse = msw.HttpResponse;
  #|}

///|
extern "js" fn ffi_set_msw_globals(
  http : @core.Any,
  http_response : @core.Any,
) -> Unit =
  #|(http, hr) => {
  #|  globalThis.__msw_http = http;
  #|  globalThis.__msw_HttpResponse = hr;
  #|}

///|
extern "js" fn get_http() -> @core.Any =
  #|() => globalThis.__msw_http

///|
extern "js" fn get_http_response() -> @core.Any =
  #|() => globalThis.__msw_HttpResponse

///|
extern "js" fn call_http_method(
  http : @core.Any,
  method_name : String,
  path : String,
  resolver : @core.Any,
) -> RequestHandler =
  #| (http, method_name, path, resolver) => http[method_name](path, resolver)

///|
fn ffi_http_get(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "get", path, resolver |> @core.identity)
}

///|
fn ffi_http_post(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "post", path, resolver |> @core.identity)
}

///|
fn ffi_http_put(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "put", path, resolver |> @core.identity)
}

///|
fn ffi_http_patch(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "patch", path, resolver |> @core.identity)
}

///|
fn ffi_http_delete(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "delete", path, resolver |> @core.identity)
}

///|
fn ffi_http_options(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "options", path, resolver |> @core.identity)
}

///|
fn ffi_http_head(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "head", path, resolver |> @core.identity)
}

///|
fn ffi_http_all(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(), "all", path, resolver |> @core.identity)
}

///| HTTP Response FFI

///|
extern "js" fn call_http_response_method(
  http_response : @core.Any,
  method_name : String,
  body : @core.Any,
  init : @core.Any,
) -> HttpResponse =
  #| (hr, method_name, body, init) => {
  #|   return Object.keys(init).length > 0 ?
  #|     hr[method_name](body, init) :
  #|     hr[method_name](body);
  #| }

///|
extern "js" fn call_http_response_error(
  http_response : @core.Any,
) -> HttpResponse =
  #| (hr) => hr.error()

///|
pub fn http_response_json(
  body : @core.Any,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  let init = @core.new_object()
  if status is Some(s) {
    init._set("status", s |> @core.any)
  }
  if statusText is Some(st) {
    init._set("statusText", st |> @core.any)
  }
  if headers is Some(h) {
    init._set("headers", h)
  }
  call_http_response_method(get_http_response(), "json", body, init)
}

///|
pub fn http_response_text(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  let init = @core.new_object()
  if status is Some(s) {
    init._set("status", s |> @core.any)
  }
  if statusText is Some(st) {
    init._set("statusText", st |> @core.any)
  }
  if headers is Some(h) {
    init._set("headers", h)
  }
  call_http_response_method(
    get_http_response(),
    "text",
    body |> @core.any,
    init,
  )
}

///|
pub fn http_response_xml(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  let init = @core.new_object()
  if status is Some(s) {
    init._set("status", s |> @core.any)
  }
  if statusText is Some(st) {
    init._set("statusText", st |> @core.any)
  }
  if headers is Some(h) {
    init._set("headers", h)
  }
  call_http_response_method(get_http_response(), "xml", body |> @core.any, init)
}

///|
pub fn http_response_html(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  let init = @core.new_object()
  if status is Some(s) {
    init._set("status", s |> @core.any)
  }
  if statusText is Some(st) {
    init._set("statusText", st |> @core.any)
  }
  if headers is Some(h) {
    init._set("headers", h)
  }
  call_http_response_method(
    get_http_response(),
    "html",
    body |> @core.any,
    init,
  )
}

///|
pub fn http_response_array_buffer(
  body : @core.Any,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  let init = @core.new_object()
  if status is Some(s) {
    init._set("status", s |> @core.any)
  }
  if statusText is Some(st) {
    init._set("statusText", st |> @core.any)
  }
  if headers is Some(h) {
    init._set("headers", h)
  }
  call_http_response_method(get_http_response(), "arrayBuffer", body, init)
}

///|
pub fn http_response_error() -> HttpResponse {
  call_http_response_error(get_http_response())
}

///| Request/Response Info FFI

///|
/// Request property accessors
pub extern "js" fn request_url(request : @core.Any) -> String =
  #| (request) => request.url

///|
pub extern "js" fn request_method(request : @core.Any) -> String =
  #| (request) => request.method

///|
pub extern "js" fn request_headers(request : @core.Any) -> @core.Any =
  #| (request) => request.headers

///|
pub extern "js" fn request_json(
  request : @core.Any,
) -> @core.Promise[@core.Any] =
  #| (request) => request.json()

///|
pub extern "js" fn request_text(request : @core.Any) -> @core.Promise[String] =
  #| (request) => request.text()

///| HTTP Handler Methods

///|
/// Create GET request handler
pub fn httpGet(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_get(path, resolver)
}

///|
/// Create POST request handler
pub fn httpPost(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_post(path, resolver)
}

///|
/// Create PUT request handler
pub fn httpPut(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_put(path, resolver)
}

///|
/// Create PATCH request handler
pub fn httpPatch(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_patch(path, resolver)
}

///|
/// Create DELETE request handler
pub fn httpDelete(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_delete(path, resolver)
}

///|
/// Create OPTIONS request handler
pub fn httpOptions(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_options(path, resolver)
}

///|
/// Create HEAD request handler
pub fn httpHead(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_head(path, resolver)
}

///|
/// Create handler for all HTTP methods
pub fn httpAll(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  ffi_http_all(path, resolver)
}

///| HTTP Response Methods

///|
/// Create JSON response
///
/// # Options
/// - `status`: HTTP status code (e.g., 200, 404)
/// - `statusText`: HTTP status text (e.g., "OK", "Not Found")
/// - `headers`: Response headers as an object
pub fn jsonResponse(
  body : @core.Any,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  http_response_json(body, status?, statusText?, headers?)
}

///|
/// Create text response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn textResponse(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  http_response_text(body, status?, statusText?, headers?)
}

///|
/// Create XML response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn xmlResponse(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  http_response_xml(body, status?, statusText?, headers?)
}

///|
/// Create HTML response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn htmlResponse(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  http_response_html(body, status?, statusText?, headers?)
}

///|
/// Create array buffer response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn arrayBufferResponse(
  body : @core.Any,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse {
  http_response_array_buffer(body, status?, statusText?, headers?)
}

///|
/// Create network error response
pub fn errorResponse() -> HttpResponse {
  http_response_error()
}

///| ResponseResolverInfo Methods

///|
/// Get the request object
pub fn ResponseResolverInfo::request(self : ResponseResolverInfo) -> @core.Any {
  self.request
}

///|
/// Get URL parameters
pub fn ResponseResolverInfo::params(self : ResponseResolverInfo) -> @core.Any {
  self.params
}

///|
/// Get cookies
pub fn ResponseResolverInfo::cookies(self : ResponseResolverInfo) -> @core.Any {
  self.cookies
}

///|
/// Get request URL
pub fn ResponseResolverInfo::url(self : ResponseResolverInfo) -> String {
  request_url(self.request)
}

///|
/// Get request method
pub fn ResponseResolverInfo::httpMethod(self : ResponseResolverInfo) -> String {
  request_method(self.request)
}

///|
/// Get request headers
pub fn ResponseResolverInfo::headers(self : ResponseResolverInfo) -> @core.Any {
  request_headers(self.request)
}

///| Request body methods

///|
/// Get request body as JSON (returns Promise)
pub fn ResponseResolverInfo::json(
  self : ResponseResolverInfo,
) -> @core.Promise[@core.Any] {
  request_json(self.request)
}

///|
/// Get request body as text (returns Promise)
pub fn ResponseResolverInfo::text(
  self : ResponseResolverInfo,
) -> @core.Promise[String] {
  request_text(self.request)
}

///| Param helper

///|
/// Get a string parameter by name
pub fn ResponseResolverInfo::getParam(
  self : ResponseResolverInfo,
  name : String,
) -> String {
  self.params[name].cast()
}

///| Convenience builders

///|
/// Create a simple JSON GET handler
pub fn mockGet(path : String, response_body : @core.Any) -> RequestHandler {
  httpGet(path, fn(_info) { jsonResponse(response_body) })
}

///|
/// Create a simple JSON POST handler
pub fn mockPost(path : String, response_body : @core.Any) -> RequestHandler {
  httpPost(path, fn(_info) { jsonResponse(response_body) })
}

///|
/// Create a handler that returns an error status
pub fn mockError(
  path : String,
  status : Int,
  message : String,
) -> RequestHandler {
  httpGet(path, fn(_info) {
    let body = @core.new_object()
    body["error"] = @core.any(message)
    jsonResponse(body, status~)
  })
}
