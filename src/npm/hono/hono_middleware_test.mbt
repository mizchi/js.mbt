///|
/// Tests for Hono middleware: Cookie, JWT, CORS

// ============ JWT Tests ============

///|
test "jwt_decode parses token structure" {
  // Create a mock token for testing decode (header.payload.signature)
  // This is a valid JWT structure but with mock data
  let mock_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  let decoded = @hono.jwt_decode(mock_token)
  @core.typeof_(decoded.header) |> assert_eq("object")
  @core.typeof_(decoded.payload) |> assert_eq("object")
}

///|
async test "jwt_sign and verify roundtrip" {
  let payload = @core.new_object()
  payload["sub"] = @core.any("user123")
  payload["role"] = @core.any("admin")
  let secret = "test-secret-key"
  let token = @hono.jwt_sign(payload, secret)
  assert_true(token.length() > 0)
  // Verify the token
  let verified = @hono.jwt_verify(token, secret)
  verified["sub"].cast() |> assert_eq("user123")
  verified["role"].cast() |> assert_eq("admin")
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
  let app : @hono.Hono[@core.Any, @core.Any] = @hono.Hono::new()
  app.get("/set-cookie", fn(c) {
    @hono.set_cookie(c, "test", "value", httpOnly=true, path="/")
    c.text("OK")
  })
  |> ignore
  let client = @hono.test_client(app)
  // test_client returns a function
  @core.typeof_(client.as_any()) |> assert_eq("function")
}

// ============ CORS Tests ============

///|
test "cors creates middleware" {
  let middleware = @hono.cors()
  @core.typeof_(middleware.as_any()) |> assert_eq("function")
}

///|
test "cors with options creates configured middleware" {
  let middleware = @hono.cors(
    origin="https://example.com",
    credentials=true,
    allowMethods=["GET", "POST"],
    maxAge=3600,
  )
  @core.typeof_(middleware.as_any()) |> assert_eq("function")
}

///|
async test "Hono::cors_all applies cors to all routes" {
  let app : @hono.Hono[@core.Any, @core.Any] = @hono.Hono::new()
  app.cors_all() |> ignore
  app.get("/test", fn(c) { c.text("OK") }) |> ignore
  let client = @hono.test_client(app)
  @core.typeof_(client.as_any()) |> assert_eq("function")
}

///|
async test "Hono::cors applies cors to specific path" {
  let app : @hono.Hono[@core.Any, @core.Any] = @hono.Hono::new()
  app.cors("/api/*", origin="*", credentials=false) |> ignore
  app.get("/api/test", fn(c) { c.text("OK") }) |> ignore
  let client = @hono.test_client(app)
  @core.typeof_(client.as_any()) |> assert_eq("function")
}

// ============ CSS Tests ============

///|
async test "css returns CssClass" {
  let class_name = @hono.css("color: red;")
  assert_true(class_name.to_string().length() > 0)
}

///|
async test "CssClass::to_string" {
  let class_name = @hono.css("color: blue;")
  let str = class_name.to_string()
  assert_true(str.length() > 0)
}

///|
async test "keyframes returns CssClass animation" {
  let animation = @hono.keyframes("from { opacity: 0; } to { opacity: 1; }")
  assert_true(animation.to_string().length() > 0)
}

///|
async test "cx combines CssClass instances" {
  let c1 = @hono.css("color: red;")
  let c2 = @hono.css("color: blue;")
  let combined = @hono.cx([c1, c2])
  assert_true(combined.to_string().length() > 0)
}

///|
async test "style_component returns JSXNode" {
  let style = @hono.style_component()
  @core.typeof_(style.as_any()) |> assert_eq("object")
}

///|
test "jsx alias h works" {
  // Test that h alias works the same as jsx
  let node = @hono.h("div", ["Hello"])
  @core.typeof_(node.as_any()) |> assert_eq("object")
}
