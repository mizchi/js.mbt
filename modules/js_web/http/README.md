# mizchi/js_web/http

Fetch API for HTTP requests and responses.

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
  "mizchi/js_web/http",
}
```

## Overview

Provides bindings for the Fetch API: `fetch`, `Request`, `RequestInit`,
`Response`, `Headers` and `FormData`.

## Usage Example

`fetch` takes its options as labelled arguments — `method_~` is required
(`method` is a reserved word in MoonBit):

```moonbit
///|
pub async fn get_json() -> @core.Any {
  let res = @http.fetch("https://api.example.com/data", method_="GET")
  res.json()
}
```

```moonbit
///|
pub async fn post() -> String {
  let res = @http.fetch(
    "https://api.example.com/users",
    method_="POST",
    headers={ "content-type": "application/json" },
    body=@core.identity("{\"name\":\"value\"}"),
  )
  res.text()
}
```

To build a request up front, pass a `RequestInit` to the `Request`
constructor and hand it to `fetch_request`. `RequestInit` is configured at
construction — it exposes getters, not setters:

```moonbit
///|
pub async fn post_request() -> String {
  let init = @http.RequestInit(
    http_method="POST",
    body=@core.identity("{\"name\":\"value\"}"),
  )
  let request = @http.Request("https://api.example.com/users", init~)
  (@http.fetch_request(request)).text()
}
```

Serving a response — a plain text body, or any `BodyInit` (bytes, `Blob`,
`ReadableStream`, …) via `from_body_init`:

```moonbit
///|
pub fn respond() -> @http.Response {
  @http.Response(
    body="hello",
    status=200,
    headers=@core.from_entries([
      ("content-type", @core.identity("text/plain")),
    ]),
  )
}
```

Note that `Headers` and `FormData` have no constructors of their own —
`Headers` is a read side type reached through `RequestInit::get_headers`, and
a `FormData` comes from `Response::formData()`. Outgoing headers are passed
either as a `Map[String, String]` (to `fetch`) or as a `@core.Any` object
built with `@core.from_entries` (to `Response`), as above.

## Available Types

- **fetch()** / **fetch_request()** - Make HTTP requests
- **Request** / **RequestInit** - HTTP request and its options
- **Response** - HTTP response object
- **Headers** - HTTP headers, read side
- **FormData** - Form data decoding

## Reference

- [MDN: Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [MDN: Request](https://developer.mozilla.org/en-US/docs/Web/API/Request)
- [MDN: Response](https://developer.mozilla.org/en-US/docs/Web/API/Response)
