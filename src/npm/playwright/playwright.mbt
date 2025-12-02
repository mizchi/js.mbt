///|
/// Playwright bindings for MoonBit
/// https://playwright.dev/
///
/// Playwright is a framework for Web Testing and Automation.
/// It supports Chromium, Firefox, and WebKit.

///| Browser Types

///|
/// BrowserType - chromium, firefox, or webkit
#external
pub type BrowserType

///|
pub fn BrowserType::to_any(self : BrowserType) -> @nostd.Any = "%identity"

///|
/// Browser instance
#external
pub type Browser

///|
pub fn Browser::to_any(self : Browser) -> @nostd.Any = "%identity"

///|
/// BrowserContext - isolated browser session
#external
pub type BrowserContext

///|
pub fn BrowserContext::to_any(self : BrowserContext) -> @nostd.Any = "%identity"

///| FFI Functions

///|
extern "js" fn ffi_chromium() -> BrowserType =
  #| () => {
  #|   const { chromium } = require('playwright');
  #|   return chromium;
  #| }

///|
extern "js" fn ffi_firefox() -> BrowserType =
  #| () => {
  #|   const { firefox } = require('playwright');
  #|   return firefox;
  #| }

///|
extern "js" fn ffi_webkit() -> BrowserType =
  #| () => {
  #|   const { webkit } = require('playwright');
  #|   return webkit;
  #| }

///| Browser Type Getters

///|
/// Get Chromium browser type
pub fn chromium() -> BrowserType {
  ffi_chromium()
}

///|
/// Get Firefox browser type
pub fn firefox() -> BrowserType {
  ffi_firefox()
}

///|
/// Get WebKit browser type
pub fn webkit() -> BrowserType {
  ffi_webkit()
}

///| BrowserType Methods

///|
/// Launch browser with options
/// See: https://playwright.dev/docs/api/class-browsertype#browser-type-launch
pub async fn BrowserType::launch(
  self : BrowserType,
  headless? : Bool,
  args? : Array[String],
  channel? : String,
  chromiumSandbox? : Bool,
  devtools? : Bool,
  downloadsPath? : String,
  executablePath? : String,
  handleSIGHUP? : Bool,
  handleSIGINT? : Bool,
  handleSIGTERM? : Bool,
  slowMo? : Int,
  timeout? : Int,
) -> Browser {
  let options = @nostd.Object::new()
  if headless is Some(v) {
    options["headless"] = @nostd.any(v)
  }
  if args is Some(v) {
    options["args"] = @nostd.any(@js.from_array(v))
  }
  if channel is Some(v) {
    options["channel"] = @nostd.any(v)
  }
  if chromiumSandbox is Some(v) {
    options["chromiumSandbox"] = @nostd.any(v)
  }
  if devtools is Some(v) {
    options["devtools"] = @nostd.any(v)
  }
  if downloadsPath is Some(v) {
    options["downloadsPath"] = @nostd.any(v)
  }
  if executablePath is Some(v) {
    options["executablePath"] = @nostd.any(v)
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
  if slowMo is Some(v) {
    options["slowMo"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Browser] = self
    .to_any()
    ._call("launch", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Launch persistent context (saves user data)
pub async fn BrowserType::launchPersistentContext(
  self : BrowserType,
  userDataDir : String,
  headless? : Bool,
  args? : Array[String],
  channel? : String,
  slowMo? : Int,
  timeout? : Int,
) -> BrowserContext {
  let options = @nostd.Object::new()
  if headless is Some(v) {
    options["headless"] = @nostd.any(v)
  }
  if args is Some(v) {
    options["args"] = @nostd.any(@js.from_array(v))
  }
  if channel is Some(v) {
    options["channel"] = @nostd.any(v)
  }
  if slowMo is Some(v) {
    options["slowMo"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[BrowserContext] = self
    .to_any()
    ._call("launchPersistentContext", [@nostd.any(userDataDir), options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get browser type name
pub fn BrowserType::name(self : BrowserType) -> String {
  self.to_any()._call("name", []).cast()
}

///| Browser Methods

///|
/// Close browser (async)
pub async fn Browser::close(self : Browser) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Close browser with error callback (for use with defer)
/// Note: This initiates close but doesn't wait for completion
pub fn Browser::close_with_error_callback(
  self : Browser,
  on_error : (Error) -> Unit,
) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [])
    |> @nostd.identity
  let _ = promise.catch_(fn(e) {
    on_error(e)
    @js.Promise::resolve(())
  })

}

///|
/// Create new browser context
pub async fn Browser::newContext(
  self : Browser,
  viewport? : (Int, Int),
  userAgent? : String,
  locale? : String,
  timezoneId? : String,
  geolocation? : (Double, Double),
  permissions? : Array[String],
  colorScheme? : String,
  reducedMotion? : String,
  forcedColors? : String,
  acceptDownloads? : Bool,
  ignoreHTTPSErrors? : Bool,
  javaScriptEnabled? : Bool,
  bypassCSP? : Bool,
  offline? : Bool,
  deviceScaleFactor? : Double,
  isMobile? : Bool,
  hasTouch? : Bool,
) -> BrowserContext {
  let options = @nostd.Object::new()
  if viewport is Some((width, height)) {
    let vp = @nostd.Object::new()
    vp["width"] = @nostd.any(width)
    vp["height"] = @nostd.any(height)
    options["viewport"] = vp
  }
  if userAgent is Some(v) {
    options["userAgent"] = @nostd.any(v)
  }
  if locale is Some(v) {
    options["locale"] = @nostd.any(v)
  }
  if timezoneId is Some(v) {
    options["timezoneId"] = @nostd.any(v)
  }
  if geolocation is Some((latitude, longitude)) {
    let geo = @nostd.Object::new()
    geo["latitude"] = @nostd.any(latitude)
    geo["longitude"] = @nostd.any(longitude)
    options["geolocation"] = geo
  }
  if permissions is Some(v) {
    options["permissions"] = @nostd.any(@js.from_array(v))
  }
  if colorScheme is Some(v) {
    options["colorScheme"] = @nostd.any(v)
  }
  if reducedMotion is Some(v) {
    options["reducedMotion"] = @nostd.any(v)
  }
  if forcedColors is Some(v) {
    options["forcedColors"] = @nostd.any(v)
  }
  if acceptDownloads is Some(v) {
    options["acceptDownloads"] = @nostd.any(v)
  }
  if ignoreHTTPSErrors is Some(v) {
    options["ignoreHTTPSErrors"] = @nostd.any(v)
  }
  if javaScriptEnabled is Some(v) {
    options["javaScriptEnabled"] = @nostd.any(v)
  }
  if bypassCSP is Some(v) {
    options["bypassCSP"] = @nostd.any(v)
  }
  if offline is Some(v) {
    options["offline"] = @nostd.any(v)
  }
  if deviceScaleFactor is Some(v) {
    options["deviceScaleFactor"] = @nostd.any(v)
  }
  if isMobile is Some(v) {
    options["isMobile"] = @nostd.any(v)
  }
  if hasTouch is Some(v) {
    options["hasTouch"] = @nostd.any(v)
  }
  let promise : @js.Promise[BrowserContext] = self
    .to_any()
    ._call("newContext", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Create new page (with default context)
pub async fn Browser::newPage(
  self : Browser,
  viewport? : (Int, Int),
  userAgent? : String,
  locale? : String,
  timezoneId? : String,
  ignoreHTTPSErrors? : Bool,
  javaScriptEnabled? : Bool,
  bypassCSP? : Bool,
  offline? : Bool,
  colorScheme? : String,
  deviceScaleFactor? : Double,
  isMobile? : Bool,
  hasTouch? : Bool,
) -> Page {
  let options = @nostd.Object::new()
  if viewport is Some((width, height)) {
    let vp = @nostd.Object::new()
    vp["width"] = @nostd.any(width)
    vp["height"] = @nostd.any(height)
    options["viewport"] = vp
  }
  if userAgent is Some(v) {
    options["userAgent"] = @nostd.any(v)
  }
  if locale is Some(v) {
    options["locale"] = @nostd.any(v)
  }
  if timezoneId is Some(v) {
    options["timezoneId"] = @nostd.any(v)
  }
  if ignoreHTTPSErrors is Some(v) {
    options["ignoreHTTPSErrors"] = @nostd.any(v)
  }
  if javaScriptEnabled is Some(v) {
    options["javaScriptEnabled"] = @nostd.any(v)
  }
  if bypassCSP is Some(v) {
    options["bypassCSP"] = @nostd.any(v)
  }
  if offline is Some(v) {
    options["offline"] = @nostd.any(v)
  }
  if colorScheme is Some(v) {
    options["colorScheme"] = @nostd.any(v)
  }
  if deviceScaleFactor is Some(v) {
    options["deviceScaleFactor"] = @nostd.any(v)
  }
  if isMobile is Some(v) {
    options["isMobile"] = @nostd.any(v)
  }
  if hasTouch is Some(v) {
    options["hasTouch"] = @nostd.any(v)
  }
  let promise : @js.Promise[Page] = self
    .to_any()
    ._call("newPage", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get all contexts
pub fn Browser::contexts(self : Browser) -> Array[BrowserContext] {
  self.to_any()._call("contexts", []) |> @nostd.identity
}

///|
/// Check if browser is connected
pub fn Browser::isConnected(self : Browser) -> Bool {
  self.to_any()._call("isConnected", []).cast()
}

///|
/// Get browser version
pub fn Browser::version(self : Browser) -> String {
  self.to_any()._call("version", []).cast()
}

///| BrowserContext Methods

///|
/// Close context
pub async fn BrowserContext::close(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Close context with error callback (for use with defer)
/// Note: This initiates close but doesn't wait for completion
pub fn BrowserContext::close_with_error_callback(
  self : BrowserContext,
  on_error : (Error) -> Unit,
) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [])
    |> @nostd.identity
  let _ = promise.catch_(fn(e) {
    on_error(e)
    @js.Promise::resolve(())
  })

}

///|
/// Create new page in context
pub async fn BrowserContext::newPage(self : BrowserContext) -> Page {
  let promise : @js.Promise[Page] = self.to_any()._call("newPage", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get all pages in context
pub fn BrowserContext::pages(self : BrowserContext) -> Array[Page] {
  self.to_any()._call("pages", []) |> @nostd.identity
}

///|
/// Set default navigation timeout
pub fn BrowserContext::setDefaultNavigationTimeout(
  self : BrowserContext,
  timeout : Int,
) -> Unit {
  self.to_any()._call("setDefaultNavigationTimeout", [@nostd.any(timeout)])
  |> ignore
}

///|
/// Set default timeout
pub fn BrowserContext::setDefaultTimeout(
  self : BrowserContext,
  timeout : Int,
) -> Unit {
  self.to_any()._call("setDefaultTimeout", [@nostd.any(timeout)]) |> ignore
}

///|
/// Add cookies
pub async fn BrowserContext::addCookies(
  self : BrowserContext,
  cookies : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("addCookies", [@nostd.any(cookies)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Clear cookies
pub async fn BrowserContext::clearCookies(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("clearCookies", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get cookies
pub async fn BrowserContext::cookies(
  self : BrowserContext,
  urls? : Array[String],
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = match urls {
    Some(u) =>
      self.to_any()._call("cookies", [@nostd.any(@js.from_array(u))])
      |> @nostd.identity
    None => self.to_any()._call("cookies", []) |> @nostd.identity
  }
  promise.wait()
}

///|
/// Grant permissions
pub async fn BrowserContext::grantPermissions(
  self : BrowserContext,
  permissions : Array[String],
  origin? : String,
) -> Unit {
  let options = @nostd.Object::new()
  if origin is Some(v) {
    options["origin"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("grantPermissions", [@nostd.any(@js.from_array(permissions)), options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Clear permissions
pub async fn BrowserContext::clearPermissions(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("clearPermissions", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Set geolocation
pub async fn BrowserContext::setGeolocation(
  self : BrowserContext,
  latitude : Double,
  longitude : Double,
  accuracy? : Double,
) -> Unit {
  let geo = @nostd.Object::new()
  geo["latitude"] = @nostd.any(latitude)
  geo["longitude"] = @nostd.any(longitude)
  if accuracy is Some(v) {
    geo["accuracy"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setGeolocation", [geo])
    |> @nostd.identity
  promise.wait()
}

///|
/// Set offline mode
pub async fn BrowserContext::setOffline(
  self : BrowserContext,
  offline : Bool,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setOffline", [@nostd.any(offline)])
    |> @nostd.identity
  promise.wait()
}
