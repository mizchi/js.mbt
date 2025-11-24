///|

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
  inspect(server.listening(), content="false")
  // Non-listening server doesn't need close
}

///| Server listening tests (with proper close)

///|
async test "Node HTTP: HTTP server can listen and close properly" {
  let mut listening_called = false
  let mut close_called = false
  let server = createServerNoListener()

  // Start listening
  server.listen(0, host="127.0.0.1", callback=fn() { listening_called = true })
  |> ignore

  // Wait for server to start
  @js.sleep(48)
  inspect(listening_called, content="true")
  inspect(server.listening(), content="true")

  // Close server with callback
  server.close(callback=fn() { close_called = true }) |> ignore

  // Wait for server to close
  @js.sleep(96)
  inspect(close_called, content="true")
}

///|
async test "Node HTTP: HTTP server can get address after listening" {
  let mut close_called = false
  let server = createServerNoListener()
  server.listen(0, host="127.0.0.1") |> ignore
  @js.sleep(48)
  let address = server.address()
  inspect(address is None, content="false")
  match address {
    Some(addr) => {
      let port : Int = @js.unsafe_cast(addr.get("port"))
      inspect(port > 0, content="true")
    }
    None => ()
  }
  server.close(callback=fn() { close_called = true }) |> ignore
  @js.sleep(96)
  inspect(close_called, content="true")
}

///| Request/Response test (single simple test)

///|
async test "Node HTTP: HTTP server handles simple request" {
  let mut request_handled = false
  let mut response_received = false
  let mut close_called = false
  let server = createServer(fn(
    _req : @http.IncomingMessage,
    res : @http.ServerResponse,
  ) {
    request_handled = true
    res.writeHead(200) |> ignore
    res.end(data="OK")
  })

  // Start server
  server.listen(0, host="127.0.0.1") |> ignore
  @js.sleep(48)

  // Get port
  let port = match server.address() {
    Some(addr) => {
      let p : Int = @js.unsafe_cast(addr.get("port"))
      p
    }
    None => 0
  }

  // Make request
  let client_req = @http.get("http://127.0.0.1:\{port}/", callback=fn(
    _res : @http.IncomingMessage,
  ) {
    response_received = true
  })
  client_req.end()

  // Wait for request/response
  @js.sleep(96)
  inspect(request_handled, content="true")
  inspect(response_received, content="true")

  // Close server
  server.close(callback=fn() { close_called = true }) |> ignore
  @js.sleep(96)
  inspect(close_called, content="true")
}

///| Module function tests

///|
async test "Node HTTP: status_codes returns status code map" {
  let codes = @http.status_codes()
  inspect(@js.typeof_(codes), content="object")

  // Check some common status codes
  let code200 : String = @js.unsafe_cast(codes.get("200"))
  inspect(code200, content="OK")
  let code404 : String = @js.unsafe_cast(codes.get("404"))
  inspect(code404, content="Not Found")
  let code500 : String = @js.unsafe_cast(codes.get("500"))
  inspect(code500, content="Internal Server Error")
}

///|
async test "Node HTTP: globalAgent exists" {
  let agent = @http.globalAgent()
  inspect(@js.typeof_(agent), content="object")
}
