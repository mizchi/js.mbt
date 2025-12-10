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
pub fn BrowserType::to_any(self : BrowserType) -> @core.Any = "%identity"

///|
/// Browser instance
#external
pub type Browser

///|
pub fn Browser::to_any(self : Browser) -> @core.Any = "%identity"

///|
/// BrowserContext - isolated browser session
#external
pub type BrowserContext

///|
pub fn BrowserContext::to_any(self : BrowserContext) -> @core.Any = "%identity"

///| FFI Functions

///| Browser Type Getters

///|
/// Get Chromium browser type
pub extern "js" fn chromium() -> BrowserType =
  #| () => {
  #|   const { chromium } = require('playwright');
  #|   return chromium;
  #| }

///|
/// Get Firefox browser type
pub extern "js" fn firefox() -> BrowserType =
  #| () => {
  #|   const { firefox } = require('playwright');
  #|   return firefox;
  #| }

///|
/// Get WebKit browser type
pub extern "js" fn webkit() -> BrowserType =
  #| () => {
  #|   const { webkit } = require('playwright');
  #|   return webkit;
  #| }

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
  let options = @core.new_object()
  if headless is Some(v) {
    options["headless"] = @core.any(v)
  }
  if args is Some(v) {
    options["args"] = @core.any(@core.any(v))
  }
  if channel is Some(v) {
    options["channel"] = @core.any(v)
  }
  if chromiumSandbox is Some(v) {
    options["chromiumSandbox"] = @core.any(v)
  }
  if devtools is Some(v) {
    options["devtools"] = @core.any(v)
  }
  if downloadsPath is Some(v) {
    options["downloadsPath"] = @core.any(v)
  }
  if executablePath is Some(v) {
    options["executablePath"] = @core.any(v)
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
  if slowMo is Some(v) {
    options["slowMo"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Browser] = self.to_any()._call("launch", [options])
    |> @core.identity
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
  let options = @core.new_object()
  if headless is Some(v) {
    options["headless"] = @core.any(v)
  }
  if args is Some(v) {
    options["args"] = @core.any(@core.any(v))
  }
  if channel is Some(v) {
    options["channel"] = @core.any(v)
  }
  if slowMo is Some(v) {
    options["slowMo"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[BrowserContext] = self
    .to_any()
    ._call("launchPersistentContext", [@core.any(userDataDir), options])
    |> @core.identity
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
    |> @core.identity
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
    |> @core.identity
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
  let options = @core.new_object()
  if viewport is Some((width, height)) {
    let vp = @core.new_object()
    vp["width"] = @core.any(width)
    vp["height"] = @core.any(height)
    options["viewport"] = vp
  }
  if userAgent is Some(v) {
    options["userAgent"] = @core.any(v)
  }
  if locale is Some(v) {
    options["locale"] = @core.any(v)
  }
  if timezoneId is Some(v) {
    options["timezoneId"] = @core.any(v)
  }
  if geolocation is Some((latitude, longitude)) {
    let geo = @core.new_object()
    geo["latitude"] = @core.any(latitude)
    geo["longitude"] = @core.any(longitude)
    options["geolocation"] = geo
  }
  if permissions is Some(v) {
    options["permissions"] = @core.any(@core.any(v))
  }
  if colorScheme is Some(v) {
    options["colorScheme"] = @core.any(v)
  }
  if reducedMotion is Some(v) {
    options["reducedMotion"] = @core.any(v)
  }
  if forcedColors is Some(v) {
    options["forcedColors"] = @core.any(v)
  }
  if acceptDownloads is Some(v) {
    options["acceptDownloads"] = @core.any(v)
  }
  if ignoreHTTPSErrors is Some(v) {
    options["ignoreHTTPSErrors"] = @core.any(v)
  }
  if javaScriptEnabled is Some(v) {
    options["javaScriptEnabled"] = @core.any(v)
  }
  if bypassCSP is Some(v) {
    options["bypassCSP"] = @core.any(v)
  }
  if offline is Some(v) {
    options["offline"] = @core.any(v)
  }
  if deviceScaleFactor is Some(v) {
    options["deviceScaleFactor"] = @core.any(v)
  }
  if isMobile is Some(v) {
    options["isMobile"] = @core.any(v)
  }
  if hasTouch is Some(v) {
    options["hasTouch"] = @core.any(v)
  }
  let promise : @js.Promise[BrowserContext] = self
    .to_any()
    ._call("newContext", [options])
    |> @core.identity
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
  let options = @core.new_object()
  if viewport is Some((width, height)) {
    let vp = @core.new_object()
    vp["width"] = @core.any(width)
    vp["height"] = @core.any(height)
    options["viewport"] = vp
  }
  if userAgent is Some(v) {
    options["userAgent"] = @core.any(v)
  }
  if locale is Some(v) {
    options["locale"] = @core.any(v)
  }
  if timezoneId is Some(v) {
    options["timezoneId"] = @core.any(v)
  }
  if ignoreHTTPSErrors is Some(v) {
    options["ignoreHTTPSErrors"] = @core.any(v)
  }
  if javaScriptEnabled is Some(v) {
    options["javaScriptEnabled"] = @core.any(v)
  }
  if bypassCSP is Some(v) {
    options["bypassCSP"] = @core.any(v)
  }
  if offline is Some(v) {
    options["offline"] = @core.any(v)
  }
  if colorScheme is Some(v) {
    options["colorScheme"] = @core.any(v)
  }
  if deviceScaleFactor is Some(v) {
    options["deviceScaleFactor"] = @core.any(v)
  }
  if isMobile is Some(v) {
    options["isMobile"] = @core.any(v)
  }
  if hasTouch is Some(v) {
    options["hasTouch"] = @core.any(v)
  }
  let promise : @js.Promise[Page] = self.to_any()._call("newPage", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Get all contexts
pub fn Browser::contexts(self : Browser) -> Array[BrowserContext] {
  self.to_any()._call("contexts", []) |> @core.identity
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
    |> @core.identity
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
    |> @core.identity
  let _ = promise.catch_(fn(e) {
    on_error(e)
    @js.Promise::resolve(())
  })

}

///|
/// Create new page in context
pub async fn BrowserContext::newPage(self : BrowserContext) -> Page {
  let promise : @js.Promise[Page] = self.to_any()._call("newPage", [])
    |> @core.identity
  promise.wait()
}

///|
/// Get all pages in context
pub fn BrowserContext::pages(self : BrowserContext) -> Array[Page] {
  self.to_any()._call("pages", []) |> @core.identity
}

///|
/// Set default navigation timeout
pub fn BrowserContext::setDefaultNavigationTimeout(
  self : BrowserContext,
  timeout : Int,
) -> Unit {
  self.to_any()._call("setDefaultNavigationTimeout", [@core.any(timeout)])
  |> ignore
}

///|
/// Set default timeout
pub fn BrowserContext::setDefaultTimeout(
  self : BrowserContext,
  timeout : Int,
) -> Unit {
  self.to_any()._call("setDefaultTimeout", [@core.any(timeout)]) |> ignore
}

///|
/// Add cookies
pub async fn BrowserContext::addCookies(
  self : BrowserContext,
  cookies : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("addCookies", [@core.any(cookies)])
    |> @core.identity
  promise.wait()
}

///|
/// Clear cookies
pub async fn BrowserContext::clearCookies(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("clearCookies", [])
    |> @core.identity
  promise.wait()
}

///|
/// Get cookies
pub async fn BrowserContext::cookies(
  self : BrowserContext,
  urls? : Array[String],
) -> @core.Any {
  let promise : @js.Promise[@core.Any] = match urls {
    Some(u) =>
      self.to_any()._call("cookies", [@core.any(@core.any(u))])
      |> @core.identity
    None => self.to_any()._call("cookies", []) |> @core.identity
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
  let options = @core.new_object()
  if origin is Some(v) {
    options["origin"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("grantPermissions", [@core.any(@core.any(permissions)), options])
    |> @core.identity
  promise.wait()
}

///|
/// Clear permissions
pub async fn BrowserContext::clearPermissions(self : BrowserContext) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("clearPermissions", [])
    |> @core.identity
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
  let geo = @core.new_object()
  geo["latitude"] = @core.any(latitude)
  geo["longitude"] = @core.any(longitude)
  if accuracy is Some(v) {
    geo["accuracy"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("setGeolocation", [geo])
    |> @core.identity
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
    ._call("setOffline", [@core.any(offline)])
    |> @core.identity
  promise.wait()
}
