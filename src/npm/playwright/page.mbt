///|
/// Page type for Playwright
/// https://playwright.dev/docs/api/class-page

///|
/// Page instance
#external
pub type Page

///|
pub impl @js.JsImpl for Page

///| Navigation Methods

///|
/// Navigate to URL
/// See: https://playwright.dev/docs/api/class-page#page-goto
pub async fn Page::goto(
  self : Page,
  url : String,
  timeout? : Int,
  waitUntil? : String,
  referer? : String,
) -> Response? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  if referer is Some(v) {
    options["referer"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("goto", [@js.any(url), options.as_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Reload page
pub async fn Page::reload(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("reload", [options.as_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Go back in history
pub async fn Page::goBack(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("goBack", [options.as_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Go forward in history
pub async fn Page::goForward(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("goForward", [options.as_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///| Page Properties

///|
/// Get page URL
pub fn Page::url(self : Page) -> String {
  self.call("url", []).cast()
}

///|
/// Get page title
pub async fn Page::title(self : Page) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("title", []))
  promise.wait()
}

///|
/// Get page content (HTML)
pub async fn Page::content(self : Page) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("content", []))
  promise.wait()
}

///|
/// Set page content
pub async fn Page::setContent(
  self : Page,
  html : String,
  timeout? : Int,
  waitUntil? : String,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setContent", [@js.any(html), options.as_any()]),
  )
  promise.wait()
}

///| Locator Methods

///|
/// Get locator for CSS selector or text
pub fn Page::locator(self : Page, selector : String) -> Locator {
  @js.identity(self.call("locator", [selector]))
}

///|
/// Get locator by role
pub fn Page::getByRole(
  self : Page,
  role : String,
  name? : String,
  exact? : Bool,
) -> Locator {
  let options = @js.Object::new()
  if name is Some(v) {
    options["name"] = v
  }
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByRole", [@js.any(role), options.as_any()]))
}

///|
/// Get locator by text
pub fn Page::getByText(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByText", [@js.any(text), options.as_any()]))
}

///|
/// Get locator by label
pub fn Page::getByLabel(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByLabel", [@js.any(text), options.as_any()]))
}

///|
/// Get locator by placeholder
pub fn Page::getByPlaceholder(
  self : Page,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByPlaceholder", [@js.any(text), options.as_any()]))
}

///|
/// Get locator by alt text
pub fn Page::getByAltText(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByAltText", [@js.any(text), options.as_any()]))
}

///|
/// Get locator by title
pub fn Page::getByTitle(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByTitle", [@js.any(text), options.as_any()]))
}

///|
/// Get locator by test ID
pub fn Page::getByTestId(self : Page, testId : String) -> Locator {
  @js.identity(self.call("getByTestId", [testId]))
}

///| Action Methods

///|
/// Click on element
pub async fn Page::click(
  self : Page,
  selector : String,
  button? : String,
  clickCount? : Int,
  delay? : Int,
  force? : Bool,
  modifiers? : Array[String],
  noWaitAfter? : Bool,
  position? : (Double, Double),
  timeout? : Int,
  trial? : Bool,
) -> Unit {
  let options = @js.Object::new()
  if button is Some(v) {
    options["button"] = v
  }
  if clickCount is Some(v) {
    options["clickCount"] = v
  }
  if delay is Some(v) {
    options["delay"] = v
  }
  if force is Some(v) {
    options["force"] = v
  }
  if modifiers is Some(v) {
    options["modifiers"] = @js.from_array(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if position is Some((x, y)) {
    let pos = @js.Object::new()
    pos["x"] = x
    pos["y"] = y
    options["position"] = pos.as_any()
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if trial is Some(v) {
    options["trial"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("click", [@js.any(selector), options.as_any()]),
  )
  promise.wait()
}

///|
/// Double click on element
pub async fn Page::dblclick(
  self : Page,
  selector : String,
  timeout? : Int,
  force? : Bool,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if force is Some(v) {
    options["force"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("dblclick", [@js.any(selector), options.as_any()]),
  )
  promise.wait()
}

///|
/// Fill input
pub async fn Page::fill(
  self : Page,
  selector : String,
  value : String,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("fill", [@js.any(selector), @js.any(value), options.as_any()]),
  )
  promise.wait()
}

///|
/// Type text (keystroke by keystroke)
pub async fn Page::type_(
  self : Page,
  selector : String,
  text : String,
  delay? : Int,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if delay is Some(v) {
    options["delay"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("type", [@js.any(selector), @js.any(text), options.as_any()]),
  )
  promise.wait()
}

///|
/// Press key
pub async fn Page::press(
  self : Page,
  selector : String,
  key : String,
  delay? : Int,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if delay is Some(v) {
    options["delay"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("press", [@js.any(selector), @js.any(key), options.as_any()]),
  )
  promise.wait()
}

///|
/// Check checkbox
pub async fn Page::check(
  self : Page,
  selector : String,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("check", [@js.any(selector), options.as_any()]),
  )
  promise.wait()
}

///|
/// Uncheck checkbox
pub async fn Page::uncheck(
  self : Page,
  selector : String,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("uncheck", [@js.any(selector), options.as_any()]),
  )
  promise.wait()
}

///|
/// Select option(s) in dropdown
pub async fn Page::selectOption(
  self : Page,
  selector : String,
  values : @js.Any,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Array[String] {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Array[String]] = @js.identity(
    self.call("selectOption", [@js.any(selector), values, options.as_any()]),
  )
  promise.wait()
}

///|
/// Hover over element
pub async fn Page::hover(
  self : Page,
  selector : String,
  force? : Bool,
  modifiers? : Array[String],
  position? : (Double, Double),
  timeout? : Int,
  trial? : Bool,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if modifiers is Some(v) {
    options["modifiers"] = @js.from_array(v)
  }
  if position is Some((x, y)) {
    let pos = @js.Object::new()
    pos["x"] = x
    pos["y"] = y
    options["position"] = pos.as_any()
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if trial is Some(v) {
    options["trial"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("hover", [@js.any(selector), options.as_any()]),
  )
  promise.wait()
}

///|
/// Focus element
pub async fn Page::focus(
  self : Page,
  selector : String,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("focus", [@js.any(selector), options.as_any()]),
  )
  promise.wait()
}

///| Wait Methods

///|
/// Wait for selector
pub async fn Page::waitForSelector(
  self : Page,
  selector : String,
  state? : String,
  timeout? : Int,
  strict? : Bool,
) -> @js.Any {
  let options = @js.Object::new()
  if state is Some(v) {
    options["state"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if strict is Some(v) {
    options["strict"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("waitForSelector", [@js.any(selector), options.as_any()]),
  )
  promise.wait()
}

///|
/// Wait for load state
pub async fn Page::waitForLoadState(
  self : Page,
  state? : String,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = match state {
    Some(s) =>
      @js.identity(self.call("waitForLoadState", [s, options.as_any()]))
    None => @js.identity(self.call("waitForLoadState", [options.as_any()]))
  }
  promise.wait()
}

///|
/// Wait for navigation
pub async fn Page::waitForNavigation(
  self : Page,
  timeout? : Int,
  url? : String,
  waitUntil? : String,
) -> Response? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if url is Some(v) {
    options["url"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("waitForNavigation", [options.as_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Wait for URL
pub async fn Page::waitForURL(
  self : Page,
  url : String,
  timeout? : Int,
  waitUntil? : String,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("waitForURL", [@js.any(url), options.as_any()]),
  )
  promise.wait()
}

///|
/// Wait for timeout
pub async fn Page::waitForTimeout(self : Page, timeout : Int) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("waitForTimeout", [timeout]),
  )
  promise.wait()
}

///|
/// Wait for function to return truthy value
pub async fn Page::waitForFunction(
  self : Page,
  pageFunction : String,
  arg? : @js.Any,
  polling? : Int,
  timeout? : Int,
) -> @js.Any {
  let options = @js.Object::new()
  if polling is Some(v) {
    options["polling"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[@js.Any] = match arg {
    Some(a) =>
      @js.identity(
        self.call("waitForFunction", [pageFunction, a, options.as_any()]),
      )
    None =>
      @js.identity(
        self.call("waitForFunction", [pageFunction, options.as_any()]),
      )
  }
  promise.wait()
}

///| Evaluate Methods

///|
/// Evaluate JavaScript in page context
pub async fn Page::evaluate(
  self : Page,
  pageFunction : String,
  arg? : @js.Any,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = match arg {
    Some(a) => @js.identity(self.call("evaluate", [pageFunction, a]))
    None => @js.identity(self.call("evaluate", [pageFunction]))
  }
  promise.wait()
}

///|
/// Evaluate JavaScript and return handle
pub async fn Page::evaluateHandle(
  self : Page,
  pageFunction : String,
  arg? : @js.Any,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = match arg {
    Some(a) => @js.identity(self.call("evaluateHandle", [pageFunction, a]))
    None => @js.identity(self.call("evaluateHandle", [pageFunction]))
  }
  promise.wait()
}

///| Screenshot Methods

///|
/// Take screenshot
pub async fn Page::screenshot(
  self : Page,
  path? : String,
  type_? : String,
  quality? : Int,
  fullPage? : Bool,
  clip? : @js.Any,
  omitBackground? : Bool,
  timeout? : Int,
  scale? : String,
) -> @js.Any {
  let options = @js.Object::new()
  if path is Some(v) {
    options["path"] = v
  }
  if type_ is Some(v) {
    options["type"] = v
  }
  if quality is Some(v) {
    options["quality"] = v
  }
  if fullPage is Some(v) {
    options["fullPage"] = v
  }
  if clip is Some(v) {
    options["clip"] = v
  }
  if omitBackground is Some(v) {
    options["omitBackground"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if scale is Some(v) {
    options["scale"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("screenshot", [options.as_any()]),
  )
  promise.wait()
}

///| PDF Methods

///|
/// Generate PDF (Chromium only)
pub async fn Page::pdf(
  self : Page,
  path? : String,
  scale? : Double,
  displayHeaderFooter? : Bool,
  headerTemplate? : String,
  footerTemplate? : String,
  printBackground? : Bool,
  landscape? : Bool,
  pageRanges? : String,
  format? : String,
  width? : String,
  height? : String,
  margin? : @js.Any,
  preferCSSPageSize? : Bool,
) -> @js.Any {
  let options = @js.Object::new()
  if path is Some(v) {
    options["path"] = v
  }
  if scale is Some(v) {
    options["scale"] = v
  }
  if displayHeaderFooter is Some(v) {
    options["displayHeaderFooter"] = v
  }
  if headerTemplate is Some(v) {
    options["headerTemplate"] = v
  }
  if footerTemplate is Some(v) {
    options["footerTemplate"] = v
  }
  if printBackground is Some(v) {
    options["printBackground"] = v
  }
  if landscape is Some(v) {
    options["landscape"] = v
  }
  if pageRanges is Some(v) {
    options["pageRanges"] = v
  }
  if format is Some(v) {
    options["format"] = v
  }
  if width is Some(v) {
    options["width"] = v
  }
  if height is Some(v) {
    options["height"] = v
  }
  if margin is Some(v) {
    options["margin"] = v
  }
  if preferCSSPageSize is Some(v) {
    options["preferCSSPageSize"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("pdf", [options.as_any()]),
  )
  promise.wait()
}

///| Page Management

///|
/// Close page
pub async fn Page::close(self : Page, runBeforeUnload? : Bool) -> Unit {
  let options = @js.Object::new()
  if runBeforeUnload is Some(v) {
    options["runBeforeUnload"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("close", [options.as_any()]),
  )
  promise.wait()
}

///|
/// Close page with error callback (for use with defer)
/// Note: This initiates close but doesn't wait for completion
pub fn Page::close_with_error_callback(
  self : Page,
  on_error : (Error) -> Unit,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("close", []))
  let _ = promise.catch_(fn(e) {
    on_error(e)
    @js.Promise::resolve(())
  })

}

///|
/// Check if page is closed
pub fn Page::isClosed(self : Page) -> Bool {
  self.call("isClosed", []).cast()
}

///|
/// Bring page to front
pub async fn Page::bringToFront(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("bringToFront", []))
  promise.wait()
}

///|
/// Set viewport size
pub async fn Page::setViewportSize(
  self : Page,
  width : Int,
  height : Int,
) -> Unit {
  let viewport = @js.Object::new()
  viewport["width"] = width
  viewport["height"] = height
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setViewportSize", [viewport.as_any()]),
  )
  promise.wait()
}

///|
/// Get viewport size
pub fn Page::viewportSize(self : Page) -> (Int, Int)? {
  let result = self.call("viewportSize", [])
  if @js.is_nullish(result) {
    None
  } else {
    let width : Int = result.get("width").cast()
    let height : Int = result.get("height").cast()
    Some((width, height))
  }
}

///|
/// Set extra HTTP headers
pub async fn Page::setExtraHTTPHeaders(self : Page, headers : @js.Any) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setExtraHTTPHeaders", [headers]),
  )
  promise.wait()
}

///|
/// Add script tag
pub async fn Page::addScriptTag(
  self : Page,
  url? : String,
  path? : String,
  content? : String,
  type_? : String,
) -> @js.Any {
  let options = @js.Object::new()
  if url is Some(v) {
    options["url"] = v
  }
  if path is Some(v) {
    options["path"] = v
  }
  if content is Some(v) {
    options["content"] = v
  }
  if type_ is Some(v) {
    options["type"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("addScriptTag", [options.as_any()]),
  )
  promise.wait()
}

///|
/// Add style tag
pub async fn Page::addStyleTag(
  self : Page,
  url? : String,
  path? : String,
  content? : String,
) -> @js.Any {
  let options = @js.Object::new()
  if url is Some(v) {
    options["url"] = v
  }
  if path is Some(v) {
    options["path"] = v
  }
  if content is Some(v) {
    options["content"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("addStyleTag", [options.as_any()]),
  )
  promise.wait()
}

///|
/// Expose function to page
pub async fn Page::exposeFunction(
  self : Page,
  name : String,
  callback : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("exposeFunction", [@js.any(name), callback]),
  )
  promise.wait()
}

///|
/// Set default navigation timeout
pub fn Page::setDefaultNavigationTimeout(self : Page, timeout : Int) -> Unit {
  let _ = self.call("setDefaultNavigationTimeout", [timeout])

}

///|
/// Set default timeout
pub fn Page::setDefaultTimeout(self : Page, timeout : Int) -> Unit {
  let _ = self.call("setDefaultTimeout", [timeout])

}
