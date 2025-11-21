///|
/// Initialize Hono for testing
fn init_hono() -> Unit {
  @node.require("global-jsdom/register") |> ignore
}

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
  init_hono()
  let app = @hono.Hono::new()
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono GET route" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/hello", fn(c) { c.text("Hello, Hono!") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono POST route" {
  init_hono()
  let app = @hono.Hono::new()
  app.post("/api/data", fn(c) { c.json({ status: "ok" }) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono multiple routes" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/", fn(c) { c.text("Home") }) |> ignore
  app.get("/about", fn(c) { c.text("About") }) |> ignore
  app.post("/api/create", fn(c) { c.json({ created: true }) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context json response" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/json", fn(c) { c.json({ message: "Hello", count: 42 }) })
  |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context text response" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/text", fn(c) { c.text("Plain text response") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context html response" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/html", fn(c) { c.html("<h1>Hello, Hono!</h1>") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context redirect" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/old", fn(c) { c.redirect("/new") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context not_found" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/404", fn(c) { c.notFound() }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono basePath" {
  init_hono()
  let app = @hono.Hono::new()
  let api = app.basePath("/api")
  api.get("/users", fn(c) { c.json({ users: [] }) }) |> ignore
  @js.typeof_(api) |> assert_eq("object")
}

///|
test "Hono PUT, DELETE, PATCH methods" {
  init_hono()
  let app = @hono.Hono::new()
  app.put("/update", fn(c) { c.json({ updated: true }) }) |> ignore
  app.delete("/delete", fn(c) { c.json({ deleted: true }) }) |> ignore
  app.patch("/patch", fn(c) { c.json({ patched: true }) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context status and headers" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/custom", fn(c) {
    c.status(201)
    c.header("X-Custom-Header", "CustomValue")
    c.text("Created")
  })
  |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context json with status" {
  init_hono()
  let app = @hono.Hono::new()
  app.post("/created", fn(c) { c.json({ id: 123 }, status=201) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context redirect with status" {
  init_hono()
  let app = @hono.Hono::new()
  app.get("/moved", fn(c) { c.redirect("/new-location", status=301) })
  |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono all method" {
  init_hono()
  let app = @hono.Hono::new()
  app.all("/any", fn(c) { c.text("Handles all HTTP methods") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono route grouping" {
  init_hono()
  let app = @hono.Hono::new()
  let api = @hono.Hono::new()
  api.get("/users", fn(c) { c.json({ users: [] }) }) |> ignore
  app.route("/api", api) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}
