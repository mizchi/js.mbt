# mizchi/js_web/url

URL API for parsing and manipulating URLs.

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_web@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_web/url",
}
```

## Overview

Provides bindings for URL parsing, URLSearchParams, and URLPattern APIs.

## Usage Example

`URL` is a struct, so its components are **fields**, not method calls. The
constructor raises `@core.JsError` on an unparseable URL.

```moonbit
///|
pub fn parse() -> String raise @core.JsError {
  // Parse a URL
  let url = @url.URL("https://example.com/path?query=value")

  // Access URL components -- plain field reads
  let _ = url.protocol // "https:"
  let _ = url.hostname // "example.com"
  let _ = url.pathname // "/path"
  let _ = url.search // "?query=value"

  // Work with query parameters
  let params = url.searchParams
  params.set("key", "value")
  match params.get("key") {
    Some(v) => v
    None => ""
  }
}
```

`URLSearchParams` has no constructor of its own — you reach one through a
`URL`, as above.

## Available Types

- **URL** - URL parsing and manipulation
- **URLSearchParams** - Query string handling
- **URLPattern** - URL pattern matching

## Reference

- [MDN: URL](https://developer.mozilla.org/en-US/docs/Web/API/URL)
- [MDN: URLSearchParams](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)
- [MDN: URLPattern](https://developer.mozilla.org/en-US/docs/Web/API/URLPattern)
