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
) -> @nostd.Any = "%identity"

///|
/// Create a new Hono instance without options
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono() -> @nostd.Any =
  #| () => {
  #|   const { Hono } = require('hono');
  #|   return new Hono();
  #| }

///|
/// Create a new Hono instance with options
/// https://hono.dev/docs/api/hono#new-hono
extern "js" fn ffi_new_hono_with_options(options : @nostd.Any) -> @nostd.Any =
  #| (options) => {
  #|   const { Hono } = require('hono');
  #|   return new Hono(options);
  #| }

///|
/// Build Hono options object
extern "js" fn build_hono_options(strict : Bool) -> @nostd.Any =
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
  () -> @nostd.Promise[@http.Response],
) -> @nostd.Promise[@http.Response]

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
  ._call(
    "get",
    [@nostd.any(path), @nostd.any(@js.promisify1(handler) |> @js.from_fn1)],
  )
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
  ._call(
    "post",
    [@nostd.any(path), @nostd.any(@js.promisify1(handler) |> @js.from_fn1)],
  )
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
  ._call(
    "put",
    [@nostd.any(path), @nostd.any(@js.promisify1(handler) |> @js.from_fn1)],
  )
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
  ._call(
    "delete",
    [@nostd.any(path), @nostd.any(@js.promisify1(handler) |> @js.from_fn1)],
  )
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
  ._call(
    "patch",
    [@nostd.any(path), @nostd.any(@js.promisify1(handler) |> @js.from_fn1)],
  )
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
  ._call(
    "options",
    [@nostd.any(path), @nostd.any(@js.promisify1(handler) |> @js.from_fn1)],
  )
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
  ._call(
    "all",
    [@nostd.any(path), @nostd.any(@js.promisify1(handler) |> @js.from_fn1)],
  )
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
  self
  .as_any()
  ._call("use", [@nostd.any(path), @nostd.any(middleware)])
  .cast()
}

///|
/// Apply middleware to all paths
pub fn[Env, ExecutionContext] Hono::useall(
  self : Hono[Env, ExecutionContext],
  middleware : Middleware[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("use", [@nostd.any(middleware)]).cast()
}

///|
/// Handle requests
/// https://hono.dev/docs/api/hono#fetch
pub fn[Env, ExecutionContext] Hono::fetch(
  self : Hono[Env, ExecutionContext],
  request : @http.Request,
) -> @nostd.Promise[@http.Response] {
  self.as_any()._call("fetch", [@nostd.any(request)]).cast()
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
  self.as_any()._call("basePath", [@nostd.any(path)]).cast()
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
  ._call("notFound", [@nostd.any(@js.promisify1(handler) |> @js.from_fn1)])
  .cast()
}

///|
/// Error handler
/// https://hono.dev/docs/api/hono#onerror
#alias(on_error)
pub fn[Env, ExecutionContext] Hono::onError(
  self : Hono[Env, ExecutionContext],
  handler : (@nostd.Any, Context[Env, ExecutionContext]) -> @http.Response,
) -> Hono[Env, ExecutionContext] {
  self.as_any()._call("onError", [@nostd.any(handler)]).cast()
}

///|
/// Mount another application
/// https://hono.dev/docs/api/hono#mount
pub fn[Env, ExecutionContext] Hono::mount(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("mount", [@nostd.any(path), app.as_any()])
  .cast()
}

///|
/// Route grouping
/// https://hono.dev/docs/api/hono#route
pub fn[Env, ExecutionContext] Hono::route(
  self : Hono[Env, ExecutionContext],
  path : String,
  app : Hono[Env, ExecutionContext],
) -> Hono[Env, ExecutionContext] {
  self
  .as_any()
  ._call("route", [@nostd.any(path), app.as_any()])
  .cast()
}
