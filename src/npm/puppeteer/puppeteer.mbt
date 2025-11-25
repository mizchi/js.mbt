///|
/// Puppeteer bindings for Node.js
/// https://pptr.dev/

///|
/// Browser instance
#external
pub type Browser

///|
pub impl @js.JsImpl for Browser

///|
/// FFI: Launch browser with options
extern "js" fn ffi_launch(options : @js.Any) -> @js.Any =
  #| (options) => {
  #|   const puppeteer = require('puppeteer');
  #|   return puppeteer.launch(options);
  #| }

///|
/// Launch browser with labeled arguments
/// See: https://pptr.dev/api/puppeteer.launchoptions
/// Example:
/// ```moonbit no-check
/// let browser = launch(headless=true, args=["--no-sandbox"])
/// ```
pub async fn launch(
  headless? : Bool,
  args? : Array[String],
  executablePath? : String,
  devtools? : Bool,
  timeout? : Int,
  userDataDir? : String,
  dumpio? : Bool,
  env? : @js.Any,
  pipe? : Bool,
  ignoreDefaultArgs? : Bool,
  waitForInitialPage? : Bool,
  debuggingPort? : Int,
  handleSIGHUP? : Bool,
  handleSIGINT? : Bool,
  handleSIGTERM? : Bool,
) -> Browser {
  let js_opts = @js.Object::new()
  match headless {
    Some(h) => js_opts.set("headless", @js.any(h))
    None => ()
  }
  match args {
    Some(a) => js_opts.set("args", @js.from_array(a))
    None => ()
  }
  match executablePath {
    Some(p) => js_opts.set("executablePath", @js.any(p))
    None => ()
  }
  match devtools {
    Some(d) => js_opts.set("devtools", @js.any(d))
    None => ()
  }
  match timeout {
    Some(t) => js_opts.set("timeout", @js.any(t))
    None => ()
  }
  match userDataDir {
    Some(u) => js_opts.set("userDataDir", @js.any(u))
    None => ()
  }
  match dumpio {
    Some(d) => js_opts.set("dumpio", @js.any(d))
    None => ()
  }
  match env {
    Some(e) => js_opts.set("env", e)
    None => ()
  }
  match pipe {
    Some(p) => js_opts.set("pipe", @js.any(p))
    None => ()
  }
  match ignoreDefaultArgs {
    Some(i) => js_opts.set("ignoreDefaultArgs", @js.any(i))
    None => ()
  }
  match waitForInitialPage {
    Some(w) => js_opts.set("waitForInitialPage", @js.any(w))
    None => ()
  }
  match debuggingPort {
    Some(d) => js_opts.set("debuggingPort", @js.any(d))
    None => ()
  }
  match handleSIGHUP {
    Some(h) => js_opts.set("handleSIGHUP", @js.any(h))
    None => ()
  }
  match handleSIGINT {
    Some(h) => js_opts.set("handleSIGINT", @js.any(h))
    None => ()
  }
  match handleSIGTERM {
    Some(h) => js_opts.set("handleSIGTERM", @js.any(h))
    None => ()
  }
  let promise : @js.Promise[Browser] = @js.identity(
    ffi_launch(js_opts.to_any()),
  )
  promise.wait()
}

///| Browser methods

///|
/// Browser: Create new page
pub async fn Browser::newPage(self : Browser) -> Page {
  let promise : @js.Promise[Page] = @js.identity(self.call("newPage", []))
  promise.wait()
}

///|
/// Browser: Close browser
pub async fn Browser::close(self : Browser) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("close", []))
  promise.wait()
}

///|
/// Browser: Get all pages
pub async fn Browser::pages(self : Browser) -> Array[Page] {
  let promise : @js.Promise[Array[Page]] = @js.identity(self.call("pages", []))
  promise.wait()
}

///|
/// Browser: Get version
pub async fn Browser::version(self : Browser) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("version", []))
  promise.wait()
}

///|
/// Browser: Get user agent
pub async fn Browser::userAgent(self : Browser) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("userAgent", []))
  promise.wait()
}
