///|
/// Manual testing example for Puppeteer
fn main {
  basic_example()
  screenshot_example()
  element_example()
  coverage_example()
}

///|
/// Basic Puppeteer usage example
fn basic_example() -> Unit {
  @js.run_async(async fn() -> Unit noraise {
    println("=== Puppeteer Basic Example ===")

    // Launch browser
    println("Launching browser...")
    let browser = @puppeteer.launch(headless=true) catch {
      e => {
        println("Failed to launch browser: \{e}")
        return
      }
    }
    println("✓ Browser launched")

    // Create new page
    let page = browser.new_page() catch {
      e => {
        println("Failed to create page: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("✓ New page created")

    // Navigate to example.com
    page.goto("https://example.com") catch {
      e => {
        println("Failed to navigate: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("✓ Navigated to example.com")

    // Get page title
    let title = page.title() catch {
      e => {
        println("Failed to get title: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("Page title: \{title}")

    // Get page URL
    let url = page.url()
    println("Page URL: \{url}")

    // Get page content
    let content = page.content() catch {
      e => {
        println("Failed to get content: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("Content length: \{content.length()} characters")

    // Close browser
    browser.close() catch {
      e => println("Failed to close browser: \{e}")
    }
    println("✓ Browser closed")
    println("\n=== Example completed successfully ===")
  })
}
