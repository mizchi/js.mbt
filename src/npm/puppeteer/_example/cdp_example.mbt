///|
/// CDP Session example
pub fn cdp_example() -> Unit {
  @js.run_async(async fn() -> Unit noraise {
    println("\n=== CDP Session Example ===")
    let browser = @puppeteer.launch(headless=true) catch {
      e => {
        println("Failed to launch browser: \{e}")
        return
      }
    }
    let page = browser.newPage() catch {
      e => {
        println("Failed to create page: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }

    // Create CDP session
    let session = page.createCDPSession() catch {
      e => {
        println("Failed to create CDP session: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("✓ Created CDP session")

    // Get session ID
    let sessionId = session.id()
    println("Session ID: \{sessionId}")

    // Enable network tracking via CDP
    session.send_simple("Network.enable") catch {
      e => {
        println("Failed to enable network: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("✓ Enabled network tracking via CDP")

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

    // Detach session
    session.detach() catch {
      e => {
        println("Failed to detach session: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("✓ Detached CDP session")
    browser.close() catch {
      _ => ()
    }
    println("✓ Browser closed")
  })
}
