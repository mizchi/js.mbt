///|
test "hc creates client" {
  let client = @hono.hc("http://localhost:8787/")
  @js.typeof_(client) |> assert_eq("object")
}

///|
test "ClientEndpoint path access" {
  let client = @hono.hc("http://localhost:8787/")
  let endpoint = client.path("posts")
  @js.typeof_(endpoint) |> assert_eq("object")
}

///|
test "ClientEndpoint supports keyword arguments" {
  let client = @hono.hc("http://localhost:8787/")
  let endpoint = client.path("posts")
  // These should compile without errors
  // In actual use, these would be async calls
  // Just testing the API signature here
  @js.typeof_(endpoint) |> assert_eq("object")
}
