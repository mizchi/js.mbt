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
test "ClientRequestOptions struct" {
  let opts : @hono.ClientRequestOptions = {
    query: @js.from_entries([("page", 1), ("limit", 10)]),
    form: @js.undefined(),
    json: @js.undefined(),
    param: @js.undefined(),
    header: @js.undefined(),
    init: @js.undefined(),
  }
  @js.typeof_(opts) |> assert_eq("object")
}

///|
test "ClientRequestOptions with json" {
  let opts : @hono.ClientRequestOptions = {
    query: @js.undefined(),
    form: @js.undefined(),
    json: @js.from_entries([("title", "Hello"), ("body", "World")]),
    param: @js.undefined(),
    header: @js.undefined(),
    init: @js.undefined(),
  }
  @js.typeof_(opts) |> assert_eq("object")
}

///|
test "ClientRequestOptions with form" {
  let opts : @hono.ClientRequestOptions = {
    query: @js.undefined(),
    form: @js.from_entries([("username", "alice"), ("password", "secret")]),
    json: @js.undefined(),
    param: @js.undefined(),
    header: @js.undefined(),
    init: @js.undefined(),
  }
  @js.typeof_(opts) |> assert_eq("object")
}

///|
test "ClientRequestOptions default" {
  let opts = @hono.ClientRequestOptions::default()
  @js.typeof_(opts) |> assert_eq("object")
}
