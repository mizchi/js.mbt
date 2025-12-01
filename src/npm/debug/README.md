# Debug Bindings

MoonBit bindings for [debug](https://github.com/debug-js/debug), a tiny JavaScript debugging utility.

## Installation

```bash
npm install debug
```

## Usage

```moonbit
fn main {
  // Create a debug logger
  let log = @debug.debug("myapp:server")

  // Enable debug output
  @debug.enable("myapp:*")

  // Log messages
  log.log("Server starting...")
  log.log1("Listening on port %d", @nostd.any(3000))
  log.log2("Request: %s %s", @nostd.any("GET"), @nostd.any("/api"))

  // Create extended loggers
  let dbLog = log.extend("db")
  dbLog.log("Database connected")
}
```

## API

### Module Functions

- `debug(ns)` - Create a new debug logger with the given namespace
- `enable(namespaces)` - Enable debug output for namespaces (supports wildcards like "app:*")
- `disable()` - Disable all debug output, returns previously enabled namespaces
- `enabled(ns)` - Check if a namespace is enabled
- `coerce(val)` - Coerce a value (useful for Error objects)

### Debug Methods

- `log(message)` - Log a debug message
- `log1(message, arg1)` - Log with one format argument
- `log2(message, arg1, arg2)` - Log with two format arguments
- `log3(message, arg1, arg2, arg3)` - Log with three format arguments
- `log_with(message, args)` - Log with array of format arguments
- `extend(ns)` - Create an extended logger with additional namespace
- `get_namespace()` - Get the namespace of this logger
- `is_enabled()` - Check if this logger is enabled
- `set_enabled(enabled)` - Manually enable/disable this logger

## Namespace Patterns

The `enable()` function supports wildcards:

```moonbit
// Enable all namespaces starting with "app:"
@debug.enable("app:*")

// Enable multiple specific namespaces
@debug.enable("app:server,app:db")

// Enable all except certain namespaces
@debug.enable("*,-app:verbose")
```

## Environment Variables

In Node.js, you can also enable debug output via the `DEBUG` environment variable:

```bash
DEBUG=myapp:* node app.js
```

## See Also

- [debug Documentation](https://github.com/debug-js/debug)
