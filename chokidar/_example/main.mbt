///|
/// Chokidar example - File watching
fn main {
  println("=== Chokidar Example ===")

  // Create a watcher
  // Ignore dotfiles with regex pattern
  let watcher = @chokidar.watch(
    ".",
    ignored?=Some(@core.any("/(^|[\/\\])\\../")),
    persistent?=Some(true),
    ignoreInitial?=Some(true),
  )

  // Set up event handlers
  let _ = watcher.on(
    "add",
    @core.from_fn1(fn(path : String) { println("File added: \{path}") }),
  )
  let _ = watcher.on(
    "change",
    @core.from_fn1(fn(path : String) { println("File changed: \{path}") }),
  )
  let _ = watcher.on(
    "unlink",
    @core.from_fn1(fn(path : String) { println("File removed: \{path}") }),
  )
  let _ = watcher.on(
    "addDir",
    @core.from_fn1(fn(path : String) { println("Directory added: \{path}") }),
  )
  let _ = watcher.on(
    "unlinkDir",
    @core.from_fn1(fn(path : String) { println("Directory removed: \{path}") }),
  )
  let _ = watcher.on(
    "error",
    @core.from_fn1(fn(_error : @core.Any) { println("Error occurred") }),
  )
  let _ = watcher.on(
    "ready",
    @core.from_fn0(fn() { println("Initial scan complete. Ready for changes") }),
  )
  println("Watching for file changes...")
  println("(This example would run continuously in a real application)")

  // In a real application, you would keep the process alive
  // For this example, we'll clean up after a short time
  let _ = @global.set_timeout(
    fn() {
      @core.run_async(async fn() -> Unit noraise {
        println("Closing watcher...")
        watcher.close() catch {
          e => println("Failed to close watcher: \{e}")
        }
        println("Watcher closed")
      })
    },
    3000,
  )

}
