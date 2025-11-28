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
pub impl @js.JsImpl for Endpoint

///|
/// Remote - a proxy to a remote object
#external
pub type Remote

///|
pub impl @js.JsImpl for Remote

///|
/// ProxyMarked - marks a value to be proxied
#external
pub type ProxyMarked

///|
pub impl @js.JsImpl for ProxyMarked

///|
/// TransferHandler - custom transfer handler for complex types
#external
pub type TransferHandler

///|
pub impl @js.JsImpl for TransferHandler

///| Core FFI

///|
extern "js" fn ffi_wrap(endpoint : @js.Any) -> Remote =
  #| (endpoint) => require('comlink').wrap(endpoint)

///|
extern "js" fn ffi_expose(obj : @js.Any, endpoint : @js.Any) -> Unit =
  #| (obj, endpoint) => require('comlink').expose(obj, endpoint)

///|
extern "js" fn ffi_expose_self(obj : @js.Any) -> Unit =
  #| (obj) => require('comlink').expose(obj)

///|
extern "js" fn ffi_transfer(
  value : @js.Any,
  transferables : @js.Any,
) -> @js.Any =
  #| (value, transferables) => require('comlink').transfer(value, transferables)

///|
extern "js" fn ffi_proxy(value : @js.Any) -> ProxyMarked =
  #| (value) => require('comlink').proxy(value)

///|
extern "js" fn ffi_window_endpoint(
  window : @js.Any,
  context : @js.Any,
  target_origin : String,
) -> Endpoint =
  #| (window, context, targetOrigin) => require('comlink').windowEndpoint(window, context, targetOrigin)

///|
extern "js" fn ffi_window_endpoint_default(window : @js.Any) -> Endpoint =
  #| (window) => require('comlink').windowEndpoint(window)

///|
extern "js" fn ffi_create_endpoint() -> @js.Any =
  #| () => require('comlink').createEndpoint

///|
extern "js" fn ffi_release_proxy() -> @js.Any =
  #| () => require('comlink').releaseProxy

///|
extern "js" fn ffi_proxy_marker() -> @js.Any =
  #| () => require('comlink').proxyMarker

///| TransferHandler FFI

///|
extern "js" fn ffi_get_transfer_handlers() -> @js.Any =
  #| () => require('comlink').transferHandlers

///| Core Functions

///|
/// Wrap an endpoint to create a proxy to the exposed object
/// Use this in the main thread to wrap a Worker
pub fn wrap(endpoint : @js.Any) -> Remote {
  ffi_wrap(endpoint)
}

///|
/// Wrap a Worker directly
pub fn wrapWorker(worker : @js.Any) -> Remote {
  ffi_wrap(worker)
}

///|
/// Expose an object to be called from another thread
/// Use this in the Worker to expose functions
pub fn expose(obj : @js.Any, endpoint? : @js.Any) -> Unit {
  match endpoint {
    Some(ep) => ffi_expose(obj, ep)
    None => ffi_expose_self(obj)
  }
}

///|
/// Mark a value to be transferred (not copied) to the other thread
/// Use for ArrayBuffer, MessagePort, etc.
pub fn transfer(value : @js.Any, transferables : Array[@js.Any]) -> @js.Any {
  ffi_transfer(value, @js.from_array(transferables))
}

///|
/// Mark a callback/function to be kept as a proxy
/// Useful for event callbacks that need to be called from the worker
pub fn proxy(value : @js.Any) -> ProxyMarked {
  ffi_proxy(value)
}

///|
/// Create an endpoint for communicating with an iframe/window
pub fn windowEndpoint(
  window : @js.Any,
  context? : @js.Any,
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
pub fn createEndpointSymbol() -> @js.Any {
  ffi_create_endpoint()
}

///|
/// Get the releaseProxy symbol
/// Used to release a proxy and its associated resources
pub fn releaseProxySymbol() -> @js.Any {
  ffi_release_proxy()
}

///|
/// Get the proxyMarker symbol
pub fn proxyMarkerSymbol() -> @js.Any {
  ffi_proxy_marker()
}

///|
/// Get the transfer handlers map
/// Use this to register custom transfer handlers
pub fn transferHandlers() -> @js.Any {
  ffi_get_transfer_handlers()
}

///| Remote Methods

///|
extern "js" fn ffi_remote_call(
  remote : Remote,
  name : String,
  args : @js.Any,
) -> @js.Promise[@js.Any] =
  #| (remote, name, args) => remote[name](...args)

///|
extern "js" fn ffi_remote_release(remote : Remote) -> Unit =
  #| (remote) => remote[require('comlink').releaseProxy]()

///|
extern "js" fn ffi_remote_create_endpoint(
  remote : Remote,
) -> @js.Promise[@js.Any] =
  #| (remote) => remote[require('comlink').createEndpoint]()

///|
/// Call a method on the remote object
/// Returns a Promise
pub fn Remote::callMethod(
  self : Remote,
  name : String,
  args : Array[@js.Any],
) -> @js.Promise[@js.Any] {
  ffi_remote_call(self, name, @js.from_array(args))
}

///|
/// Call remote with no arguments
pub fn Remote::call0(self : Remote, name : String) -> @js.Promise[@js.Any] {
  @js.identity(self.to_any().call0(name))
}

///|
/// Call remote with one argument
pub fn Remote::call1(
  self : Remote,
  name : String,
  arg : @js.Any,
) -> @js.Promise[@js.Any] {
  @js.identity(self.to_any().call1(name, arg))
}

///|
/// Call remote with two arguments
pub fn Remote::call2(
  self : Remote,
  name : String,
  arg1 : @js.Any,
  arg2 : @js.Any,
) -> @js.Promise[@js.Any] {
  @js.identity(self.to_any().call2(name, arg1, arg2))
}

///|
/// Get a property from the remote object
pub fn Remote::get(self : Remote, prop : String) -> @js.Promise[@js.Any] {
  @js.identity(self.to_any().get(prop))
}

///|
/// Release the proxy and free resources
pub fn Remote::release(self : Remote) -> Unit {
  ffi_remote_release(self)
}

///|
/// Create a new endpoint from the proxy
pub fn Remote::createEndpoint(self : Remote) -> @js.Promise[@js.Any] {
  ffi_remote_create_endpoint(self)
}

///| Helper functions for common patterns

///|
/// Wrap a function to be proxied (for callbacks)
pub fn proxyCallback(f : (@js.Any) -> Unit) -> ProxyMarked {
  ffi_proxy(@js.from_fn1(f))
}

///|
/// Wrap a function with return value to be proxied
pub fn proxyFunction(f : (@js.Any) -> @js.Any) -> ProxyMarked {
  ffi_proxy(@js.from_fn1(f))
}

///|
/// Transfer an ArrayBuffer
pub fn transferArrayBuffer(buffer : @js.Any) -> @js.Any {
  ffi_transfer(buffer, @js.from_array([buffer]))
}
