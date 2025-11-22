# mizchi/js/web/http

Fetch API for HTTP requests and responses.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/web/http"
  ]
}
```

## Overview

Provides bindings for the Fetch API, including Request, Response, Headers, and FormData.

## Usage Example

```moonbit
fn main {
  // Simple GET request
  let response = @http.fetch("https://api.example.com/data")
  
  // Create a Request
  let request = @http.Request::new("https://api.example.com/users")
  request.set_method("POST")
  request.set_header("Content-Type", "application/json")
  
  // Fetch with options
  let init = @http.RequestInit::new()
  init.set_method("POST")
  init.set_body("{\"name\":\"value\"}")
  let response2 = @http.fetch_with_init("https://api.example.com", init)
  
  // Working with Headers
  let headers = @http.Headers::new()
  headers.set("Content-Type", "application/json")
  headers.append("X-Custom-Header", "value")
  
  // Working with FormData
  let form = @http.FormData::new()
  form.append("field", "value")
  
  // Create Response
  let response3 = @http.Response::new("body content")
}
```

## Available Types

- **fetch()** - Make HTTP requests
- **Request** - HTTP request object
- **Response** - HTTP response object
- **Headers** - HTTP headers manipulation
- **FormData** - Form data encoding

## Reference

- [MDN: Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [MDN: Request](https://developer.mozilla.org/en-US/docs/Web/API/Request)
- [MDN: Response](https://developer.mozilla.org/en-US/docs/Web/API/Response)
