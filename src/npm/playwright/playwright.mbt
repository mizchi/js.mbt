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
pub impl @js.JsImpl for BrowserType

///|
/// Browser instance
#external
pub type Browser

///|
pub impl @js.JsImpl for Browser

///|
/// BrowserContext - isolated browser session
#external
pub type BrowserContext

///|
pub impl @js.JsImpl for BrowserContext

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
  let options = @js.Object::new()
  if headless is Some(v) {
    options["headless"] = v
  }
  if args is Some(v) {
    options["args"] = @js.from_array(v)
  }
  if channel is Some(v) {
    options["channel"] = v
  }
  if chromiumSandbox is Some(v) {
    options["chromiumSandbox"] = v
  }
  if devtools is Some(v) {
    options["devtools"] = v
  }
  if downloadsPath is Some(v) {
    options["downloadsPath"] = v
  }
  if executablePath is Some(v) {
    options["executablePath"] = v
  }
  if handleSIGHUP is Some(v) {
    options["handleSIGHUP"] = v
  }
  if handleSIGINT is Some(v) {
    options["handleSIGINT"] = v
  }
  if handleSIGTERM is Some(v) {
    options["handleSIGTERM"] = v
  }
  if slowMo is Some(v) {
    options["slowMo"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Browser] = @js.identity(
    self.call("launch", [options.to_any()]),
  )
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
  let options = @js.Object::new()
  if headless is Some(v) {
    options["headless"] = v
  }
  if args is Some(v) {
    options["args"] = @js.from_array(v)
  }
  if channel is Some(v) {
    options["channel"] = v
  }
  if slowMo is Some(v) {
    options["slowMo"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[BrowserContext] = @js.identity(
    self.call("launchPersistentContext", [
      @js.any(userDataDir),
      options.to_any(),
    ]),
  )
  promise.wait()
}

///|
/// Get browser type name
pub fn BrowserType::name(self : BrowserType) -> String {
  self.call("name", []).cast()
}

///| Browser Methods

///|
/// Close browser (async)
pub async fn Browser::close(self : Browser) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("close", []))
  promise.wait()
}

///|
/// Close browser with error callback (for use with defer)
/// Note: This initiates close but doesn't wait for completion
pub fn Browser::close_with_error_callback(
  self : Browser,
  on_error : (Error) -> Unit,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("close", []))
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
  let options = @js.Object::new()
  if viewport is Some((width, height)) {
    let vp = @js.Object::new()
    vp["width"] = width
    vp["height"] = height
    options["viewport"] = vp.to_any()
  }
  if userAgent is Some(v) {
    options["userAgent"] = v
  }
  if locale is Some(v) {
    options["locale"] = v
  }
  if timezoneId is Some(v) {
    options["timezoneId"] = v
  }
  if geolocation is Some((latitude, longitude)) {
    let geo = @js.Object::new()
    geo["latitude"] = latitude
    geo["longitude"] = longitude
    options["geolocation"] = geo.to_any()
  }
  if permissions is Some(v) {
    options["permissions"] = @js.from_array(v)
  }
  if colorScheme is Some(v) {
    options["colorScheme"] = v
  }
  if reducedMotion is Some(v) {
    options["reducedMotion"] = v
  }
  if forcedColors is Some(v) {
    options["forcedColors"] = v
  }
  if acceptDownloads is Some(v) {
    options["acceptDownloads"] = v
  }
  if ignoreHTTPSErrors is Some(v) {
    options["ignoreHTTPSErrors"] = v
  }
  if javaScriptEnabled is Some(v) {
    options["javaScriptEnabled"] = v
  }
  if bypassCSP is Some(v) {
    options["bypassCSP"] = v
  }
  if offline is Some(v) {
    options["offline"] = v
  }
  if deviceScaleFactor is Some(v) {
    options["deviceScaleFactor"] = v
  }
  if isMobile is Some(v) {
    options["isMobile"] = v
  }
  if hasTouch is Some(v) {
    options["hasTouch"] = v
  }
  let promise : @js.Promise[BrowserContext] = @js.identity(
    self.call("newContext", [options.to_any()]),
  )
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
  let options = @js.Object::new()
  if viewport is Some((width, height)) {
    let vp = @js.Object::new()
    vp["width"] = width
    vp["height"] = height
    options["viewport"] = vp.to_any()
  }
  if userAgent is Some(v) {
    options["userAgent"] = v
  }
  if locale is Some(v) {
    options["locale"] = v
  }
  if timezoneId is Some(v) {
    options["timezoneId"] = v
  }
  if ignoreHTTPSErrors is Some(v) {
    options["ignoreHTTPSErrors"] = v
  }
  if javaScriptEnabled is Some(v) {
    options["javaScriptEnabled"] = v
  }
  if bypassCSP is Some(v) {
    options["bypassCSP"] = v
  }
  if offline is Some(v) {
    options["offline"] = v
  }
  if colorScheme is Some(v) {
    options["colorScheme"] = v
  }
  if deviceScaleFactor is Some(v) {
    options["deviceScaleFactor"] = v
  }
  if isMobile is Some(v) {
    options["isMobile"] = v
  }
  if hasTouch is Some(v) {
    options["hasTouch"] = v
  }
  let promise : @js.Promise[Page] = @js.identity(
    self.call("newPage", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Get all contexts
pub fn Browser::contexts(self : Browser) -> Array[BrowserContext] {
  @js.identity(self.call("contexts", []))
}

///|
/// Check if browser is connected
pub fn Browser::isConnected(self : Browser) -> Bool {
  self.call("isConnected", []).cast()
}

///|
/// Get browser version
pub fn Browser::version(self : Browser) -> String {
  self.call("version", []).cast()
}

///| BrowserContext Methods

///|
/// Close context
pub async fn BrowserContext::close(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("close", []))
  promise.wait()
}

///|
/// Close context with error callback (for use with defer)
/// Note: This initiates close but doesn't wait for completion
pub fn BrowserContext::close_with_error_callback(
  self : BrowserContext,
  on_error : (Error) -> Unit,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("close", []))
  let _ = promise.catch_(fn(e) {
    on_error(e)
    @js.Promise::resolve(())
  })

}

///|
/// Create new page in context
pub async fn BrowserContext::newPage(self : BrowserContext) -> Page {
  let promise : @js.Promise[Page] = @js.identity(self.call("newPage", []))
  promise.wait()
}

///|
/// Get all pages in context
pub fn BrowserContext::pages(self : BrowserContext) -> Array[Page] {
  @js.identity(self.call("pages", []))
}

///|
/// Set default navigation timeout
pub fn BrowserContext::setDefaultNavigationTimeout(
  self : BrowserContext,
  timeout : Int,
) -> Unit {
  let _ = self.call("setDefaultNavigationTimeout", [timeout])

}

///|
/// Set default timeout
pub fn BrowserContext::setDefaultTimeout(
  self : BrowserContext,
  timeout : Int,
) -> Unit {
  let _ = self.call("setDefaultTimeout", [timeout])

}

///|
/// Add cookies
pub async fn BrowserContext::addCookies(
  self : BrowserContext,
  cookies : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("addCookies", [cookies]),
  )
  promise.wait()
}

///|
/// Clear cookies
pub async fn BrowserContext::clearCookies(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("clearCookies", []))
  promise.wait()
}

///|
/// Get cookies
pub async fn BrowserContext::cookies(
  self : BrowserContext,
  urls? : Array[String],
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = match urls {
    Some(u) => @js.identity(self.call("cookies", [@js.from_array(u)]))
    None => @js.identity(self.call("cookies", []))
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
  let options = @js.Object::new()
  if origin is Some(v) {
    options["origin"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("grantPermissions", [
      @js.from_array(permissions),
      options.to_any(),
    ]),
  )
  promise.wait()
}

///|
/// Clear permissions
pub async fn BrowserContext::clearPermissions(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("clearPermissions", []),
  )
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
  let geo = @js.Object::new()
  geo["latitude"] = latitude
  geo["longitude"] = longitude
  if accuracy is Some(v) {
    geo["accuracy"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setGeolocation", [geo.to_any()]),
  )
  promise.wait()
}

///|
/// Set offline mode
pub async fn BrowserContext::setOffline(
  self : BrowserContext,
  offline : Bool,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setOffline", [offline]),
  )
  promise.wait()
}
