///|
/// Hono - Web framework for Cloudflare Workers, Deno, Bun, etc.
/// https://hono.dev/

///|
/// Hono application instance
#external
pub type Hono

///|
pub impl @js.JsImpl for Hono

///|
/// Create a new Hono instance
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono() -> Js =
  #| () => {
  #|   const { Hono } = require('hono');
  #|   return new Hono();
  #| }

///|
pub fn Hono::new() -> Hono {
  unsafe_cast(ffi_new_hono())
}

///|
/// Handler function type: (Context) -> Response | Promise[Response]
pub type Handler = (Context) -> @http.Response

///|
/// Middleware function type
pub type Middleware = (Context, () -> Promise[@http.Response]) -> Promise[
  @http.Response,
]

///|
/// GET route handler
/// https://hono.dev/docs/api/hono#get-post-put-delete
pub fn Hono::get(self : Self, path : String, handler : Handler) -> Hono {
  self.call("get", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// POST route handler
pub fn Hono::post(self : Self, path : String, handler : Handler) -> Hono {
  self.call("post", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// PUT route handler
pub fn Hono::put(self : Self, path : String, handler : Handler) -> Hono {
  self.call("put", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// DELETE route handler
pub fn Hono::delete(self : Self, path : String, handler : Handler) -> Hono {
  self.call("delete", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// PATCH route handler
pub fn Hono::patch(self : Self, path : String, handler : Handler) -> Hono {
  self.call("patch", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// OPTIONS route handler
pub fn Hono::options(self : Self, path : String, handler : Handler) -> Hono {
  self.call("options", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// ALL method handler
pub fn Hono::all(self : Self, path : String, handler : Handler) -> Hono {
  self.call("all", [path, unsafe_js(handler)]) |> unsafe_cast
}

///|
/// Apply middleware
/// https://hono.dev/docs/api/hono#use
pub fn Hono::use_(self : Self, path : String, middleware : Middleware) -> Hono {
  self.call("use", [path, unsafe_js(middleware)]) |> unsafe_cast
}

///|
/// Apply middleware to all paths
pub fn Hono::useall(self : Self, middleware : Middleware) -> Hono {
  self.call("use", [unsafe_js(middleware)]) |> unsafe_cast
}

///|
/// Handle requests
/// https://hono.dev/docs/api/hono#fetch
pub fn Hono::fetch(
  self : Self,
  request : @http.Request,
) -> Promise[@http.Response] {
  self.call("fetch", [request]) |> unsafe_cast
}

///|
/// Fire requests (for testing)
/// https://hono.dev/docs/api/hono#fire
pub fn Hono::fire(self : Self) -> Hono {
  self.call0("fire") |> unsafe_cast
}

///|
/// Set base path
/// https://hono.dev/docs/api/hono#basepath
#alias(base_path)
pub fn Hono::basePath(self : Self, path : String) -> Hono {
  self.call("basePath", [path]) |> unsafe_cast
}

///|
/// Custom 404 handler
/// https://hono.dev/docs/api/hono#notfound
#alias(not_found)
pub fn Hono::notFound(self : Self, handler : Handler) -> Hono {
  self.call("notFound", [unsafe_js(handler)]) |> unsafe_cast
}

///|
/// Error handler
/// https://hono.dev/docs/api/hono#onerror
#alias(on_error)
pub fn Hono::onError(
  self : Self,
  handler : (Js, Context) -> @http.Response,
) -> Hono {
  self.call("onError", [unsafe_js(handler)]) |> unsafe_cast
}

///|
/// Mount another application
/// https://hono.dev/docs/api/hono#mount
pub fn Hono::mount(self : Self, path : String, app : Hono) -> Hono {
  self.call("mount", [path, app]) |> unsafe_cast
}

///|
/// Route grouping
/// https://hono.dev/docs/api/hono#route
pub fn Hono::route(self : Self, path : String, app : Hono) -> Hono {
  self.call("route", [path, app]) |> unsafe_cast
}
