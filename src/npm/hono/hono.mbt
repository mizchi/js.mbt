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
/// Create a new Hono instance without options
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono() -> @js.Any =
  #| () => {
  #|   const { Hono } = require('hono');
  #|   return new Hono();
  #| }

///|
/// Create a new Hono instance with options
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono_with_options(options : @js.Any) -> @js.Any =
  #| (options) => {
  #|   const { Hono } = require('hono');
  #|   return new Hono(options);
  #| }

///|
/// Build Hono options object
extern "js" fn build_hono_options(strict : Bool) -> @js.Any =
  #| (strict) => {
  #|   return { strict };
  #| }

///|
/// Create a new Hono instance
/// Example with strict mode disabled:
/// ```moonbit no-check
/// let app = Hono::new(strict=false)
/// ```
pub fn[Env, ExecutionContext] Hono::new(
  strict? : Bool,
) -> Hono[Env, ExecutionContext] {
  match strict {
    Some(s) => @js.identity(ffi_new_hono_with_options(build_hono_options(s)))
    None => @js.identity(ffi_new_hono())
  }
}

///|
/// Handler function type: (Context) -> Response | Promise[Response]
pub type Handler[Env, ExecutionContext] = (Context[Env, ExecutionContext]) -> @http.Response

///|
/// Middleware function type
pub type Middleware[Env, ExecutionContext] = (
  Context[Env, ExecutionContext],
  () -> @js.Promise[@http.Response],
) -> @js.Promise[@http.Response]

///|
/// GET route handler
/// https://hono.dev/docs/api/hono#get-post-put-delete
pub fn[Env, ExecutionContext] Hono::get(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("get", path, @js.unsafe_any(handler)).cast()
}

///|
/// POST route handler
pub fn[Env, ExecutionContext] Hono::post(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("post", path, @js.unsafe_any(handler)).cast()
}

///|
/// PUT route handler
pub fn[Env, ExecutionContext] Hono::put(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("put", path, @js.unsafe_any(handler)).cast()
}

///|
/// DELETE route handler
pub fn[Env, ExecutionContext] Hono::delete(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("delete", path, @js.unsafe_any(handler)).cast()
}

///|
/// PATCH route handler
pub fn[Env, ExecutionContext] Hono::patch(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("patch", path, @js.unsafe_any(handler)).cast()
}

///|
/// OPTIONS route handler
pub fn[Env, ExecutionContext] Hono::options(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("options", path, @js.unsafe_any(handler)).cast()
}

///|
/// ALL method handler
pub fn[Env, ExecutionContext] Hono::all(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("all", path, @js.unsafe_any(handler)).cast()
}

///|
/// Apply middleware
/// https://hono.dev/docs/api/hono#use
pub fn[Env, ExecutionContext] Hono::use_(
  self : Hono[Env, ExecutionContext],
  path : String,
  middleware : Middleware[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("use", path, @js.unsafe_any(middleware)).cast()
}

///|
/// Apply middleware to all paths
pub fn[Env, ExecutionContext] Hono::useall(
  self : Hono[Env, ExecutionContext],
  middleware : Middleware[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call1("use", @js.unsafe_any(middleware)).cast()
}

///|
/// Handle requests
/// https://hono.dev/docs/api/hono#fetch
pub fn[Env, ExecutionContext] Hono::fetch(
  self : Hono[Env, ExecutionContext],
  request : @http.Request,
) -> @js.Promise[@http.Response] {
  self.call1("fetch", request).cast()
}

///|
/// Fire requests (for testing)
/// https://hono.dev/docs/api/hono#fire
pub fn[Env, ExecutionContext] Hono::fire(
  self : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call0("fire").cast()
}

///|
/// Set base path
/// https://hono.dev/docs/api/hono#basepath
#alias(base_path)
pub fn[Env, ExecutionContext] Hono::basePath(
  self : Hono[Env, ExecutionContext],
  path : String,
) -> Hono[Env, ExecutionContext] {
  self.call1("basePath", path).cast()
}

///|
/// Custom 404 handler
/// https://hono.dev/docs/api/hono#notfound
#alias(not_found)
pub fn[Env, ExecutionContext] Hono::notFound(
  self : Hono[Env, ExecutionContext],
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call1("notFound", @js.unsafe_any(handler)).cast()
}

///|
/// Error handler
/// https://hono.dev/docs/api/hono#onerror
#alias(on_error)
pub fn[Env, ExecutionContext] Hono::onError(
  self : Hono[Env, ExecutionContext],
  handler : (@js.Any, Context[Env, ExecutionContext]) -> @http.Response,
) -> Hono[Env, ExecutionContext] {
  self.call1("onError", @js.unsafe_any(handler)).cast()
}

///|
/// Mount another application
/// https://hono.dev/docs/api/hono#mount
pub fn[Env, ExecutionContext] Hono::mount(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("mount", path, app).cast()
}

///|
/// Route grouping
/// https://hono.dev/docs/api/hono#route
pub fn[Env, ExecutionContext] Hono::route(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.call2("route", path, app).cast()
}
