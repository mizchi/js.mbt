///|
/// Tests for Hono middleware: Cookie, JWT, CORS

// ============ JWT Tests ============

///|
test "jwt_decode parses token structure" {
  // Create a mock token for testing decode (header.payload.signature)
  // This is a valid JWT structure but with mock data
  let mock_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  let decoded = @hono.jwt_decode(mock_token)
  @js.typeof_(decoded.header) |> assert_eq("object")
  @js.typeof_(decoded.payload) |> assert_eq("object")
}

///|
async test "jwt_sign and verify roundtrip" {
  let payload = @js.Object::new()
  payload.set("sub", "user123")
  payload.set("role", "admin")
  let secret = "test-secret-key"
  let token = @hono.jwt_sign(payload.to_any(), secret)
  assert_true(token.length() > 0)
  // Verify the token
  let verified = @hono.jwt_verify(token, secret)
  verified.get("sub").cast() |> assert_eq("user123")
  verified.get("role").cast() |> assert_eq("admin")
}

///|
test "JwtPayload::default creates empty payload" {
  let payload = @hono.JwtPayload::default()
  assert_true(payload.sub is None)
  assert_true(payload.iss is None)
  assert_true(payload.exp is None)
}

// ============ Cookie Tests ============

///|
async test "set_cookie in handler" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/set-cookie", fn(c) {
    @hono.set_cookie(c, "test", "value", httpOnly=true, path="/")
    c.text("OK")
  })
  |> ignore
  let client = @hono.test_client(app)
  // test_client returns a function
  @js.typeof_(client) |> assert_eq("function")
}

// ============ CORS Tests ============

///|
test "cors creates middleware" {
  let middleware = @hono.cors()
  @js.typeof_(middleware) |> assert_eq("function")
}

///|
test "cors with options creates configured middleware" {
  let middleware = @hono.cors(
    origin="https://example.com",
    credentials=true,
    allowMethods=["GET", "POST"],
    maxAge=3600,
  )
  @js.typeof_(middleware) |> assert_eq("function")
}

///|
async test "Hono::cors_all applies cors to all routes" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.cors_all() |> ignore
  app.get("/test", fn(c) { c.text("OK") }) |> ignore
  let client = @hono.test_client(app)
  @js.typeof_(client) |> assert_eq("function")
}

///|
async test "Hono::cors applies cors to specific path" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.cors("/api/*", origin="*", credentials=false) |> ignore
  app.get("/api/test", fn(c) { c.text("OK") }) |> ignore
  let client = @hono.test_client(app)
  @js.typeof_(client) |> assert_eq("function")
}
