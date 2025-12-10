///|
/// Better Auth Hono Integration
/// https://www.better-auth.com/docs/integrations/hono

///|
/// Get raw Request from HonoRequest
fn get_raw_request(req : HonoRequest) -> @http.Request {
  req.as_any()["raw"].cast()
}

///|
/// Convert auth handler to Hono handler
pub fn[Env, ExecutionContext] toHonoHandler(
  auth : @better_auth.Auth,
) -> Handler[Env, ExecutionContext] {
  let handler : @core.Any = auth.handler().cast()
  async fn(ctx) {
    let req = get_raw_request(ctx.req)
    let response : @http.Response = ffi_call_handler(handler, req).wait()
    response
  }
}

///|
extern "js" fn ffi_call_handler(
  handler : @core.Any,
  request : @http.Request,
) -> @core.Promise[@http.Response] =
  #|(handler, request) => handler(request)

///|
/// Mount auth routes on Hono app at /api/auth/*
pub fn[Env, ExecutionContext] mount_auth(
  app : Hono[Env, ExecutionContext],
  auth : @better_auth.Auth,
) -> Hono[Env, ExecutionContext] {
  let handler : Handler[Env, ExecutionContext] = toHonoHandler(auth)
  app.all("/api/auth/*", handler)
}
