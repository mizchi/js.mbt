# mizchi/js/web/performance

Performance API for timing and measurement.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/web/performance"
  ]
}
```

## Overview

Provides bindings for the Performance API to measure timing and performance metrics.

## Usage Example

```moonbit
fn main {
  // Get current timestamp
  let now = @performance.now()
  
  // Mark a performance entry
  @performance.mark("start")
  
  // ... some operation
  
  @performance.mark("end")
  
  // Measure between marks
  @performance.measure("operation", "start", "end")
  
  // Get performance entries
  let entries = @performance.get_entries()
  let marks = @performance.get_entries_by_type("mark")
}
```

## Available Methods

- `now()` - High-resolution timestamp
- `mark(name)` - Create a performance mark
- `measure(name, start, end)` - Measure between marks
- `getEntries()` - Get all performance entries

## Reference

- [MDN: Performance](https://developer.mozilla.org/en-US/docs/Web/API/Performance)
- [MDN: PerformanceEntry](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry)
