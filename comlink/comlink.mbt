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
pub fn Endpoint::as_any(self : Endpoint) -> @core.Any = "%identity"

///|
/// Remote - a proxy to a remote object
#external
pub type Remote

///|
pub fn Remote::as_any(self : Remote) -> @core.Any = "%identity"

///|
/// ProxyMarked - marks a value to be proxied
#external
pub type ProxyMarked

///|
pub fn ProxyMarked::as_any(self : ProxyMarked) -> @core.Any = "%identity"

///|
/// TransferHandler - custom transfer handler for complex types
#external
pub type TransferHandler

///|
pub fn TransferHandler::as_any(self : TransferHandler) -> @core.Any = "%identity"

///| Core FFI

///|
/// Wrap an endpoint to create a proxy to the exposed object
/// Use this in the main thread to wrap a Worker
#module("comlink")
pub extern "js" fn wrap(endpoint : @core.Any) -> Remote = "wrap"

///|
#module("comlink")
extern "js" fn ffi_expose(obj : @core.Any, endpoint : @core.Any) -> Unit =
  #|(...args) => Comlink.expose(...args)

///|
#module("comlink")
extern "js" fn ffi_expose_self(obj : @core.Any) -> Unit =
  #|(obj) => Comlink.expose(obj)

///|
#module("comlink")
extern "js" fn ffi_transfer(
  value : @core.Any,
  transferables : @core.Any,
) -> @core.Any = "transfer"

///|
/// Mark a callback/function to be kept as a proxy
/// Useful for event callbacks that need to be called from the worker
#module("comlink")
pub extern "js" fn proxy(value : @core.Any) -> ProxyMarked = "proxy"

///|
#module("comlink")
extern "js" fn ffi_window_endpoint(
  window : @core.Any,
  context : @core.Any,
  target_origin : String,
) -> Endpoint = "windowEndpoint"

///|
#module("comlink")
extern "js" fn ffi_window_endpoint_default(window : @core.Any) -> Endpoint =
  #|(w) => Comlink.windowEndpoint(w)

///|
/// Note: createEndpoint is a Symbol, not a function
extern "js" fn ffi_create_endpoint() -> @core.Any =
  #| () => require('comlink').createEndpoint

///|
/// Note: releaseProxy is a Symbol, not a function
extern "js" fn ffi_release_proxy() -> @core.Any =
  #| () => require('comlink').releaseProxy

///|
/// Note: proxyMarker is a Symbol, not a function
extern "js" fn ffi_proxy_marker() -> @core.Any =
  #| () => require('comlink').proxyMarker

///| TransferHandler FFI

///|
/// Note: transferHandlers is a Map, not a function
extern "js" fn ffi_get_transfer_handlers() -> @core.Any =
  #| () => require('comlink').transferHandlers

///| Core Functions

///|
/// Wrap a Worker directly
pub fn wrapWorker(worker : @worker.Worker) -> Remote {
  wrap(worker.as_any().cast())
}

///|
/// Wrap a MessagePort
pub fn wrapMessagePort(port : @message.MessagePort) -> Remote {
  wrap(port.as_any().cast())
}

///|
/// Expose an object to be called from another thread
/// Use this in the Worker to expose functions
pub fn expose(obj : @core.Any, endpoint? : @core.Any) -> Unit {
  match endpoint {
    Some(ep) => ffi_expose(obj, ep)
    None => ffi_expose_self(obj)
  }
}

///|
/// Expose an object to a Worker
pub fn exposeToWorker(obj : @core.Any, worker : @worker.Worker) -> Unit {
  ffi_expose(obj, worker.as_any().cast())
}

///|
/// Expose an object to a MessagePort
pub fn exposeToMessagePort(
  obj : @core.Any,
  port : @message.MessagePort,
) -> Unit {
  ffi_expose(obj, port.as_any().cast())
}

///|
/// Mark a value to be transferred (not copied) to the other thread
/// Use for ArrayBuffer, MessagePort, etc.
pub fn transfer(
  value : @core.Any,
  transferables : Array[@core.Any],
) -> @core.Any {
  ffi_transfer(value, @core.any(transferables))
}

///|
/// Create an endpoint for communicating with an iframe/window
pub fn windowEndpoint(
  window : @core.Any,
  context? : @core.Any,
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
pub fn createEndpointSymbol() -> @core.Any {
  ffi_create_endpoint()
}

///|
/// Get the releaseProxy symbol
/// Used to release a proxy and its associated resources
pub fn releaseProxySymbol() -> @core.Any {
  ffi_release_proxy()
}

///|
/// Get the proxyMarker symbol
pub fn proxyMarkerSymbol() -> @core.Any {
  ffi_proxy_marker()
}

///|
/// Get the transfer handlers map
/// Use this to register custom transfer handlers
pub fn transferHandlers() -> @core.Any {
  ffi_get_transfer_handlers()
}

///| Remote Methods

///|
extern "js" fn ffi_remote_call(
  remote : Remote,
  name : String,
  args : @core.Any,
) -> @js.Promise[@core.Any] =
  #| (remote, name, args) => remote[name](...args)

///|
extern "js" fn ffi_remote_release(remote : Remote) -> Unit =
  #| (remote) => { const { releaseProxy } = require('comlink'); remote[releaseProxy](); }

///|
extern "js" fn ffi_remote_create_endpoint(
  remote : Remote,
) -> @js.Promise[@message.MessagePort] =
  #| (remote) => { const { createEndpoint } = require('comlink'); return remote[createEndpoint](); }

///|
/// Call a method on the remote object
/// Returns a Promise
pub fn Remote::callMethod(
  self : Remote,
  name : String,
  args : Array[@core.Any],
) -> @js.Promise[@core.Any] {
  ffi_remote_call(self, name, @core.any(args))
}

///|
/// Call remote with no arguments
pub fn Remote::call0(self : Remote, name : String) -> @js.Promise[@core.Any] {
  self.as_any()._call(name, []).cast()
}

///|
/// Call remote with one argument
pub fn Remote::call1(
  self : Remote,
  name : String,
  arg : @core.Any,
) -> @js.Promise[@core.Any] {
  self.as_any()._call(name, [@core.any(arg)]).cast()
}

///|
/// Call remote with two arguments
pub fn Remote::call2(
  self : Remote,
  name : String,
  arg1 : @core.Any,
  arg2 : @core.Any,
) -> @js.Promise[@core.Any] {
  self.as_any()._call(name, [@core.any(arg1), @core.any(arg2)]).cast()
}

///|
/// Get a property from the remote object
pub fn Remote::get(self : Remote, prop : String) -> @js.Promise[@core.Any] {
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
pub fn proxyCallback(f : (@core.Any) -> Unit) -> ProxyMarked {
  proxy(@js.from_fn1(f))
}

///|
/// Wrap a function with return value to be proxied
pub fn proxyFunction(f : (@core.Any) -> @core.Any) -> ProxyMarked {
  proxy(@js.from_fn1(f))
}

///|
/// Transfer an ArrayBuffer
pub fn transferArrayBuffer(buffer : @core.Any) -> @core.Any {
  ffi_transfer(buffer, @core.any([buffer]))
}
