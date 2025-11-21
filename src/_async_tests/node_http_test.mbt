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

///| Module function tests only (no server creation)

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
