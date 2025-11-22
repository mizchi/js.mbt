///|
using @http {
  get,
  status_codes,
  globalAgent,
  type IncomingMessage,
  type ServerResponse,
  type Server,
}

///|
fn createServer(listener : (IncomingMessage, ServerResponse) -> Unit) -> Server {
  @http.createServer(requestListener=listener)
}

///|
fn createServerNoListener() -> Server {
  @http.createServer()
}

///| Server creation tests (non-listening)

///|
test {
  it("HTTP server can be created", _ => {
    let server = createServerNoListener()
    inspect(server.listening(), content="false")
    // Non-listening server doesn't need close
  })
}

///|
test {
  it("HTTP server can be created with request listener", _ => {
    let server = createServer(fn(_req : IncomingMessage, res : ServerResponse) {
      res.writeHead(200) |> ignore
      res.end()
    })
    inspect(server.listening(), content="false")
    // Non-listening server doesn't need close
  })
}

///| Server listening tests (with proper close)

///|
test {
  it("HTTP server can listen and close properly", _ => {
    let mut listening_called = false
    let mut close_called = false
    let server = createServerNoListener()

    // Start listening
    server.listen(0, host="127.0.0.1", callback=fn() { listening_called = true })
    |> ignore

    // Wait for server to start
    sleep(50)
    inspect(listening_called, content="true")
    inspect(server.listening(), content="true")

    // Close server with callback
    server.close(callback=fn() { close_called = true }) |> ignore

    // Wait for server to close
    sleep(100)
    inspect(close_called, content="true")
  })
}

///|
test {
  it("HTTP server can get address after listening", _ => {
    let mut close_called = false
    let server = createServerNoListener()
    server.listen(0, host="127.0.0.1") |> ignore
    sleep(50)
    let address = server.address()
    inspect(address.is_empty(), content="false")
    match address {
      Some(addr) => {
        let port : Int = @js.unsafe_cast(addr.get("port"))
        inspect(port > 0, content="true")
      }
      None => ()
    }
    server.close(callback=fn() { close_called = true }) |> ignore
    sleep(100)
    inspect(close_called, content="true")
  })
}

///| Request/Response test (single simple test)

///|
test {
  it("HTTP server handles simple request", _ => {
    let mut request_handled = false
    let mut response_received = false
    let mut close_called = false
    let server = createServer(fn(_req : IncomingMessage, res : ServerResponse) {
      request_handled = true
      res.writeHead(200) |> ignore
      res.end(data="OK")
    })

    // Start server
    server.listen(0, host="127.0.0.1") |> ignore
    sleep(50)

    // Get port
    let port = match server.address() {
      Some(addr) => {
        let p : Int = @js.unsafe_cast(addr.get("port"))
        p
      }
      None => 0
    }

    // Make request
    let client_req = get("http://127.0.0.1:\{port}/", callback=fn(
      _res : IncomingMessage,
    ) {
      response_received = true
    })
    client_req.end()

    // Wait for request/response
    sleep(100)
    inspect(request_handled, content="true")
    inspect(response_received, content="true")

    // Close server
    server.close(callback=fn() { close_called = true }) |> ignore
    sleep(100)
    inspect(close_called, content="true")
  })
}

///| Module function tests

///|
test {
  it("status_codes returns status code map", _ => {
    let codes = status_codes()
    inspect(@js.typeof_(codes), content="object")

    // Check some common status codes
    let code200 : String = @js.unsafe_cast(codes.get("200"))
    inspect(code200, content="OK")
    let code404 : String = @js.unsafe_cast(codes.get("404"))
    inspect(code404, content="Not Found")
    let code500 : String = @js.unsafe_cast(codes.get("500"))
    inspect(code500, content="Internal Server Error")
  })
}

///|
test {
  it("globalAgent exists", _ => {
    let agent = globalAgent()
    inspect(@js.typeof_(agent), content="object")
  })
}
