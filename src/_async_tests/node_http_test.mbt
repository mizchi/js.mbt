///|
using @http {
  request,
  get,
  status_codes,
  globalAgent,
  type IncomingMessage,
  type ServerResponse,
  type Server,
}

fn createServer(listener : (IncomingMessage, ServerResponse) -> Unit) -> Server {
  @http.createServer(requestListener=listener)
}

fn createServerNoListener() -> Server {
  @http.createServer()
}

///| Server creation tests

///|
test {
  it("HTTP server can be created", _ => {
    let server = createServerNoListener()
    inspect(server.listening(), content="false")
    server.close(callback=fn() {}) |> ignore; sleep(50)
  })
}

///|
test {
  it("HTTP server can be created with request listener", _ => {
    let mut request_received = false
    let server = createServer(fn(_req : IncomingMessage, res : ServerResponse) {
      request_received = true
      res.writeHead(200) |> ignore
      res.end()
    })
    inspect(server.listening(), content="false")
    server.close(callback=fn() {}) |> ignore; sleep(50)
  })
}

///|
test {
  it("HTTP server can listen on a port", _ => {
    let mut listening = false
    let mut closed = false
    let server = createServerNoListener()
    server.listen(0, host="127.0.0.1", callback=fn() { listening = true })
    |> ignore
    sleep(100)
    inspect(listening, content="true")
    inspect(server.listening(), content="true")
    server.close(callback=fn() { closed = true }) |> ignore
    sleep(100)
    inspect(closed, content="true")
  })
}

///|
test {
  it("HTTP server can get address", _ => {
    let mut closed = false
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
    server.close(callback=fn() { closed = true }) |> ignore
    sleep(100)
    inspect(closed, content="true")
  })
}

///| Request/Response tests

///|
test {
  it("HTTP server handles request and sends response", _ => {
    let mut request_handled = false
    let mut response_body = ""

    let server = createServer(fn(req : IncomingMessage, res : ServerResponse) {
      request_handled = true
      // Check request properties exist
      let _ = req.httpVersion()
      let _ = req.method_()
      let _ = req.url()

      // Send response
      res.writeHead(200, headers=@js.from_entries([
        ("Content-Type", "text/plain"),
      ])) |> ignore
      res.end(data="Hello World")
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
    let mut response_received = false
    let client_req = get(
      "http://127.0.0.1:\{port}/",
      callback=fn(res : IncomingMessage) {
        response_received = true
        let status = match res.statusCode() {
          Some(code) => code
          None => 0
        }
        let _ = status

        // Read response body
        res.as_readable().on("data", fn(chunk) {
          let data : String = @js.unsafe_cast(chunk)
          response_body = data
        })
      },
    )
    client_req.end()

    sleep(100)
    inspect(request_handled, content="true")
    inspect(response_received, content="true")
    inspect(response_body, content="Hello World")

    let mut closed = false
    server.close(callback=fn() { closed = true }) |> ignore
    sleep(100)
    inspect(closed, content="true")
  })
}

///|
test {
  it("HTTP server can set and get headers", _ => {
    let mut header_check_passed = false

    let server = createServer(fn(_req : IncomingMessage, res : ServerResponse) {
      res.setHeader("X-Custom-Header", "test-value")
      res.setHeader("X-Another-Header", "another-value")

      let header1 = res.getHeader("X-Custom-Header")
      let has_header1 = match header1 {
        Some(_) => true
        None => false
      }

      res.removeHeader("X-Another-Header")
      let header2 = res.getHeader("X-Another-Header")
      let has_header2 = match header2 {
        Some(_) => true
        None => false
      }

      header_check_passed = has_header1 && not(has_header2)

      res.writeHead(200) |> ignore
      res.end()
    })

    server.listen(0, host="127.0.0.1") |> ignore
    sleep(50)

    let port = match server.address() {
      Some(addr) => {
        let p : Int = @js.unsafe_cast(addr.get("port"))
        p
      }
      None => 0
    }

    let mut response_has_headers = false
    let client_req = get(
      "http://127.0.0.1:\{port}/",
      callback=fn(res : IncomingMessage) {
        let headers = res.headers()
        response_has_headers = @js.typeof_(headers) == "object"
      },
    )
    client_req.end()

    sleep(100)
    inspect(header_check_passed, content="true")
    inspect(response_has_headers, content="true")

    server.close(callback=fn() {}) |> ignore; sleep(50)
  })
}

///|
test {
  it("HTTP server can handle multiple requests", _ => {
    let mut request_count = 0
    let server = createServer(fn(_req : IncomingMessage, res : ServerResponse) {
      request_count = request_count + 1
      res.writeHead(200) |> ignore
      res.end(data="Request \{request_count}")
    })

    server.listen(0, host="127.0.0.1") |> ignore
    sleep(50)

    let port = match server.address() {
      Some(addr) => {
        let p : Int = @js.unsafe_cast(addr.get("port"))
        p
      }
      None => 0
    }

    // Make first request
    let req1 = get("http://127.0.0.1:\{port}/", callback=fn(_res) {})
    req1.end()

    sleep(50)

    // Make second request
    let req2 = get("http://127.0.0.1:\{port}/", callback=fn(_res) {})
    req2.end()

    sleep(50)

    // Make third request
    let req3 = get("http://127.0.0.1:\{port}/", callback=fn(_res) {})
    req3.end()

    sleep(100)
    inspect(request_count, content="3")

    server.close(callback=fn() {}) |> ignore; sleep(50)
  })
}

///|
test {
  it("HTTP client request can set headers", _ => {
    let mut header_received = ""

    let server = createServer(fn(req : IncomingMessage, res : ServerResponse) {
      let headers = req.headers()
      let custom_header : String = @js.unsafe_cast(
        headers.get("x-client-header"),
      )
      header_received = custom_header

      res.writeHead(200) |> ignore
      res.end()
    })

    server.listen(0, host="127.0.0.1") |> ignore
    sleep(50)

    let port = match server.address() {
      Some(addr) => {
        let p : Int = @js.unsafe_cast(addr.get("port"))
        p
      }
      None => 0
    }

    let client_req = request("http://127.0.0.1:\{port}/")
    client_req.setHeader("X-Client-Header", "client-value")
    client_req.end()

    sleep(100)
    inspect(header_received, content="client-value")

    server.close(callback=fn() {}) |> ignore; sleep(50)
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

///|
test {
  it("ServerResponse status code and message can be set", _ => {
    let mut status_check = 0
    let mut message_check = ""

    let server = createServer(fn(_req : IncomingMessage, res : ServerResponse) {
      res.set_statusCode(201)
      res.set_statusMessage("Created")

      status_check = res.statusCode()
      message_check = res.statusMessage()

      res.end()
    })

    server.listen(0, host="127.0.0.1") |> ignore
    sleep(50)

    let port = match server.address() {
      Some(addr) => {
        let p : Int = @js.unsafe_cast(addr.get("port"))
        p
      }
      None => 0
    }

    let mut client_status = 0
    let client_req = get(
      "http://127.0.0.1:\{port}/",
      callback=fn(res : IncomingMessage) {
        client_status = match res.statusCode() {
          Some(code) => code
          None => 0
        }
      },
    )
    client_req.end()

    sleep(100)
    inspect(status_check, content="201")
    inspect(message_check, content="Created")
    inspect(client_status, content="201")

    server.close(callback=fn() {}) |> ignore; sleep(50)
  })
}
