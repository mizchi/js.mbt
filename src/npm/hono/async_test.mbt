///|
/// Hono Testing Integration Tests
/// These tests demonstrate the usage of Hono with testClient
async test "testClient with simple GET route" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()

  // Define a simple route
  app.get("/hello", fn(c) { c.text("Hello World") }) |> ignore

  // Create test client
  let client = @hono.test_client(app)

  // Access the route
  let endpoint = client.path("hello")

  // Verify endpoint is created
  @js.typeof_(endpoint) |> inspect(content="function")
}

///|
async test "testClient with JSON response" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()

  // Define a JSON route
  app.get("/api/user", fn(c) {
    let user = @js.from_entries([("name", "Alice"), ("age", 25)])
    c.json(user)
  })
  |> ignore

  // Create test client
  let client = @hono.test_client(app)

  // Access the route
  let endpoint = client.path("api/user")

  // Verify endpoint is created
  @js.typeof_(endpoint) |> inspect(content="function")
}

///|
async test "testClient with POST route" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()

  // Define a POST route
  app.post("/api/create", fn(c) { c.text("Created") }) |> ignore

  // Create test client
  let client = @hono.test_client(app)

  // Access the route
  let endpoint = client.path("api/create")

  // Verify endpoint is created
  @js.typeof_(endpoint) |> inspect(content="function")
}
