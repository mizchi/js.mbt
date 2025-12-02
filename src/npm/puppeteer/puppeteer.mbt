///|
/// Puppeteer bindings for Node.js
/// https://pptr.dev/

///|
/// Browser instance
#external
pub type Browser

///|
pub fn Browser::to_any(self : Browser) -> @nostd.Any = "%identity"

///|
/// FFI: Launch browser with options
extern "js" fn ffi_launch(options : @nostd.Any) -> @nostd.Any =
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
  env? : @nostd.Any,
  pipe? : Bool,
  ignoreDefaultArgs? : Bool,
  waitForInitialPage? : Bool,
  debuggingPort? : Int,
  handleSIGHUP? : Bool,
  handleSIGINT? : Bool,
  handleSIGTERM? : Bool,
) -> Browser {
  let options = @nostd.Object::new()
  if headless is Some(v) {
    options["headless"] = @nostd.any(v)
  }
  if args is Some(v) {
    options["args"] = @nostd.any(@js.from_array(v))
  }
  if executablePath is Some(v) {
    options["executablePath"] = @nostd.any(v)
  }
  if devtools is Some(v) {
    options["devtools"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if userDataDir is Some(v) {
    options["userDataDir"] = @nostd.any(v)
  }
  if dumpio is Some(v) {
    options["dumpio"] = @nostd.any(v)
  }
  if env is Some(v) {
    options["env"] = @nostd.any(v)
  }
  if pipe is Some(v) {
    options["pipe"] = @nostd.any(v)
  }
  if ignoreDefaultArgs is Some(v) {
    options["ignoreDefaultArgs"] = @nostd.any(v)
  }
  if waitForInitialPage is Some(v) {
    options["waitForInitialPage"] = @nostd.any(v)
  }
  if debuggingPort is Some(v) {
    options["debuggingPort"] = @nostd.any(v)
  }
  if handleSIGHUP is Some(v) {
    options["handleSIGHUP"] = @nostd.any(v)
  }
  if handleSIGINT is Some(v) {
    options["handleSIGINT"] = @nostd.any(v)
  }
  if handleSIGTERM is Some(v) {
    options["handleSIGTERM"] = @nostd.any(v)
  }
  let promise : @js.Promise[Browser] = ffi_launch(options) |> @nostd.identity
  promise.wait()
}

///| Browser methods

///|
/// Browser: Create new page
pub async fn Browser::newPage(self : Browser) -> Page {
  let promise : @js.Promise[Page] = self.to_any()._call("newPage", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Browser: Close browser
pub async fn Browser::close(self : Browser) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Browser: Get all pages
pub async fn Browser::pages(self : Browser) -> Array[Page] {
  let promise : @js.Promise[Array[Page]] = self.to_any()._call("pages", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Browser: Get version
pub async fn Browser::version(self : Browser) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("version", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Browser: Get user agent
pub async fn Browser::userAgent(self : Browser) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("userAgent", [])
    |> @nostd.identity
  promise.wait()
}
