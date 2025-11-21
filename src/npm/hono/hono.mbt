///|
/// Hono - Web framework for Cloudflare Workers, Deno, Bun, etc.
/// https://hono.dev/

///|
/// Hono application instance
/// Type parameters: Env (environment bindings), ExecutionContext
#external
pub type Hono[Env, ExecutionContext]

///|
pub impl[Env, ExecutionContext] @js.JsImpl for Hono[Env, ExecutionContext]

///|
/// Create a new Hono instance
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono() -> Js =
  #| () => {
  #|   const { Hono } = require('hono');
  #|   return new Hono();
  #| }

///|
pub fn[Env, ExecutionContext] Hono::new() -> Hono[Env, ExecutionContext] {
  unsafe_cast(ffi_new_hono())
}

///|
/// Handler function type: (Context) -> Response | Promise[Response]
pub type Handler[Env, ExecutionContext] = (Context[Env, ExecutionContext]) -> @http.Response

///|
/// Middleware function type
pub type Middleware[Env, ExecutionContext] = (
  Context[Env, ExecutionContext],
  () -> Promise[@http.Response],
) -> Promise[@http.Response]

///|
/// GET route handler
/// https://hono.dev/docs/api/hono#get-post-put-delete
pub fn[Env, ExecutionContext] Hono::get(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("get", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// POST route handler
pub fn[Env, ExecutionContext] Hono::post(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("post", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// PUT route handler
pub fn[Env, ExecutionContext] Hono::put(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("put", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// DELETE route handler
pub fn[Env, ExecutionContext] Hono::delete(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("delete", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// PATCH route handler
pub fn[Env, ExecutionContext] Hono::patch(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("patch", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// OPTIONS route handler
pub fn[Env, ExecutionContext] Hono::options(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("options", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// ALL method handler
pub fn[Env, ExecutionContext] Hono::all(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("all", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// Apply middleware
/// https://hono.dev/docs/api/hono#use
pub fn[Env, ExecutionContext] Hono::use_(
  self : Hono[Env, ExecutionContext],
  path : String,
  middleware : Middleware[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("use", [path, unsafe_js(middleware)]) |> unsafe_cast
}

///|
/// Apply middleware to all paths
pub fn[Env, ExecutionContext] Hono::useall(
  self : Hono[Env, ExecutionContext],
  middleware : Middleware[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("use", [unsafe_js(middleware)]) |> unsafe_cast
}

///|
/// Handle requests
/// https://hono.dev/docs/api/hono#fetch
pub fn[Env, ExecutionContext] Hono::fetch(
  self : Hono[Env, ExecutionContext],
  request : @http.Request,
) -> Promise[@http.Response] {
  self.call("fetch", [request]) |> unsafe_cast
}

///|
/// Fire requests (for testing)
/// https://hono.dev/docs/api/hono#fire
pub fn[Env, ExecutionContext] Hono::fire(
  self : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call0("fire") |> unsafe_cast
}

///|
/// Set base path
/// https://hono.dev/docs/api/hono#basepath
#alias(base_path)
pub fn[Env, ExecutionContext] Hono::basePath(
  self : Hono[Env, ExecutionContext],
  path : String,
) -> Hono[Env, ExecutionContext] {
  self.call("basePath", [path]) |> unsafe_cast
}

///|
/// Custom 404 handler
/// https://hono.dev/docs/api/hono#notfound
#alias(not_found)
pub fn[Env, ExecutionContext] Hono::notFound(
  self : Hono[Env, ExecutionContext],
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("notFound", [unsafe_js(handler)]) |> unsafe_cast
}

///|
/// Error handler
/// https://hono.dev/docs/api/hono#onerror
#alias(on_error)
pub fn[Env, ExecutionContext] Hono::onError(
  self : Hono[Env, ExecutionContext],
  handler : (Js, Context[Env, ExecutionContext]) -> @http.Response,
) -> Hono[Env, ExecutionContext] {
  self.call("onError", [unsafe_js(handler)]) |> unsafe_cast
}

///|
/// Mount another application
/// https://hono.dev/docs/api/hono#mount
pub fn[Env, ExecutionContext] Hono::mount(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("mount", [path, app]) |> unsafe_cast
}

///|
/// Route grouping
/// https://hono.dev/docs/api/hono#route
pub fn[Env, ExecutionContext] Hono::route(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call("route", [path, app]) |> unsafe_cast
}
