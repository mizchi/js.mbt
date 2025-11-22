# mizchi/js/web/url

URL API for parsing and manipulating URLs.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/web/url"
  ]
}
```

## Overview

Provides bindings for URL parsing, URLSearchParams, and URLPattern APIs.

## Usage Example

```moonbit
fn main {
  // Parse a URL
  let url = @url.URL::new("https://example.com/path?query=value")
  
  // Access URL components
  let protocol = url.protocol()
  let hostname = url.hostname()
  let pathname = url.pathname()
  let search = url.search()
  
  // Work with query parameters
  let params = url.search_params()
  params.set("key", "value")
  let value = params.get("key")
  
  // Create URLSearchParams directly
  let search_params = @url.URLSearchParams::new()
  search_params.append("name", "value")
}
```

## Available Types

- **URL** - URL parsing and manipulation
- **URLSearchParams** - Query string handling
- **URLPattern** - URL pattern matching

## Reference

- [MDN: URL](https://developer.mozilla.org/en-US/docs/Web/API/URL)
- [MDN: URLSearchParams](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)
- [MDN: URLPattern](https://developer.mozilla.org/en-US/docs/Web/API/URLPattern)
