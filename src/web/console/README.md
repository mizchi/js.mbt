# mizchi/js/web/console

Console logging API for debugging and output.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/web/console"
  ]
}
```

## Overview

Provides bindings for the Console API, available across browsers, Node.js, Deno, and edge runtimes.

## Usage Example

```moonbit
fn main {
  // Basic logging
  @console.log("Hello, world!")
  @console.log("Value:", 42)
  
  // Different log levels
  @console.info("Info message")
  @console.warn("Warning message")
  @console.error("Error message")
  
  // Grouping
  @console.group("Group name")
  @console.log("Inside group")
  @console.group_end()
  
  // Timing
  @console.time("operation")
  // ... some operation
  @console.time_end("operation")
}
```

## Available Methods

- `log`, `info`, `warn`, `error`, `debug` - Logging methods
- `group`, `groupCollapsed`, `groupEnd` - Grouping output
- `time`, `timeEnd`, `timeLog` - Performance timing
- `assert`, `clear`, `count`, `table` - Additional utilities

## Reference

- [MDN: Console API](https://developer.mozilla.org/en-US/docs/Web/API/Console)
