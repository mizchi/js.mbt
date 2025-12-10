///| npm happy-dom package FFI bindings
/// https://github.com/capricorn86/happy-dom
/// JavaScript implementation of a web browser without GUI

///|
/// Window class - main entry point for happy-dom
#external
pub type Window

///|
pub extern "js" fn Window::as_any(self : Window) -> @core.Any =
  #| (x) => x

///|
/// Get the document from the window
pub fn Window::document(self : Window) -> @dom.Document {
  self.as_any()["document"].cast()
}

///|
/// Get the happyDOM API object for controlling the window
pub fn Window::happy_dom(self : Window) -> HappyDOMAPI {
  self.as_any()["happyDOM"].cast()
}

///|
/// Get the location object
pub fn Window::location(self : Window) -> @core.Any {
  self.as_any()["location"]
}

///|
/// Get the navigator object
pub fn Window::navigator(self : Window) -> @core.Any {
  self.as_any()["navigator"]
}

///|
/// Get the localStorage
pub fn Window::local_storage(self : Window) -> @core.Any {
  self.as_any()["localStorage"]
}

///|
/// Get the sessionStorage
pub fn Window::session_storage(self : Window) -> @core.Any {
  self.as_any()["sessionStorage"]
}

///|
/// Get the console
pub fn Window::console(self : Window) -> @core.Any {
  self.as_any()["console"]
}

///|
/// HappyDOM API for controlling the window
#external
pub type HappyDOMAPI

///|
pub extern "js" fn HappyDOMAPI::as_any(self : HappyDOMAPI) -> @core.Any =
  #| (x) => x

///|
/// Close the window and clean up resources
pub async fn HappyDOMAPI::close(self : HappyDOMAPI) -> Unit {
  let promise : @core.Promise[Unit] = self.as_any()._call("close", []).cast()
  promise.wait()
}

///|
/// Abort all ongoing operations
pub fn HappyDOMAPI::abort(self : HappyDOMAPI) -> Unit {
  self.as_any()._call("abort", []) |> ignore
}

///|
/// Set the viewport size
pub fn HappyDOMAPI::set_viewport(
  self : HappyDOMAPI,
  width? : Int,
  height? : Int,
) -> Unit {
  let viewport = @core.new_object()
  match width {
    Some(w) => viewport["width"] = @core.any(w)
    None => ()
  }
  match height {
    Some(h) => viewport["height"] = @core.any(h)
    None => ()
  }
  self.as_any()._call("setViewport", [viewport]) |> ignore
}

///|
/// Wait for async tasks to complete
pub async fn HappyDOMAPI::wait_until_complete(self : HappyDOMAPI) -> Unit {
  let promise : @core.Promise[Unit] = self
    .as_any()
    ._call("waitUntilComplete", [])
    .cast()
  promise.wait()
}

///|
/// Wait for async tasks with a timeout
pub async fn HappyDOMAPI::wait_async(self : HappyDOMAPI) -> Unit {
  let promise : @core.Promise[Unit] = self
    .as_any()
    ._call("waitAsync", [])
    .cast()
  promise.wait()
}

///|
/// Window options for creating a new Window
pub(all) struct WindowOptions {
  url : String?
  width : Int?
  height : Int?
  console : @core.Any?
}

///|
pub fn WindowOptions::default() -> WindowOptions {
  { url: None, width: None, height: None, console: None }
}

///|
fn build_window_options(options : WindowOptions) -> @core.Any {
  let opts = @core.new_object()
  match options.url {
    Some(url) => opts["url"] = @core.any(url)
    None => ()
  }
  match options.width {
    Some(w) => opts["width"] = @core.any(w)
    None => ()
  }
  match options.height {
    Some(h) => opts["height"] = @core.any(h)
    None => ()
  }
  match options.console {
    Some(c) => opts["console"] = c
    None => ()
  }
  opts
}

///|
/// Import the Window class from happy-dom
/// Note: #module cannot be used for class constructors directly
extern "js" fn ffi_get_window_class() -> @core.Promise[@core.Any] =
  #| async () => {
  #|   const m = await import("happy-dom");
  #|   return m.Window;
  #| }

///|
let window_class_cache : Ref[@core.Any?] = { val: None }

///|
async fn get_window_class() -> @core.Any {
  match window_class_cache.val {
    Some(cls) => cls
    None => {
      let cls = ffi_get_window_class().wait()
      window_class_cache.val = Some(cls)
      cls
    }
  }
}

///|
/// Create a new Window instance with options
pub async fn create_window(
  options? : WindowOptions = WindowOptions::default(),
) -> Window {
  let window_cls = get_window_class()
  let opts = build_window_options(options)
  @core.new(window_cls, [opts]).cast()
}

///|
/// Create a new Window instance with default options
pub async fn create_window_default() -> Window {
  let window_cls = get_window_class()
  @core.new(window_cls, []).cast()
}

///| GlobalRegistrator - for registering happy-dom globally
/// Note: This requires @happy-dom/global-registrator package

///|
extern "js" fn ffi_get_global_registrator() -> @core.Promise[@core.Any] =
  #| async () => {
  #|   const m = await import("@happy-dom/global-registrator");
  #|   return m.GlobalRegistrator;
  #| }

///|
let global_registrator_cache : Ref[@core.Any?] = { val: None }

///|
async fn get_global_registrator() -> @core.Any {
  match global_registrator_cache.val {
    Some(reg) => reg
    None => {
      let reg = ffi_get_global_registrator().wait()
      global_registrator_cache.val = Some(reg)
      reg
    }
  }
}

///|
/// GlobalRegistrator options
pub(all) struct GlobalRegistratorOptions {
  url : String?
  width : Int?
  height : Int?
}

///|
pub fn GlobalRegistratorOptions::default() -> GlobalRegistratorOptions {
  { url: None, width: None, height: None }
}

///|
fn build_global_registrator_options(
  options : GlobalRegistratorOptions,
) -> @core.Any {
  let opts = @core.new_object()
  match options.url {
    Some(url) => opts["url"] = @core.any(url)
    None => ()
  }
  match options.width {
    Some(w) => opts["width"] = @core.any(w)
    None => ()
  }
  match options.height {
    Some(h) => opts["height"] = @core.any(h)
    None => ()
  }
  opts
}

///|
/// Register happy-dom globally (makes document, window, etc. available globally)
pub async fn register_global(
  options? : GlobalRegistratorOptions = GlobalRegistratorOptions::default(),
) -> Unit {
  let registrator = get_global_registrator()
  let opts = build_global_registrator_options(options)
  registrator._call("register", [opts]) |> ignore
}

///|
/// Unregister happy-dom from global scope
pub async fn unregister_global() -> Unit {
  let registrator = get_global_registrator()
  let promise : @core.Promise[Unit] = registrator._call("unregister", []).cast()
  promise.wait()
}
