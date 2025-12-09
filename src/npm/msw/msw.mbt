///|
/// MSW (Mock Service Worker) bindings for MoonBit
/// https://mswjs.io/
///
/// API mocking library for browser and Node.js testing.

///| Types

///|
/// MSW module instance containing http and HttpResponse
#external
pub type Msw

///|
pub fn Msw::as_any(self : Msw) -> @core.Any = "%identity"

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

///| MSW Import

///|
/// Dynamic import for msw module
extern "js" fn ffi_import_msw() -> @core.Promise[@core.Any] =
  #|() => import("msw")

///|
/// Import msw module and return Msw instance
pub async fn import_msw() -> Msw {
  ffi_import_msw().wait().cast()
}

///| HTTP Handler FFI

///|
extern "js" fn get_http(msw : Msw) -> @core.Any =
  #|(msw) => msw.http

///|
extern "js" fn get_http_response(msw : Msw) -> @core.Any =
  #|(msw) => msw.HttpResponse

///|
extern "js" fn call_http_method(
  http : @core.Any,
  method_name : String,
  path : String,
  resolver : @core.Any,
) -> RequestHandler =
  #| (http, method_name, path, resolver) => http[method_name](path, resolver)

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

///| Msw Methods - HTTP Handlers

///|
/// Create GET request handler
pub fn Msw::httpGet(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "get", path, resolver |> @core.identity)
}

///|
/// Create POST request handler
pub fn Msw::httpPost(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "post", path, resolver |> @core.identity)
}

///|
/// Create PUT request handler
pub fn Msw::httpPut(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "put", path, resolver |> @core.identity)
}

///|
/// Create PATCH request handler
pub fn Msw::httpPatch(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "patch", path, resolver |> @core.identity)
}

///|
/// Create DELETE request handler
pub fn Msw::httpDelete(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "delete", path, resolver |> @core.identity)
}

///|
/// Create OPTIONS request handler
pub fn Msw::httpOptions(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "options", path, resolver |> @core.identity)
}

///|
/// Create HEAD request handler
pub fn Msw::httpHead(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "head", path, resolver |> @core.identity)
}

///|
/// Create handler for all HTTP methods
pub fn Msw::httpAll(
  self : Msw,
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler {
  call_http_method(get_http(self), "all", path, resolver |> @core.identity)
}

///| Msw Methods - HTTP Responses

///|
/// Create JSON response
///
/// # Options
/// - `status`: HTTP status code (e.g., 200, 404)
/// - `statusText`: HTTP status text (e.g., "OK", "Not Found")
/// - `headers`: Response headers as an object
pub fn Msw::jsonResponse(
  self : Msw,
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
  call_http_response_method(get_http_response(self), "json", body, init)
}

///|
/// Create text response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn Msw::textResponse(
  self : Msw,
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
    get_http_response(self),
    "text",
    body |> @core.any,
    init,
  )
}

///|
/// Create XML response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn Msw::xmlResponse(
  self : Msw,
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
    get_http_response(self),
    "xml",
    body |> @core.any,
    init,
  )
}

///|
/// Create HTML response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn Msw::htmlResponse(
  self : Msw,
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
    get_http_response(self),
    "html",
    body |> @core.any,
    init,
  )
}

///|
/// Create array buffer response
///
/// # Options
/// - `status`: HTTP status code
/// - `statusText`: HTTP status text
/// - `headers`: Response headers
pub fn Msw::arrayBufferResponse(
  self : Msw,
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
  call_http_response_method(get_http_response(self), "arrayBuffer", body, init)
}

///|
/// Create network error response
pub fn Msw::errorResponse(self : Msw) -> HttpResponse {
  call_http_response_error(get_http_response(self))
}

///| Msw Methods - Convenience builders

///|
/// Create a simple JSON GET handler
pub fn Msw::mockGet(
  self : Msw,
  path : String,
  response_body : @core.Any,
) -> RequestHandler {
  self.httpGet(path, fn(_info) { self.jsonResponse(response_body) })
}

///|
/// Create a simple JSON POST handler
pub fn Msw::mockPost(
  self : Msw,
  path : String,
  response_body : @core.Any,
) -> RequestHandler {
  self.httpPost(path, fn(_info) { self.jsonResponse(response_body) })
}

///|
/// Create a handler that returns an error status
pub fn Msw::mockError(
  self : Msw,
  path : String,
  status : Int,
  message : String,
) -> RequestHandler {
  self.httpGet(path, fn(_info) {
    let body = @core.new_object()
    body["error"] = @core.any(message)
    self.jsonResponse(body, status~)
  })
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
