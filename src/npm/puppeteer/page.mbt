///|
/// Page type
#external
pub type Page

///|
pub fn Page::to_any(self : Page) -> @core.Any = "%identity"

///|
/// ElementHandle type
#external
pub type ElementHandle

///|
pub fn ElementHandle::to_any(self : ElementHandle) -> @core.Any = "%identity"

///| Page methods (basic)

///|
/// Page: Navigate to URL
pub async fn Page::goto(self : Page, url : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("goto", [@core.any(url)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Get page content
pub async fn Page::content(self : Page) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("content", [])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Take screenshot
pub async fn Page::screenshot(self : Page, path : String) -> Unit {
  let opts = @core.from_entries([("path", @core.any(path))])
  let promise : @js.Promise[Unit] = self.to_any()._call("screenshot", [opts])
    |> @core.identity
  promise.wait()
}

///| Page methods (element interaction)

///|
/// Page: Click on element
pub async fn Page::click(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("click", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Type text into element
pub async fn Page::type_(self : Page, selector : String, text : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@core.any(selector), @core.any(text)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Wait for selector
/// JS: page.waitForSelector(selector)
pub async fn Page::waitForSelector(
  self : Page,
  selector : String,
) -> ElementHandle? {
  let promise : @js.Promise[ElementHandle?] = self
    .to_any()
    ._call("waitForSelector", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Query selector (alias for $)
/// JS: page.$(selector)
pub async fn Page::query_selector(
  self : Page,
  selector : String,
) -> ElementHandle? {
  let promise : @js.Promise[ElementHandle?] = self
    .to_any()
    ._call("$", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Query selector all (alias for $$)
/// JS: page.$$(selector)
pub async fn Page::query_selector_all(
  self : Page,
  selector : String,
) -> Array[ElementHandle] {
  let promise : @js.Promise[Array[ElementHandle]] = self
    .to_any()
    ._call("$$", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Evaluate JavaScript in page context
pub async fn Page::evaluate(self : Page, script : String) -> @core.Any {
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("evaluate", [@core.any(script)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Set viewport size
/// JS: page.setViewport({ width, height })
pub async fn Page::setViewport(self : Page, width : Int, height : Int) -> Unit {
  let viewport = @core.from_entries([
    ("width", @core.any(width)),
    ("height", @core.any(height)),
  ])
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setViewport", [viewport])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Set user agent
pub async fn Page::setUserAgent(self : Page, userAgent : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setUserAgent", [@core.any(userAgent)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Reload page
pub async fn Page::reload(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("reload", [])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Get page title
pub async fn Page::title(self : Page) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("title", [])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Get page URL
pub fn Page::url(self : Page) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// Page: Focus on element
pub async fn Page::focus(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("focus", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Hover over element
pub async fn Page::hover(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("hover", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Select options in a <select> element
/// JS: page.select(selector, ...values)
pub async fn Page::select(
  self : Page,
  selector : String,
  values : Array[String],
) -> Array[String] {
  let js_values = @core.any(values)
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("select", [@core.any(selector), @core.any(js_values)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Tap on element (touch event)
pub async fn Page::tap(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("tap", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///| Page methods (waiting)

///|
/// Page: Wait for navigation
/// JS: page.waitForNavigation()
pub async fn Page::waitForNavigation(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("waitForNavigation", [])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Wait for function to return truthy value
/// JS: page.waitForFunction(pageFunction)
pub async fn Page::waitForFunction(self : Page, fn_str : String) -> @core.Any {
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("waitForFunction", [@core.any(fn_str)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Wait for timeout (milliseconds)
/// JS: page.waitForTimeout(milliseconds)
pub async fn Page::waitForTimeout(self : Page, ms : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("waitForTimeout", [@core.any(ms)])
    |> @core.identity
  promise.wait()
}

///| Page methods (cookies)

///|
/// Cookie type
pub(all) struct Cookie {
  name : String
  value : String
  domain : String?
  path : String?
  expires : Double?
  httpOnly : Bool?
  secure : Bool?
  sameSite : String?
} derive(Show)

///|
/// Page: Get cookies
/// JS: page.cookies()
pub async fn Page::cookies(self : Page) -> Array[@core.Any] {
  let promise : @js.Promise[Array[@core.Any]] = self
    .to_any()
    ._call("cookies", [])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Set cookies
/// JS: page.setCookie(...cookies)
pub async fn Page::setCookie(self : Page, cookies : Array[@core.Any]) -> Unit {
  let js_cookies = @core.any(cookies)
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setCookie", [@core.any(js_cookies)])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Delete cookies
/// JS: page.deleteCookie(...cookies)
pub async fn Page::deleteCookie(
  self : Page,
  cookies : Array[@core.Any],
) -> Unit {
  let js_cookies = @core.any(cookies)
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("deleteCookie", [@core.any(js_cookies)])
    |> @core.identity
  promise.wait()
}

///| Page methods (PDF)

///|
/// Page: Generate PDF with options
/// JS: page.pdf({ path })
pub async fn Page::pdf(self : Page, path : String) -> Unit {
  let opts = @core.from_entries([("path", @core.any(path))])
  let promise : @js.Promise[Unit] = self.to_any()._call("pdf", [opts])
    |> @core.identity
  promise.wait()
}

///| Page methods (navigation history)

///|
/// Page: Go back in history
/// JS: page.goBack()
pub async fn Page::goBack(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("goBack", [])
    |> @core.identity
  promise.wait()
}

///|
/// Page: Go forward in history
/// JS: page.goForward()
pub async fn Page::goForward(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("goForward", [])
    |> @core.identity
  promise.wait()
}

///| Page methods (content manipulation)

///|
/// Page: Set content HTML
/// JS: page.setContent(html)
pub async fn Page::setContent(self : Page, html : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setContent", [@core.any(html)])
    |> @core.identity
  promise.wait()
}

///| ElementHandle methods

///|
/// ElementHandle: Click element
pub async fn ElementHandle::click(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("click", [])
    |> @core.identity
  promise.wait()
}

///|
/// ElementHandle: Type text
pub async fn ElementHandle::type_(self : ElementHandle, text : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@core.any(text)])
    |> @core.identity
  promise.wait()
}

///|
/// ElementHandle: Get element property
/// JS: element.getProperty(propertyName)
pub async fn ElementHandle::getProperty(
  self : ElementHandle,
  propertyName : String,
) -> @core.Any {
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("getProperty", [@core.any(propertyName)])
    |> @core.identity
  promise.wait()
}

///|
/// ElementHandle: Query selector within element
/// JS: element.$(selector)
pub async fn ElementHandle::query_selector(
  self : ElementHandle,
  selector : String,
) -> ElementHandle? {
  let promise : @js.Promise[ElementHandle?] = self
    .to_any()
    ._call("$", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// ElementHandle: Query selector all within element
/// JS: element.$$(selector)
pub async fn ElementHandle::query_selector_all(
  self : ElementHandle,
  selector : String,
) -> Array[ElementHandle] {
  let promise : @js.Promise[Array[ElementHandle]] = self
    .to_any()
    ._call("$$", [@core.any(selector)])
    |> @core.identity
  promise.wait()
}

///|
/// ElementHandle: Focus on element
pub async fn ElementHandle::focus(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("focus", [])
    |> @core.identity
  promise.wait()
}

///|
/// ElementHandle: Hover over element
pub async fn ElementHandle::hover(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("hover", [])
    |> @core.identity
  promise.wait()
}
