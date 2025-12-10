///|
/// MSW bindings tests

///|
async test "create json response" {
  let msw = @msw.import_msw()
  let body = @core.new_object()
  body["message"] = @core.any("hello")
  let response = msw.jsonResponse(body)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create json response with status" {
  let msw = @msw.import_msw()
  let body = @core.new_object()
  body["error"] = @core.any("not found")
  let response = msw.jsonResponse(body, status=404)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create text response" {
  let msw = @msw.import_msw()
  let response = msw.textResponse("Hello, World!")
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create text response with status" {
  let msw = @msw.import_msw()
  let response = msw.textResponse("Created", status=201)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create html response" {
  let msw = @msw.import_msw()
  let response = msw.htmlResponse("<h1>Hello</h1>")
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create xml response" {
  let msw = @msw.import_msw()
  let response = msw.xmlResponse("<root><item>test</item></root>")
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create error response" {
  let msw = @msw.import_msw()
  let response = msw.errorResponse()
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http get handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpGet("/api/users", fn(_info) {
    msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http post handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpPost("/api/users", fn(_info) {
    msw.jsonResponse(@core.new_object(), status=201)
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http put handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpPut("/api/users/:id", fn(_info) {
    msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http patch handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpPatch("/api/users/:id", fn(_info) {
    msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http delete handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpDelete("/api/users/:id", fn(_info) {
    msw.textResponse("Deleted")
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http options handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpOptions("/api/users", fn(_info) { msw.textResponse("") })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http head handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpHead("/api/users", fn(_info) { msw.textResponse("") })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "create http all handler" {
  let msw = @msw.import_msw()
  let handler = msw.httpAll("/api/*", fn(_info) {
    msw.jsonResponse(@core.new_object())
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "setup server empty" {
  let msw_node = @msw.import_msw_node()
  let empty : Array[@msw.RequestHandler] = []
  let server = msw_node.setupServer(empty)
  inspect(server.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "setup server with handlers" {
  let msw = @msw.import_msw()
  let msw_node = @msw.import_msw_node()
  let body = @core.new_object()
  body["ok"] = @core.any(true)
  let handler = msw.httpGet("/test", fn(_info) { msw.jsonResponse(body) })
  let server = msw_node.setupServer([handler])
  inspect(server.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "server listen and close" {
  let msw_node = @msw.import_msw_node()
  let server = msw_node.setupServer([])
  defer server.close()
  server.listen(onUnhandledRequest="bypass")
}

///|
async test "server reset handlers" {
  let msw_node = @msw.import_msw_node()
  let server = msw_node.setupServer([])
  defer server.close()
  server.listen(onUnhandledRequest="bypass")
  server.resetHandlers()
}

///|
async test "server use handlers" {
  let msw = @msw.import_msw()
  let msw_node = @msw.import_msw_node()
  let server = msw_node.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  defer server.close()
  let handler = msw.httpGet("/dynamic", fn(_info) {
    msw.textResponse("dynamic")
  })
  server.useHandlers([handler])
}

///|
async test "server restore handlers" {
  let msw_node = @msw.import_msw_node()
  let server = msw_node.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  server.restoreHandlers()
  server.close()
}

///|
async test "server list handlers" {
  let msw = @msw.import_msw()
  let msw_node = @msw.import_msw_node()
  let handler = msw.httpGet("/test", fn(_info) { msw.textResponse("ok") })
  let server = msw_node.setupServer([handler])
  let handlers = server.listHandlers()
  inspect(handlers |> @core.is_nullish |> not, content="true")
}

///|
async test "server reset handlers with new" {
  let msw = @msw.import_msw()
  let msw_node = @msw.import_msw_node()
  let server = msw_node.setupServer([])
  server.listen(onUnhandledRequest="bypass")
  let newHandler = msw.httpGet("/new", fn(_info) { msw.textResponse("new") })
  server.resetHandlersWith([newHandler])
  server.close()
}

///|
async test "mockGet convenience" {
  let msw = @msw.import_msw()
  let data = @core.new_object()
  data["users"] = @core.any([1])
  let handler = msw.mockGet("/api/users", data)
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "mockPost convenience" {
  let msw = @msw.import_msw()
  let data = @core.new_object()
  data["id"] = @core.any(1)
  let handler = msw.mockPost("/api/users", data)
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "mockError convenience" {
  let msw = @msw.import_msw()
  let handler = msw.mockError("/api/fail", 500, "Internal Server Error")
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
async test "handler with resolver accessing info" {
  let msw = @msw.import_msw()
  let body = @core.new_object()
  body["ok"] = @core.any(true)
  let handler = msw.httpGet("/api/items/:id", fn(info) {
    let _url = info.url()
    let _method = info.httpMethod()
    let _params = info.params()
    let _cookies = info.cookies()
    let _headers = info.headers()
    let _request = info.request()
    msw.jsonResponse(body)
  })
  inspect(handler.as_any() |> @core.is_nullish |> not, content="true")
}

///|
extern "js" fn ffi_new_array_buffer(size : Int) -> @core.Any =
  #| (size) => new ArrayBuffer(size)

///|
async test "array buffer response" {
  let msw = @msw.import_msw()
  let buffer = ffi_new_array_buffer(8)
  let response = msw.arrayBufferResponse(buffer)
  inspect(response.as_any() |> @core.is_nullish |> not, content="true")
}
