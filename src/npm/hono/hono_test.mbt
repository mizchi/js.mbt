///|
struct StatusResponse {
  status : String
} derive(Show)

///|
struct CreatedResponse {
  created : Bool
} derive(Show)

///|
struct MessageResponse {
  message : String
  count : Int
} derive(Show)

///|
struct UpdatedResponse {
  updated : Bool
} derive(Show)

///|
struct DeletedResponse {
  deleted : Bool
} derive(Show)

///|
struct PatchedResponse {
  patched : Bool
} derive(Show)

///|
struct IdResponse {
  id : Int
} derive(Show)

///|
struct UsersResponse {
  users : Array[String]
} derive(Show)

///|
test "Hono::new creates instance" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Hono GET route" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/hello", fn(c) { c.text("Hello, Hono!") }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Hono POST route" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.post("/api/data", fn(c) { c.json({ status: "ok" }) }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Hono multiple routes" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/", fn(c) { c.text("Home") }) |> ignore
  app.get("/about", fn(c) { c.text("About") }) |> ignore
  app.post("/api/create", fn(c) { c.json({ created: true }) }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context json response" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/json", fn(c) { c.json({ message: "Hello", count: 42 }) }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context text response" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/text", fn(c) { c.text("Plain text response") }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context html response" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/html", fn(c) { c.html("<h1>Hello, Hono!</h1>") }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context redirect" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/old", fn(c) { c.redirect("/new") }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context not_found" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/404", fn(c) { c.notFound() }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Hono basePath" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  let api = app.basePath("/api")
  api.get("/users", fn(c) { c.json({ users: [] }) }) |> ignore
  @nostd.typeof_(api.as_any()) |> assert_eq("object")
}

///|
test "Hono PUT, DELETE, PATCH methods" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.put("/update", fn(c) { c.json({ updated: true }) }) |> ignore
  app.delete("/delete", fn(c) { c.json({ deleted: true }) }) |> ignore
  app.patch("/patch", fn(c) { c.json({ patched: true }) }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context status and headers" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/custom", fn(c) {
    c.status(201)
    c.header("X-Custom-Header", "CustomValue")
    c.text("Created")
  })
  |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context json with status" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.post("/created", fn(c) { c.json({ id: 123 }, status=201) }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Context redirect with status" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.get("/moved", fn(c) { c.redirect("/new-location", status=301) }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Hono all method" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  app.all("/any", fn(c) { c.text("Handles all HTTP methods") }) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

///|
test "Hono route grouping" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  let api : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()
  api.get("/users", fn(c) { c.json({ users: [] }) }) |> ignore
  app.route("/api", api) |> ignore
  @nostd.typeof_(app.as_any()) |> assert_eq("object")
}

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
  @nostd.typeof_(endpoint.as_any()) |> inspect(content="function")
}

///|
async test "testClient with JSON response" {
  let app : @hono.Hono[@js.Any, @js.Any] = @hono.Hono::new()

  // Define a JSON route
  app.get("/api/user", fn(c) {
    let user = @js.from_map({ "name": @js.any("Alice"), "age": @js.any(25) })
    c.json(user)
  })
  |> ignore

  // Create test client
  let client = @hono.test_client(app)

  // Access the route
  let endpoint = client.path("api/user")

  // Verify endpoint is created
  @nostd.typeof_(endpoint.as_any()) |> inspect(content="function")
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
  @nostd.typeof_(endpoint.as_any()) |> inspect(content="function")
}
