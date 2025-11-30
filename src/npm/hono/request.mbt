///|
/// HonoRequest type - wrapper around Request
pub(all) struct HonoRequest {
  url : String
  bodyUsed : Bool
}

///|
pub fn HonoRequest::as_any(self : HonoRequest) -> @nostd.Any = "%identity"

///|
/// Get request method
pub fn HonoRequest::method_(self : Self) -> String {
  self.as_any()["method"].cast()
}

///|
/// Get query parameter
/// https://hono.dev/docs/api/request#query
pub fn HonoRequest::query(self : Self, key : String) -> String? {
  let result = self.as_any()._call("query", [@nostd.any(key)])
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get all query parameters
#alias(query_all)
pub fn HonoRequest::queryAll(self : Self) -> @nostd.Any {
  self.as_any()._call("query", [])
}

///|
/// Get path parameter
/// https://hono.dev/docs/api/request#param
pub fn HonoRequest::param(self : Self, key : String) -> String? {
  let result = self.as_any()._call("param", [@nostd.any(key)])
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get all path parameters
#alias(param_all)
pub fn HonoRequest::paramAll(self : Self) -> @nostd.Any {
  self.as_any()._call("param", [])
}

///|
/// Get header value
/// https://hono.dev/docs/api/request#header
pub fn HonoRequest::header(self : Self, key : String) -> String? {
  let result = self.as_any()._call("header", [@nostd.any(key)])
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Parse request body as JSON
/// https://hono.dev/docs/api/request#json
pub async fn HonoRequest::json(self : Self) -> @nostd.Any {
  let promise : @nostd.Promise[@nostd.Any] = self.as_any()._call("json", []).cast()
  promise.wait()
}

///|
/// Parse request body as text
/// https://hono.dev/docs/api/request#text
pub async fn HonoRequest::text(self : Self) -> String {
  let promise : @nostd.Promise[String] = self.as_any()._call("text", []).cast()
  promise.wait()
}

///|
/// Parse request body as form data
/// https://hono.dev/docs/api/request#formdata
#alias(form_data)
pub async fn HonoRequest::formData(self : Self) -> @http.FormData {
  let promise : @nostd.Promise[@http.FormData] = self
    .as_any()
    ._call("formData", [])
    .cast()
  promise.wait()
}

///|
/// Parse request body as array buffer
/// https://hono.dev/docs/api/request#arraybuffer
#alias(array_buffer)
pub async fn HonoRequest::arrayBuffer(self : Self) -> @nostd.Any {
  let promise : @nostd.Promise[@nostd.Any] = self
    .as_any()
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
/// Parse request body as blob
/// https://hono.dev/docs/api/request#blob
pub async fn HonoRequest::blob(self : Self) -> @nostd.Any {
  let promise : @nostd.Promise[@nostd.Any] = self
    .as_any()
    ._call("blob", [])
    .cast()
  promise.wait()
}

///|
/// Parse request body of multipart/form-data or application/x-www-form-urlencoded
/// https://hono.dev/docs/api/request#parsebody
#alias(parse_body)
pub async fn HonoRequest::parseBody(
  self : Self,
  options? : @nostd.Any,
) -> @nostd.Any {
  let promise : @nostd.Promise[@nostd.Any] = match options {
    Some(opts) => self.as_any()._call("parseBody", [opts]).cast()
    None => self.as_any()._call("parseBody", []).cast()
  }
  promise.wait()
}

///|
/// Get request path
pub fn HonoRequest::path(self : Self) -> String {
  self.as_any()._call("path", []).cast()
}
