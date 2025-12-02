///|
/// Node.js Inspector module
/// Provides programmatic access to the V8 Inspector for debugging

///|
/// Session class for V8 Inspector communication
pub type Session

///|
pub fn Session::as_any(self : Session) -> @nostd.Any = "%identity"

///|
pub fn Session::to_any(self : Session) -> @nostd.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn Session::as_event_target(self : Session) -> @event.EventTarget = "%identity"

///|
pub impl @event.EventTargetImpl for Session with as_any(self) -> @nostd.Any {
  self.to_any()
}

///|
/// Creates a new Inspector Session
extern "js" fn ffi_create_session() -> Session =
  #| () => {
  #|   const inspector = require('node:inspector');
  #|   return new inspector.Session();
  #| }

///|
pub fn Session::new() -> Session {
  ffi_create_session()
}

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
  let cb : @nostd.Any = callback |> @nostd.any
  match params {
    Some(p) =>
      self.to_any()._call("post", [@nostd.any(method_), @nostd.any(p), cb])
      |> ignore
    None => self.to_any()._call("post", [@nostd.any(method_), cb]) |> ignore
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
pub fn close() -> Unit {
  ffi_close()
}

///|
extern "js" fn ffi_close() -> Unit =
  #| () => require('node:inspector').close()

///|
pub fn url() -> String? {
  let result : @nostd.Any = ffi_url()
  let is_undef : Bool = @nostd.identity(@js.typeof_(result) == "undefined")
  if is_undef {
    None
  } else {
    Some(@nostd.identity(result))
  }
}

///|
extern "js" fn ffi_url() -> @nostd.Any =
  #| () => require('node:inspector').url()

///|
pub fn wait_for_debugger() -> Unit {
  ffi_wait_for_debugger()
}

///|
extern "js" fn ffi_wait_for_debugger() -> Unit =
  #| () => require('node:inspector').waitForDebugger()

///|
/// Console object for inspector
pub type Console

///|
pub fn Console::as_any(self : Console) -> @nostd.Any = "%identity"

///|
pub fn Console::to_any(self : Console) -> @nostd.Any = "%identity"

///|
pub fn console() -> Console {
  ffi_console()
}

///|
extern "js" fn ffi_console() -> Console =
  #| () => require('node:inspector').console
