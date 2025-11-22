///|
/// Node.js Inspector module
/// Provides programmatic access to the V8 Inspector for debugging
using @js {type Js, trait JsImpl, js}

///|
/// Session class for V8 Inspector communication
pub type Session

///|
pub impl @js.JsImpl for Session

///|
pub impl @event.EventTargetImpl for Session

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
  self.call("connect", []) |> ignore
}

///|
pub fn Session::connect_to_main_thread(self : Session) -> Unit {
  self.call("connectToMainThread", []) |> ignore
}

///|
pub fn Session::disconnect(self : Session) -> Unit {
  self.call("disconnect", []) |> ignore
}

///|
pub fn Session::post(
  self : Session,
  method_ : String,
  params : @js.Object?,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : Js = @js.unsafe_cast(callback)
  match params {
    Some(p) => self.call("post", [method_, p.to_js(), cb]) |> ignore
    None => self.call("post", [method_, cb]) |> ignore
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
  let result : Js = ffi_url()
  let is_undef : Bool = @js.unsafe_cast(@js.typeof_(result) == "undefined")
  if is_undef {
    None
  } else {
    Some(@js.unsafe_cast(result))
  }
}

///|
extern "js" fn ffi_url() -> Js =
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
pub impl @js.JsImpl for Console

///|
pub fn console() -> Console {
  ffi_console()
}

///|
extern "js" fn ffi_console() -> Console =
  #| () => require('node:inspector').console
