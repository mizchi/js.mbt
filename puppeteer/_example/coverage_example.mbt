///|
/// Code coverage example
pub fn coverage_example() -> Unit {
  @js.run_async(async fn() -> Unit noraise {
    println("\n=== Code Coverage Example ===")
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

    // Get coverage instance
    let coverage = page.coverage()
    println("✓ Got coverage instance")

    // Start coverage tracking
    coverage.startJSCoverage() catch {
      e => {
        println("Failed to start JS coverage: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    coverage.startCSSCoverage() catch {
      e => {
        println("Failed to start CSS coverage: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("✓ Started JS and CSS coverage tracking")

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

    // Stop coverage and get results
    let jsCoverage = coverage.stopJSCoverage() catch {
      e => {
        println("Failed to stop JS coverage: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    let cssCoverage = coverage.stopCSSCoverage() catch {
      e => {
        println("Failed to stop CSS coverage: \{e}")
        browser.close() catch {
          _ => ()
        }
        return
      }
    }
    println("✓ Stopped coverage tracking")
    println("JS coverage entries: \{jsCoverage.length()}")
    println("CSS coverage entries: \{cssCoverage.length()}")

    // Display first entry info if available
    if jsCoverage.length() > 0 {
      let first : @core.Any = jsCoverage[0] |> @core.any
      let url : String = first["url"].cast()
      println("First JS entry URL: \{url}")
    }
    if cssCoverage.length() > 0 {
      let first : @core.Any = cssCoverage[0] |> @core.any
      let url : String = first["url"].cast()
      println("First CSS entry URL: \{url}")
    }
    browser.close() catch {
      _ => ()
    }
    println("✓ Browser closed")
  })
}
