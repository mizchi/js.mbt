# puppeteer

MoonBit bindings for Puppeteer - A headless Chrome/Chromium browser automation library.

## Installation

First, install puppeteer via npm:

```bash
npm install puppeteer
```

## Usage

### Basic Example

```moonbit
let browser = launch(headless=true)!
let page = browser.newPage()!
page.goto("https://example.com")!
let content = page.content()!
browser.close()!
```

### With Custom Arguments

```moonbit
let browser = launch(
  headless=true,
  args=["--no-sandbox", "--disable-setuid-sandbox"]
)!
let page = browser.newPage()!
page.goto("https://example.com")!
browser.close()!
```

### Advanced Launch Options

All [Puppeteer launch options](https://pptr.dev/api/puppeteer.launchoptions) are supported as labeled arguments:

```moonbit
let browser = launch(
  headless=true,
  executablePath="/path/to/chrome",
  devtools=true,
  timeout=60000,
  userDataDir="/path/to/user/data",
  dumpio=true,
  pipe=true,
  ignoreDefaultArgs=false,
  waitForInitialPage=true,
  debuggingPort=9222,
  handleSIGHUP=true,
  handleSIGINT=true,
  handleSIGTERM=true
)!
```

**Common Options:**
- `headless`: Run in headless mode (default: true in new headless mode)
- `args`: Additional command line arguments for Chrome/Chromium
- `executablePath`: Path to custom Chrome/Chromium executable
- `devtools`: Auto-open DevTools for each tab (forces headless=false)
- `timeout`: Maximum time in ms to wait for browser to start (default: 30000)
- `userDataDir`: Path to user data directory (for profiles, cookies, etc.)
- `dumpio`: Pipe browser stdout/stderr to process output
- `env`: Custom environment variables as `@js.Js` object
- `pipe`: Connect via pipe instead of WebSocket (Chrome only)
- `ignoreDefaultArgs`: Skip Puppeteer's default arguments
- `waitForInitialPage`: Wait for initial page before resolving (default: true)
- `debuggingPort`: Specify remote debugging port
- `handleSIGHUP/SIGINT/SIGTERM`: Handle process signals (default: true)

### Navigation

```moonbit
page.setViewport(1920, 1080)!
page.goto("https://example.com")!
page.reload()!
let title = page.title()!
let url = page.url()
```

### Element Interaction

```moonbit
page.click("#submit-button")!
page.type_("#username", "myuser")!
page.waitForSelector(".result")!
```

### Querying Elements

```moonbit
// Single element
let element = page.query_selector(".my-class")!
match element {
  Some(el) => el.click()!
  None => println("Element not found")
}

// Multiple elements
let elements = page.query_selector_all("div")!
```

### JavaScript Evaluation

```moonbit
let result = page.evaluate("() => document.title")!
```

### Screenshots & PDF

```moonbit
page.screenshot("screenshot.png")!
page.pdf("document.pdf")!
```

### Waiting Operations

```moonbit
// Wait for element
page.waitForSelector("#result")!

// Wait for navigation
page.click("#link")!
page.waitForNavigation()!

// Wait for timeout
page.waitForTimeout(1000)!

// Wait for function
page.waitForFunction("() => document.readyState === 'complete'")!
```

### Form Interaction

```moonbit
// Focus and type
page.focus("#username")!
page.type_("#username", "myuser")!

// Select dropdown
page.select("#country", ["USA"])!

// Hover over element
page.hover(".tooltip-trigger")!
```

### Navigation History

```moonbit
page.goBack()!
page.goForward()!
```

### Cookies

```moonbit
// Get cookies
let cookies = page.cookies()!

// Set cookies
let cookie = @js.from_entries([
  ("name", "session"),
  ("value", "abc123"),
  ("domain", ".example.com")
])
page.setCookie([cookie])!
```

### Browser Information

```moonbit
let version = browser.version()!
let userAgent = browser.userAgent()!
let pages = browser.pages()!
```

### Network Interception

See: [Network Interception Guide](https://pptr.dev/guides/network-interception)

```moonbit
// Enable request interception
page.setRequestInterception(true)!

// Listen to request events (using EventEmitter pattern)
// Example: Block images
page.on("request", fn(req: HTTPRequest) {
  if req.isInterceptResolutionHandled() {
    return
  }
  if req.resourceType() == "image" {
    req.abort()!
  } else {
    req.continue_()!
  }
})!

// Modify request headers
page.on("request", fn(req: HTTPRequest) {
  if req.isInterceptResolutionHandled() {
    return
  }
  let overrides = @js.from_entries([
    ("headers", @js.from_entries([
      ("User-Agent", "Custom User Agent")
    ]))
  ])
  req.continue_with(overrides)!
})!

// Mock response
page.on("request", fn(req: HTTPRequest) {
  if req.url().contains("/api/data") {
    let response = @js.from_entries([
      ("status", 200),
      ("contentType", "application/json"),
      ("body", "{\"mock\": true}")
    ])
    req.respond(response)!
  } else {
    req.continue_()!
  }
})!

// Inspect response
page.goto("https://example.com")!
let response = page.waitForNavigation()!
match response {
  Some(res) => {
    println("Status: \{res.status()}")
    println("OK: \{res.ok()}")
    let text = res.text()!
    println("Body: \{text}")
  }
  None => println("No response")
}
```

### Code Coverage

See: [Coverage API](https://pptr.dev/api/puppeteer.coverage)

```moonbit
// Get coverage instance
let coverage = page.coverage()

// Start tracking JS and CSS coverage
coverage.startJSCoverage()!
coverage.startCSSCoverage()!

// Navigate and interact with page
page.goto("https://example.com")!
// ... perform actions ...

// Stop coverage and get results
let jsCoverage = coverage.stopJSCoverage()!
let cssCoverage = coverage.stopCSSCoverage()!

println("JS coverage entries: \{jsCoverage.length()}")
println("CSS coverage entries: \{cssCoverage.length()}")

// Each entry contains: url, text (source), ranges (used code ranges)
```

**Coverage with options:**
```moonbit
// Start JS coverage with anonymous scripts reporting
let options = @js.from_entries([
  ("reportAnonymousScripts", true)
])
coverage.startJSCoverage_with(options)!
```

### Chrome DevTools Protocol (CDP) Session

See: [CDPSession API](https://pptr.dev/api/puppeteer.cdpsession)

```moonbit
// Create a CDP session
let session = page.createCDPSession()!

// Get session ID
let sessionId = session.id()
println("Session ID: \{sessionId}")

// Send CDP commands
let params = @js.from_entries([
  ("enabled", true)
])
session.send("Network.enable", params)!

// Send command without params
session.send_simple("Page.enable")!

// Detach when done
session.detach()!
```

**Common CDP Commands:**
```moonbit
// Enable network tracking
session.send_simple("Network.enable")!

// Set user agent override
let uaParams = @js.from_entries([
  ("userAgent", "Custom User Agent")
])
session.send("Network.setUserAgentOverride", uaParams)!

// Enable DOM snapshot
session.send_simple("DOMSnapshot.enable")!

// Take DOM snapshot
let snapshot = session.send_simple("DOMSnapshot.captureSnapshot")!
```

## API Reference

### Types

- `Browser` - Browser instance
- `Page` - Browser page/tab instance
- `ElementHandle` - Handle to a DOM element
- `HTTPRequest` - HTTP request object (for network interception)
- `HTTPResponse` - HTTP response object
- `Coverage` - Code coverage tracking
- `CoverageRange` - Range of used code (start, end)
- `JSCoverageEntry` - JavaScript coverage entry (url, text, ranges)
- `CSSCoverageEntry` - CSS coverage entry (url, text, ranges)
- `CDPSession` - Chrome DevTools Protocol session

### Browser Methods

- `launch(...)` - Launch a new browser instance with labeled arguments (see [LaunchOptions](https://pptr.dev/api/puppeteer.launchoptions))
  - `headless?` - Run in headless mode
  - `args?` - Additional Chrome/Chromium arguments
  - `executablePath?` - Path to custom executable
  - `devtools?` - Auto-open DevTools
  - `timeout?` - Launch timeout in milliseconds
  - `userDataDir?` - User data directory path
  - `dumpio?` - Pipe browser output to process
  - `env?` - Environment variables
  - `pipe?` - Use pipe instead of WebSocket
  - `ignoreDefaultArgs?` - Skip default arguments
  - `waitForInitialPage?` - Wait for initial page
  - `debuggingPort?` - Remote debugging port
  - `handleSIGHUP?` - Handle SIGHUP signal
  - `handleSIGINT?` - Handle SIGINT signal
  - `handleSIGTERM?` - Handle SIGTERM signal
- `Browser::newPage()` - Create a new page
- `Browser::close()` - Close the browser
- `Browser::pages()` - Get all open pages
- `Browser::version()` - Get browser version
- `Browser::userAgent()` - Get browser user agent

### Page Methods

#### Navigation
- `Page::goto(url)` - Navigate to URL
- `Page::reload()` - Reload page
- `Page::goBack()` - Go back in history
- `Page::goForward()` - Go forward in history
- `Page::url()` - Get current URL

#### Content
- `Page::content()` - Get page HTML content
- `Page::setContent(html)` - Set page HTML content
- `Page::title()` - Get page title

#### Element Interaction
- `Page::click(selector)` - Click element
- `Page::type_(selector, text)` - Type into element
- `Page::focus(selector)` - Focus on element
- `Page::hover(selector)` - Hover over element
- `Page::select(selector, values)` - Select options in <select> element
- `Page::tap(selector)` - Tap element (touch event)

#### Element Querying
- `Page::query_selector(selector)` - Query single element
- `Page::query_selector_all(selector)` - Query multiple elements
- `Page::waitForSelector(selector)` - Wait for element

#### Waiting
- `Page::waitForNavigation()` - Wait for navigation
- `Page::waitForFunction(fn_str)` - Wait for function to return truthy
- `Page::waitForTimeout(ms)` - Wait for timeout

#### Evaluation
- `Page::evaluate(script)` - Execute JavaScript

#### Configuration
- `Page::setViewport(width, height)` - Set viewport size
- `Page::setUserAgent(userAgent)` - Set user agent

#### Cookies
- `Page::cookies()` - Get cookies
- `Page::setCookie(cookies)` - Set cookies
- `Page::deleteCookie(cookies)` - Delete cookies

#### Export
- `Page::screenshot(path)` - Take screenshot
- `Page::pdf(path)` - Generate PDF

#### Network Interception
- `Page::setRequestInterception(value)` - Enable/disable request interception

#### Coverage
- `Page::coverage()` - Get coverage instance

#### CDP Session
- `Page::createCDPSession()` - Create a new CDP session

### ElementHandle Methods

- `ElementHandle::click()` - Click element
- `ElementHandle::type_(text)` - Type into element
- `ElementHandle::focus()` - Focus on element
- `ElementHandle::hover()` - Hover over element
- `ElementHandle::getProperty(propertyName)` - Get element property
- `ElementHandle::query_selector(selector)` - Query selector within element
- `ElementHandle::query_selector_all(selector)` - Query all within element

### HTTPRequest Methods

- `HTTPRequest::abort()` - Abort the request
- `HTTPRequest::continue_()` - Continue the request
- `HTTPRequest::continue_with(overrides)` - Continue with request overrides
- `HTTPRequest::respond(response)` - Respond with custom response
- `HTTPRequest::isInterceptResolutionHandled()` - Check if already handled
- `HTTPRequest::url()` - Get request URL
- `HTTPRequest::method_()` - Get HTTP method
- `HTTPRequest::headers()` - Get request headers
- `HTTPRequest::resourceType()` - Get resource type
- `HTTPRequest::isNavigationRequest()` - Check if navigation request
- `HTTPRequest::response()` - Get response (if available)
- `HTTPRequest::redirectChain()` - Get redirect chain
- `HTTPRequest::hasPostData()` - Check if has POST data
- `HTTPRequest::fetchPostData()` - Fetch POST data

### HTTPResponse Methods

- `HTTPResponse::url()` - Get response URL
- `HTTPResponse::status()` - Get HTTP status code
- `HTTPResponse::statusText()` - Get status text
- `HTTPResponse::ok()` - Check if status is 200-299
- `HTTPResponse::headers()` - Get response headers
- `HTTPResponse::text()` - Get response body as text
- `HTTPResponse::json()` - Get response body as JSON
- `HTTPResponse::buffer()` - Get response body as buffer
- `HTTPResponse::fromCache()` - Check if served from cache
- `HTTPResponse::fromServiceWorker()` - Check if from service worker
- `HTTPResponse::request()` - Get associated request
- `HTTPResponse::remoteAddress()` - Get remote server address

### Coverage Methods

- `Coverage::startJSCoverage()` - Start JavaScript coverage tracking
- `Coverage::startJSCoverage_with(options)` - Start JS coverage with options
- `Coverage::stopJSCoverage()` - Stop JS coverage and get results
- `Coverage::startCSSCoverage()` - Start CSS coverage tracking
- `Coverage::startCSSCoverage_with(options)` - Start CSS coverage with options
- `Coverage::stopCSSCoverage()` - Stop CSS coverage and get results

### CDPSession Methods

- `CDPSession::detach()` - Detach the session from the target
- `CDPSession::id()` - Get the session ID
- `CDPSession::send(method, params)` - Send a CDP command with parameters
- `CDPSession::send_simple(method)` - Send a CDP command without parameters

### Types

- `Cookie` - Cookie structure with name, value, domain, path, expires, httpOnly, secure, sameSite

## References

- [Puppeteer Official Documentation](https://pptr.dev/)
- [Puppeteer API Reference](https://pptr.dev/api/puppeteer.page)
