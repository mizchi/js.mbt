// ///|
// /// Main entry point
// fn main {
//   run_example()
// }
//
// ///|
// /// Example: Simple Puppeteer usage
// pub fn run_example() -> Unit {
//   @js.run_async(async fn() -> Unit noraise {
//     println("Starting Puppeteer example...")
//     let browser = launch(headless=true) catch {
//       e => {
//         println("Failed to launch browser: \{e}")
//         return
//       }
//     }
//     println("Browser launched successfully")
//     let page = browser.new_page() catch {
//       e => {
//         println("Failed to create page: \{e}")
//         browser.close() catch {
//           _ => ()
//         }
//         return
//       }
//     }
//     println("New page created")
//     page.goto("https://example.com") catch {
//       e => {
//         println("Failed to navigate: \{e}")
//         browser.close() catch {
//           _ => ()
//         }
//         return
//       }
//     }
//     println("Navigated to example.com")
//     let title = page.title() catch {
//       e => {
//         println("Failed to get title: \{e}")
//         browser.close() catch {
//           _ => ()
//         }
//         return
//       }
//     }
//     println("Page title: \{title}")
//     let url = page.url()
//     println("Page URL: \{url}")
//     browser.close() catch {
//       e => println("Failed to close browser: \{e}")
//     }
//     println("Browser closed")
//   })
// }
