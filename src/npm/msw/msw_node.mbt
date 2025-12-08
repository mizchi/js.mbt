///|
/// MSW Node.js adapter - Server API
/// https://mswjs.io/docs/api/setup-server
///
/// Node.js specific functionality for MSW testing.
/// Use SetupServer for mocking in Node.js environments.

///| Node.js Server Types

///|
/// Mock server instance (Node.js)
#external
pub type SetupServer

///|
pub fn SetupServer::as_any(self : SetupServer) -> @core.Any = "%identity"

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
///
/// # Options
/// - `onUnhandledRequest`: Specifies how to react to unhandled requests
///   - `"bypass"`: Pass through to the actual network
///   - `"warn"`: Log a warning (default)
///   - `"error"`: Throw an error
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
