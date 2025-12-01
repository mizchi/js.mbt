///|
/// Playwright bindings tests
/// Note: These tests require playwright to be installed:
///   npm install playwright
///   npx playwright install chromium
///
/// Run tests with:
///   PLAYWRIGHT_TEST=1 moon test --no-parallelize -p mizchi/js/npm/playwright

///|
/// Check if PLAYWRIGHT_TEST=1 is set
fn should_run_playwright_tests() -> Bool {
  @process.env()._get("PLAYWRIGHT_TEST") == Some("1")
}

///|
/// Helper: create browser and return cleanup function for defer
async fn with_browser(_timeout_ms : Int) -> (Browser, () -> Unit)? {
  let browser = chromium().launch(headless=true)
  let cleanup = fn() { browser.close_with_error_callback(fn(_e) {  }) }
  Some((browser, cleanup))
}

///|
/// Helper: create browser and page, return cleanup function for defer
async fn with_page(timeout_ms : Int) -> (Page, () -> Unit)? {
  let browser = chromium().launch(headless=true)
  let page = browser.newPage()
  page.setDefaultTimeout(timeout_ms)
  let cleanup = fn() {
    page.close_with_error_callback(fn(_e) {  })
    browser.close_with_error_callback(fn(_e) {  })
  }
  Some((page, cleanup))
}

///|
test "chromium browser type" {
  guard should_run_playwright_tests() else { return }
  let browser_type = chromium()
  inspect(browser_type.name(), content="chromium")
  println("[PASS] chromium browser type")
}

///|
async test "launch and close browser" {
  guard should_run_playwright_tests() else { return }
  guard with_browser(10000) is Some((browser, cleanup)) else { return }
  defer cleanup()
  assert_eq(browser.isConnected(), true)
  println("[PASS] launch and close browser")
}

///|
async test "create new page" {
  guard should_run_playwright_tests() else { return }
  guard with_browser(10000) is Some((browser, cleanup)) else { return }
  defer cleanup()
  let page = browser.newPage()
  assert_eq(page.isClosed(), false)
  page.close()
  assert_eq(page.isClosed(), true)
  println("[PASS] create new page")
}

///|
async test "page navigation with data URL" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<h1>Hello World</h1>")
  let content = page.content()
  assert_eq(content.contains("Hello World"), true)
  println("[PASS] page navigation with data URL")
}

///|
async test "page title" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<title>Test Title</title><body>content</body>",
  )
  let title = page.title()
  inspect(title, content="Test Title")
  println("[PASS] page title")
}

///|
async test "page URL" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<h1>Test</h1>")
  let url = page.url()
  assert_eq(url.has_prefix("data:"), true)
  println("[PASS] page URL")
}

///|
async test "locator and text content" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<div id=\"test\">Hello Locator</div>")
  let locator = page.locator("#test")
  let text = locator.innerText()
  inspect(text, content="Hello Locator")
  println("[PASS] locator and text content")
}

///|
async test "locator count" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<ul><li>One</li><li>Two</li><li>Three</li></ul>",
  )
  let locator = page.locator("li")
  let count = locator.count()
  inspect(count, content="3")
  println("[PASS] locator count")
}

///|
async test "locator nth" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<ul><li>First</li><li>Second</li><li>Third</li></ul>",
  )
  let second = page.locator("li").nth(1)
  let text = second.innerText()
  inspect(text, content="Second")
  println("[PASS] locator nth")
}

///|
async test "locator first and last" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<ul><li>A</li><li>B</li><li>C</li></ul>")
  let items = page.locator("li")
  let first_text = items.first().innerText()
  let last_text = items.last().innerText()
  inspect(first_text, content="A")
  inspect(last_text, content="C")
  println("[PASS] locator first and last")
}

///|
async test "getByRole" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<button>Click Me</button>")
  let button = page.getByRole("button", name="Click Me")
  let text = button.innerText()
  inspect(text, content="Click Me")
  println("[PASS] getByRole")
}

///|
async test "getByText" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<p>Some paragraph text</p>")
  let element = page.getByText("Some paragraph")
  let visible = element.isVisible()
  assert_eq(visible, true)
  println("[PASS] getByText")
}

///|
async test "fill input" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<input type=\"text\" id=\"name\" />")
  let input = page.locator("#name")
  input.fill("Test Value")
  let value = input.inputValue()
  inspect(value, content="Test Value")
  println("[PASS] fill input")
}

///|
async test "click button" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<button onclick=\"document.body.innerHTML='Clicked!'\">Click</button>",
  )
  page.locator("button").click()
  let content = page.content()
  assert_eq(content.contains("Clicked!"), true)
  println("[PASS] click button")
}

///|
async test "checkbox check and uncheck" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<input type=\"checkbox\" id=\"cb\" />")
  let checkbox = page.locator("#cb")
  assert_eq(checkbox.isChecked(), false)
  checkbox.check()
  assert_eq(checkbox.isChecked(), true)
  checkbox.uncheck()
  assert_eq(checkbox.isChecked(), false)
  println("[PASS] checkbox check and uncheck")
}

///|
async test "getAttribute" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<a href=\"https://example.com\" class=\"link\">Link</a>",
  )
  let link = page.locator("a")
  let href = link.getAttribute("href")
  inspect(href, content="Some(\"https://example.com\")")
  let class_attr = link.getAttribute("class")
  inspect(class_attr, content="Some(\"link\")")
  println("[PASS] getAttribute")
}

///|
async test "isVisible and isHidden" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<div id=\"visible\">Show</div><div id=\"hidden\" style=\"display:none\">Hide</div>",
  )
  let visible_el = page.locator("#visible")
  let hidden_el = page.locator("#hidden")
  assert_eq(visible_el.isVisible(), true)
  assert_eq(visible_el.isHidden(), false)
  assert_eq(hidden_el.isVisible(), false)
  assert_eq(hidden_el.isHidden(), true)
  println("[PASS] isVisible and isHidden")
}

// Note: evaluate tests are skipped due to issues with async promise resolution
// TODO: Fix page.evaluate to work correctly

///|
async test "setContent" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  page.setContent("<html><body><h1>Dynamic Content</h1></body></html>")
  let title = page.locator("h1").innerText()
  inspect(title, content="Dynamic Content")
  println("[PASS] setContent")
}

///|
async test "browser context" {
  guard should_run_playwright_tests() else { return }
  let browser = chromium().launch(headless=true)
  defer browser.close_with_error_callback(fn(_e) {  })
  let context = browser.newContext()
  defer context.close_with_error_callback(fn(_e) {  })
  let page = context.newPage()
  defer page.close_with_error_callback(fn(_e) {  })
  let _ = page.goto("data:text/html,<h1>Context Test</h1>")
  let pages = context.pages()
  assert_eq(pages.length(), 1)
  println("[PASS] browser context")
}

///|
async test "setViewportSize" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  page.setViewportSize(800, 600)
  match page.viewportSize() {
    Some((width, height)) => {
      inspect(width, content="800")
      inspect(height, content="600")
    }
    None => fail("Expected viewport size")
  }
  println("[PASS] setViewportSize")
}

///|
async test "allTextContents" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<ul><li>Apple</li><li>Banana</li><li>Cherry</li></ul>",
  )
  let texts = page.locator("li").allTextContents()
  inspect(texts.length(), content="3")
  inspect(texts[0], content="Apple")
  inspect(texts[1], content="Banana")
  inspect(texts[2], content="Cherry")
  println("[PASS] allTextContents")
}

///|
async test "locator filter with hasText" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<div class=\"item\">Apple</div><div class=\"item\">Banana</div><div class=\"item\">Cherry</div>",
  )
  let items = page.locator(".item")
  let banana = items.filter(hasText="Banana")
  let count = banana.count()
  inspect(count, content="1")
  let text = banana.innerText()
  inspect(text, content="Banana")
  println("[PASS] locator filter with hasText")
}

///|
async test "waitForSelector" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto("data:text/html,<div id=\"target\">Found</div>")
  let _ = page.waitForSelector("#target", timeout=5000)
  let text = page.locator("#target").innerText()
  inspect(text, content="Found")
  println("[PASS] waitForSelector")
}

///|
async test "getByTestId" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<div data-testid=\"my-element\">Test ID Element</div>",
  )
  let element = page.getByTestId("my-element")
  let text = element.innerText()
  inspect(text, content="Test ID Element")
  println("[PASS] getByTestId")
}

///|
async test "getByLabel" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<label for=\"email\">Email</label><input id=\"email\" type=\"email\" />",
  )
  let input = page.getByLabel("Email")
  input.fill("test@example.com")
  let value = input.inputValue()
  inspect(value, content="test@example.com")
  println("[PASS] getByLabel")
}

///|
async test "getByPlaceholder" {
  guard should_run_playwright_tests() else { return }
  guard with_page(10000) is Some((page, cleanup)) else { return }
  defer cleanup()
  let _ = page.goto(
    "data:text/html,<input type=\"text\" placeholder=\"Enter your name\" />",
  )
  let input = page.getByPlaceholder("Enter your name")
  input.fill("John Doe")
  let value = input.inputValue()
  inspect(value, content="John Doe")
  println("[PASS] getByPlaceholder")
}
