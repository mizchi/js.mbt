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
pub fn RequestHandler::as_any(self : RequestHandler) -> @nostd.Any = "%identity"

///|
/// Mock server instance (Node.js)
#external
pub type SetupServer

///|
pub fn SetupServer::as_any(self : SetupServer) -> @nostd.Any = "%identity"

///|
/// Mock worker instance (Browser)
#external
pub type SetupWorker

///|
pub fn SetupWorker::as_any(self : SetupWorker) -> @nostd.Any = "%identity"

///|
/// StartOptions for worker.start()
#external
pub type StartOptions

///|
pub fn StartOptions::as_any(self : StartOptions) -> @nostd.Any = "%identity"

///|
/// HTTP response
#external
pub type HttpResponse

///|
pub fn HttpResponse::as_any(self : HttpResponse) -> @nostd.Any = "%identity"

///|
/// Request info
#external
pub type RequestInfo

///|
pub fn RequestInfo::as_any(self : RequestInfo) -> @nostd.Any = "%identity"

///|
/// Response resolver context
#external
pub type ResponseResolverInfo

///|
pub fn ResponseResolverInfo::as_any(self : ResponseResolverInfo) -> @nostd.Any = "%identity"

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
extern "js" fn ffi_http_response_json(
  body : @nostd.Any,
  status : Int,
) -> HttpResponse =
  #| (body, status) => require('msw').HttpResponse.json(body, { status })

///|
extern "js" fn ffi_http_response_json_default(
  body : @nostd.Any,
) -> HttpResponse =
  #| (body) => require('msw').HttpResponse.json(body)

///|
extern "js" fn ffi_http_response_text(
  body : String,
  status : Int,
) -> HttpResponse =
  #| (body, status) => require('msw').HttpResponse.text(body, { status })

///|
extern "js" fn ffi_http_response_text_default(body : String) -> HttpResponse =
  #| (body) => require('msw').HttpResponse.text(body)

///|
extern "js" fn ffi_http_response_xml(
  body : String,
  status : Int,
) -> HttpResponse =
  #| (body, status) => require('msw').HttpResponse.xml(body, { status })

///|
extern "js" fn ffi_http_response_xml_default(body : String) -> HttpResponse =
  #| (body) => require('msw').HttpResponse.xml(body)

///|
extern "js" fn ffi_http_response_html(
  body : String,
  status : Int,
) -> HttpResponse =
  #| (body, status) => require('msw').HttpResponse.html(body, { status })

///|
extern "js" fn ffi_http_response_html_default(body : String) -> HttpResponse =
  #| (body) => require('msw').HttpResponse.html(body)

///|
extern "js" fn ffi_http_response_array_buffer(
  body : @nostd.Any,
  status : Int,
) -> HttpResponse =
  #| (body, status) => require('msw').HttpResponse.arrayBuffer(body, { status })

///|
extern "js" fn ffi_http_response_error() -> HttpResponse =
  #| () => require('msw').HttpResponse.error()

///| Server FFI (msw/node)

///|
extern "js" fn ffi_setup_server(handlers : @nostd.Any) -> SetupServer =
  #| (handlers) => require('msw/node').setupServer(...handlers)

///|
extern "js" fn ffi_setup_server_empty() -> SetupServer =
  #| () => require('msw/node').setupServer()

///|
extern "js" fn ffi_server_listen(server : SetupServer) -> Unit =
  #| (server) => server.listen()

///|
extern "js" fn ffi_server_listen_with_options(
  server : SetupServer,
  options : @nostd.Any,
) -> Unit =
  #| (server, options) => server.listen(options)

///|
extern "js" fn ffi_server_close(server : SetupServer) -> Unit =
  #| (server) => server.close()

///|
extern "js" fn ffi_server_reset_handlers(server : SetupServer) -> Unit =
  #| (server) => server.resetHandlers()

///|
extern "js" fn ffi_server_reset_handlers_with(
  server : SetupServer,
  handlers : @nostd.Any,
) -> Unit =
  #| (server, handlers) => server.resetHandlers(...handlers)

///|
extern "js" fn ffi_server_use(
  server : SetupServer,
  handlers : @nostd.Any,
) -> Unit =
  #| (server, handlers) => server.use(...handlers)

///|
extern "js" fn ffi_server_restore_handlers(server : SetupServer) -> Unit =
  #| (server) => server.restoreHandlers()

///|
extern "js" fn ffi_server_list_handlers(server : SetupServer) -> @nostd.Any =
  #| (server) => server.listHandlers()

///| Worker FFI (msw/browser)

///|
extern "js" fn ffi_setup_worker(handlers : @nostd.Any) -> SetupWorker =
  #| (handlers) => require('msw/browser').setupWorker(...handlers)

///|
extern "js" fn ffi_setup_worker_empty() -> SetupWorker =
  #| () => require('msw/browser').setupWorker()

///|
extern "js" fn ffi_worker_start(worker : SetupWorker) -> @nostd.Promise[Unit] =
  #| (worker) => worker.start()

///|
extern "js" fn ffi_worker_start_with_options(
  worker : SetupWorker,
  options : @nostd.Any,
) -> @nostd.Promise[Unit] =
  #| (worker, options) => worker.start(options)

///|
extern "js" fn ffi_worker_stop(worker : SetupWorker) -> Unit =
  #| (worker) => worker.stop()

///|
extern "js" fn ffi_worker_reset_handlers(worker : SetupWorker) -> Unit =
  #| (worker) => worker.resetHandlers()

///|
extern "js" fn ffi_worker_reset_handlers_with(
  worker : SetupWorker,
  handlers : @nostd.Any,
) -> Unit =
  #| (worker, handlers) => worker.resetHandlers(...handlers)

///|
extern "js" fn ffi_worker_use(
  worker : SetupWorker,
  handlers : @nostd.Any,
) -> Unit =
  #| (worker, handlers) => worker.use(...handlers)

///|
extern "js" fn ffi_worker_restore_handlers(worker : SetupWorker) -> Unit =
  #| (worker) => worker.restoreHandlers()

///|
extern "js" fn ffi_worker_list_handlers(worker : SetupWorker) -> @nostd.Any =
  #| (worker) => worker.listHandlers()

///| Request/Response Info FFI

///|
extern "js" fn ffi_info_request(info : ResponseResolverInfo) -> @nostd.Any =
  #| (info) => info.request

///|
extern "js" fn ffi_info_params(info : ResponseResolverInfo) -> @nostd.Any =
  #| (info) => info.params

///|
extern "js" fn ffi_info_cookies(info : ResponseResolverInfo) -> @nostd.Any =
  #| (info) => info.cookies

///|
extern "js" fn ffi_request_url(request : @nostd.Any) -> String =
  #| (request) => request.url

///|
extern "js" fn ffi_request_method(request : @nostd.Any) -> String =
  #| (request) => request.method

///|
extern "js" fn ffi_request_headers(request : @nostd.Any) -> @nostd.Any =
  #| (request) => request.headers

///|
extern "js" fn ffi_request_json(
  request : @nostd.Any,
) -> @nostd.Promise[@nostd.Any] =
  #| (request) => request.json()

///|
extern "js" fn ffi_request_text(request : @nostd.Any) -> @nostd.Promise[String] =
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
pub fn jsonResponse(body : @nostd.Any, status? : Int = 200) -> HttpResponse {
  if status == 200 {
    ffi_http_response_json_default(body)
  } else {
    ffi_http_response_json(body, status)
  }
}

///|
/// Create text response
pub fn textResponse(body : String, status? : Int = 200) -> HttpResponse {
  if status == 200 {
    ffi_http_response_text_default(body)
  } else {
    ffi_http_response_text(body, status)
  }
}

///|
/// Create XML response
pub fn xmlResponse(body : String, status? : Int = 200) -> HttpResponse {
  if status == 200 {
    ffi_http_response_xml_default(body)
  } else {
    ffi_http_response_xml(body, status)
  }
}

///|
/// Create HTML response
pub fn htmlResponse(body : String, status? : Int = 200) -> HttpResponse {
  if status == 200 {
    ffi_http_response_html_default(body)
  } else {
    ffi_http_response_html(body, status)
  }
}

///|
/// Create array buffer response
pub fn arrayBufferResponse(
  body : @nostd.Any,
  status? : Int = 200,
) -> HttpResponse {
  ffi_http_response_array_buffer(body, status)
}

///|
/// Create network error response
pub fn errorResponse() -> HttpResponse {
  ffi_http_response_error()
}

///| Server Methods

///|
/// Setup mock server with handlers
pub fn setupServer(handlers : Array[RequestHandler]) -> SetupServer {
  if handlers.length() == 0 {
    ffi_setup_server_empty()
  } else {
    ffi_setup_server(@nostd.any(handlers.map(fn(h) { h.as_any() })))
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
      let options = @nostd.Object::new()
      options["onUnhandledRequest"] = @nostd.any(mode)
      ffi_server_listen_with_options(self, options)
    }
    None => ffi_server_listen(self)
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
    @nostd.any(handlers.map(fn(h) { h.as_any() })),
  )
}

///|
/// Add runtime request handlers
pub fn SetupServer::useHandlers(
  self : SetupServer,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_server_use(self, @nostd.any(handlers.map(fn(h) { h.as_any() })))
}

///|
/// Restore handlers to initial state (alias for resetHandlers)
pub fn SetupServer::restoreHandlers(self : SetupServer) -> Unit {
  ffi_server_restore_handlers(self)
}

///|
/// List all current handlers
pub fn SetupServer::listHandlers(self : SetupServer) -> @nostd.Any {
  ffi_server_list_handlers(self)
}

///| Worker Methods (Browser)

///|
/// Setup mock worker with handlers (Browser)
pub fn setupWorker(handlers : Array[RequestHandler]) -> SetupWorker {
  if handlers.length() == 0 {
    ffi_setup_worker_empty()
  } else {
    ffi_setup_worker(@nostd.any(handlers.map(fn(h) { h.as_any() })))
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
    let options = @nostd.Object::new()
    match serviceWorkerUrl {
      Some(url) => {
        let sw = @nostd.Object::new()
        sw["url"] = @nostd.any(url)
        options["serviceWorker"] = sw
      }
      None => ()
    }
    match quiet {
      Some(q) => options["quiet"] = @nostd.any(q)
      None => ()
    }
    match onUnhandledRequest {
      Some(mode) => options["onUnhandledRequest"] = @nostd.any(mode)
      None => ()
    }
    ffi_worker_start_with_options(self, options).wait()
  } else {
    ffi_worker_start(self).wait()
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
    @nostd.any(handlers.map(fn(h) { h.as_any() })),
  )
}

///|
/// Add runtime request handlers
pub fn SetupWorker::useHandlers(
  self : SetupWorker,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_worker_use(self, @nostd.any(handlers.map(fn(h) { h.as_any() })))
}

///|
/// Restore handlers to initial state
pub fn SetupWorker::restoreHandlers(self : SetupWorker) -> Unit {
  ffi_worker_restore_handlers(self)
}

///|
/// List all current handlers
pub fn SetupWorker::listHandlers(self : SetupWorker) -> @nostd.Any {
  ffi_worker_list_handlers(self)
}

///| ResponseResolverInfo Methods

///|
/// Get the request object
pub fn ResponseResolverInfo::request(self : ResponseResolverInfo) -> @nostd.Any {
  ffi_info_request(self)
}

///|
/// Get URL parameters
pub fn ResponseResolverInfo::params(self : ResponseResolverInfo) -> @nostd.Any {
  ffi_info_params(self)
}

///|
/// Get cookies
pub fn ResponseResolverInfo::cookies(self : ResponseResolverInfo) -> @nostd.Any {
  ffi_info_cookies(self)
}

///|
/// Get request URL
pub fn ResponseResolverInfo::url(self : ResponseResolverInfo) -> String {
  ffi_request_url(self.request())
}

///|
/// Get request method
pub fn ResponseResolverInfo::httpMethod(self : ResponseResolverInfo) -> String {
  ffi_request_method(self.request())
}

///|
/// Get request headers
pub fn ResponseResolverInfo::headers(self : ResponseResolverInfo) -> @nostd.Any {
  ffi_request_headers(self.request())
}

///| Request body methods

///|
/// Get request body as JSON (returns Promise)
pub fn ResponseResolverInfo::json(
  self : ResponseResolverInfo,
) -> @nostd.Promise[@nostd.Any] {
  ffi_request_json(self.request())
}

///|
/// Get request body as text (returns Promise)
pub fn ResponseResolverInfo::text(
  self : ResponseResolverInfo,
) -> @nostd.Promise[String] {
  ffi_request_text(self.request())
}

///| Param helper

///|
/// Get a string parameter by name
pub fn ResponseResolverInfo::getParam(
  self : ResponseResolverInfo,
  name : String,
) -> String {
  self.params()[name].cast()
}

///| Convenience builders

///|
/// Create a simple JSON GET handler
pub fn mockGet(path : String, response_body : @nostd.Any) -> RequestHandler {
  httpGet(path, fn(_info) { jsonResponse(response_body) })
}

///|
/// Create a simple JSON POST handler
pub fn mockPost(path : String, response_body : @nostd.Any) -> RequestHandler {
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
    let body = @nostd.Object::new()
    body["error"] = @nostd.any(message)
    jsonResponse(body, status~)
  })
}
