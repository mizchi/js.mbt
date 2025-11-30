///|
/// Hono CORS Middleware
/// https://hono.dev/docs/middleware/builtin/cors

///|
/// CORS middleware type
#external
pub type CorsMiddleware

///|
pub impl @js.JsImpl for CorsMiddleware

///|
fn build_cors_options(
  origin? : String,
  allowMethods? : Array[String],
  allowHeaders? : Array[String],
  maxAge? : Int,
  credentials? : Bool,
  exposeHeaders? : Array[String],
) -> @js.Any {
  let obj = @js.Object::new()
  if origin is Some(v) {
    obj.set("origin", v)
  }
  if allowMethods is Some(v) {
    obj.set("allowMethods", v |> @js.from_array)
  }
  if allowHeaders is Some(v) {
    obj.set("allowHeaders", v |> @js.from_array)
  }
  if maxAge is Some(v) {
    obj.set("maxAge", v)
  }
  if credentials is Some(v) {
    obj.set("credentials", v)
  }
  if exposeHeaders is Some(v) {
    obj.set("exposeHeaders", v |> @js.from_array)
  }
  obj.as_any()
}

///|
/// Create CORS middleware
/// https://hono.dev/docs/middleware/builtin/cors
pub fn cors(
  origin? : String,
  allowMethods? : Array[String],
  allowHeaders? : Array[String],
  maxAge? : Int,
  credentials? : Bool,
  exposeHeaders? : Array[String],
) -> CorsMiddleware {
  ffi_cors_with_options(
    build_cors_options(
      origin?,
      allowMethods?,
      allowHeaders?,
      maxAge?,
      credentials?,
      exposeHeaders?,
    ),
  )
  |> @js.identity
}

///|
extern "js" fn ffi_cors_with_options(options : @js.Any) -> @js.Any =
  #|(options) => {
  #|  const { cors } = require('hono/cors');
  #|  return cors(options);
  #|}

///|
/// Apply CORS middleware to Hono app for a specific path
pub fn[Env, ExecutionContext] Hono::cors(
  self : Hono[Env, ExecutionContext],
  path : String,
  origin? : String,
  allowMethods? : Array[String],
  allowHeaders? : Array[String],
  maxAge? : Int,
  credentials? : Bool,
  exposeHeaders? : Array[String],
) -> Hono[Env, ExecutionContext] {
  let middleware = cors(
    origin?,
    allowMethods?,
    allowHeaders?,
    maxAge?,
    credentials?,
    exposeHeaders?,
  )
  self.call2("use", path, @js.unsafe_any(middleware)).cast()
}

///|
/// Apply CORS middleware to all paths
pub fn[Env, ExecutionContext] Hono::cors_all(
  self : Hono[Env, ExecutionContext],
  origin? : String,
  allowMethods? : Array[String],
  allowHeaders? : Array[String],
  maxAge? : Int,
  credentials? : Bool,
  exposeHeaders? : Array[String],
) -> Hono[Env, ExecutionContext] {
  let middleware = cors(
    origin?,
    allowMethods?,
    allowHeaders?,
    maxAge?,
    credentials?,
    exposeHeaders?,
  )
  self.call1("use", @js.unsafe_any(middleware)).cast()
}
