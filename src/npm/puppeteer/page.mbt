///|
/// Page type
#external
pub type Page

///|
pub impl @js.JsImpl for Page

///|
/// ElementHandle type
#external
pub type ElementHandle

///|
pub impl @js.JsImpl for ElementHandle

///| Page methods (basic)

///|
/// Page: Navigate to URL
pub async fn Page::goto(self : Page, url : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("goto", [url]))
  promise.wait()
}

///|
/// Page: Get page content
pub async fn Page::content(self : Page) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("content", []))
  promise.wait()
}

///|
/// Page: Take screenshot
pub async fn Page::screenshot(self : Page, path : String) -> Unit {
  let opts = @js.from_map({ "path": @js.any(path) })
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("screenshot", [opts]),
  )
  promise.wait()
}

///| Page methods (element interaction)

///|
/// Page: Click on element
pub async fn Page::click(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("click", [selector]))
  promise.wait()
}

///|
/// Page: Type text into element
pub async fn Page::type_(self : Page, selector : String, text : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("type", [selector, text]),
  )
  promise.wait()
}

///|
/// Page: Wait for selector
/// JS: page.waitForSelector(selector)
pub async fn Page::waitForSelector(
  self : Page,
  selector : String,
) -> ElementHandle? {
  let promise : @js.Promise[ElementHandle?] = @js.identity(
    self.call("waitForSelector", [selector]),
  )
  promise.wait()
}

///|
/// Page: Query selector (alias for $)
/// JS: page.$(selector)
pub async fn Page::query_selector(
  self : Page,
  selector : String,
) -> ElementHandle? {
  let promise : @js.Promise[ElementHandle?] = @js.identity(
    self.call("$", [selector]),
  )
  promise.wait()
}

///|
/// Page: Query selector all (alias for $$)
/// JS: page.$$(selector)
pub async fn Page::query_selector_all(
  self : Page,
  selector : String,
) -> Array[ElementHandle] {
  let promise : @js.Promise[Array[ElementHandle]] = @js.identity(
    self.call("$$", [selector]),
  )
  promise.wait()
}

///|
/// Page: Evaluate JavaScript in page context
pub async fn Page::evaluate(self : Page, script : String) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("evaluate", [script]),
  )
  promise.wait()
}

///|
/// Page: Set viewport size
/// JS: page.setViewport({ width, height })
pub async fn Page::setViewport(self : Page, width : Int, height : Int) -> Unit {
  let viewport = @js.from_map({
    "width": @js.any(width),
    "height": @js.any(height),
  })
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setViewport", [viewport]),
  )
  promise.wait()
}

///|
/// Page: Set user agent
pub async fn Page::setUserAgent(self : Page, userAgent : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setUserAgent", [userAgent]),
  )
  promise.wait()
}

///|
/// Page: Reload page
pub async fn Page::reload(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("reload", []))
  promise.wait()
}

///|
/// Page: Get page title
pub async fn Page::title(self : Page) -> String {
  let promise : @js.Promise[String] = @js.identity(self.call("title", []))
  promise.wait()
}

///|
/// Page: Get page URL
pub fn Page::url(self : Page) -> String {
  self.call("url", []).cast()
}

///|
/// Page: Focus on element
pub async fn Page::focus(
  self : Page,
  selector : String,
) -> Unit raise @js.ThrowError {
  let promise : @js.Promise[Unit] = @js.identity(self.call("focus", [selector]))
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_any(e))
  }
}

///|
/// Page: Hover over element
pub async fn Page::hover(
  self : Page,
  selector : String,
) -> Unit raise @js.ThrowError {
  let promise : @js.Promise[Unit] = @js.identity(self.call("hover", [selector]))
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_any(e))
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
  let promise : @js.Promise[Array[String]] = @js.identity(
    self.call("select", [selector, js_values]),
  )
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_any(e))
  }
}

///|
/// Page: Tap on element (touch event)
pub async fn Page::tap(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("tap", [selector]))
  promise.wait()
}

///| Page methods (waiting)

///|
/// Page: Wait for navigation
/// JS: page.waitForNavigation()
pub async fn Page::waitForNavigation(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("waitForNavigation", []),
  )
  promise.wait()
}

///|
/// Page: Wait for function to return truthy value
/// JS: page.waitForFunction(pageFunction)
pub async fn Page::waitForFunction(self : Page, fn_str : String) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("waitForFunction", [fn_str]),
  )
  promise.wait()
}

///|
/// Page: Wait for timeout (milliseconds)
/// JS: page.waitForTimeout(milliseconds)
pub async fn Page::waitForTimeout(self : Page, ms : Int) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("waitForTimeout", [ms]),
  )
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
pub async fn Page::cookies(self : Page) -> Array[@js.Any] raise @js.ThrowError {
  let promise : @js.Promise[Array[@js.Any]] = @js.identity(
    self.call("cookies", []),
  )
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_any(e))
  }
}

///|
/// Page: Set cookies
/// JS: page.setCookie(...cookies)
pub async fn Page::setCookie(self : Page, cookies : Array[@js.Any]) -> Unit {
  let js_cookies = @js.from_array(cookies)
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setCookie", [js_cookies]),
  )
  promise.wait()
}

///|
/// Page: Delete cookies
/// JS: page.deleteCookie(...cookies)
pub async fn Page::deleteCookie(self : Page, cookies : Array[@js.Any]) -> Unit {
  let js_cookies = @js.from_array(cookies)
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("deleteCookie", [js_cookies]),
  )
  promise.wait()
}

///| Page methods (PDF)

///|
/// Page: Generate PDF with options
/// JS: page.pdf({ path })
pub async fn Page::pdf(self : Page, path : String) -> Unit raise @js.ThrowError {
  let opts = @js.from_map({ "path": @js.any(path) })
  let promise : @js.Promise[Unit] = @js.identity(self.call("pdf", [opts]))
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_any(e))
  }
}

///| Page methods (navigation history)

///|
/// Page: Go back in history
/// JS: page.goBack()
pub async fn Page::goBack(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("goBack", []))
  promise.wait()
}

///|
/// Page: Go forward in history
/// JS: page.goForward()
pub async fn Page::goForward(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("goForward", []))
  promise.wait()
}

///| Page methods (content manipulation)

///|
/// Page: Set content HTML
/// JS: page.setContent(html)
pub async fn Page::setContent(self : Page, html : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setContent", [html]),
  )
  promise.wait()
}

///| ElementHandle methods

///|
/// ElementHandle: Click element
pub async fn ElementHandle::click(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("click", []))
  promise.wait()
}

///|
/// ElementHandle: Type text
pub async fn ElementHandle::type_(self : ElementHandle, text : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("type", [text]))
  promise.wait()
}

///|
/// ElementHandle: Get element property
/// JS: element.getProperty(propertyName)
pub async fn ElementHandle::getProperty(
  self : ElementHandle,
  propertyName : String,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("getProperty", [propertyName]),
  )
  promise.wait()
}

///|
/// ElementHandle: Query selector within element
/// JS: element.$(selector)
pub async fn ElementHandle::query_selector(
  self : ElementHandle,
  selector : String,
) -> ElementHandle? {
  let promise : @js.Promise[ElementHandle?] = @js.identity(
    self.call("$", [selector]),
  )
  promise.wait()
}

///|
/// ElementHandle: Query selector all within element
/// JS: element.$$(selector)
pub async fn ElementHandle::query_selector_all(
  self : ElementHandle,
  selector : String,
) -> Array[ElementHandle] {
  let promise : @js.Promise[Array[ElementHandle]] = @js.identity(
    self.call("$$", [selector]),
  )
  promise.wait()
}

///|
/// ElementHandle: Focus on element
pub async fn ElementHandle::focus(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("focus", []))
  promise.wait()
}

///|
/// ElementHandle: Hover over element
pub async fn ElementHandle::hover(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("hover", []))
  promise.wait()
}
