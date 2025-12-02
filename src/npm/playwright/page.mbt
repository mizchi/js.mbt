///|
/// Page type for Playwright
/// https://playwright.dev/docs/api/class-page

///|
/// Page instance
#external
pub type Page

///|
pub fn Page::to_any(self : Page) -> @nostd.Any = "%identity"

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
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  if referer is Some(v) {
    options["referer"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("goto", [@nostd.any(url), options])
    |> @nostd.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
  }
}

///|
/// Reload page
pub async fn Page::reload(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("reload", [options])
    |> @nostd.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
  }
}

///|
/// Go back in history
pub async fn Page::goBack(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("goBack", [options])
    |> @nostd.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
  }
}

///|
/// Go forward in history
pub async fn Page::goForward(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("goForward", [options])
    |> @nostd.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
  }
}

///| Page Properties

///|
/// Get page URL
pub fn Page::url(self : Page) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// Get page title
pub async fn Page::title(self : Page) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("title", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get page content (HTML)
pub async fn Page::content(self : Page) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("content", [])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setContent", [@nostd.any(html), options])
    |> @nostd.identity
  promise.wait()
}

///| Locator Methods

///|
/// Get locator for CSS selector or text
pub fn Page::locator(self : Page, selector : String) -> Locator {
  self.to_any()._call("locator", [@nostd.any(selector)]) |> @nostd.identity
}

///|
/// Get locator by role
pub fn Page::getByRole(
  self : Page,
  role : String,
  name? : String,
  exact? : Bool,
) -> Locator {
  let options = @nostd.Object::new()
  if name is Some(v) {
    options["name"] = @nostd.any(v)
  }
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByRole", [@nostd.any(role), options]) |> @nostd.identity
}

///|
/// Get locator by text
pub fn Page::getByText(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByText", [@nostd.any(text), options]) |> @nostd.identity
}

///|
/// Get locator by label
pub fn Page::getByLabel(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByLabel", [@nostd.any(text), options])
  |> @nostd.identity
}

///|
/// Get locator by placeholder
pub fn Page::getByPlaceholder(
  self : Page,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByPlaceholder", [@nostd.any(text), options])
  |> @nostd.identity
}

///|
/// Get locator by alt text
pub fn Page::getByAltText(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByAltText", [@nostd.any(text), options])
  |> @nostd.identity
}

///|
/// Get locator by title
pub fn Page::getByTitle(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByTitle", [@nostd.any(text), options])
  |> @nostd.identity
}

///|
/// Get locator by test ID
pub fn Page::getByTestId(self : Page, testId : String) -> Locator {
  self.to_any()._call("getByTestId", [@nostd.any(testId)]) |> @nostd.identity
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
  let options = @nostd.Object::new()
  if button is Some(v) {
    options["button"] = @nostd.any(v)
  }
  if clickCount is Some(v) {
    options["clickCount"] = @nostd.any(v)
  }
  if delay is Some(v) {
    options["delay"] = @nostd.any(v)
  }
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @nostd.any(@js.from_array(v))
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if position is Some((x, y)) {
    let pos = @nostd.Object::new()
    pos["x"] = @nostd.any(x)
    pos["y"] = @nostd.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("click", [@nostd.any(selector), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("dblclick", [@nostd.any(selector), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("fill", [@nostd.any(selector), @nostd.any(value), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if delay is Some(v) {
    options["delay"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@nostd.any(selector), @nostd.any(text), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if delay is Some(v) {
    options["delay"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("press", [@nostd.any(selector), @nostd.any(key), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("check", [@nostd.any(selector), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("uncheck", [@nostd.any(selector), options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Select option(s) in dropdown
pub async fn Page::selectOption(
  self : Page,
  selector : String,
  values : @nostd.Any,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Array[String] {
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("selectOption", [@nostd.any(selector), @nostd.any(values), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @nostd.any(@js.from_array(v))
  }
  if position is Some((x, y)) {
    let pos = @nostd.Object::new()
    pos["x"] = @nostd.any(x)
    pos["y"] = @nostd.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("hover", [@nostd.any(selector), options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Focus element
pub async fn Page::focus(
  self : Page,
  selector : String,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("focus", [@nostd.any(selector), options])
    |> @nostd.identity
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
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if state is Some(v) {
    options["state"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if strict is Some(v) {
    options["strict"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("waitForSelector", [@nostd.any(selector), options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Wait for load state
pub async fn Page::waitForLoadState(
  self : Page,
  state? : String,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = match state {
    Some(s) =>
      self.to_any()._call("waitForLoadState", [@nostd.any(s), options])
      |> @nostd.identity
    None => self.to_any()._call("waitForLoadState", [options]) |> @nostd.identity
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
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if url is Some(v) {
    options["url"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("waitForNavigation", [options])
    |> @nostd.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result |> @nostd.identity)
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
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("waitForURL", [@nostd.any(url), options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Wait for timeout
pub async fn Page::waitForTimeout(self : Page, timeout : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("waitForTimeout", [@nostd.any(timeout)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Wait for function to return truthy value
pub async fn Page::waitForFunction(
  self : Page,
  pageFunction : String,
  arg? : @nostd.Any,
  polling? : Int,
  timeout? : Int,
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if polling is Some(v) {
    options["polling"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("waitForFunction", [@nostd.any(pageFunction), @nostd.any(a), options])
      |> @nostd.identity
    None =>
      self
      .to_any()
      ._call("waitForFunction", [@nostd.any(pageFunction), options])
      |> @nostd.identity
  }
  promise.wait()
}

///| Evaluate Methods

///|
/// Evaluate JavaScript in page context
pub async fn Page::evaluate(
  self : Page,
  pageFunction : String,
  arg? : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("evaluate", [@nostd.any(pageFunction), @nostd.any(a)])
      |> @nostd.identity
    None =>
      self.to_any()._call("evaluate", [@nostd.any(pageFunction)]) |> @nostd.identity
  }
  promise.wait()
}

///|
/// Evaluate JavaScript and return handle
pub async fn Page::evaluateHandle(
  self : Page,
  pageFunction : String,
  arg? : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("evaluateHandle", [@nostd.any(pageFunction), @nostd.any(a)])
      |> @nostd.identity
    None =>
      self.to_any()._call("evaluateHandle", [@nostd.any(pageFunction)])
      |> @nostd.identity
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
  clip? : @nostd.Any,
  omitBackground? : Bool,
  timeout? : Int,
  scale? : String,
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if path is Some(v) {
    options["path"] = @nostd.any(v)
  }
  if type_ is Some(v) {
    options["type"] = @nostd.any(v)
  }
  if quality is Some(v) {
    options["quality"] = @nostd.any(v)
  }
  if fullPage is Some(v) {
    options["fullPage"] = @nostd.any(v)
  }
  if clip is Some(v) {
    options["clip"] = @nostd.any(v)
  }
  if omitBackground is Some(v) {
    options["omitBackground"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if scale is Some(v) {
    options["scale"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("screenshot", [options])
    |> @nostd.identity
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
  margin? : @nostd.Any,
  preferCSSPageSize? : Bool,
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if path is Some(v) {
    options["path"] = @nostd.any(v)
  }
  if scale is Some(v) {
    options["scale"] = @nostd.any(v)
  }
  if displayHeaderFooter is Some(v) {
    options["displayHeaderFooter"] = @nostd.any(v)
  }
  if headerTemplate is Some(v) {
    options["headerTemplate"] = @nostd.any(v)
  }
  if footerTemplate is Some(v) {
    options["footerTemplate"] = @nostd.any(v)
  }
  if printBackground is Some(v) {
    options["printBackground"] = @nostd.any(v)
  }
  if landscape is Some(v) {
    options["landscape"] = @nostd.any(v)
  }
  if pageRanges is Some(v) {
    options["pageRanges"] = @nostd.any(v)
  }
  if format is Some(v) {
    options["format"] = @nostd.any(v)
  }
  if width is Some(v) {
    options["width"] = @nostd.any(v)
  }
  if height is Some(v) {
    options["height"] = @nostd.any(v)
  }
  if margin is Some(v) {
    options["margin"] = @nostd.any(v)
  }
  if preferCSSPageSize is Some(v) {
    options["preferCSSPageSize"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self.to_any()._call("pdf", [options])
    |> @nostd.identity
  promise.wait()
}

///| Page Management

///|
/// Close page
pub async fn Page::close(self : Page, runBeforeUnload? : Bool) -> Unit {
  let options = @nostd.Object::new()
  if runBeforeUnload is Some(v) {
    options["runBeforeUnload"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Close page with error callback (for use with defer)
/// Note: This initiates close but doesn't wait for completion
pub fn Page::close_with_error_callback(
  self : Page,
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
/// Check if page is closed
pub fn Page::isClosed(self : Page) -> Bool {
  self.to_any()._call("isClosed", []).cast()
}

///|
/// Bring page to front
pub async fn Page::bringToFront(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("bringToFront", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Set viewport size
pub async fn Page::setViewportSize(
  self : Page,
  width : Int,
  height : Int,
) -> Unit {
  let viewport = @nostd.Object::new()
  viewport["width"] = @nostd.any(width)
  viewport["height"] = @nostd.any(height)
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setViewportSize", [viewport])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get viewport size
pub fn Page::viewportSize(self : Page) -> (Int, Int)? {
  let result = self.to_any()._call("viewportSize", [])
  if @nostd.is_nullish(result) {
    None
  } else {
    let width : Int = result["width"].cast()
    let height : Int = result["height"].cast()
    Some((width, height))
  }
}

///|
/// Set extra HTTP headers
pub async fn Page::setExtraHTTPHeaders(self : Page, headers : @nostd.Any) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setExtraHTTPHeaders", [@nostd.any(headers)])
    |> @nostd.identity
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
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if url is Some(v) {
    options["url"] = @nostd.any(v)
  }
  if path is Some(v) {
    options["path"] = @nostd.any(v)
  }
  if content is Some(v) {
    options["content"] = @nostd.any(v)
  }
  if type_ is Some(v) {
    options["type"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("addScriptTag", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Add style tag
pub async fn Page::addStyleTag(
  self : Page,
  url? : String,
  path? : String,
  content? : String,
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if url is Some(v) {
    options["url"] = @nostd.any(v)
  }
  if path is Some(v) {
    options["path"] = @nostd.any(v)
  }
  if content is Some(v) {
    options["content"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("addStyleTag", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Expose function to page
pub async fn Page::exposeFunction(
  self : Page,
  name : String,
  callback : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("exposeFunction", [@nostd.any(name), @nostd.any(callback)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Set default navigation timeout
pub fn Page::setDefaultNavigationTimeout(self : Page, timeout : Int) -> Unit {
  self.to_any()._call("setDefaultNavigationTimeout", [@nostd.any(timeout)])
  |> ignore
}

///|
/// Set default timeout
pub fn Page::setDefaultTimeout(self : Page, timeout : Int) -> Unit {
  self.to_any()._call("setDefaultTimeout", [@nostd.any(timeout)]) |> ignore
}
