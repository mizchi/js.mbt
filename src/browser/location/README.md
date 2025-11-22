# mizchi/js/browser/location

Location API for getting and manipulating the current URL.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/browser/location"
  ]
}
```

## Overview

Provides bindings for the Location API to access and modify the current document URL.

## Usage Example

```moonbit
fn main {
  // Get location object
  let loc = @location.location()
  
  // Get URL components
  let href = loc.href()           // Full URL
  let protocol = loc.protocol()   // "https:"
  let hostname = loc.hostname()   // "example.com"
  let port = loc.port()          // "3000"
  let pathname = loc.pathname()   // "/path"
  let search = loc.search()      // "?query=value"
  let hash = loc.hash()          // "#section"
  
  // Navigate to new URL
  loc.assign("https://example.com/new-page")
  
  // Reload page
  loc.reload()
  
  // Replace current URL (no history entry)
  loc.replace("https://example.com/replaced")
}
```

## Reference

- [MDN: Location](https://developer.mozilla.org/en-US/docs/Web/API/Location)
