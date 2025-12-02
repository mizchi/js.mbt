///|
/// Hono - Web framework for Cloudflare Workers, Deno, Bun, etc.
/// https://hono.dev/

///|
/// Hono application instance
/// Type parameters: Env (environment bindings), ExecutionContext
#external
pub type Hono[Env, ExecutionContext]

///|
pub fn[Env, ExecutionContext] Hono::as_any(
  self : Hono[Env, ExecutionContext],
) -> @core.Any = "%identity"

///|
/// Create a new Hono instance without options
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono() -> @core.Any =
  #| () => {
  #|   const { Hono } = require('hono');
  #|   return new Hono();
  #| }

///|
/// Create a new Hono instance with options
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono_with_options(options : @core.Any) -> @core.Any =
  #| (options) => {
  #|   const { Hono } = require('hono');
  #|   return new Hono(options);
  #| }

///|
/// Build Hono options object
extern "js" fn build_hono_options(strict : Bool) -> @core.Any =
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
    Some(s) => ffi_new_hono_with_options(build_hono_options(s)).cast()
    None => ffi_new_hono().cast()
  }
}

///|
/// Handler function type: (Context) -> Response | Promise[Response]
pub type Handler[Env, ExecutionContext] = async (Context[Env, ExecutionContext]) -> @http.Response

///|
/// Middleware function type
pub type Middleware[Env, ExecutionContext] = (
  Context[Env, ExecutionContext],
  () -> @core.Promise[@http.Response],
) -> @core.Promise[@http.Response]

///|
/// GET route handler
/// https://hono.dev/docs/api/hono#get-post-put-delete
pub fn[Env, ExecutionContext] Hono::get(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("get", [
    @core.any(path),
    @core.any(@js.promisify1(handler) |> @js.from_fn1),
  ])
  .cast()
}

///|
/// POST route handler
pub fn[Env, ExecutionContext] Hono::post(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("post", [
    @core.any(path),
    @core.any(@js.promisify1(handler) |> @js.from_fn1),
  ])
  .cast()
}

///|
/// PUT route handler
pub fn[Env, ExecutionContext] Hono::put(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("put", [
    @core.any(path),
    @core.any(@js.promisify1(handler) |> @js.from_fn1),
  ])
  .cast()
}

///|
/// DELETE route handler
pub fn[Env, ExecutionContext] Hono::delete(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("delete", [
    @core.any(path),
    @core.any(@js.promisify1(handler) |> @js.from_fn1),
  ])
  .cast()
}

///|
/// PATCH route handler
pub fn[Env, ExecutionContext] Hono::patch(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("patch", [
    @core.any(path),
    @core.any(@js.promisify1(handler) |> @js.from_fn1),
  ])
  .cast()
}

///|
/// OPTIONS route handler
pub fn[Env, ExecutionContext] Hono::options(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("options", [
    @core.any(path),
    @core.any(@js.promisify1(handler) |> @js.from_fn1),
  ])
  .cast()
}

///|
/// ALL method handler
pub fn[Env, ExecutionContext] Hono::all(
  self : Hono[Env, ExecutionContext],
  path : String,
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("all", [
    @core.any(path),
    @core.any(@js.promisify1(handler) |> @js.from_fn1),
  ])
  .cast()
}

///|
/// Apply middleware
/// https://hono.dev/docs/api/hono#use
pub fn[Env, ExecutionContext] Hono::use_(
  self : Hono[Env, ExecutionContext],
  path : String,
  middleware : Middleware[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("use", [@core.any(path), @core.any(middleware)]).cast()
}

///|
/// Apply middleware to all paths
pub fn[Env, ExecutionContext] Hono::useall(
  self : Hono[Env, ExecutionContext],
  middleware : Middleware[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("use", [@core.any(middleware)]).cast()
}

///|
/// Handle requests
/// https://hono.dev/docs/api/hono#fetch
pub fn[Env, ExecutionContext] Hono::fetch(
  self : Hono[Env, ExecutionContext],
  request : @http.Request,
) -> @core.Promise[@http.Response] {
  self.as_any()._call("fetch", [@core.any(request)]).cast()
}

///|
/// Fire requests (for testing)
/// https://hono.dev/docs/api/hono#fire
pub fn[Env, ExecutionContext] Hono::fire(
  self : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("fire", []).cast()
}

///|
/// Set base path
/// https://hono.dev/docs/api/hono#basepath
#alias(base_path)
pub fn[Env, ExecutionContext] Hono::basePath(
  self : Hono[Env, ExecutionContext],
  path : String,
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("basePath", [@core.any(path)]).cast()
}

///|
/// Custom 404 handler
/// https://hono.dev/docs/api/hono#notfound
#alias(not_found)
pub fn[Env, ExecutionContext] Hono::notFound(
  self : Hono[Env, ExecutionContext],
  handler : Handler[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("notFound", [@core.any(@js.promisify1(handler) |> @js.from_fn1)])
  .cast()
}

///|
/// Error handler
/// https://hono.dev/docs/api/hono#onerror
#alias(on_error)
pub fn[Env, ExecutionContext] Hono::onError(
  self : Hono[Env, ExecutionContext],
  handler : (@core.Any, Context[Env, ExecutionContext]) -> @http.Response,
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("onError", [@core.any(handler)]).cast()
}

///|
/// Mount another application
/// https://hono.dev/docs/api/hono#mount
pub fn[Env, ExecutionContext] Hono::mount(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("mount", [@core.any(path), app.as_any()]).cast()
}

///|
/// Route grouping
/// https://hono.dev/docs/api/hono#route
pub fn[Env, ExecutionContext] Hono::route(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("route", [@core.any(path), app.as_any()]).cast()
}
