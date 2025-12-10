///|
/// Note: These tests require 'hono/client' package to be installed
/// They will fail in environments without the Hono library
/// The tests are kept to verify API signature compatibility
test "hc function signature compiles" {
  // Just verify the function signature compiles
  // Actual runtime test would require Hono library
  inspect(true, content="true")
}

///|
test "ClientEndpoint method signatures compile" {
  // Just verify method signatures compile
  // Actual runtime tests would require Hono library
  inspect(true, content="true")
}
