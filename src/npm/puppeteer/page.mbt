///|
/// Page type
#external
pub type Page

///|
pub fn Page::to_any(self : Page) -> @nostd.Any = "%identity"

///|
/// ElementHandle type
#external
pub type ElementHandle

///|
pub fn ElementHandle::to_any(self : ElementHandle) -> @nostd.Any = "%identity"

///| Page methods (basic)

///|
/// Page: Navigate to URL
pub async fn Page::goto(self : Page, url : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("goto", [@nostd.any(url)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Get page content
pub async fn Page::content(self : Page) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("content", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Take screenshot
pub async fn Page::screenshot(self : Page, path : String) -> Unit {
  let opts = @nostd.from_entries([("path", @nostd.any(path))])
  let promise : @js.Promise[Unit] = self.to_any()._call("screenshot", [opts])
    |> @nostd.identity
  promise.wait()
}

///| Page methods (element interaction)

///|
/// Page: Click on element
pub async fn Page::click(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("click", [@nostd.any(selector)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Type text into element
pub async fn Page::type_(self : Page, selector : String, text : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@nostd.any(selector), @nostd.any(text)])
    |> @nostd.identity
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
    ._call("waitForSelector", [@nostd.any(selector)])
    |> @nostd.identity
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
    ._call("$", [@nostd.any(selector)])
    |> @nostd.identity
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
    ._call("$$", [@nostd.any(selector)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Evaluate JavaScript in page context
pub async fn Page::evaluate(self : Page, script : String) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("evaluate", [@nostd.any(script)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Set viewport size
/// JS: page.setViewport({ width, height })
pub async fn Page::setViewport(self : Page, width : Int, height : Int) -> Unit {
  let viewport = @nostd.from_entries([
    ("width", @nostd.any(width)),
    ("height", @nostd.any(height)),
  ])
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setViewport", [viewport])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Set user agent
pub async fn Page::setUserAgent(self : Page, userAgent : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setUserAgent", [@nostd.any(userAgent)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Reload page
pub async fn Page::reload(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("reload", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Get page title
pub async fn Page::title(self : Page) -> String {
  let promise : @js.Promise[String] = self.to_any()._call("title", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Get page URL
pub fn Page::url(self : Page) -> String {
  self.to_any()._call("url", []).cast()
}

///|
/// Page: Focus on element
pub async fn Page::focus(
  self : Page,
  selector : String,
) -> Unit raise @js.ThrowError {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("focus", [@nostd.any(selector)])
    |> @nostd.identity
  promise.wait() catch {
    e => raise @js.ThrowError::from(@js.unsafe_any(e))
  }
}

///|
/// Page: Hover over element
pub async fn Page::hover(
  self : Page,
  selector : String,
) -> Unit raise @js.ThrowError {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("hover", [@nostd.any(selector)])
    |> @nostd.identity
  promise.wait() catch {
    e => raise @js.ThrowError::from(@js.unsafe_any(e))
  }
}

///|
/// Page: Select options in a <select> element
/// JS: page.select(selector, ...values)
pub async fn Page::select(
  self : Page,
  selector : String,
  values : Array[String],
) -> Array[String] raise @js.ThrowError {
  let js_values = @js.from_array(values)
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("select", [@nostd.any(selector), @nostd.any(js_values)])
    |> @nostd.identity
  promise.wait() catch {
    e => raise @js.ThrowError::from(@js.unsafe_any(e))
  }
}

///|
/// Page: Tap on element (touch event)
pub async fn Page::tap(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("tap", [@nostd.any(selector)])
    |> @nostd.identity
  promise.wait()
}

///| Page methods (waiting)

///|
/// Page: Wait for navigation
/// JS: page.waitForNavigation()
pub async fn Page::waitForNavigation(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("waitForNavigation", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Wait for function to return truthy value
/// JS: page.waitForFunction(pageFunction)
pub async fn Page::waitForFunction(self : Page, fn_str : String) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("waitForFunction", [@nostd.any(fn_str)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Wait for timeout (milliseconds)
/// JS: page.waitForTimeout(milliseconds)
pub async fn Page::waitForTimeout(self : Page, ms : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("waitForTimeout", [@nostd.any(ms)])
    |> @nostd.identity
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
pub async fn Page::cookies(
  self : Page,
) -> Array[@nostd.Any] raise @js.ThrowError {
  let promise : @js.Promise[Array[@nostd.Any]] = self
    .to_any()
    ._call("cookies", [])
    |> @nostd.identity
  promise.wait() catch {
    e => raise @js.ThrowError::from(@js.unsafe_any(e))
  }
}

///|
/// Page: Set cookies
/// JS: page.setCookie(...cookies)
pub async fn Page::setCookie(self : Page, cookies : Array[@nostd.Any]) -> Unit {
  let js_cookies = @js.from_array(cookies)
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setCookie", [@nostd.any(js_cookies)])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Delete cookies
/// JS: page.deleteCookie(...cookies)
pub async fn Page::deleteCookie(
  self : Page,
  cookies : Array[@nostd.Any],
) -> Unit {
  let js_cookies = @js.from_array(cookies)
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("deleteCookie", [@nostd.any(js_cookies)])
    |> @nostd.identity
  promise.wait()
}

///| Page methods (PDF)

///|
/// Page: Generate PDF with options
/// JS: page.pdf({ path })
pub async fn Page::pdf(self : Page, path : String) -> Unit raise @js.ThrowError {
  let opts = @nostd.from_entries([("path", @nostd.any(path))])
  let promise : @js.Promise[Unit] = self.to_any()._call("pdf", [opts])
    |> @nostd.identity
  promise.wait() catch {
    e => raise @js.ThrowError::from(@js.unsafe_any(e))
  }
}

///| Page methods (navigation history)

///|
/// Page: Go back in history
/// JS: page.goBack()
pub async fn Page::goBack(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("goBack", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Page: Go forward in history
/// JS: page.goForward()
pub async fn Page::goForward(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("goForward", [])
    |> @nostd.identity
  promise.wait()
}

///| Page methods (content manipulation)

///|
/// Page: Set content HTML
/// JS: page.setContent(html)
pub async fn Page::setContent(self : Page, html : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setContent", [@nostd.any(html)])
    |> @nostd.identity
  promise.wait()
}

///| ElementHandle methods

///|
/// ElementHandle: Click element
pub async fn ElementHandle::click(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("click", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// ElementHandle: Type text
pub async fn ElementHandle::type_(self : ElementHandle, text : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@nostd.any(text)])
    |> @nostd.identity
  promise.wait()
}

///|
/// ElementHandle: Get element property
/// JS: element.getProperty(propertyName)
pub async fn ElementHandle::getProperty(
  self : ElementHandle,
  propertyName : String,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("getProperty", [@nostd.any(propertyName)])
    |> @nostd.identity
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
    ._call("$", [@nostd.any(selector)])
    |> @nostd.identity
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
    ._call("$$", [@nostd.any(selector)])
    |> @nostd.identity
  promise.wait()
}

///|
/// ElementHandle: Focus on element
pub async fn ElementHandle::focus(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("focus", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// ElementHandle: Hover over element
pub async fn ElementHandle::hover(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("hover", [])
    |> @nostd.identity
  promise.wait()
}
