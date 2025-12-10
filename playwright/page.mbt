///|
/// Page type for Playwright
/// https://playwright.dev/docs/api/class-page

///|
/// Page instance
#external
pub type Page

///|
pub fn Page::to_any(self : Page) -> @core.Any = "%identity"

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
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @core.any(v)
  }
  if referer is Some(v) {
    options["referer"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("goto", [@core.any(url), options])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) {
    None
  } else {
    Some(result |> @core.identity)
  }
}

///|
/// Reload page
pub async fn Page::reload(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("reload", [options])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) {
    None
  } else {
    Some(result |> @core.identity)
  }
}

///|
/// Go back in history
pub async fn Page::goBack(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("goBack", [options])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) {
    None
  } else {
    Some(result |> @core.identity)
  }
}

///|
/// Go forward in history
pub async fn Page::goForward(
  self : Page,
  timeout? : Int,
  waitUntil? : String,
) -> Response? {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("goForward", [options])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) {
    None
  } else {
    Some(result |> @core.identity)
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
    |> @core.identity
  promise.wait()
}

///|
/// Get page content (HTML)
pub async fn Page::content(self : Page) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("content", [])
    |> @core.identity
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
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setContent", [@core.any(html), options])
    |> @core.identity
  promise.wait()
}

///| Locator Methods

///|
/// Get locator for CSS selector or text
pub fn Page::locator(self : Page, selector : String) -> Locator {
  self.to_any()._call("locator", [@core.any(selector)]) |> @core.identity
}

///|
/// Get locator by role
pub fn Page::getByRole(
  self : Page,
  role : String,
  name? : String,
  exact? : Bool,
) -> Locator {
  let options = @core.new_object()
  if name is Some(v) {
    options["name"] = @core.any(v)
  }
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByRole", [@core.any(role), options]) |> @core.identity
}

///|
/// Get locator by text
pub fn Page::getByText(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByText", [@core.any(text), options]) |> @core.identity
}

///|
/// Get locator by label
pub fn Page::getByLabel(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByLabel", [@core.any(text), options])
  |> @core.identity
}

///|
/// Get locator by placeholder
pub fn Page::getByPlaceholder(
  self : Page,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByPlaceholder", [@core.any(text), options])
  |> @core.identity
}

///|
/// Get locator by alt text
pub fn Page::getByAltText(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByAltText", [@core.any(text), options])
  |> @core.identity
}

///|
/// Get locator by title
pub fn Page::getByTitle(self : Page, text : String, exact? : Bool) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByTitle", [@core.any(text), options])
  |> @core.identity
}

///|
/// Get locator by test ID
pub fn Page::getByTestId(self : Page, testId : String) -> Locator {
  self.to_any()._call("getByTestId", [@core.any(testId)]) |> @core.identity
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
  let options = @core.new_object()
  if button is Some(v) {
    options["button"] = @core.any(v)
  }
  if clickCount is Some(v) {
    options["clickCount"] = @core.any(v)
  }
  if delay is Some(v) {
    options["delay"] = @core.any(v)
  }
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @core.any(@core.any(v))
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if position is Some((x, y)) {
    let pos = @core.new_object()
    pos["x"] = @core.any(x)
    pos["y"] = @core.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("click", [@core.any(selector), options])
    |> @core.identity
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
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("dblclick", [@core.any(selector), options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("fill", [@core.any(selector), @core.any(value), options])
    |> @core.identity
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
  let options = @core.new_object()
  if delay is Some(v) {
    options["delay"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@core.any(selector), @core.any(text), options])
    |> @core.identity
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
  let options = @core.new_object()
  if delay is Some(v) {
    options["delay"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("press", [@core.any(selector), @core.any(key), options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("check", [@core.any(selector), options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("uncheck", [@core.any(selector), options])
    |> @core.identity
  promise.wait()
}

///|
/// Select option(s) in dropdown
pub async fn Page::selectOption(
  self : Page,
  selector : String,
  values : @core.Any,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Array[String] {
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("selectOption", [@core.any(selector), @core.any(values), options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @core.any(@core.any(v))
  }
  if position is Some((x, y)) {
    let pos = @core.new_object()
    pos["x"] = @core.any(x)
    pos["y"] = @core.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("hover", [@core.any(selector), options])
    |> @core.identity
  promise.wait()
}

///|
/// Focus element
pub async fn Page::focus(
  self : Page,
  selector : String,
  timeout? : Int,
) -> Unit {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("focus", [@core.any(selector), options])
    |> @core.identity
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
) -> @core.Any {
  let options = @core.new_object()
  if state is Some(v) {
    options["state"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if strict is Some(v) {
    options["strict"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("waitForSelector", [@core.any(selector), options])
    |> @core.identity
  promise.wait()
}

///|
/// Wait for load state
pub async fn Page::waitForLoadState(
  self : Page,
  state? : String,
  timeout? : Int,
) -> Unit {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = match state {
    Some(s) =>
      self.to_any()._call("waitForLoadState", [@core.any(s), options])
      |> @core.identity
    None => self.to_any()._call("waitForLoadState", [options]) |> @core.identity
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
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if url is Some(v) {
    options["url"] = @core.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("waitForNavigation", [options])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) {
    None
  } else {
    Some(result |> @core.identity)
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
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if waitUntil is Some(v) {
    options["waitUntil"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("waitForURL", [@core.any(url), options])
    |> @core.identity
  promise.wait()
}

///|
/// Wait for timeout
pub async fn Page::waitForTimeout(self : Page, timeout : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("waitForTimeout", [@core.any(timeout)])
    |> @core.identity
  promise.wait()
}

///|
/// Wait for function to return truthy value
pub async fn Page::waitForFunction(
  self : Page,
  pageFunction : String,
  arg? : @core.Any,
  polling? : Int,
  timeout? : Int,
) -> @core.Any {
  let options = @core.new_object()
  if polling is Some(v) {
    options["polling"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("waitForFunction", [@core.any(pageFunction), @core.any(a), options])
      |> @core.identity
    None =>
      self.to_any()._call("waitForFunction", [@core.any(pageFunction), options])
      |> @core.identity
  }
  promise.wait()
}

///| Evaluate Methods

///|
/// Evaluate JavaScript in page context
pub async fn Page::evaluate(
  self : Page,
  pageFunction : String,
  arg? : @core.Any,
) -> @core.Any {
  let promise : @js.Promise[@core.Any] = match arg {
    Some(a) =>
      self.to_any()._call("evaluate", [@core.any(pageFunction), @core.any(a)])
      |> @core.identity
    None =>
      self.to_any()._call("evaluate", [@core.any(pageFunction)])
      |> @core.identity
  }
  promise.wait()
}

///|
/// Evaluate JavaScript and return handle
pub async fn Page::evaluateHandle(
  self : Page,
  pageFunction : String,
  arg? : @core.Any,
) -> @core.Any {
  let promise : @js.Promise[@core.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("evaluateHandle", [@core.any(pageFunction), @core.any(a)])
      |> @core.identity
    None =>
      self.to_any()._call("evaluateHandle", [@core.any(pageFunction)])
      |> @core.identity
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
  clip? : @core.Any,
  omitBackground? : Bool,
  timeout? : Int,
  scale? : String,
) -> @core.Any {
  let options = @core.new_object()
  if path is Some(v) {
    options["path"] = @core.any(v)
  }
  if type_ is Some(v) {
    options["type"] = @core.any(v)
  }
  if quality is Some(v) {
    options["quality"] = @core.any(v)
  }
  if fullPage is Some(v) {
    options["fullPage"] = @core.any(v)
  }
  if clip is Some(v) {
    options["clip"] = @core.any(v)
  }
  if omitBackground is Some(v) {
    options["omitBackground"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if scale is Some(v) {
    options["scale"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("screenshot", [options])
    |> @core.identity
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
  margin? : @core.Any,
  preferCSSPageSize? : Bool,
) -> @core.Any {
  let options = @core.new_object()
  if path is Some(v) {
    options["path"] = @core.any(v)
  }
  if scale is Some(v) {
    options["scale"] = @core.any(v)
  }
  if displayHeaderFooter is Some(v) {
    options["displayHeaderFooter"] = @core.any(v)
  }
  if headerTemplate is Some(v) {
    options["headerTemplate"] = @core.any(v)
  }
  if footerTemplate is Some(v) {
    options["footerTemplate"] = @core.any(v)
  }
  if printBackground is Some(v) {
    options["printBackground"] = @core.any(v)
  }
  if landscape is Some(v) {
    options["landscape"] = @core.any(v)
  }
  if pageRanges is Some(v) {
    options["pageRanges"] = @core.any(v)
  }
  if format is Some(v) {
    options["format"] = @core.any(v)
  }
  if width is Some(v) {
    options["width"] = @core.any(v)
  }
  if height is Some(v) {
    options["height"] = @core.any(v)
  }
  if margin is Some(v) {
    options["margin"] = @core.any(v)
  }
  if preferCSSPageSize is Some(v) {
    options["preferCSSPageSize"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self.to_any()._call("pdf", [options])
    |> @core.identity
  promise.wait()
}

///| Page Management

///|
/// Close page
pub async fn Page::close(self : Page, runBeforeUnload? : Bool) -> Unit {
  let options = @core.new_object()
  if runBeforeUnload is Some(v) {
    options["runBeforeUnload"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("close", [options])
    |> @core.identity
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
    |> @core.identity
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
    |> @core.identity
  promise.wait()
}

///|
/// Set viewport size
pub async fn Page::setViewportSize(
  self : Page,
  width : Int,
  height : Int,
) -> Unit {
  let viewport = @core.new_object()
  viewport["width"] = @core.any(width)
  viewport["height"] = @core.any(height)
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setViewportSize", [viewport])
    |> @core.identity
  promise.wait()
}

///|
/// Get viewport size
pub fn Page::viewportSize(self : Page) -> (Int, Int)? {
  let result = self.to_any()._call("viewportSize", [])
  if @core.is_nullish(result) {
    None
  } else {
    let width : Int = result["width"].cast()
    let height : Int = result["height"].cast()
    Some((width, height))
  }
}

///|
/// Set extra HTTP headers
pub async fn Page::setExtraHTTPHeaders(
  self : Page,
  headers : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setExtraHTTPHeaders", [@core.any(headers)])
    |> @core.identity
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
) -> @core.Any {
  let options = @core.new_object()
  if url is Some(v) {
    options["url"] = @core.any(v)
  }
  if path is Some(v) {
    options["path"] = @core.any(v)
  }
  if content is Some(v) {
    options["content"] = @core.any(v)
  }
  if type_ is Some(v) {
    options["type"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("addScriptTag", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Add style tag
pub async fn Page::addStyleTag(
  self : Page,
  url? : String,
  path? : String,
  content? : String,
) -> @core.Any {
  let options = @core.new_object()
  if url is Some(v) {
    options["url"] = @core.any(v)
  }
  if path is Some(v) {
    options["path"] = @core.any(v)
  }
  if content is Some(v) {
    options["content"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("addStyleTag", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Expose function to page
pub async fn Page::exposeFunction(
  self : Page,
  name : String,
  callback : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("exposeFunction", [@core.any(name), @core.any(callback)])
    |> @core.identity
  promise.wait()
}

///|
/// Set default navigation timeout
pub fn Page::setDefaultNavigationTimeout(self : Page, timeout : Int) -> Unit {
  self.to_any()._call("setDefaultNavigationTimeout", [@core.any(timeout)])
  |> ignore
}

///|
/// Set default timeout
pub fn Page::setDefaultTimeout(self : Page, timeout : Int) -> Unit {
  self.to_any()._call("setDefaultTimeout", [@core.any(timeout)]) |> ignore
}
