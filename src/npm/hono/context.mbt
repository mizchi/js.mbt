///|
/// Context object passed to handlers
/// Type parameters: Env (environment bindings), ExecutionContext
pub(all) struct Context[Env, ExecutionContext] {
  req : HonoRequest
  env : Env
  executionCtx : ExecutionContext
}

///|
pub impl[Env, ExecutionContext] @js.JsImpl for Context[Env, ExecutionContext]

///|
/// Get execution context (c.executionCtx)
/// Alias for executionCtx field
#alias(execution_ctx)
pub fn Context::executionCtx[Env, ExecutionContext](
  self : Context[Env, ExecutionContext]
) -> ExecutionContext {
  self.executionCtx
}

///|
/// Return JSON response
/// https://hono.dev/docs/api/context#json
pub fn Context::json[Env, ExecutionContext, T](
  self : Context[Env, ExecutionContext],
  data : T,
  status? : Int
) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("json", [unsafe_cast(data), status_code]) |> unsafe_cast
}

///|
/// Return text response
/// https://hono.dev/docs/api/context#text
pub fn Context::text[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  text : String,
  status? : Int
) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("text", [text, status_code]) |> unsafe_cast
}

///|
/// Return HTML response
/// https://hono.dev/docs/api/context#html
pub fn Context::html[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  html : String,
  status? : Int
) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("html", [html, status_code]) |> unsafe_cast
}

///|
/// Redirect to URL
/// https://hono.dev/docs/api/context#redirect
pub fn Context::redirect[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  url : String,
  status? : Int
) -> @http.Response {
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
pub fn Context::notFound[Env, ExecutionContext](
  self : Context[Env, ExecutionContext]
) -> @http.Response {
  self.call0("notFound") |> unsafe_cast
}

///|
/// Set response header
/// https://hono.dev/docs/api/context#header
pub fn Context::header[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  name : String,
  value : String
) -> Unit {
  self.call("header", [name, value]) |> ignore
}

///|
/// Set status code
/// https://hono.dev/docs/api/context#status
pub fn Context::status[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  code : Int
) -> Unit {
  self.call("status", [code]) |> ignore
}

///|
/// Set a value in context
/// https://hono.dev/docs/api/context#set-get
pub fn Context::set[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  key : String,
  value : Js
) -> Unit {
  self.call("set", [key, value]) |> ignore
}

///|
/// Get a value from context
#alias(get_value)
pub fn Context::getValue[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  key : String
) -> Js {
  self.call("get", [key])
}

///|
/// Get the Response object
/// https://hono.dev/docs/api/context#res
pub fn Context::res[Env, ExecutionContext](
  self : Context[Env, ExecutionContext]
) -> @http.Response {
  self.get("res") |> unsafe_cast
}

///|
/// Get a variable from context
/// https://hono.dev/docs/api/context#var
pub fn Context::var_[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  key : String
) -> Js {
  self.get("var").get(key)
}

///|
/// Return a Response with body
/// https://hono.dev/docs/api/context#body
pub fn Context::body[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  body : String,
  status? : Int,
  headers? : Js
) -> @http.Response {
  match (status, headers) {
    (Some(s), Some(h)) => self.call("body", [body, s, h]) |> unsafe_cast
    (Some(s), None) => self.call("body", [body, s]) |> unsafe_cast
    _ => self.call("body", [body]) |> unsafe_cast
  }
}

///|
/// Set a custom renderer for templates
/// https://hono.dev/docs/api/context#setrenderer
#alias(set_renderer)
pub fn Context::setRenderer[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  renderer : (String) -> @http.Response
) -> Unit {
  self.call("setRenderer", [unsafe_js(renderer)]) |> ignore
}

///|
/// Render content using the renderer set by setRenderer
/// https://hono.dev/docs/api/context#render-setrenderer
pub fn Context::render[Env, ExecutionContext](
  self : Context[Env, ExecutionContext],
  content : String
) -> @http.Response {
  self.call("render", [content]) |> unsafe_cast
}
