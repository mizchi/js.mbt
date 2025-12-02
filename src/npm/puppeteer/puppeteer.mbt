///|
/// Puppeteer bindings for Node.js
/// https://pptr.dev/

///|
/// Browser instance
#external
pub type Browser

///|
pub fn Browser::to_any(self : Browser) -> @core.Any = "%identity"

///|
/// FFI: Launch browser with options
extern "js" fn ffi_launch(options : @core.Any) -> @core.Any =
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
  env? : @core.Any,
  pipe? : Bool,
  ignoreDefaultArgs? : Bool,
  waitForInitialPage? : Bool,
  debuggingPort? : Int,
  handleSIGHUP? : Bool,
  handleSIGINT? : Bool,
  handleSIGTERM? : Bool,
) -> Browser {
  let options = @core.new_object()
  if headless is Some(v) {
    options["headless"] = @core.any(v)
  }
  if args is Some(v) {
    options["args"] = @core.any(@core.any(v))
  }
  if executablePath is Some(v) {
    options["executablePath"] = @core.any(v)
  }
  if devtools is Some(v) {
    options["devtools"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if userDataDir is Some(v) {
    options["userDataDir"] = @core.any(v)
  }
  if dumpio is Some(v) {
    options["dumpio"] = @core.any(v)
  }
  if env is Some(v) {
    options["env"] = @core.any(v)
  }
  if pipe is Some(v) {
    options["pipe"] = @core.any(v)
  }
  if ignoreDefaultArgs is Some(v) {
    options["ignoreDefaultArgs"] = @core.any(v)
  }
  if waitForInitialPage is Some(v) {
    options["waitForInitialPage"] = @core.any(v)
  }
  if debuggingPort is Some(v) {
    options["debuggingPort"] = @core.any(v)
  }
  if handleSIGHUP is Some(v) {
    options["handleSIGHUP"] = @core.any(v)
  }
  if handleSIGINT is Some(v) {
    options["handleSIGINT"] = @core.any(v)
  }
  if handleSIGTERM is Some(v) {
    options["handleSIGTERM"] = @core.any(v)
  }
  let promise : @js.Promise[Browser] = ffi_launch(options) |> @core.identity
  promise.wait()
}

///| Browser methods

///|
/// Browser: Create new page
pub async fn Browser::newPage(self : Browser) -> Page {
  let promise : @js.Promise[Page] = self.to_any()._call("newPage", [])
    |> @core.identity
  promise.wait()
}

///|
/// Browser: Close browser
pub async fn Browser::close(self : Browser) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [])
    |> @core.identity
  promise.wait()
}

///|
/// Browser: Get all pages
pub async fn Browser::pages(self : Browser) -> Array[Page] {
  let promise : @js.Promise[Array[Page]] = self.to_any()._call("pages", [])
    |> @core.identity
  promise.wait()
}

///|
/// Browser: Get version
pub async fn Browser::version(self : Browser) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("version", [])
    |> @core.identity
  promise.wait()
}

///|
/// Browser: Get user agent
pub async fn Browser::userAgent(self : Browser) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("userAgent", [])
    |> @core.identity
  promise.wait()
}
