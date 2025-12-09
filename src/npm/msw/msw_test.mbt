///|
/// MSW bindings tests

///|
fn setup() -> Unit {
  @msw.init_msw(@node.require("msw"))
  @msw.init_msw_node(@node.require("msw/node"))
}

///|
test "create json response" {
  setup()
  let body = @core.new_object()
  body["message"] = @core.any("hello")
  let response = @msw.jsonResponse(body)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create json response with status" {
  setup()
  let body = @core.new_object()
  body["error"] = @core.any("not found")
  let response = @msw.jsonResponse(body, status=404)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create text response" {
  setup()
  let response = @msw.textResponse("Hello, World!")
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create text response with status" {
  setup()
  let response = @msw.textResponse("Created", status=201)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create html response" {
  setup()
  let response = @msw.htmlResponse("<h1>Hello</h1>")
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create xml response" {
  setup()
  let response = @msw.xmlResponse("<root><item>test</item></root>")
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create error response" {
  setup()
  let response = @msw.errorResponse()
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http get handler" {
  setup()
  let handler = @msw.httpGet("/api/users", fn(_info) {
    @msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http post handler" {
  setup()
  let handler = @msw.httpPost("/api/users", fn(_info) {
    @msw.jsonResponse(@core.new_object(), status=201)
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http put handler" {
  setup()
  let handler = @msw.httpPut("/api/users/:id", fn(_info) {
    @msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http patch handler" {
  setup()
  let handler = @msw.httpPatch("/api/users/:id", fn(_info) {
    @msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http delete handler" {
  setup()
  let handler = @msw.httpDelete("/api/users/:id", fn(_info) {
    @msw.textResponse("Deleted")
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http options handler" {
  setup()
  let handler = @msw.httpOptions("/api/users", fn(_info) {
    @msw.textResponse("")
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http head handler" {
  setup()
  let handler = @msw.httpHead("/api/users", fn(_info) { @msw.textResponse("") })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "create http all handler" {
  setup()
  let handler = @msw.httpAll("/api/*", fn(_info) {
    @msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "setup server empty" {
  setup()
  let empty : Array[@msw.RequestHandler] = []
  let server = @msw.setupServer(empty)
  inspect(server.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "setup server with handlers" {
  setup()
  let body = @core.new_object()
  body["ok"] = @core.any(true)
  let handler = @msw.httpGet("/test", fn(_info) { @msw.jsonResponse(body) })
  let server = @msw.setupServer([handler])
  inspect(server.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "server listen and close" {
  setup()
  let server = @msw.setupServer([])
  defer server.close()
  server.listen(onUnhandledRequest="bypass")
}

///|
test "server reset handlers" {
  setup()
  let server = @msw.setupServer([])
  defer server.close()
  server.listen(onUnhandledRequest="bypass")
  server.resetHandlers()
}

///|
test "server use handlers" {
  setup()
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
  setup()
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  server.restoreHandlers()
  server.close()
}

///|
test "server list handlers" {
  setup()
  let handler = @msw.httpGet("/test", fn(_info) { @msw.textResponse("ok") })
  let server = @msw.setupServer([handler])
  let handlers = server.listHandlers()
  inspect(handlers |> @core.is_nullish |> not, content="true")
}

///|
test "server reset handlers with new" {
  setup()
  let server = @msw.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  let newHandler = @msw.httpGet("/new", fn(_info) { @msw.textResponse("new") })
  server.resetHandlersWith([newHandler])
  server.close()
}

///|
test "mockGet convenience" {
  setup()
  let data = @core.new_object()
  data["users"] = @core.any([1])
  let handler = @msw.mockGet("/api/users", data)
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "mockPost convenience" {
  setup()
  let data = @core.new_object()
  data["id"] = @core.any(1)
  let handler = @msw.mockPost("/api/users", data)
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "mockError convenience" {
  setup()
  let handler = @msw.mockError("/api/fail", 500, "Internal Server Error")
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
test "handler with resolver accessing info" {
  setup()
  let body = @core.new_object()
  body["ok"] = @core.any(true)
  let handler = @msw.httpGet("/api/items/:id", fn(info) {
    let _url = info.url()
    let _method = info.httpMethod()
    let _params = info.params()
    let _cookies = info.cookies()
    let _headers = info.headers()
    let _request = info.request()
    @msw.jsonResponse(body)
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
extern "js" fn ffi_new_array_buffer(size : Int) -> @core.Any =
  #| (size) => new ArrayBuffer(size)

///|
test "array buffer response" {
  setup()
  let buffer = ffi_new_array_buffer(8)
  let response = @msw.arrayBufferResponse(buffer)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}
