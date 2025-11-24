///|
/// Element interaction example
pub fn element_example() -> Unit {
  @js.run_async(async fn() -> Unit noraise {
    println("\n=== Element Interaction Example ===")

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

    // Navigate to example.com
    page.goto("https://example.com") catch {
      e => {
        println("Failed to navigate: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }
    println("✓ Navigated to example.com")

    // Query all paragraphs
    let paragraphs = page.query_selector_all("p") catch {
      e => {
        println("Failed to query paragraphs: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }
    println("✓ Found \{paragraphs.length()} paragraphs")

    // Query single h1
    let h1 = page.query_selector("h1") catch {
      e => {
        println("Failed to query h1: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }
    match h1 {
      Some(_) => println("✓ Found h1 element")
      None => println("✗ No h1 element found")
    }

    // Evaluate JavaScript
    let result = page.evaluate("document.title") catch {
      e => {
        println("Failed to evaluate: \{e}")
        browser.close() catch { _ => () }
        return
      }
    }
    println("✓ JavaScript evaluation result: \{result}")

    browser.close() catch { _ => () }
    println("✓ Browser closed")
  })
}
