# chokidar

MoonBit bindings for Chokidar - Efficient cross-platform file watching library.

## Installation

First, install chokidar via npm:

```bash
npm install chokidar
```

## Usage

### Basic File Watching

```moonbit
// Watch a file or directory
let watcher = @chokidar.watch(
  @js.Any("src"),
  ignoreInitial?=Some(true),
  persistent?=Some(true)
)

// Listen for events
let _ = watcher.on("add", @js.identity(fn(path) {
  println("File added: \{path}")
}))

let _ = watcher.on("change", @js.identity(fn(path) {
  println("File changed: \{path}")
}))

let _ = watcher.on("unlink", @js.identity(fn(path) {
  println("File removed: \{path}")
}))
```

### Watch Multiple Paths

```moonbit
// Watch multiple files or directories
let watcher = @chokidar.watch(
  @js.from_array([@js.Any("src"), @js.Any("tests")]),
  persistent?=Some(true)
)
```

### Ignoring Files

```moonbit
// Ignore dotfiles
let watcher = @chokidar.watch(
  @js.Any("."),
  ignored?=Some(@js.Any("/(^|[\/\\])\\../")),
  ignoreInitial?=Some(true)
)

// Ignore node_modules
let watcher = @chokidar.watch(
  @js.Any("."),
  ignored?=Some(@js.Any("node_modules")),
  persistent?=Some(true)
)
```

### Add/Remove Watched Paths

```moonbit
let watcher = @chokidar.watch(@js.Any("src"))

// Add more paths
let _ = watcher.add(@js.Any("tests"))

// Stop watching specific paths
let _ = watcher.unwatch(@js.Any("tests"))
```

### Close Watcher

```moonbit
// Close the watcher
@js.run_async(async fn() -> Unit noraise {
  watcher.close() catch {
    e => println("Error closing watcher: \{e}")
  }
})
```

### Get Watched Paths

```moonbit
let watched = watcher.getWatched()
println("Watched paths: \{watched}")
```

## API Reference

### watch

Create a file system watcher with options:

```moonbit
pub fn watch(
  paths : @js.Any,
  persistent? : Bool,
  ignored? : @js.Any,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @js.Any,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher
```

**Parameters:**

- `paths` - String or array of strings for files/directories to watch
- `persistent?` - Keep process running while watching (default: true)
- `ignored?` - Regex, function, or string to ignore files
- `ignoreInitial?` - Don't emit events during initial scan (default: false)
- `followSymlinks?` - Follow symbolic links (default: true)
- `cwd?` - Base directory for relative paths
- `disableGlobbing?` - Disable glob pattern matching (default: false)
- `usePolling?` - Use polling instead of native events (default: false)
- `interval?` - Polling interval in ms (default: 100)
- `binaryInterval?` - Polling interval for binary files (default: 300)
- `alwaysStat?` - Always provide fs.Stats with events (default: false)
- `depth?` - Limit recursion depth
- `awaitWriteFinish?` - Wait for write completion before emitting
- `ignorePermissionErrors?` - Ignore permission errors (default: false)
- `atomic_?` - Filter atomic write artifacts (default: true)

### FSWatcher Methods

#### add

Add files or directories to watch:

```moonbit
pub fn FSWatcher::add(self : FSWatcher, paths : @js.Any) -> FSWatcher
```

**Example:**
```moonbit
let _ = watcher.add(@js.Any("new-folder"))
```

#### unwatch

Stop watching files or directories:

```moonbit
pub fn FSWatcher::unwatch(self : FSWatcher, paths : @js.Any) -> FSWatcher
```

**Example:**
```moonbit
let _ = watcher.unwatch(@js.Any("old-folder"))
```

#### close

Close the watcher and remove all listeners:

```moonbit
pub async fn FSWatcher::close(self : FSWatcher) -> Unit
```

**Example:**
```moonbit
@js.run_async(async fn() -> Unit noraise {
  watcher.close() catch {
    e => println("Error: \{e}")
  }
})
```

#### getWatched

Get object mapping watched directories to their contents:

```moonbit
pub fn FSWatcher::getWatched(self : FSWatcher) -> @js.Any
```

**Example:**
```moonbit
let watched = watcher.getWatched()
```

#### on

Listen for file system events:

```moonbit
pub fn FSWatcher::on(
  self : FSWatcher,
  event : String,
  callback : @js.Any,
) -> FSWatcher
```

**Events:**
- `"add"` - File added (path)
- `"addDir"` - Directory added (path)
- `"change"` - File changed (path)
- `"unlink"` - File removed (path)
- `"unlinkDir"` - Directory removed (path)
- `"ready"` - Initial scan complete
- `"raw"` - Raw event data (event, path, details)
- `"error"` - Error occurred (error)
- `"all"` - Any event (event, path)

**Example:**
```moonbit
let _ = watcher.on("change", @js.identity(fn(path) {
  println("Changed: \{path}")
}))
```

#### off

Remove event listener:

```moonbit
pub fn FSWatcher::off(
  self : FSWatcher,
  event : String,
  callback : @js.Any,
) -> FSWatcher
```

## Advanced Examples

### Await Write Finish

Wait for file writes to complete before emitting events:

```moonbit
let watcher = @chokidar.watch(
  @js.Any("downloads"),
  awaitWriteFinish?=Some(@js.from_map({
    "stabilityThreshold": @js.any(2000),
    "pollInterval": @js.any(100)
  })),
  ignoreInitial?=Some(true)
)
```

### Using Polling

Force polling mode (useful for network drives):

```moonbit
let watcher = @chokidar.watch(
  @js.Any("/network/share"),
  usePolling?=Some(true),
  interval?=Some(1000)
)
```

### Limit Recursion Depth

Watch only up to a certain depth:

```moonbit
let watcher = @chokidar.watch(
  @js.Any("src"),
  depth?=Some(2),
  ignoreInitial?=Some(true)
)
```

### Error Handling

```moonbit
let watcher = @chokidar.watch(@js.Any("src"))

let _ = watcher.on("error", @js.identity(fn(error) {
  println("Watcher error: \{error}")
}))

let _ = watcher.on("ready", @js.identity(fn() {
  println("Initial scan complete")
}))
```

## Complete Example

```moonbit
fn main {
  // Create watcher with options
  let watcher = @chokidar.watch(
    @js.from_array([@js.Any("src"), @js.Any("lib")]),
    ignored?=Some(@js.Any("/(^|[\/\\])\\../")),
    persistent?=Some(true),
    ignoreInitial?=Some(true),
    awaitWriteFinish?=Some(@js.from_map({
      "stabilityThreshold": @js.any(1000),
      "pollInterval": @js.any(100)
    }))
  )

  // Set up event handlers
  let _ = watcher
    .on("add", @js.identity(fn(path) {
      println("File \{path} has been added")
    }))
    .on("change", @js.identity(fn(path) {
      println("File \{path} has been changed")
    }))
    .on("unlink", @js.identity(fn(path) {
      println("File \{path} has been removed")
    }))
    .on("error", @js.identity(fn(error) {
      println("Error occurred: \{error}")
    }))
    .on("ready", @js.identity(fn() {
      println("Ready for changes")
    }))

  // Add more paths later
  let _ = watcher.add(@js.Any("tests"))

  // Get watched paths
  let watched = watcher.getWatched()
  println("Watching: \{watched}")

  // Clean up when done
  @js.run_async(async fn() -> Unit noraise {
    // ... do work ...
    watcher.close() catch {
      e => println("Error closing: \{e}")
    }
  })
}
```

## Types

### FSWatcher

External type representing a Chokidar watcher instance.

## References

- [Chokidar GitHub](https://github.com/paulmillr/chokidar)
- [Chokidar API Documentation](https://github.com/paulmillr/chokidar#api)
