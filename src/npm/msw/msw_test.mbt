///|
/// MSW bindings tests

///|
test "create json response" {
  let body = @nostd.Object::new()
  body["message"] = @nostd.any("hello")
  let response = @msw.jsonResponse(body)
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create json response with status" {
  let body = @nostd.Object::new()
  body["error"] = @nostd.any("not found")
  let response = @msw.jsonResponse(body, status=404)
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create text response" {
  let response = @msw.textResponse("Hello, World!")
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create text response with status" {
  let response = @msw.textResponse("Created", status=201)
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create html response" {
  let response = @msw.htmlResponse("<h1>Hello</h1>")
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create xml response" {
  let response = @msw.xmlResponse("<root><item>test</item></root>")
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create error response" {
  let response = @msw.errorResponse()
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http get handler" {
  let handler = @msw.httpGet("/api/users", fn(_info) {
    @msw.jsonResponse(@nostd.Object::new())
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http post handler" {
  let handler = @msw.httpPost("/api/users", fn(_info) {
    @msw.jsonResponse(@nostd.Object::new(), status=201)
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http put handler" {
  let handler = @msw.httpPut("/api/users/:id", fn(_info) {
    @msw.jsonResponse(@nostd.Object::new())
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http patch handler" {
  let handler = @msw.httpPatch("/api/users/:id", fn(_info) {
    @msw.jsonResponse(@nostd.Object::new())
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http delete handler" {
  let handler = @msw.httpDelete("/api/users/:id", fn(_info) {
    @msw.textResponse("Deleted")
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http options handler" {
  let handler = @msw.httpOptions("/api/users", fn(_info) {
    @msw.textResponse("")
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http head handler" {
  let handler = @msw.httpHead("/api/users", fn(_info) { @msw.textResponse("") })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "create http all handler" {
  let handler = @msw.httpAll("/api/*", fn(_info) {
    @msw.jsonResponse(@nostd.Object::new())
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "setup server empty" {
  let empty : Array[@msw.RequestHandler] = []
  let server = @msw.setupServer(empty)
  inspect(server.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "setup server with handlers" {
  let body = @nostd.Object::new()
  body["ok"] = @nostd.any(true)
  let handler = @msw.httpGet("/test", fn(_info) { @msw.jsonResponse(body) })
  let server = @msw.setupServer([handler])
  inspect(server.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "server listen and close" {
  let server = @msw.setupServer([])
  defer server.close()
  server.listen(onUnhandledRequest="bypass")
}

///|
test "server reset handlers" {
  let server = @msw.setupServer([])
  defer server.close()
  server.listen(onUnhandledRequest="bypass")
  server.resetHandlers()
}

///|
test "server use handlers" {
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  defer server.close()
  let handler = @msw.httpGet("/dynamic", fn(_info) {
    @msw.textResponse("dynamic")
  })
  server.useHandlers([handler])
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
  inspect(handlers |> @nostd.is_nullish |> not, content="true")
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
  let data = @nostd.Object::new()
  data["users"] = @nostd.any([1])
  let handler = @msw.mockGet("/api/users", data)
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "mockPost convenience" {
  let data = @nostd.Object::new()
  data["id"] = @nostd.any(1)
  let handler = @msw.mockPost("/api/users", data)
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "mockError convenience" {
  let handler = @msw.mockError("/api/fail", 500, "Internal Server Error")
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
test "handler with resolver accessing info" {
  let body = @nostd.Object::new()
  body["ok"] = @nostd.any(true)
  let handler = @msw.httpGet("/api/items/:id", fn(info) {
    let _url = info.url()
    let _method = info.httpMethod()
    let _params = info.params()
    let _cookies = info.cookies()
    let _headers = info.headers()
    let _request = info.request()
    @msw.jsonResponse(body)
  })
  inspect(handler.as_any() |> @nostd.is_nullish |> not, content="true")
}

///|
extern "js" fn ffi_new_array_buffer(size : Int) -> @nostd.Any =
  #| (size) => new ArrayBuffer(size)

///|
test "array buffer response" {
  let buffer = ffi_new_array_buffer(8)
  let response = @msw.arrayBufferResponse(buffer)
  inspect(response.as_any() |> @nostd.is_nullish |> not, content="true")
}
