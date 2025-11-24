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
pub fn[Env, ExecutionContext] Context::executionCtx(
  self : Context[Env, ExecutionContext],
) -> ExecutionContext {
  self.executionCtx
}

///|
/// Return JSON response
/// https://hono.dev/docs/api/context#json
pub fn[Env, ExecutionContext, T] Context::json(
  self : Context[Env, ExecutionContext],
  data : T,
  status? : Int,
) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("json", [@js.identity(data), status_code]).cast()
}

///|
/// Return text response
/// https://hono.dev/docs/api/context#text
pub fn[Env, ExecutionContext] Context::text(
  self : Context[Env, ExecutionContext],
  text : String,
  status? : Int,
) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("text", [text, status_code]).cast()
}

///|
/// Return HTML response
/// https://hono.dev/docs/api/context#html
pub fn[Env, ExecutionContext] Context::html(
  self : Context[Env, ExecutionContext],
  html : String,
  status? : Int,
) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.call("html", [html, status_code]).cast()
}

///|
/// Redirect to URL
/// https://hono.dev/docs/api/context#redirect
pub fn[Env, ExecutionContext] Context::redirect(
  self : Context[Env, ExecutionContext],
  url : String,
  status? : Int,
) -> @http.Response {
  let status_code = match status {
    Some(s) => s
    None => 302
  }
  self.call("redirect", [url, status_code]).cast()
}

///|
/// Return 404 Not Found
/// https://hono.dev/docs/api/context#notfound
#alias(not_found)
pub fn[Env, ExecutionContext] Context::notFound(
  self : Context[Env, ExecutionContext],
) -> @http.Response {
  self.call0("notFound") |> @js.identity
}

///|
/// Set response header
/// https://hono.dev/docs/api/context#header
pub fn[Env, ExecutionContext] Context::header(
  self : Context[Env, ExecutionContext],
  name : String,
  value : String,
) -> Unit {
  self.call("header", [name, value]) |> ignore
}

///|
/// Set status code
/// https://hono.dev/docs/api/context#status
pub fn[Env, ExecutionContext] Context::status(
  self : Context[Env, ExecutionContext],
  code : Int,
) -> Unit {
  self.call("status", [code]) |> ignore
}

///|
/// Set a value in context
/// https://hono.dev/docs/api/context#set-get
pub fn[Env, ExecutionContext] Context::set(
  self : Context[Env, ExecutionContext],
  key : String,
  value : @js.Any,
) -> Unit {
  self.call("set", [key, value]) |> ignore
}

///|
/// Get a value from context
#alias(get_value)
pub fn[Env, ExecutionContext] Context::getValue(
  self : Context[Env, ExecutionContext],
  key : String,
) -> @js.Any {
  self.call("get", [key])
}

///|
/// Get the Response object
/// https://hono.dev/docs/api/context#res
pub fn[Env, ExecutionContext] Context::res(
  self : Context[Env, ExecutionContext],
) -> @http.Response {
  self.get("res").cast()
}

///|
/// Get a variable from context
/// https://hono.dev/docs/api/context#var
pub fn[Env, ExecutionContext] Context::var_(
  self : Context[Env, ExecutionContext],
  key : String,
) -> @js.Any {
  self.get("var").get(key)
}

///|
/// Return a Response with body
/// https://hono.dev/docs/api/context#body
pub fn[Env, ExecutionContext] Context::body(
  self : Context[Env, ExecutionContext],
  body : String,
  status? : Int,
  headers? : @js.Any,
) -> @http.Response {
  match (status, headers) {
    (Some(s), Some(h)) => self.call("body", [body, s, h]).cast()
    (Some(s), None) => self.call("body", [body, s]).cast()
    _ => self.call("body", [body]).cast()
  }
}

///|
/// Set a custom renderer for templates
/// https://hono.dev/docs/api/context#setrenderer
#alias(set_renderer)
pub fn[Env, ExecutionContext] Context::setRenderer(
  self : Context[Env, ExecutionContext],
  renderer : (String) -> @http.Response,
) -> Unit {
  self.call("setRenderer", [@js.unsafe_js(renderer)]) |> ignore
}

///|
/// Render content using the renderer set by setRenderer
/// https://hono.dev/docs/api/context#render-setrenderer
pub fn[Env, ExecutionContext] Context::render(
  self : Context[Env, ExecutionContext],
  content : String,
) -> @http.Response {
  self.call("render", [content]).cast()
}
