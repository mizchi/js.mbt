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
extern "js" fn ffi_http_get(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.get(path, resolver)

///|
extern "js" fn ffi_http_post(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.post(path, resolver)

///|
extern "js" fn ffi_http_put(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.put(path, resolver)

///|
extern "js" fn ffi_http_patch(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.patch(path, resolver)

///|
extern "js" fn ffi_http_delete(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.delete(path, resolver)

///|
extern "js" fn ffi_http_options(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.options(path, resolver)

///|
extern "js" fn ffi_http_head(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.head(path, resolver)

///|
extern "js" fn ffi_http_all(
  path : String,
  resolver : (ResponseResolverInfo) -> HttpResponse,
) -> RequestHandler =
  #| (path, resolver) => require('msw').http.all(path, resolver)

///| HTTP Response FFI

///|
pub extern "js" fn http_response_json(
  body : @core.Any,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse =
  #| (body, status, statusText, headers) => {
  #|   const msw = require('msw');
  #|   const init = {};
  #|   if (status !== undefined) init.status = status;
  #|   if (statusText !== undefined) init.statusText = statusText;
  #|   if (headers !== undefined) init.headers = headers;
  #|   return Object.keys(init).length > 0 ?
  #|     msw.HttpResponse.json(body, init) :
  #|     msw.HttpResponse.json(body);
  #| }

///|
pub extern "js" fn http_response_text(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse =
  #| (body, status, statusText, headers) => {
  #|   const msw = require('msw');
  #|   const init = {};
  #|   if (status !== undefined) init.status = status;
  #|   if (statusText !== undefined) init.statusText = statusText;
  #|   if (headers !== undefined) init.headers = headers;
  #|   return Object.keys(init).length > 0 ?
  #|     msw.HttpResponse.text(body, init) :
  #|     msw.HttpResponse.text(body);
  #| }

///|
pub extern "js" fn http_response_xml(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse =
  #| (body, status, statusText, headers) => {
  #|   const msw = require('msw');
  #|   const init = {};
  #|   if (status !== undefined) init.status = status;
  #|   if (statusText !== undefined) init.statusText = statusText;
  #|   if (headers !== undefined) init.headers = headers;
  #|   return Object.keys(init).length > 0 ?
  #|     msw.HttpResponse.xml(body, init) :
  #|     msw.HttpResponse.xml(body);
  #| }

///|
pub extern "js" fn http_response_html(
  body : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse =
  #| (body, status, statusText, headers) => {
  #|   const msw = require('msw');
  #|   const init = {};
  #|   if (status !== undefined) init.status = status;
  #|   if (statusText !== undefined) init.statusText = statusText;
  #|   if (headers !== undefined) init.headers = headers;
  #|   return Object.keys(init).length > 0 ?
  #|     msw.HttpResponse.html(body, init) :
  #|     msw.HttpResponse.html(body);
  #| }

///|
pub extern "js" fn http_response_array_buffer(
  body : @core.Any,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> HttpResponse =
  #| (body, status, statusText, headers) => {
  #|   const msw = require('msw');
  #|   const init = {};
  #|   if (status !== undefined) init.status = status;
  #|   if (statusText !== undefined) init.statusText = statusText;
  #|   if (headers !== undefined) init.headers = headers;
  #|   return Object.keys(init).length > 0 ?
  #|     msw.HttpResponse.arrayBuffer(body, init) :
  #|     msw.HttpResponse.arrayBuffer(body);
  #| }

///|
pub extern "js" fn http_response_error() -> HttpResponse =
  #| () => require('msw').HttpResponse.error()

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
