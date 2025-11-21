///|
/// HonoRequest type - wrapper around Request
#external
pub type HonoRequest

///|
pub impl @js.JsImpl for HonoRequest

///|
/// Get query parameter
/// https://hono.dev/docs/api/request#query
pub fn HonoRequest::query(self : Self, key : String) -> String? {
  let result : Js = self.call("query", [key])
  if result == @js.undefined() {
    None
  } else {
    Some(unsafe_cast(result))
  }
}

///|
/// Get all query parameters
#alias(query_all)
pub fn HonoRequest::queryAll(self : Self) -> Js {
  self.call0("query")
}

///|
/// Get path parameter
/// https://hono.dev/docs/api/request#param
pub fn HonoRequest::param(self : Self, key : String) -> String? {
  let result : Js = self.call("param", [key])
  if result == @js.undefined() {
    None
  } else {
    Some(unsafe_cast(result))
  }
}

///|
/// Get all path parameters
#alias(param_all)
pub fn HonoRequest::paramAll(self : Self) -> Js {
  self.call0("param")
}

///|
/// Get header value
/// https://hono.dev/docs/api/request#header
pub fn HonoRequest::header(self : Self, key : String) -> String? {
  let result : Js = self.call("header", [key])
  if result == @js.undefined() {
    None
  } else {
    Some(unsafe_cast(result))
  }
}

///|
/// Parse request body as JSON
/// https://hono.dev/docs/api/request#json
pub fn HonoRequest::json(self : Self) -> Promise[Js] {
  self.call0("json") |> unsafe_cast
}

///|
/// Parse request body as text
/// https://hono.dev/docs/api/request#text
pub fn HonoRequest::text(self : Self) -> Promise[String] {
  self.call0("text") |> unsafe_cast
}

///|
/// Parse request body as form data
/// https://hono.dev/docs/api/request#formdata
#alias(form_data)
pub fn HonoRequest::formData(self : Self) -> Promise[@http.FormData] {
  self.call0("formData") |> unsafe_cast
}

///|
/// Parse request body as array buffer
/// https://hono.dev/docs/api/request#arraybuffer
#alias(array_buffer)
pub fn HonoRequest::arrayBuffer(
  self : Self,
) -> Promise[@arraybuffer.ArrayBuffer] {
  self.call0("arrayBuffer") |> unsafe_cast
}

///|
/// Get request URL
pub fn HonoRequest::url(self : Self) -> String {
  self.get("url") |> unsafe_cast
}

///|
/// Get request method
pub fn HonoRequest::method_(self : Self) -> String {
  self.get("method") |> unsafe_cast
}

///|
/// Get request path
pub fn HonoRequest::path(self : Self) -> String {
  self.call0("path") |> unsafe_cast
}

///|
/// Check if request body has been used
#alias(body_used)
pub fn HonoRequest::bodyUsed(self : Self) -> Bool {
  self.get("bodyUsed") |> unsafe_cast
}
