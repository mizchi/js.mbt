///|
/// Comlink bindings for MoonBit
/// https://github.com/GoogleChromeLabs/comlink
///
/// Makes WebWorkers enjoyable. Comlink makes postMessage communication
/// as simple as function calls.

///| Types

///|
/// Endpoint - represents a message channel endpoint (Worker, MessagePort, etc.)
#external
pub type Endpoint

///|
pub fn Endpoint::as_any(self : Endpoint) -> @nostd.Any = "%identity"

///|
/// Remote - a proxy to a remote object
#external
pub type Remote

///|
pub fn Remote::as_any(self : Remote) -> @nostd.Any = "%identity"

///|
/// ProxyMarked - marks a value to be proxied
#external
pub type ProxyMarked

///|
pub fn ProxyMarked::as_any(self : ProxyMarked) -> @nostd.Any = "%identity"

///|
/// TransferHandler - custom transfer handler for complex types
#external
pub type TransferHandler

///|
pub fn TransferHandler::as_any(self : TransferHandler) -> @nostd.Any = "%identity"

///| Core FFI

///|
extern "js" fn ffi_wrap(endpoint : @nostd.Any) -> Remote =
  #| (endpoint) => require('comlink').wrap(endpoint)

///|
extern "js" fn ffi_expose(obj : @nostd.Any, endpoint : @nostd.Any) -> Unit =
  #| (obj, endpoint) => require('comlink').expose(obj, endpoint)

///|
extern "js" fn ffi_expose_self(obj : @nostd.Any) -> Unit =
  #| (obj) => require('comlink').expose(obj)

///|
extern "js" fn ffi_transfer(
  value : @nostd.Any,
  transferables : @nostd.Any,
) -> @nostd.Any =
  #| (value, transferables) => require('comlink').transfer(value, transferables)

///|
extern "js" fn ffi_proxy(value : @nostd.Any) -> ProxyMarked =
  #| (value) => require('comlink').proxy(value)

///|
extern "js" fn ffi_window_endpoint(
  window : @nostd.Any,
  context : @nostd.Any,
  target_origin : String,
) -> Endpoint =
  #| (window, context, targetOrigin) => require('comlink').windowEndpoint(window, context, targetOrigin)

///|
extern "js" fn ffi_window_endpoint_default(window : @nostd.Any) -> Endpoint =
  #| (window) => require('comlink').windowEndpoint(window)

///|
extern "js" fn ffi_create_endpoint() -> @nostd.Any =
  #| () => require('comlink').createEndpoint

///|
extern "js" fn ffi_release_proxy() -> @nostd.Any =
  #| () => require('comlink').releaseProxy

///|
extern "js" fn ffi_proxy_marker() -> @nostd.Any =
  #| () => require('comlink').proxyMarker

///| TransferHandler FFI

///|
extern "js" fn ffi_get_transfer_handlers() -> @nostd.Any =
  #| () => require('comlink').transferHandlers

///| Core Functions

///|
/// Wrap an endpoint to create a proxy to the exposed object
/// Use this in the main thread to wrap a Worker
pub fn wrap(endpoint : @nostd.Any) -> Remote {
  ffi_wrap(endpoint)
}

///|
/// Wrap a Worker directly
pub fn wrapWorker(worker : @worker.Worker) -> Remote {
  ffi_wrap(worker.as_any().cast())
}

///|
/// Wrap a MessagePort
pub fn wrapMessagePort(port : @message.MessagePort) -> Remote {
  ffi_wrap(port.as_any().cast())
}

///|
/// Expose an object to be called from another thread
/// Use this in the Worker to expose functions
pub fn expose(obj : @nostd.Any, endpoint? : @nostd.Any) -> Unit {
  match endpoint {
    Some(ep) => ffi_expose(obj, ep)
    None => ffi_expose_self(obj)
  }
}

///|
/// Expose an object to a Worker
pub fn exposeToWorker(obj : @nostd.Any, worker : @worker.Worker) -> Unit {
  ffi_expose(obj, worker.as_any().cast())
}

///|
/// Expose an object to a MessagePort
pub fn exposeToMessagePort(obj : @nostd.Any, port : @message.MessagePort) -> Unit {
  ffi_expose(obj, port.as_any().cast())
}

///|
/// Mark a value to be transferred (not copied) to the other thread
/// Use for ArrayBuffer, MessagePort, etc.
pub fn transfer(value : @nostd.Any, transferables : Array[@nostd.Any]) -> @nostd.Any {
  ffi_transfer(value, @js.from_array(transferables))
}

///|
/// Mark a callback/function to be kept as a proxy
/// Useful for event callbacks that need to be called from the worker
pub fn proxy(value : @nostd.Any) -> ProxyMarked {
  ffi_proxy(value)
}

///|
/// Create an endpoint for communicating with an iframe/window
pub fn windowEndpoint(
  window : @nostd.Any,
  context? : @nostd.Any,
  target_origin? : String,
) -> Endpoint {
  match (context, target_origin) {
    (Some(ctx), Some(origin)) => ffi_window_endpoint(window, ctx, origin)
    (_, _) => ffi_window_endpoint_default(window)
  }
}

///|
/// Get the createEndpoint symbol
/// Used to create a new MessagePort from a proxy
pub fn createEndpointSymbol() -> @nostd.Any {
  ffi_create_endpoint()
}

///|
/// Get the releaseProxy symbol
/// Used to release a proxy and its associated resources
pub fn releaseProxySymbol() -> @nostd.Any {
  ffi_release_proxy()
}

///|
/// Get the proxyMarker symbol
pub fn proxyMarkerSymbol() -> @nostd.Any {
  ffi_proxy_marker()
}

///|
/// Get the transfer handlers map
/// Use this to register custom transfer handlers
pub fn transferHandlers() -> @nostd.Any {
  ffi_get_transfer_handlers()
}

///| Remote Methods

///|
extern "js" fn ffi_remote_call(
  remote : Remote,
  name : String,
  args : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #| (remote, name, args) => remote[name](...args)

///|
extern "js" fn ffi_remote_release(remote : Remote) -> Unit =
  #| (remote) => remote[require('comlink').releaseProxy]()

///|
extern "js" fn ffi_remote_create_endpoint(
  remote : Remote,
) -> @js.Promise[@message.MessagePort] =
  #| (remote) => remote[require('comlink').createEndpoint]()

///|
/// Call a method on the remote object
/// Returns a Promise
pub fn Remote::callMethod(
  self : Remote,
  name : String,
  args : Array[@nostd.Any],
) -> @js.Promise[@nostd.Any] {
  ffi_remote_call(self, name, @js.from_array(args))
}

///|
/// Call remote with no arguments
pub fn Remote::call0(self : Remote, name : String) -> @js.Promise[@nostd.Any] {
  self.as_any()._call(name, []).cast()
}

///|
/// Call remote with one argument
pub fn Remote::call1(
  self : Remote,
  name : String,
  arg : @nostd.Any,
) -> @js.Promise[@nostd.Any] {
  self.as_any()._call(name, [@nostd.any(arg)]).cast()
}

///|
/// Call remote with two arguments
pub fn Remote::call2(
  self : Remote,
  name : String,
  arg1 : @nostd.Any,
  arg2 : @nostd.Any,
) -> @js.Promise[@nostd.Any] {
  self.as_any()._call(name, [@nostd.any(arg1), @nostd.any(arg2)]).cast()
}

///|
/// Get a property from the remote object
pub fn Remote::get(self : Remote, prop : String) -> @js.Promise[@nostd.Any] {
  self.as_any()[prop].cast()
}

///|
/// Release the proxy and free resources
pub fn Remote::release(self : Remote) -> Unit {
  ffi_remote_release(self)
}

///|
/// Create a new endpoint (MessagePort) from the proxy
pub fn Remote::createEndpoint(
  self : Remote,
) -> @js.Promise[@message.MessagePort] {
  ffi_remote_create_endpoint(self)
}

///| Helper functions for common patterns

///|
/// Wrap a function to be proxied (for callbacks)
pub fn proxyCallback(f : (@nostd.Any) -> Unit) -> ProxyMarked {
  ffi_proxy(@js.from_fn1(f))
}

///|
/// Wrap a function with return value to be proxied
pub fn proxyFunction(f : (@nostd.Any) -> @nostd.Any) -> ProxyMarked {
  ffi_proxy(@js.from_fn1(f))
}

///|
/// Transfer an ArrayBuffer
pub fn transferArrayBuffer(buffer : @nostd.Any) -> @nostd.Any {
  ffi_transfer(buffer, @js.from_array([buffer]))
}
