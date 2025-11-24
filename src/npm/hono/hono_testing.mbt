///|
/// Hono Testing Helper
/// https://hono.dev/docs/helpers/testing

///|
/// Create a test client from a Hono app instance
/// The test client allows you to make type-safe requests to your Hono app routes
/// Returns an object that mirrors your app's route structure
extern "js" fn ffi_test_client(app : @js.Js) -> @js.Js =
  #| (app) => {
  #|   const { testClient } = require('hono/testing');
  #|   return testClient(app);
  #| }

///|
/// Create a test client for a Hono application
/// Original: testClient(app)
pub fn[Env, ExecutionContext] test_client(
  app : Hono[Env, ExecutionContext],
) -> HonoClient {
  ffi_test_client(@js.identity(app)) |> @js.identity
}
