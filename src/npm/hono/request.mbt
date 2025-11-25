///|
/// HonoRequest type - wrapper around Request
pub(all) struct HonoRequest {
  url : String
  bodyUsed : Bool
}

///|
pub impl @js.JsImpl for HonoRequest

///|
/// Get request method
pub fn HonoRequest::method_(self : Self) -> String {
  self.to_any().get("method").cast()
}

///|
/// Get query parameter
/// https://hono.dev/docs/api/request#query
pub fn HonoRequest::query(self : Self, key : String) -> String? {
  let result : @js.Any = self.call("query", [key])
  if result == @js.undefined() {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Get all query parameters
#alias(query_all)
pub fn HonoRequest::queryAll(self : Self) -> @js.Any {
  self.call0("query")
}

///|
/// Get path parameter
/// https://hono.dev/docs/api/request#param
pub fn HonoRequest::param(self : Self, key : String) -> String? {
  let result : @js.Any = self.call("param", [key])
  if result == @js.undefined() {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Get all path parameters
#alias(param_all)
pub fn HonoRequest::paramAll(self : Self) -> @js.Any {
  self.call0("param")
}

///|
/// Get header value
/// https://hono.dev/docs/api/request#header
pub fn HonoRequest::header(self : Self, key : String) -> String? {
  let result : @js.Any = self.call("header", [key])
  if result == @js.undefined() {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Parse request body as JSON
/// https://hono.dev/docs/api/request#json
pub fn HonoRequest::json(self : Self) -> @js.Promise[@js.Any] {
  self.call0("json").cast()
}

///|
/// Parse request body as text
/// https://hono.dev/docs/api/request#text
pub fn HonoRequest::text(self : Self) -> @js.Promise[String] {
  self.call0("text").cast()
}

///|
/// Parse request body as form data
/// https://hono.dev/docs/api/request#formdata
#alias(form_data)
pub fn HonoRequest::formData(self : Self) -> @js.Promise[@http.FormData] {
  self.call0("formData").cast()
}

///|
/// Parse request body as array buffer
/// https://hono.dev/docs/api/request#arraybuffer
#alias(array_buffer)
pub fn HonoRequest::arrayBuffer(self : Self) -> @js.Promise[@js.ArrayBuffer] {
  self.call0("arrayBuffer").cast()
}

///|
/// Parse request body as blob
/// https://hono.dev/docs/api/request#blob
pub fn HonoRequest::blob(self : Self) -> @js.Promise[@js.Any] {
  self.call0("blob").cast()
}

///|
/// Parse request body of multipart/form-data or application/x-www-form-urlencoded
/// https://hono.dev/docs/api/request#parsebody
#alias(parse_body)
pub fn HonoRequest::parseBody(
  self : Self,
  options? : @js.Any,
) -> @js.Promise[@js.Any] {
  match options {
    Some(opts) => self.call("parseBody", [opts]).cast()
    None => self.call0("parseBody").cast()
  }
}

///|
/// Get request path
pub fn HonoRequest::path(self : Self) -> String {
  self.call0("path").cast()
}
