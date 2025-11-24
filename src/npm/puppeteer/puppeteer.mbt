///|
/// Puppeteer bindings for Node.js
/// https://pptr.dev/

///|
/// Browser instance
#external
pub type Browser

///|
pub impl @js.JsImpl for Browser

///|
/// Page instance
#external
pub type Page

///|
pub impl @js.JsImpl for Page

///|
/// FFI: Launch browser with options
extern "js" fn ffi_launch(options : @js.Js) -> @js.Js =
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
  env? : @js.Js,
  pipe? : Bool,
  ignoreDefaultArgs? : Bool,
  waitForInitialPage? : Bool,
  debuggingPort? : Int,
  handleSIGHUP? : Bool,
  handleSIGINT? : Bool,
  handleSIGTERM? : Bool,
) -> Browser {
  let js_opts = @js.from_entries([])
  match headless {
    Some(h) => js_opts.set("headless", @js.js(h))
    None => ()
  }
  match args {
    Some(a) => js_opts.set("args", @js.from_array(a))
    None => ()
  }
  match executablePath {
    Some(p) => js_opts.set("executablePath", @js.js(p))
    None => ()
  }
  match devtools {
    Some(d) => js_opts.set("devtools", @js.js(d))
    None => ()
  }
  match timeout {
    Some(t) => js_opts.set("timeout", @js.js(t))
    None => ()
  }
  match userDataDir {
    Some(u) => js_opts.set("userDataDir", @js.js(u))
    None => ()
  }
  match dumpio {
    Some(d) => js_opts.set("dumpio", @js.js(d))
    None => ()
  }
  match env {
    Some(e) => js_opts.set("env", e)
    None => ()
  }
  match pipe {
    Some(p) => js_opts.set("pipe", @js.js(p))
    None => ()
  }
  match ignoreDefaultArgs {
    Some(i) => js_opts.set("ignoreDefaultArgs", @js.js(i))
    None => ()
  }
  match waitForInitialPage {
    Some(w) => js_opts.set("waitForInitialPage", @js.js(w))
    None => ()
  }
  match debuggingPort {
    Some(d) => js_opts.set("debuggingPort", @js.js(d))
    None => ()
  }
  match handleSIGHUP {
    Some(h) => js_opts.set("handleSIGHUP", @js.js(h))
    None => ()
  }
  match handleSIGINT {
    Some(h) => js_opts.set("handleSIGINT", @js.js(h))
    None => ()
  }
  match handleSIGTERM {
    Some(h) => js_opts.set("handleSIGTERM", @js.js(h))
    None => ()
  }
  let promise : @js.Promise[Browser] = @js.unsafe_cast(ffi_launch(js_opts))
  promise.wait()
}

///|
/// Browser: Create new page
pub async fn Browser::new_page(self : Browser) -> Page {
  let promise : @js.Promise[Page] = @js.unsafe_cast(self.call("newPage", []))
  promise.wait()
}

///|
/// Browser: Close browser
pub async fn Browser::close(self : Browser) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("close", []))
  promise.wait()
}

///|
/// Page: Navigate to URL
pub async fn Page::goto(self : Page, url : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("goto", [url]))
  promise.wait()
}

///|
/// Page: Get page content
pub async fn Page::content(self : Page) -> String {
  let promise : @js.Promise[String] = @js.unsafe_cast(self.call("content", []))
  promise.wait()
}

///|
/// Page: Take screenshot
pub async fn Page::screenshot(self : Page, path : String) -> Unit {
  let opts = @js.from_entries([("path", path)])
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("screenshot", [opts]),
  )
  promise.wait()
}

///| Browser methods (additional)

///|
/// Browser: Get all pages
pub async fn Browser::pages(self : Browser) -> Array[Page] {
  let promise : @js.Promise[Array[Page]] = @js.unsafe_cast(
    self.call("pages", []),
  )
  promise.wait()
}

///|
/// Browser: Get version
pub async fn Browser::version(self : Browser) -> String {
  let promise : @js.Promise[String] = @js.unsafe_cast(self.call("version", []))
  promise.wait()
}

///|
/// Browser: Get user agent
pub async fn Browser::userAgent(self : Browser) -> String {
  let promise : @js.Promise[String] = @js.unsafe_cast(
    self.call("userAgent", []),
  )
  promise.wait()
}

///| Page methods (additional)

///|
/// ElementHandle type
#external
pub type ElementHandle

///|
pub impl @js.JsImpl for ElementHandle

///|
/// Page: Click on element
pub async fn Page::click(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("click", [selector]),
  )
  promise.wait()
}

///|
/// Page: Type text into element
pub async fn Page::type_(self : Page, selector : String, text : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
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
  let promise : @js.Promise[ElementHandle?] = @js.unsafe_cast(
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
  let promise : @js.Promise[ElementHandle?] = @js.unsafe_cast(
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
  let promise : @js.Promise[Array[ElementHandle]] = @js.unsafe_cast(
    self.call("$$", [selector]),
  )
  promise.wait()
}

///|
/// Page: Evaluate JavaScript in page context
pub async fn Page::evaluate(self : Page, script : String) -> @js.Js {
  let promise : @js.Promise[@js.Js] = @js.unsafe_cast(
    self.call("evaluate", [script]),
  )
  promise.wait()
}

///|
/// Page: Set viewport size
/// JS: page.setViewport({ width, height })
pub async fn Page::setViewport(self : Page, width : Int, height : Int) -> Unit {
  let viewport = @js.from_entries([("width", width), ("height", height)])
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("setViewport", [viewport]),
  )
  promise.wait()
}

///|
/// Page: Set user agent
pub async fn Page::setUserAgent(self : Page, userAgent : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("setUserAgent", [userAgent]),
  )
  promise.wait()
}

///|
/// Page: Reload page
pub async fn Page::reload(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("reload", []))
  promise.wait()
}

///|
/// Page: Get page title
pub async fn Page::title(self : Page) -> String {
  let promise : @js.Promise[String] = @js.unsafe_cast(self.call("title", []))
  promise.wait()
}

///|
/// Page: Get page URL
pub fn Page::url(self : Page) -> String {
  self.call("url", []) |> @js.unsafe_cast
}

///| ElementHandle methods

///|
/// ElementHandle: Click element
pub async fn ElementHandle::click(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("click", []))
  promise.wait()
}

///|
/// ElementHandle: Type text
pub async fn ElementHandle::type_(self : ElementHandle, text : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("type", [text]))
  promise.wait()
}

///| Page methods (interaction)

///|
/// Page: Focus on element
pub async fn Page::focus(
  self : Page,
  selector : String,
) -> Unit raise @js.ThrowError {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("focus", [selector]),
  )
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_js(e))
  }
}

///|
/// Page: Hover over element
pub async fn Page::hover(
  self : Page,
  selector : String,
) -> Unit raise @js.ThrowError {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("hover", [selector]),
  )
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_js(e))
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
  let promise : @js.Promise[Array[String]] = @js.unsafe_cast(
    self.call("select", [selector, js_values]),
  )
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_js(e))
  }
}

///|
/// Page: Tap on element (touch event)
pub async fn Page::tap(self : Page, selector : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("tap", [selector]),
  )
  promise.wait()
}

///| Page methods (waiting)

///|
/// Page: Wait for navigation
/// JS: page.waitForNavigation()
pub async fn Page::waitForNavigation(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("waitForNavigation", []),
  )
  promise.wait()
}

///|
/// Page: Wait for function to return truthy value
/// JS: page.waitForFunction(pageFunction)
pub async fn Page::waitForFunction(self : Page, fn_str : String) -> @js.Js {
  let promise : @js.Promise[@js.Js] = @js.unsafe_cast(
    self.call("waitForFunction", [fn_str]),
  )
  promise.wait()
}

///|
/// Page: Wait for timeout (milliseconds)
/// JS: page.waitForTimeout(milliseconds)
pub async fn Page::waitForTimeout(self : Page, ms : Int) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
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
pub async fn Page::cookies(self : Page) -> Array[@js.Js] raise @js.ThrowError {
  let promise : @js.Promise[Array[@js.Js]] = @js.unsafe_cast(
    self.call("cookies", []),
  )
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_js(e))
  }
}

///|
/// Page: Set cookies
/// JS: page.setCookie(...cookies)
pub async fn Page::setCookie(self : Page, cookies : Array[@js.Js]) -> Unit {
  let js_cookies = @js.from_array(cookies)
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("setCookie", [js_cookies]),
  )
  promise.wait()
}

///|
/// Page: Delete cookies
/// JS: page.deleteCookie(...cookies)
pub async fn Page::deleteCookie(self : Page, cookies : Array[@js.Js]) -> Unit {
  let js_cookies = @js.from_array(cookies)
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("deleteCookie", [js_cookies]),
  )
  promise.wait()
}

///| Page methods (PDF)

///|
/// Page: Generate PDF with options
/// JS: page.pdf({ path })
pub async fn Page::pdf(self : Page, path : String) -> Unit raise @js.ThrowError {
  let opts = @js.from_entries([("path", path)])
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("pdf", [opts]))
  promise.wait() catch {
    e => raise @js.ThrowError::from_js(@js.unsafe_js(e))
  }
}

///| Page methods (navigation history)

///|
/// Page: Go back in history
/// JS: page.goBack()
pub async fn Page::goBack(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("goBack", []))
  promise.wait()
}

///|
/// Page: Go forward in history
/// JS: page.goForward()
pub async fn Page::goForward(self : Page) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("goForward", []))
  promise.wait()
}

///| Page methods (content manipulation)

///|
/// Page: Set content HTML
/// JS: page.setContent(html)
pub async fn Page::setContent(self : Page, html : String) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("setContent", [html]),
  )
  promise.wait()
}

///| ElementHandle methods (additional)

///|
/// ElementHandle: Get element property
/// JS: element.getProperty(propertyName)
pub async fn ElementHandle::getProperty(
  self : ElementHandle,
  propertyName : String,
) -> @js.Js {
  let promise : @js.Promise[@js.Js] = @js.unsafe_cast(
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
  let promise : @js.Promise[ElementHandle?] = @js.unsafe_cast(
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
  let promise : @js.Promise[Array[ElementHandle]] = @js.unsafe_cast(
    self.call("$$", [selector]),
  )
  promise.wait()
}

///|
/// ElementHandle: Focus on element
pub async fn ElementHandle::focus(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("focus", []))
  promise.wait()
}

///|
/// ElementHandle: Hover over element
pub async fn ElementHandle::hover(self : ElementHandle) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("hover", []))
  promise.wait()
}
