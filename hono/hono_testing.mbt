///|
/// Hono Testing Helper
/// https://hono.dev/docs/helpers/testing

///| FFI with #module for ESM

///|
#module("hono/testing")
extern "js" fn ffi_test_client(app : @core.Any) -> @core.Any = "testClient"

///| Public API

///|
/// Create a test client for a Hono application
/// Original: testClient(app)
pub fn[Env, ExecutionContext] test_client(
  app : Hono[Env, ExecutionContext],
) -> HonoClient {
  ffi_test_client(app.as_any()).cast()
}
