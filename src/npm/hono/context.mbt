///|
/// Context object passed to handlers
#external
pub type Context

///|
pub impl @js.JsImpl for Context

///|
/// Context methods for handling requests and responses
/// https://hono.dev/docs/api/context

///|
/// Get the Request object
/// https://hono.dev/docs/api/context#req
pub fn Context::req(self : Self) -> HonoRequest {
  self.get("req") |> unsafe_cast
}

///|
/// Return JSON response
/// https://hono.dev/docs/api/context#json
pub fn Context::json(self : Self, data : Js, status? : Int) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("json", [data, status_code]) |> unsafe_cast
}

///|
/// Return text response
/// https://hono.dev/docs/api/context#text
pub fn Context::text(self : Self, text : String, status? : Int) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("text", [text, status_code]) |> unsafe_cast
}

///|
/// Return HTML response
/// https://hono.dev/docs/api/context#html
pub fn Context::html(self : Self, html : String, status? : Int) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("html", [html, status_code]) |> unsafe_cast
}

///|
/// Redirect to URL
/// https://hono.dev/docs/api/context#redirect
pub fn Context::redirect(self : Self, url : String, status? : Int) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 302
  }
  self.call("redirect", [url, status_code]) |> unsafe_cast
}

///|
/// Return 404 Not Found
/// https://hono.dev/docs/api/context#notfound
#alias(not_found)
pub fn Context::notFound(self : Self) -> @http.Response {
  self.call0("notFound") |> unsafe_cast
}

///|
/// Set response header
/// https://hono.dev/docs/api/context#header
pub fn Context::header(self : Self, name : String, value : String) -> Unit {
  self.call("header", [name, value]) |> ignore
}

///|
/// Set status code
/// https://hono.dev/docs/api/context#status
pub fn Context::status(self : Self, code : Int) -> Unit {
  self.call("status", [code]) |> ignore
}

///|
/// Set a value in context
/// https://hono.dev/docs/api/context#set-get
pub fn Context::set(self : Self, key : String, value : Js) -> Unit {
  self.call("set", [key, value]) |> ignore
}

///|
/// Get a value from context
#alias(get_value)
pub fn Context::getValue(self : Self, key : String) -> Js {
  self.call("get", [key])
}

///|
/// Get the Response object
/// https://hono.dev/docs/api/context#res
pub fn Context::res(self : Self) -> @http.Response {
  self.get("res") |> unsafe_cast
}

///|
/// Get a variable from context
/// https://hono.dev/docs/api/context#var
pub fn Context::var_(self : Self, key : String) -> Js {
  self.get("var").get(key)
}

///|
/// Return a Response with body
/// https://hono.dev/docs/api/context#body
pub fn Context::body(
  self : Self,
  body : String,
  status? : Int,
  headers? : Js,
) -> @http.Response {
  match (status, headers) {
    (Some(s), Some(h)) => self.call("body", [body, s, h]) |> unsafe_cast
    (Some(s), None) => self.call("body", [body, s]) |> unsafe_cast
    _ => self.call("body", [body]) |> unsafe_cast
  }
}
