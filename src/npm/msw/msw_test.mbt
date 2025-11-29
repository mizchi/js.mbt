///|
/// MSW bindings tests

///|
test "create json response" {
  let body = @js.Object::new()
  body.set("message", "hello")
  let response = @msw.jsonResponse(body.to_any())
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create json response with status" {
  let body = @js.Object::new()
  body.set("error", "not found")
  let response = @msw.jsonResponse(body.to_any(), status=404)
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create text response" {
  let response = @msw.textResponse("Hello, World!")
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create text response with status" {
  let response = @msw.textResponse("Created", status=201)
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create html response" {
  let response = @msw.htmlResponse("<h1>Hello</h1>")
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create xml response" {
  let response = @msw.xmlResponse("<root><item>test</item></root>")
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create error response" {
  let response = @msw.errorResponse()
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http get handler" {
  let handler = @msw.httpGet("/api/users", fn(_info) {
    @msw.jsonResponse(@js.Object::new().to_any())
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http post handler" {
  let handler = @msw.httpPost("/api/users", fn(_info) {
    @msw.jsonResponse(@js.Object::new().to_any(), status=201)
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http put handler" {
  let handler = @msw.httpPut("/api/users/:id", fn(_info) {
    @msw.jsonResponse(@js.Object::new().to_any())
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http patch handler" {
  let handler = @msw.httpPatch("/api/users/:id", fn(_info) {
    @msw.jsonResponse(@js.Object::new().to_any())
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http delete handler" {
  let handler = @msw.httpDelete("/api/users/:id", fn(_info) {
    @msw.textResponse("Deleted")
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http options handler" {
  let handler = @msw.httpOptions("/api/users", fn(_info) {
    @msw.textResponse("")
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http head handler" {
  let handler = @msw.httpHead("/api/users", fn(_info) { @msw.textResponse("") })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create http all handler" {
  let handler = @msw.httpAll("/api/*", fn(_info) {
    @msw.jsonResponse(@js.Object::new().to_any())
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "setup server empty" {
  let empty : Array[@msw.RequestHandler] = []
  let server = @msw.setupServer(empty)
  inspect(server.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "setup server with handlers" {
  let body = @js.Object::new()
  body.set("ok", true)
  let handler = @msw.httpGet("/test", fn(_info) {
    @msw.jsonResponse(body.to_any())
  })
  let server = @msw.setupServer([handler])
  inspect(server.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "server listen and close" {
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  server.close()
}

///|
test "server reset handlers" {
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  server.resetHandlers()
  server.close()
}

///|
test "server use handlers" {
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  let handler = @msw.httpGet("/dynamic", fn(_info) {
    @msw.textResponse("dynamic")
  })
  server.useHandlers([handler])
  server.close()
}

///|
test "server restore handlers" {
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  server.restoreHandlers()
  server.close()
}

///|
test "server list handlers" {
  let handler = @msw.httpGet("/test", fn(_info) { @msw.textResponse("ok") })
  let server = @msw.setupServer([handler])
  let handlers = server.listHandlers()
  inspect(handlers |> @js.is_nullish |> not, content="true")
}

///|
test "server reset handlers with new" {
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  let newHandler = @msw.httpGet("/new", fn(_info) { @msw.textResponse("new") })
  server.resetHandlersWith([newHandler])
  server.close()
}

///|
test "mockGet convenience" {
  let data = @js.Object::new()
  let empty_array : Array[@js.Any] = []
  data.set("users", @js.from_array(empty_array))
  let handler = @msw.mockGet("/api/users", data.to_any())
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "mockPost convenience" {
  let data = @js.Object::new()
  data.set("id", 1)
  let handler = @msw.mockPost("/api/users", data.to_any())
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "mockError convenience" {
  let handler = @msw.mockError("/api/fail", 500, "Internal Server Error")
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "handler with resolver accessing info" {
  let body = @js.Object::new()
  body.set("ok", true)
  let handler = @msw.httpGet("/api/items/:id", fn(info) {
    let _url = info.url()
    let _method = info.httpMethod()
    let _params = info.params()
    let _cookies = info.cookies()
    let _headers = info.headers()
    let _request = info.request()
    @msw.jsonResponse(body.to_any())
  })
  inspect(handler.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "array buffer response" {
  let buffer = @js.ArrayBuffer::new(8)
  let response = @msw.arrayBufferResponse(buffer.to_any())
  inspect(response.to_any() |> @js.is_nullish |> not, content="true")
}
