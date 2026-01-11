///|
fn createServer(
  listener : (@http.IncomingMessage, @http.ServerResponse) -> Unit,
) -> @http.Server {
  @http.createServer(requestListener=listener)
}

///|
fn createServerNoListener() -> @http.Server {
  @http.createServer()
}

///| Server creation tests (non-listening)

///|
async test "Node HTTP: HTTP server can be created" {
  let server = createServerNoListener()
  defer server.close() |> ignore // Cleanup to prevent leaks
  inspect(server.listening(), content="false")
  // Non-listening server doesn't need close
}

///|
async test "Node HTTP: HTTP server can be created with request listener" {
  let server = createServer(fn(
    _req : @http.IncomingMessage,
    res : @http.ServerResponse,
  ) {
    res.writeHead(200) |> ignore
    res.end()
  })
  defer server.close() |> ignore // Cleanup to prevent leaks
  inspect(server.listening(), content="false")
  // Non-listening server doesn't need close
}

///| Server listening tests (with proper close)

///|
async test "Node HTTP: HTTP server can listen and close properly" {
  let server = createServerNoListener()
  defer server.close() |> ignore // Cleanup to prevent leaks

  // Start listening and suspend until ready
  @core.suspend(fn(resolve, _reject) {
    server.listen(0, host="127.0.0.1", callback=() => resolve(())) |> ignore
  })
  inspect(server.listening(), content="true")

  // Explicitly close server with callback and suspend until closed
  @core.suspend(fn(resolve, _reject) {
    server.close(callback=() => resolve(())) |> ignore
  })
  inspect(server.listening(), content="false")
}

///|
async test "Node HTTP: HTTP server can get address after listening" {
  let server = createServerNoListener()
  defer server.close() |> ignore // Cleanup to prevent leaks

  // Start listening and suspend until ready
  @core.suspend(fn(resolve, _reject) {
    server.listen(0, host="127.0.0.1", callback=() => resolve(())) |> ignore
  })
  let address = server.address()
  inspect(address is None, content="false")
  match address {
    Some(addr) => {
      let port = addr.port()
      inspect(port > 0, content="true")
    }
    None => ()
  }

  // Explicitly close server with callback and suspend until closed
  @core.suspend(fn(resolve, _reject) {
    server.close(callback=() => resolve(())) |> ignore
  })
  inspect(server.listening(), content="false")
}

///| Request/Response test (single simple test)

///|
async test "Node HTTP: HTTP server handles simple request" {
  let mut request_handled = false
  let server = createServer(fn(
    _req : @http.IncomingMessage,
    res : @http.ServerResponse,
  ) {
    request_handled = true
    res.writeHead(200) |> ignore
    res.end(data="OK")
  })
  defer server.close() |> ignore // Cleanup to prevent leaks

  // Start server with callback and suspend until ready
  @core.suspend(fn(resolve, _reject) {
    server.listen(0, host="127.0.0.1", callback=() => resolve(())) |> ignore
  })
  inspect(server.listening(), content="true")

  // Get port
  let port = match server.address() {
    Some(addr) => addr.port()
    None => 0
  }

  // Make request and suspend until response received
  @core.suspend(fn(resolve, _reject) {
    let client_req = @http.get("http://127.0.0.1:\{port}/", callback=_res => resolve(
      (),
    ))
    client_req.end()
  })
  inspect(request_handled, content="true")

  // Explicitly close server with callback and suspend until closed
  @core.suspend(fn(resolve, _reject) {
    server.close(callback=() => resolve(())) |> ignore
  })
  inspect(server.listening(), content="false")
}

///| Module function tests

///|
async test "Node HTTP: status_codes returns status code map" {
  let codes = @http.status_codes()
  inspect(@core.typeof_(codes), content="object")

  // Check some common status codes
  let code200 : String = @core.identity(codes._get("200"))
  inspect(code200, content="OK")
  let code404 : String = @core.identity(codes._get("404"))
  inspect(code404, content="Not Found")
  let code500 : String = @core.identity(codes._get("500"))
  inspect(code500, content="Internal Server Error")
}

///|
async test "Node HTTP: globalAgent exists" {
  let agent = @http.globalAgent()
  inspect(@core.typeof_(agent), content="object")
}
