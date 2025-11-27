# Playwright Bindings

MoonBit bindings for [Playwright](https://playwright.dev/), a framework for Web Testing and Automation.

## Installation

```bash
npm install playwright
npx playwright install chromium
```

## Usage

```moonbit
// Launch browser and navigate
let browser = @playwright.chromium().launch(headless=true)
let page = browser.newPage()
let _ = page.goto("https://example.com")

// Get page content
let title = page.title()
let content = page.content()

// Use locators
let button = page.getByRole("button", name="Submit")
button.click()

// Fill forms
page.locator("#email").fill("test@example.com")

// Close browser
page.close()
browser.close()
```

## Available Types

- `BrowserType` - chromium(), firefox(), webkit()
- `Browser` - browser instance with context/page management
- `BrowserContext` - isolated browser session
- `Page` - page with navigation, actions, and locators
- `Locator` - element selector with actions
- `Frame` - iframe handling
- `Request` / `Response` - network request/response

## Running Tests

Playwright tests require the browser to be installed and run in a special mode.

### Prerequisites

```bash
# Install playwright package
npm install playwright

# Install Chromium browser
npx playwright install chromium
```

### Running Tests Locally

```bash
# Run playwright tests with the environment variable
PLAYWRIGHT_TEST=1 moon test --no-parallelize -p mizchi/js/npm/playwright
```

The `PLAYWRIGHT_TEST=1` environment variable is required to run the actual browser tests. Without it, tests will be skipped (useful for regular CI that doesn't have browser support).

The `--no-parallelize` flag is recommended to avoid resource contention when launching multiple browser instances.

### CI Integration

Playwright tests run in a separate CI workflow (`.github/workflows/playwright.yaml`) that:
- Only triggers on changes to `src/npm/playwright/**` or `src/npm/playwright_test/**`
- Installs Chromium browser with dependencies
- Runs tests with `PLAYWRIGHT_TEST=1` environment variable

## See Also

- [Playwright Documentation](https://playwright.dev/docs/intro)
- [Playwright API Reference](https://playwright.dev/docs/api/class-playwright)
- [@playwright/test bindings](../playwright_test/README.md)
