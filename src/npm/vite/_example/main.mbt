///|
/// Manual testing example for Vite
fn main {
  config_example()
  plugin_example()
  dev_server_example()
}

///|
/// Development server example
fn dev_server_example() -> Unit {
  @js.run_async(async fn() -> Unit noraise {
    println("=== Vite Dev Server Example ===")

    // Create and start development server
    println("Creating development server...")
    let server = @vite.createServer(
      root?=Some("."),
      logLevel?=Some("info"),
      clearScreen?=Some(false),
    ) catch {
      e => {
        println("Failed to create server: \{e}")
        return
      }
    }
    println("✓ Server created")

    // Start listening
    let listening = server.listen(port?=Some(5173)) catch {
      e => {
        println("Failed to start server: \{e}")
        return
      }
    }
    println("✓ Server listening")

    // Print URLs
    listening.printUrls()

    // Get resolved URLs
    let urls = listening.resolvedUrls()
    println("URLs: \{urls}")

    // Wait a bit
    let _ = @global.set_timeout(
      fn() {
        @js.run_async(async fn() -> Unit noraise {
          // Close server
          server.close() catch {
            e => println("Failed to close server: \{e}")
          }
          println("✓ Server closed")
        })
      },
      3000,
    )

  })
}
