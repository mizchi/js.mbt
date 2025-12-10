///|
/// MSW Node.js adapter - Server API
/// https://mswjs.io/docs/api/setup-server
///
/// Node.js specific functionality for MSW testing.
/// Use MswNode for mocking in Node.js environments.

///| Node.js Server Types

///|
/// MSW Node module instance containing setupServer
#external
pub type MswNode

///|
pub fn MswNode::as_any(self : MswNode) -> @core.Any = "%identity"

///|
/// Mock server instance (Node.js)
#external
pub type SetupServer

///|
pub fn SetupServer::as_any(self : SetupServer) -> @core.Any = "%identity"

///| Server FFI (msw/node)

///|
/// Dynamic import for msw/node module
extern "js" fn ffi_import_msw_node() -> @core.Promise[@core.Any] =
  #|() => import("msw/node")

///|
/// Import msw/node module and return MswNode instance
pub async fn import_msw_node() -> MswNode {
  ffi_import_msw_node().wait().cast()
}

///|
extern "js" fn get_setup_server_fn(msw_node : MswNode) -> @core.Any =
  #|(msw_node) => msw_node.setupServer

///|
extern "js" fn call_setup_server(
  setup_server : @core.Any,
  handlers : @core.Any,
) -> SetupServer =
  #| (ss, handlers) => ss(...handlers)

///|
extern "js" fn call_setup_server_empty(setup_server : @core.Any) -> SetupServer =
  #| (ss) => ss()

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

///| MswNode Methods

///|
/// Setup mock server with handlers
pub fn MswNode::setupServer(
  self : MswNode,
  handlers : Array[RequestHandler],
) -> SetupServer {
  let setup_server_fn = get_setup_server_fn(self)
  if handlers.length() == 0 {
    call_setup_server_empty(setup_server_fn)
  } else {
    call_setup_server(
      setup_server_fn,
      @core.any(handlers.map(fn(h) { h.as_any() })),
    )
  }
}

///| SetupServer Methods

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
