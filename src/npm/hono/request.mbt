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
  self.as_any().get("method").cast()
}

///|
/// Get query parameter
/// https://hono.dev/docs/api/request#query
pub fn HonoRequest::query(self : Self, key : String) -> String? {
  let result : @js.Any = self.call1("query", key)
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
  let result : @js.Any = self.call1("param", key)
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
  let result : @js.Any = self.call1("header", key)
  if result == @js.undefined() {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Parse request body as JSON
/// https://hono.dev/docs/api/request#json
pub async fn HonoRequest::json(self : Self) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call0("json").cast()
  promise.wait()
}

///|
/// Parse request body as text
/// https://hono.dev/docs/api/request#text
pub async fn HonoRequest::text(self : Self) -> String {
  let promise : @js.Promise[String] = self.call0("text").cast()
  promise.wait()
}

///|
/// Parse request body as form data
/// https://hono.dev/docs/api/request#formdata
#alias(form_data)
pub async fn HonoRequest::formData(self : Self) -> @http.FormData {
  let promise : @js.Promise[@http.FormData] = self.call0("formData").cast()
  promise.wait()
}

///|
/// Parse request body as array buffer
/// https://hono.dev/docs/api/request#arraybuffer
#alias(array_buffer)
pub async fn HonoRequest::arrayBuffer(self : Self) -> @js.ArrayBuffer {
  let promise : @js.Promise[@js.ArrayBuffer] = self.call0("arrayBuffer").cast()
  promise.wait()
}

///|
/// Parse request body as blob
/// https://hono.dev/docs/api/request#blob
pub async fn HonoRequest::blob(self : Self) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call0("blob").cast()
  promise.wait()
}

///|
/// Parse request body of multipart/form-data or application/x-www-form-urlencoded
/// https://hono.dev/docs/api/request#parsebody
#alias(parse_body)
pub async fn HonoRequest::parseBody(self : Self, options? : @js.Any) -> @js.Any {
  let promise : @js.Promise[@js.Any] = match options {
    Some(opts) => self.call1("parseBody", opts).cast()
    None => self.call0("parseBody").cast()
  }
  promise.wait()
}

///|
/// Get request path
pub fn HonoRequest::path(self : Self) -> String {
  self.call0("path").cast()
}
