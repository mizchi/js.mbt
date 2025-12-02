///|
/// Hono CORS Middleware
/// https://hono.dev/docs/middleware/builtin/cors

///|
/// CORS middleware type
#external
pub type CorsMiddleware

///|
pub fn CorsMiddleware::as_any(self : CorsMiddleware) -> @core.Any = "%identity"

///|
fn build_cors_options(
  origin? : String,
  allowMethods? : Array[String],
  allowHeaders? : Array[String],
  maxAge? : Int,
  credentials? : Bool,
  exposeHeaders? : Array[String],
) -> @core.Any {
  let obj = @core.new_object()
  if origin is Some(v) {
    obj["origin"] = @core.any(v)
  }
  if allowMethods is Some(v) {
    obj["allowMethods"] = @core.any(v)
  }
  if allowHeaders is Some(v) {
    obj["allowHeaders"] = @core.any(v)
  }
  if maxAge is Some(v) {
    obj["maxAge"] = @core.any(v)
  }
  if credentials is Some(v) {
    obj["credentials"] = @core.any(v)
  }
  if exposeHeaders is Some(v) {
    obj["exposeHeaders"] = @core.any(v)
  }
  obj
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
  ).cast()
}

///|
extern "js" fn ffi_cors_with_options(options : @core.Any) -> @core.Any =
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
  self.as_any()._call("use", [@core.any(path), middleware.as_any()]).cast()
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
  self.as_any()._call("use", [middleware.as_any()]).cast()
}
