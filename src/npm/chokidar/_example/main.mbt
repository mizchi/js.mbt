///|
/// Chokidar example - File watching
fn main {
  println("=== Chokidar Example ===")

  // Create a watcher
  // Ignore dotfiles with regex pattern
  let watcher = @chokidar.watch(
    @js.js("."),
    ignored?=Some(@js.js("/(^|[\/\\])\\../")),
    persistent?=Some(true),
    ignoreInitial?=Some(true),
  )

  // Set up event handlers
  let _ = watcher.on(
    "add",
    @js.identity(fn(path : @js.Js) { println("File added: \{path}") }),
  )
  let _ = watcher.on(
    "change",
    @js.identity(fn(path : @js.Js) { println("File changed: \{path}") }),
  )
  let _ = watcher.on(
    "unlink",
    @js.identity(fn(path : @js.Js) { println("File removed: \{path}") }),
  )
  let _ = watcher.on(
    "addDir",
    @js.identity(fn(path : @js.Js) { println("Directory added: \{path}") }),
  )
  let _ = watcher.on(
    "unlinkDir",
    @js.identity(fn(path : @js.Js) { println("Directory removed: \{path}") }),
  )
  let _ = watcher.on(
    "error",
    @js.identity(fn(error : @js.Js) { println("Error: \{error}") }),
  )
  let _ = watcher.on(
    "ready",
    @js.identity(fn() { println("Initial scan complete. Ready for changes") }),
  )
  println("Watching for file changes...")
  println("(This example would run continuously in a real application)")

  // In a real application, you would keep the process alive
  // For this example, we'll clean up after a short time
  let _ = @js.set_timeout(
    fn() {
      @js.run_async(async fn() -> Unit noraise {
        println("Closing watcher...")
        watcher.close() catch {
          e => println("Failed to close watcher: \{e}")
        }
        println("✓ Watcher closed")
      })
    },
    3000,
  )

}
