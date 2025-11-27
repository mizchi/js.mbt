# @playwright/test Bindings

MoonBit bindings for [@playwright/test](https://playwright.dev/docs/api/class-test), the Playwright Test framework.

## Installation

```bash
npm install @playwright/test
npx playwright install chromium
```

## Usage

This module provides bindings for Playwright Test's API, intended for use when integrating MoonBit code with JavaScript test runners.

```moonbit
// Get test and expect functions
let test = @playwright_test.test_fn()
let expect = @playwright_test.expect_fn()

// Define a test
test.run("my test", @js.from_fn1(async fn(fixtures) {
  let page : @playwright.Page = @js.identity(fixtures.get("page"))
  let _ = page.goto("https://example.com")

  // Use assertions
  expect.page(page).toHaveTitle("Example Domain")
  expect.locator(page.locator("h1")).toBeVisible()
}))

// Define a describe block
test.describe("my suite", @js.from_fn0(fn() {
  test.beforeEach(@js.from_fn1(async fn(fixtures) {
    let page : @playwright.Page = @js.identity(fixtures.get("page"))
    let _ = page.goto("https://example.com")
  }))

  test.run("has title", @js.from_fn1(async fn(fixtures) {
    let page : @playwright.Page = @js.identity(fixtures.get("page"))
    expect.page(page).toHaveTitle("Example Domain")
  }))
}))
```

## Available Types

### Test

- `test_fn()` - Get the test function
- `Test::run(name, callback)` - Define a test case
- `Test::describe(name, callback)` - Create a describe block
- `Test::skip(condition?)` - Skip test(s)
- `Test::slow()` - Mark test as slow (triples timeout)
- `Test::setTimeout(timeout_ms)` - Set test timeout
- `Test::beforeEach(callback)` - Run before each test
- `Test::afterEach(callback)` - Run after each test
- `Test::beforeAll(callback)` - Run once before all tests
- `Test::afterAll(callback)` - Run once after all tests
- `Test::use_options(options)` - Configure test options

### Expect

- `expect_fn()` - Get the expect function
- `Expect::value(value)` - Create expectation for any value
- `Expect::page(page)` - Create page assertions
- `Expect::locator(locator)` - Create locator assertions

### PageAssertions

- `toHaveTitle(title, timeout?)` - Assert page title
- `toHaveURL(url, timeout?)` - Assert page URL

### LocatorAssertions

- `toBeVisible(timeout?)` - Assert element is visible
- `toBeHidden(timeout?)` - Assert element is hidden
- `toBeEnabled(timeout?)` - Assert element is enabled
- `toBeDisabled(timeout?)` - Assert element is disabled
- `toBeChecked(checked?, timeout?)` - Assert checkbox state
- `toBeFocused(timeout?)` - Assert element has focus
- `toHaveText(text, ignoreCase?, timeout?)` - Assert exact text
- `toContainText(text, ignoreCase?, timeout?)` - Assert contains text
- `toHaveValue(value, timeout?)` - Assert input value
- `toHaveAttribute(name, value, timeout?)` - Assert attribute
- `toHaveClass(class_, timeout?)` - Assert CSS class
- `toHaveCount(count, timeout?)` - Assert element count

### TestInfo

- `title()` - Get test title
- `file()` - Get test file path
- `line()` - Get test line number
- `column()` - Get test column number
- `timeout()` - Get test timeout
- `retry()` - Get retry count
- `status()` - Get test status
- `skip(message?)` - Skip the test
- `fail(message?)` - Fail the test
- `slow()` - Mark as slow
- `attach(name, path?, body?, contentType?)` - Attach file to report

## See Also

- [Playwright Test Documentation](https://playwright.dev/docs/writing-tests)
- [Playwright API Reference](https://playwright.dev/docs/api/class-test)
- [Playwright bindings](../playwright/README.md)
