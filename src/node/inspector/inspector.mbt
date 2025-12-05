///|
/// Node.js Inspector module
/// Provides programmatic access to the V8 Inspector for debugging

///|
/// Session class for V8 Inspector communication
pub type Session

///|
pub fn Session::as_any(self : Session) -> @core.Any = "%identity"

///|
pub fn Session::to_any(self : Session) -> @core.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn Session::as_event_target(self : Session) -> @event.EventTarget = "%identity"

///|
/// Creates a new Inspector Session
pub extern "js" fn Session::new() -> Session =
  #| () => {
  #|   const inspector = require('node:inspector');
  #|   return new inspector.Session();
  #| }

///|
/// Session methods
pub fn Session::connect(self : Session) -> Unit {
  self.to_any()._call("connect", []) |> ignore
}

///|
pub fn Session::connect_to_main_thread(self : Session) -> Unit {
  self.to_any()._call("connectToMainThread", []) |> ignore
}

///|
pub fn Session::disconnect(self : Session) -> Unit {
  self.to_any()._call("disconnect", []) |> ignore
}

///|
pub fn Session::post(
  self : Session,
  method_ : String,
  params : @js.Object?,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @core.Any = callback |> @core.any
  match params {
    Some(p) =>
      self.to_any()._call("post", [@core.any(method_), @core.any(p), cb])
      |> ignore
    None => self.to_any()._call("post", [@core.any(method_), cb]) |> ignore
  }
}

///|
/// Module-level functions
pub fn open(port : Int?, host : String?, wait : Bool?) -> @js.Object {
  match (port, host, wait) {
    (Some(p), Some(h), Some(w)) => ffi_open_3(p, h, w)
    (Some(p), Some(h), None) => ffi_open_2(p, h)
    (Some(p), None, None) => ffi_open_1(p)
    _ => ffi_open_0()
  }
}

///|
extern "js" fn ffi_open_0() -> @js.Object =
  #| () => require('node:inspector').open()

///|
extern "js" fn ffi_open_1(port : Int) -> @js.Object =
  #| (port) => require('node:inspector').open(port)

///|
extern "js" fn ffi_open_2(port : Int, host : String) -> @js.Object =
  #| (port, host) => require('node:inspector').open(port, host)

///|
extern "js" fn ffi_open_3(port : Int, host : String, wait : Bool) -> @js.Object =
  #| (port, host, wait) => require('node:inspector').open(port, host, wait)

///|
pub extern "js" fn close() -> Unit =
  #| () => require('node:inspector').close()

///|
pub fn url() -> String? {
  let result : @core.Any = ffi_url()
  let is_undef : Bool = @core.identity(@core.typeof_(result) == "undefined")
  if is_undef {
    None
  } else {
    Some(@core.identity(result))
  }
}

///|
extern "js" fn ffi_url() -> @core.Any =
  #| () => require('node:inspector').url()

///|
pub extern "js" fn wait_for_debugger() -> Unit =
  #| () => require('node:inspector').waitForDebugger()

///|
/// Console object for inspector
pub type Console

///|
pub fn Console::as_any(self : Console) -> @core.Any = "%identity"

///|
pub fn Console::to_any(self : Console) -> @core.Any = "%identity"

///|
pub extern "js" fn console() -> Console =
  #| () => require('node:inspector').console
