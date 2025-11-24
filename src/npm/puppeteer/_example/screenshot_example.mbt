///|
/// Screenshot example
pub fn screenshot_example() -> Unit {
  @js.run_async(async fn() -> Unit noraise {
    println("\n=== Screenshot Example ===")

    let browser = @puppeteer.launch(headless=true) catch {
      e => {
        println("Failed to launch browser: \{e}")
        return
      }
    }

    let page = browser.new_page() catch {
      e => {
        println("Failed to create page: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }

    // Set viewport size
    page.setViewport(1920, 1080) catch {
      e => {
        println("Failed to set viewport: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }
    println("✓ Viewport set to 1920x1080")

    // Navigate to example.com
    page.goto("https://example.com") catch {
      e => {
        println("Failed to navigate: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }
    println("✓ Navigated to example.com")

    // Take screenshot
    page.screenshot("/tmp/puppeteer-example.png") catch {
      e => {
        println("Failed to take screenshot: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }
    println("✓ Screenshot saved to /tmp/puppeteer-example.png")

    browser.close() catch { _ => () }
    println("✓ Browser closed")
  })
}
