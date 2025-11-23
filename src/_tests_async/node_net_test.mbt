///|

///|
fn createNetServer(
  allowHalfOpen? : Bool,
  pauseOnConnect? : Bool,
  noDelay? : Bool,
  keepAlive? : Bool,
  keepAliveInitialDelay? : Int,
) -> @net.Server {
  @net.createServer(
    allowHalfOpen?,
    pauseOnConnect?,
    noDelay?,
    keepAlive?,
    keepAliveInitialDelay?,
  )
}

///| IP validation tests

///|
test {
  @test.describe("Node Net: IP validation", _ => {
    @test.it("isIPv4 should validate IPv4 addresses", _ => {
      inspect(@net.isIPv4("127.0.0.1"), content="true")
      inspect(@net.isIPv4("192.168.1.1"), content="true")
      inspect(@net.isIPv4("invalid"), content="false")
      inspect(@net.isIPv4("::1"), content="false")
    })
    @test.it("isIPv6 should validate IPv6 addresses", _ => {
      inspect(@net.isIPv6("::1"), content="true")
      inspect(@net.isIPv6("2001:db8::1"), content="true")
      inspect(@net.isIPv6("127.0.0.1"), content="false")
      inspect(@net.isIPv6("invalid"), content="false")
    })
    @test.it("isIP should return IP version", _ => {
      inspect(@net.isIP("127.0.0.1"), content="4")
      inspect(@net.isIP("::1"), content="6")
      inspect(@net.isIP("invalid"), content="0")
    })
  })
}

///|
test {
  @test.describe("Node Net: Server operations", _ => {
    @test.it("Server can be created", _ => {
      let server = createNetServer()
      inspect(server.listening(), content="false")
    })
    @test.it("Server can be created with options", _ => {
      let server = createNetServer(
        allowHalfOpen=true,
        pauseOnConnect=false,
        noDelay=true,
        keepAlive=true,
        keepAliveInitialDelay=1000,
      )
      inspect(server.listening(), content="false")
    })
    @test.it("Server listen with callback", _ => {
      let mut callback_called = false
      let server = createNetServer()
      server.listen(0, host="127.0.0.1", callback=fn() {
        callback_called = true
      })
      |> ignore
      @js.sleep(100)
      inspect(callback_called, content="true")
      inspect(server.listening(), content="true")
      server.close() |> ignore
    })
    @test.it("Server listen and get address", _ => {
      let server = createNetServer()
      server.listen(0, host="127.0.0.1") |> ignore
      @js.sleep(50)
      let address = server.address()
      inspect(address is None, content="false")
      match address {
        Some(addr) => {
          let port : Int = @js.unsafe_cast(addr.get("port"))
          inspect(port > 0, content="true")
        }
        None => ()
      }
      server.close() |> ignore
    })
  })
}

///|
test {
  @test.describe("Node Net: Socket operations", _ => it(
    "Socket can be created",
    _ => {
      let socket = @net.createConnection(8080, host="127.0.0.1")
      // Just check that socket was created without connecting
      inspect(socket.destroyed(), content="false")
      socket.destroy() |> ignore
    },
  ))
}
