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
/// Mock server instance (Node.js)
#external
pub type SetupServer

///|
pub fn SetupServer::as_any(self : SetupServer) -> @core.Any = "%identity"

///|
/// Mock worker instance (Browser)
#external
pub type SetupWorker

///|
pub fn SetupWorker::as_any(self : SetupWorker) -> @core.Any = "%identity"

///|
/// StartOptions for worker.start()
#external
pub type StartOptions

///|
pub fn StartOptions::as_any(self : StartOptions) -> @core.Any = "%identity"

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
) -> HttpResponse =
  #| (body, status) => {
  #|   const msw = require('msw');
  #|   return status !== undefined ?
  #|     msw.HttpResponse.json(body, { status }) :
  #|     msw.HttpResponse.json(body);
  #| }

///|
pub extern "js" fn http_response_text(
  body : String,
  status? : Int,
) -> HttpResponse =
  #| (body, status) => {
  #|   const msw = require('msw');
  #|   return status !== undefined ?
  #|     msw.HttpResponse.text(body, { status }) :
  #|     msw.HttpResponse.text(body);
  #| }

///|
pub extern "js" fn http_response_xml(
  body : String,
  status? : Int,
) -> HttpResponse =
  #| (body, status) => {
  #|   const msw = require('msw');
  #|   return status !== undefined ?
  #|     msw.HttpResponse.xml(body, { status }) :
  #|     msw.HttpResponse.xml(body);
  #| }

///|
pub extern "js" fn http_response_html(
  body : String,
  status? : Int,
) -> HttpResponse =
  #| (body, status) => {
  #|   const msw = require('msw');
  #|   return status !== undefined ?
  #|     msw.HttpResponse.html(body, { status }) :
  #|     msw.HttpResponse.html(body);
  #| }

///|
pub extern "js" fn http_response_array_buffer(
  body : @core.Any,
  status? : Int,
) -> HttpResponse =
  #| (body, status) => {
  #|   const msw = require('msw');
  #|   return status !== undefined ?
  #|     msw.HttpResponse.arrayBuffer(body, { status }) :
  #|     msw.HttpResponse.arrayBuffer(body);
  #| }

///|
pub extern "js" fn http_response_error() -> HttpResponse =
  #| () => require('msw').HttpResponse.error()

///| Server FFI (msw/node)

///|
extern "js" fn ffi_setup_server(handlers : @core.Any) -> SetupServer =
  #| (handlers) => require('msw/node').setupServer(...handlers)

///|
extern "js" fn ffi_setup_server_empty() -> SetupServer =
  #| () => require('msw/node').setupServer()

///|
pub extern "js" fn server_listen(
  server : SetupServer,
  options? : @core.Any,
) -> Unit =
  #| (server, options) => {
  #|   return options !== undefined ?
  #|     server.listen(options) :
  #|     server.listen();
  #| }

///|
extern "js" fn ffi_server_close(server : SetupServer) -> Unit =
  #| (server) => server.close()

///|
extern "js" fn ffi_server_reset_handlers(server : SetupServer) -> Unit =
  #| (server) => server.resetHandlers()

///|
extern "js" fn ffi_server_reset_handlers_with(
  server : SetupServer,
  handlers : @core.Any,
) -> Unit =
  #| (server, handlers) => server.resetHandlers(...handlers)

///|
extern "js" fn ffi_server_use(
  server : SetupServer,
  handlers : @core.Any,
) -> Unit =
  #| (server, handlers) => server.use(...handlers)

///|
extern "js" fn ffi_server_restore_handlers(server : SetupServer) -> Unit =
  #| (server) => server.restoreHandlers()

///|
extern "js" fn ffi_server_list_handlers(server : SetupServer) -> @core.Any =
  #| (server) => server.listHandlers()

///| Worker FFI (msw/browser)

///|
extern "js" fn ffi_setup_worker(handlers : @core.Any) -> SetupWorker =
  #| (handlers) => require('msw/browser').setupWorker(...handlers)

///|
extern "js" fn ffi_setup_worker_empty() -> SetupWorker =
  #| () => require('msw/browser').setupWorker()

///|
pub extern "js" fn worker_start(
  worker : SetupWorker,
  options? : @core.Any,
) -> @core.Promise[Unit] =
  #| (worker, options) => {
  #|   return options !== undefined ?
  #|     worker.start(options) :
  #|     worker.start();
  #| }

///|
extern "js" fn ffi_worker_stop(worker : SetupWorker) -> Unit =
  #| (worker) => worker.stop()

///|
extern "js" fn ffi_worker_reset_handlers(worker : SetupWorker) -> Unit =
  #| (worker) => worker.resetHandlers()

///|
extern "js" fn ffi_worker_reset_handlers_with(
  worker : SetupWorker,
  handlers : @core.Any,
) -> Unit =
  #| (worker, handlers) => worker.resetHandlers(...handlers)

///|
extern "js" fn ffi_worker_use(
  worker : SetupWorker,
  handlers : @core.Any,
) -> Unit =
  #| (worker, handlers) => worker.use(...handlers)

///|
extern "js" fn ffi_worker_restore_handlers(worker : SetupWorker) -> Unit =
  #| (worker) => worker.restoreHandlers()

///|
extern "js" fn ffi_worker_list_handlers(worker : SetupWorker) -> @core.Any =
  #| (worker) => worker.listHandlers()

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
pub fn jsonResponse(body : @core.Any, status? : Int) -> HttpResponse {
  http_response_json(body, status?)
}

///|
/// Create text response
pub fn textResponse(body : String, status? : Int) -> HttpResponse {
  http_response_text(body, status?)
}

///|
/// Create XML response
pub fn xmlResponse(body : String, status? : Int) -> HttpResponse {
  http_response_xml(body, status?)
}

///|
/// Create HTML response
pub fn htmlResponse(body : String, status? : Int) -> HttpResponse {
  http_response_html(body, status?)
}

///|
/// Create array buffer response
pub fn arrayBufferResponse(body : @core.Any, status? : Int) -> HttpResponse {
  http_response_array_buffer(body, status?)
}

///|
/// Create network error response
pub fn errorResponse() -> HttpResponse {
  http_response_error()
}

///| Server Methods

///|
/// Setup mock server with handlers
pub fn setupServer(handlers : Array[RequestHandler]) -> SetupServer {
  if handlers.length() == 0 {
    ffi_setup_server_empty()
  } else {
    ffi_setup_server(@core.any(handlers.map(fn(h) { h.as_any() })))
  }
}

///|
/// Start listening for requests
pub fn SetupServer::listen(
  self : SetupServer,
  onUnhandledRequest? : String,
) -> Unit {
  match onUnhandledRequest {
    Some(mode) => {
      let options = @core.new_object()
      options["onUnhandledRequest"] = @core.any(mode)
      server_listen(self, options~)
    }
    None => server_listen(self)
  }
}

///|
/// Stop the mock server
pub fn SetupServer::close(self : SetupServer) -> Unit {
  ffi_server_close(self)
}

///|
/// Reset handlers to initial state
pub fn SetupServer::resetHandlers(self : SetupServer) -> Unit {
  ffi_server_reset_handlers(self)
}

///|
/// Reset handlers with new handlers
pub fn SetupServer::resetHandlersWith(
  self : SetupServer,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_server_reset_handlers_with(
    self,
    @core.any(handlers.map(fn(h) { h.as_any() })),
  )
}

///|
/// Add runtime request handlers
pub fn SetupServer::useHandlers(
  self : SetupServer,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_server_use(self, @core.any(handlers.map(fn(h) { h.as_any() })))
}

///|
/// Restore handlers to initial state (alias for resetHandlers)
pub fn SetupServer::restoreHandlers(self : SetupServer) -> Unit {
  ffi_server_restore_handlers(self)
}

///|
/// List all current handlers
pub fn SetupServer::listHandlers(self : SetupServer) -> @core.Any {
  ffi_server_list_handlers(self)
}

///| Worker Methods (Browser)

///|
/// Setup mock worker with handlers (Browser)
pub fn setupWorker(handlers : Array[RequestHandler]) -> SetupWorker {
  if handlers.length() == 0 {
    ffi_setup_worker_empty()
  } else {
    ffi_setup_worker(@core.any(handlers.map(fn(h) { h.as_any() })))
  }
}

///|
/// Start the service worker (async)
pub async fn SetupWorker::start(
  self : SetupWorker,
  serviceWorkerUrl? : String,
  quiet? : Bool,
  onUnhandledRequest? : String,
) -> Unit {
  let has_options = serviceWorkerUrl is Some(_) ||
    quiet is Some(_) ||
    onUnhandledRequest is Some(_)
  if has_options {
    let options = @core.new_object()
    match serviceWorkerUrl {
      Some(url) => {
        let sw = @core.new_object()
        sw["url"] = @core.any(url)
        options["serviceWorker"] = sw
      }
      None => ()
    }
    match quiet {
      Some(q) => options["quiet"] = @core.any(q)
      None => ()
    }
    match onUnhandledRequest {
      Some(mode) => options["onUnhandledRequest"] = @core.any(mode)
      None => ()
    }
    worker_start(self, options~).wait()
  } else {
    worker_start(self).wait()
  }
}

///|
/// Stop the service worker
pub fn SetupWorker::stop(self : SetupWorker) -> Unit {
  ffi_worker_stop(self)
}

///|
/// Reset handlers to initial state
pub fn SetupWorker::resetHandlers(self : SetupWorker) -> Unit {
  ffi_worker_reset_handlers(self)
}

///|
/// Reset handlers with new handlers
pub fn SetupWorker::resetHandlersWith(
  self : SetupWorker,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_worker_reset_handlers_with(
    self,
    @core.any(handlers.map(fn(h) { h.as_any() })),
  )
}

///|
/// Add runtime request handlers
pub fn SetupWorker::useHandlers(
  self : SetupWorker,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_worker_use(self, @core.any(handlers.map(fn(h) { h.as_any() })))
}

///|
/// Restore handlers to initial state
pub fn SetupWorker::restoreHandlers(self : SetupWorker) -> Unit {
  ffi_worker_restore_handlers(self)
}

///|
/// List all current handlers
pub fn SetupWorker::listHandlers(self : SetupWorker) -> @core.Any {
  ffi_worker_list_handlers(self)
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
