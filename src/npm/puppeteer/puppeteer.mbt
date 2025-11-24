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
extern "js" fn ffi_launch(options : @js.Js) -> @js.Js =
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
  env? : @js.Js,
  pipe? : Bool,
  ignoreDefaultArgs? : Bool,
  waitForInitialPage? : Bool,
  debuggingPort? : Int,
  handleSIGHUP? : Bool,
  handleSIGINT? : Bool,
  handleSIGTERM? : Bool,
) -> Browser {
  let js_opts = @js.from_entries([])
  match headless {
    Some(h) => js_opts.set("headless", @js.js(h))
    None => ()
  }
  match args {
    Some(a) => js_opts.set("args", @js.from_array(a))
    None => ()
  }
  match executablePath {
    Some(p) => js_opts.set("executablePath", @js.js(p))
    None => ()
  }
  match devtools {
    Some(d) => js_opts.set("devtools", @js.js(d))
    None => ()
  }
  match timeout {
    Some(t) => js_opts.set("timeout", @js.js(t))
    None => ()
  }
  match userDataDir {
    Some(u) => js_opts.set("userDataDir", @js.js(u))
    None => ()
  }
  match dumpio {
    Some(d) => js_opts.set("dumpio", @js.js(d))
    None => ()
  }
  match env {
    Some(e) => js_opts.set("env", e)
    None => ()
  }
  match pipe {
    Some(p) => js_opts.set("pipe", @js.js(p))
    None => ()
  }
  match ignoreDefaultArgs {
    Some(i) => js_opts.set("ignoreDefaultArgs", @js.js(i))
    None => ()
  }
  match waitForInitialPage {
    Some(w) => js_opts.set("waitForInitialPage", @js.js(w))
    None => ()
  }
  match debuggingPort {
    Some(d) => js_opts.set("debuggingPort", @js.js(d))
    None => ()
  }
  match handleSIGHUP {
    Some(h) => js_opts.set("handleSIGHUP", @js.js(h))
    None => ()
  }
  match handleSIGINT {
    Some(h) => js_opts.set("handleSIGINT", @js.js(h))
    None => ()
  }
  match handleSIGTERM {
    Some(h) => js_opts.set("handleSIGTERM", @js.js(h))
    None => ()
  }
  let promise : @js.Promise[Browser] = @js.unsafe_cast(ffi_launch(js_opts))
  promise.wait()
}

///| Browser methods

///|
/// Browser: Create new page
pub async fn Browser::new_page(self : Browser) -> Page {
  let promise : @js.Promise[Page] = @js.unsafe_cast(self.call("newPage", []))
  promise.wait()
}

///|
/// Browser: Close browser
pub async fn Browser::close(self : Browser) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("close", []))
  promise.wait()
}

///|
/// Browser: Get all pages
pub async fn Browser::pages(self : Browser) -> Array[Page] {
  let promise : @js.Promise[Array[Page]] = @js.unsafe_cast(
    self.call("pages", []),
  )
  promise.wait()
}

///|
/// Browser: Get version
pub async fn Browser::version(self : Browser) -> String {
  let promise : @js.Promise[String] = @js.unsafe_cast(self.call("version", []))
  promise.wait()
}

///|
/// Browser: Get user agent
pub async fn Browser::userAgent(self : Browser) -> String {
  let promise : @js.Promise[String] = @js.unsafe_cast(
    self.call("userAgent", []),
  )
  promise.wait()
}
