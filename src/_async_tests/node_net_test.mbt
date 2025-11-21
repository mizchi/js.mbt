///|
using @net {createServer, createConnection, isIP, isIPv4, isIPv6}

///| IP validation tests

///|
test {
  it("isIPv4 should validate IPv4 addresses", _ => {
    inspect(isIPv4("127.0.0.1"), content="true")
    inspect(isIPv4("192.168.1.1"), content="true")
    inspect(isIPv4("invalid"), content="false")
    inspect(isIPv4("::1"), content="false")
  })
}

///|
test {
  it("isIPv6 should validate IPv6 addresses", _ => {
    inspect(isIPv6("::1"), content="true")
    inspect(isIPv6("2001:db8::1"), content="true")
    inspect(isIPv6("127.0.0.1"), content="false")
    inspect(isIPv6("invalid"), content="false")
  })
}

///|
test {
  it("isIP should return IP version", _ => {
    inspect(isIP("127.0.0.1"), content="4")
    inspect(isIP("::1"), content="6")
    inspect(isIP("invalid"), content="0")
  })
}

///|
test {
  it("Server can be created", _ => {
    let server = createServer()
    inspect(server.listening(), content="false")
  })
}

///|
test {
  it("Server can be created with options", _ => {
    let server = createServer(
      allowHalfOpen=true,
      pauseOnConnect=false,
      noDelay=true,
      keepAlive=true,
      keepAliveInitialDelay=1000,
    )
    inspect(server.listening(), content="false")
  })
}

///|
test {
  it("Server listen with callback", _ => {
    let mut callback_called = false
    let server = createServer()
    server.listen(0, host="127.0.0.1", callback=fn() { callback_called = true })
    |> ignore
    sleep(100)
    inspect(callback_called, content="true")
    inspect(server.listening(), content="true")
    server.close() |> ignore
  })
}

///|
test {
  it("Server listen and get address", _ => {
    let server = createServer()
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
    server.close() |> ignore
  })
}

///|
test {
  it("Socket can be created", _ => {
    let socket = createConnection(8080, host="127.0.0.1")
    // Just check that socket was created without connecting
    inspect(socket.destroyed(), content="false")
    socket.destroy() |> ignore
  })
}
