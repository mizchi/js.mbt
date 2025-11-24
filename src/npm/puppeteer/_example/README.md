# Puppeteer Manual Testing Examples

This directory contains manual testing examples for the Puppeteer bindings.

## Prerequisites

Install Puppeteer first:

```bash
npm install puppeteer
```

## Running Examples

Build and run the example:

```bash
# Build
moon build --target js

# Run
node target/js/release/build/npm/puppeteer/_example/_example.js
```

## Examples

### main.mbt - Basic Example

Demonstrates:
- Launching a browser with `headless=true`
- Creating a new page
- Navigating to a URL
- Getting page title and URL
- Getting page content
- Closing the browser

### screenshot_example.mbt - Screenshot Example

Demonstrates:
- Setting viewport size
- Taking screenshots
- Saving to file

### element_example.mbt - Element Interaction

Demonstrates:
- Querying elements with `query_selector` and `query_selector_all`
- Evaluating JavaScript in page context
- Working with Optional types for element queries

## Adding New Examples

To add new examples:

1. Create a new function in `main.mbt`
2. Call it from `main()` or create a separate test function
3. Rebuild and run

Example:

```moonbit
fn my_test() -> Unit {
  @js.run_async(async fn() -> Unit noraise {
    println("My test...")
    let browser = @puppeteer.launch()!
    // ... your test code
    browser.close()!
  })
}

fn main {
  basic_example()
  my_test()
}
```
