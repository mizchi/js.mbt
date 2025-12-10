///| npm jsdom package FFI bindings
/// https://github.com/jsdom/jsdom
/// JavaScript implementation of web standards for Node.js
///
/// This module returns @dom.Window which provides all standard DOM APIs.
/// Use window.document() to access the Document.

///|
/// JSDOM instance type
#external
pub type JSDOM

///|
pub extern "js" fn JSDOM::as_any(self : JSDOM) -> @core.Any =
  #| (x) => x

///|
/// Get the window from JSDOM instance
pub fn JSDOM::window(self : JSDOM) -> @dom.Window {
  self.as_any()["window"].cast()
}

///|
/// Serialize the document to HTML string
pub fn JSDOM::serialize(self : JSDOM) -> String {
  self.as_any()._call("serialize", []).cast()
}

///|
/// Get the virtual console (if configured)
pub fn JSDOM::virtual_console(self : JSDOM) -> @core.Any {
  self.as_any()["virtualConsole"]
}

///|
/// JSDOM options for creating a new instance
pub(all) struct JSDOMOptions {
  url : String?
  referrer : String?
  content_type : String?
  run_scripts : String? // "dangerously" | "outside-only" | undefined
  resources : String? // "usable" | undefined
  pretend_to_be_visual : Bool?
}

///|
pub fn JSDOMOptions::default() -> JSDOMOptions {
  {
    url: None,
    referrer: None,
    content_type: None,
    run_scripts: None,
    resources: None,
    pretend_to_be_visual: None,
  }
}

///|
fn build_jsdom_options(options : JSDOMOptions) -> @core.Any {
  let opts = @core.new_object()
  match options.url {
    Some(url) => opts["url"] = @core.any(url)
    None => ()
  }
  match options.referrer {
    Some(r) => opts["referrer"] = @core.any(r)
    None => ()
  }
  match options.content_type {
    Some(ct) => opts["contentType"] = @core.any(ct)
    None => ()
  }
  match options.run_scripts {
    Some(rs) => opts["runScripts"] = @core.any(rs)
    None => ()
  }
  match options.resources {
    Some(r) => opts["resources"] = @core.any(r)
    None => ()
  }
  match options.pretend_to_be_visual {
    Some(v) => opts["pretendToBeVisual"] = @core.any(v)
    None => ()
  }
  opts
}

///|
/// Import the JSDOM class
extern "js" fn ffi_get_jsdom_class() -> @core.Promise[@core.Any] =
  #| async () => {
  #|   const m = await import("jsdom");
  #|   return m.JSDOM;
  #| }

///|
let jsdom_class_cache : Ref[@core.Any?] = { val: None }

///|
async fn get_jsdom_class() -> @core.Any {
  match jsdom_class_cache.val {
    Some(cls) => cls
    None => {
      let cls = ffi_get_jsdom_class().wait()
      jsdom_class_cache.val = Some(cls)
      cls
    }
  }
}

///|
/// Create a new JSDOM instance from HTML string
pub async fn create_jsdom(
  html? : String = "",
  options? : JSDOMOptions = JSDOMOptions::default(),
) -> JSDOM {
  let jsdom_cls = get_jsdom_class()
  let opts = build_jsdom_options(options)
  @core.new(jsdom_cls, [@core.any(html), opts]).cast()
}

///|
/// Create a new Window from JSDOM
/// Convenience function that returns @dom.Window directly
pub async fn create_window(
  html? : String = "",
  options? : JSDOMOptions = JSDOMOptions::default(),
) -> @dom.Window {
  let jsdom = create_jsdom(html~, options~)
  jsdom.window()
}

///|
/// Create JSDOM from URL (async)
pub async fn from_url(
  url : String,
  options? : JSDOMOptions = JSDOMOptions::default(),
) -> JSDOM {
  let jsdom_cls = get_jsdom_class()
  let opts = build_jsdom_options(options)
  let promise : @core.Promise[JSDOM] = jsdom_cls
    ._call("fromURL", [@core.any(url), opts])
    .cast()
  promise.wait()
}

///|
/// Create JSDOM from file path (async)
pub async fn from_file(
  path : String,
  options? : JSDOMOptions = JSDOMOptions::default(),
) -> JSDOM {
  let jsdom_cls = get_jsdom_class()
  let opts = build_jsdom_options(options)
  let promise : @core.Promise[JSDOM] = jsdom_cls
    ._call("fromFile", [@core.any(path), opts])
    .cast()
  promise.wait()
}

///|
/// Fragment mode - creates a DocumentFragment
pub async fn fragment(html : String) -> @dom.DocumentFragment {
  let jsdom_cls = get_jsdom_class()
  jsdom_cls._call("fragment", [@core.any(html)]).cast()
}
