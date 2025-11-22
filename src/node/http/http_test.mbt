///|
/// Basic HTTP server test
test "http server creation" {
  let server = createServer()
  inspect(server |> @js.typeof_, content="object")
}

///|
/// Test server with request listener
test "http server with request listener" {
  let server = createServer(requestListener=fn(
    _req : IncomingMessage,
    res : ServerResponse,
  ) {
    res.writeHead(
      200,
      headers=@js.from_entries([("Content-Type", "text/plain")]),
    )
    |> ignore
    res.end(data="Hello World")
  })
  inspect(server |> @js.typeof_, content="object")
}

///|
/// Test IncomingMessage methods
test "incoming message methods exist" {
  let server = createServer(requestListener=fn(
    req : IncomingMessage,
    _res : ServerResponse,
  ) {
    // Test that methods exist
    let _ = req.httpVersion()
    let _ = req.headers()
    let _ = req.rawHeaders()

  })
  inspect(server |> @js.typeof_, content="object")
}

///|
/// Test ServerResponse methods
test "server response methods" {
  let server = createServer(requestListener=fn(
    _req : IncomingMessage,
    res : ServerResponse,
  ) {
    // Test chaining methods
    res.setHeader("X-Custom-Header", "test")
    let _ = res.getHeader("X-Custom-Header")
    res.set_statusCode(200)
    let _code = res.statusCode()

  })
  inspect(server |> @js.typeof_, content="object")
}

///|
/// Test ClientRequest creation
test "http request creation" {
  let req = request("http://example.com")
  inspect(req |> @js.typeof_, content="object")
  req.end()
}

///|
/// Test HTTP GET
test "http get request" {
  let req = get("http://example.com")
  inspect(req |> @js.typeof_, content="object")
  req.end()
}

///|
/// Test status_codes
test "http status codes" {
  let codes = status_codes()
  inspect(codes |> @js.typeof_, content="object")
}

///|
/// Test globalAgent
test "http global agent" {
  let agent = globalAgent()
  inspect(agent |> @js.typeof_, content="object")
}
