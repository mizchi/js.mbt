///|
/// Playwright bindings tests
/// Note: These tests require playwright to be installed:
///   npm install playwright
///   npx playwright install chromium

///|
test "chromium browser type" {
  let browser_type = chromium()
  inspect(browser_type.name(), content="chromium")
}

///|
/// Helper: run test with browser, ensuring cleanup on success or timeout
async fn[T] with_browser(timeout_ms : Int, f : async (Browser) -> T) -> T {
  @async.with_timeout(timeout_ms, fn() {
    let browser = chromium().launch(headless=true)
    let result = f(browser)
    browser.close()
    result
  })
}

///|
/// Helper: run test with browser and page, ensuring cleanup on success or timeout
async fn[T] with_page(timeout_ms : Int, f : async (Page) -> T) -> T {
  @async.with_timeout(timeout_ms, fn() {
    let browser = chromium().launch(headless=true)
    let page = browser.newPage()
    let result = f(page)
    page.close()
    browser.close()
    result
  })
}

///|
async test "launch and close browser" {
  with_browser(10000, async fn(browser) {
    assert_eq(browser.isConnected(), true)
  })
}

///|
async test "create new page" {
  with_browser(10000, async fn(browser) {
    let page = browser.newPage()
    assert_eq(page.isClosed(), false)
    page.close()
    assert_eq(page.isClosed(), true)
  })
}

///|
async test "page navigation with data URL" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<h1>Hello World</h1>")
    let content = page.content()
    assert_eq(content.contains("Hello World"), true)
  })
}

///|
async test "page title" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<title>Test Title</title><body>content</body>",
    )
    let title = page.title()
    inspect(title, content="Test Title")
  })
}

///|
async test "page URL" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<h1>Test</h1>")
    let url = page.url()
    assert_eq(url.has_prefix("data:"), true)
  })
}

///|
async test "locator and text content" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<div id=\"test\">Hello Locator</div>")
    let locator = page.locator("#test")
    let text = locator.innerText()
    inspect(text, content="Hello Locator")
  })
}

///|
async test "locator count" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<ul><li>One</li><li>Two</li><li>Three</li></ul>",
    )
    let locator = page.locator("li")
    let count = locator.count()
    inspect(count, content="3")
  })
}

///|
async test "locator nth" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<ul><li>First</li><li>Second</li><li>Third</li></ul>",
    )
    let second = page.locator("li").nth(1)
    let text = second.innerText()
    inspect(text, content="Second")
  })
}

///|
async test "locator first and last" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<ul><li>A</li><li>B</li><li>C</li></ul>")
    let items = page.locator("li")
    let first_text = items.first().innerText()
    let last_text = items.last().innerText()
    inspect(first_text, content="A")
    inspect(last_text, content="C")
  })
}

///|
async test "getByRole" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<button>Click Me</button>")
    let button = page.getByRole("button", name="Click Me")
    let text = button.innerText()
    inspect(text, content="Click Me")
  })
}

///|
async test "getByText" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<p>Some paragraph text</p>")
    let element = page.getByText("Some paragraph")
    let visible = element.isVisible()
    assert_eq(visible, true)
  })
}

///|
async test "fill input" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<input type=\"text\" id=\"name\" />")
    let input = page.locator("#name")
    input.fill("Test Value")
    let value = input.inputValue()
    inspect(value, content="Test Value")
  })
}

///|
async test "click button" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<button onclick=\"document.body.innerHTML='Clicked!'\">Click</button>",
    )
    page.locator("button").click()
    let content = page.content()
    assert_eq(content.contains("Clicked!"), true)
  })
}

///|
async test "checkbox check and uncheck" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<input type=\"checkbox\" id=\"cb\" />")
    let checkbox = page.locator("#cb")
    assert_eq(checkbox.isChecked(), false)
    checkbox.check()
    assert_eq(checkbox.isChecked(), true)
    checkbox.uncheck()
    assert_eq(checkbox.isChecked(), false)
  })
}

///|
async test "getAttribute" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<a href=\"https://example.com\" class=\"link\">Link</a>",
    )
    let link = page.locator("a")
    let href = link.getAttribute("href")
    inspect(href, content="Some(\"https://example.com\")")
    let class_attr = link.getAttribute("class")
    inspect(class_attr, content="Some(\"link\")")
  })
}

///|
async test "isVisible and isHidden" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<div id=\"visible\">Show</div><div id=\"hidden\" style=\"display:none\">Hide</div>",
    )
    let visible_el = page.locator("#visible")
    let hidden_el = page.locator("#hidden")
    assert_eq(visible_el.isVisible(), true)
    assert_eq(visible_el.isHidden(), false)
    assert_eq(hidden_el.isVisible(), false)
    assert_eq(hidden_el.isHidden(), true)
  })
}

///|
async test "evaluate JavaScript" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<h1>Test</h1>")
    let result = page.evaluate("() => 1 + 2")
    let num : Int = @js.identity(result)
    inspect(num, content="3")
  })
}

///|
async test "evaluate with argument" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<h1>Test</h1>")
    let result = page.evaluate("(x) => x * 2", arg=@js.any(5))
    let num : Int = @js.identity(result)
    inspect(num, content="10")
  })
}

///|
async test "setContent" {
  with_page(10000, async fn(page) {
    page.setContent("<html><body><h1>Dynamic Content</h1></body></html>")
    let title = page.locator("h1").innerText()
    inspect(title, content="Dynamic Content")
  })
}

///|
async test "browser context" {
  @async.with_timeout(10000, fn() {
    let browser = chromium().launch(headless=true)
    let context = browser.newContext()
    let page = context.newPage()
    let _ = page.goto("data:text/html,<h1>Context Test</h1>")
    let pages = context.pages()
    assert_eq(pages.length(), 1)
    page.close()
    context.close()
    browser.close()
  })
}

///|
async test "setViewportSize" {
  with_page(10000, async fn(page) {
    page.setViewportSize(800, 600)
    match page.viewportSize() {
      Some((width, height)) => {
        inspect(width, content="800")
        inspect(height, content="600")
      }
      None => fail("Expected viewport size")
    }
  })
}

///|
async test "allTextContents" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<ul><li>Apple</li><li>Banana</li><li>Cherry</li></ul>",
    )
    let texts = page.locator("li").allTextContents()
    inspect(texts.length(), content="3")
    inspect(texts[0], content="Apple")
    inspect(texts[1], content="Banana")
    inspect(texts[2], content="Cherry")
  })
}

///|
async test "locator filter with hasText" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<div class=\"item\">Apple</div><div class=\"item\">Banana</div><div class=\"item\">Cherry</div>",
    )
    let items = page.locator(".item")
    let banana = items.filter(hasText="Banana")
    let count = banana.count()
    inspect(count, content="1")
    let text = banana.innerText()
    inspect(text, content="Banana")
  })
}

///|
async test "waitForSelector" {
  with_page(10000, async fn(page) {
    let _ = page.goto("data:text/html,<div id=\"target\">Found</div>")
    let _ = page.waitForSelector("#target", timeout=5000)
    let text = page.locator("#target").innerText()
    inspect(text, content="Found")
  })
}

///|
async test "getByTestId" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<div data-testid=\"my-element\">Test ID Element</div>",
    )
    let element = page.getByTestId("my-element")
    let text = element.innerText()
    inspect(text, content="Test ID Element")
  })
}

///|
async test "getByLabel" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<label for=\"email\">Email</label><input id=\"email\" type=\"email\" />",
    )
    let input = page.getByLabel("Email")
    input.fill("test@example.com")
    let value = input.inputValue()
    inspect(value, content="test@example.com")
  })
}

///|
async test "getByPlaceholder" {
  with_page(10000, async fn(page) {
    let _ = page.goto(
      "data:text/html,<input type=\"text\" placeholder=\"Enter your name\" />",
    )
    let input = page.getByPlaceholder("Enter your name")
    input.fill("John Doe")
    let value = input.inputValue()
    inspect(value, content="John Doe")
  })
}
