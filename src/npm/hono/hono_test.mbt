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
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono GET route" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/hello", fn(c) { c.text("Hello, Hono!") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono POST route" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.post("/api/data", fn(c) { c.json({ status: "ok" }) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono multiple routes" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/", fn(c) { c.text("Home") }) |> ignore
  app.get("/about", fn(c) { c.text("About") }) |> ignore
  app.post("/api/create", fn(c) { c.json({ created: true }) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context json response" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/json", fn(c) { c.json({ message: "Hello", count: 42 }) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context text response" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/text", fn(c) { c.text("Plain text response") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context html response" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/html", fn(c) { c.html("<h1>Hello, Hono!</h1>") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context redirect" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/old", fn(c) { c.redirect("/new") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context not_found" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/404", fn(c) { c.notFound() }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono basePath" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  let api = app.basePath("/api")
  api.get("/users", fn(c) { c.json({ users: [] }) }) |> ignore
  @js.typeof_(api) |> assert_eq("object")
}

///|
test "Hono PUT, DELETE, PATCH methods" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.put("/update", fn(c) { c.json({ updated: true }) }) |> ignore
  app.delete("/delete", fn(c) { c.json({ deleted: true }) }) |> ignore
  app.patch("/patch", fn(c) { c.json({ patched: true }) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context status and headers" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
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
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.post("/created", fn(c) { c.json({ id: 123 }, status=201) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Context redirect with status" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.get("/moved", fn(c) { c.redirect("/new-location", status=301) }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono all method" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  app.all("/any", fn(c) { c.text("Handles all HTTP methods") }) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}

///|
test "Hono route grouping" {
  let app : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  let api : @hono.Hono[@js.Js, @js.Js] = @hono.Hono::new()
  api.get("/users", fn(c) { c.json({ users: [] }) }) |> ignore
  app.route("/api", api) |> ignore
  @js.typeof_(app) |> assert_eq("object")
}
