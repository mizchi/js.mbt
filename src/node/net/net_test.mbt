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
async test "Node Net: isIPv4 should validate IPv4 addresses" {
  inspect(@net.isIPv4("127.0.0.1"), content="true")
  inspect(@net.isIPv4("192.168.1.1"), content="true")
  inspect(@net.isIPv4("invalid"), content="false")
  inspect(@net.isIPv4("::1"), content="false")
}

///|
async test "Node Net: isIPv6 should validate IPv6 addresses" {
  inspect(@net.isIPv6("::1"), content="true")
  inspect(@net.isIPv6("2001:db8::1"), content="true")
  inspect(@net.isIPv6("127.0.0.1"), content="false")
  inspect(@net.isIPv6("invalid"), content="false")
}

///|
async test "Node Net: isIP should return IP version" {
  inspect(@net.isIP("127.0.0.1"), content="4")
  inspect(@net.isIP("::1"), content="6")
  inspect(@net.isIP("invalid"), content="0")
}

///| Server operations

///|
async test "Node Net: Server can be created" {
  let server = createNetServer()
  defer server.close() |> ignore // Cleanup to prevent leaks
  inspect(server.listening(), content="false")
}

///|
async test "Node Net: Server can be created with options" {
  let server = createNetServer(
    allowHalfOpen=true,
    pauseOnConnect=false,
    noDelay=true,
    keepAlive=true,
    keepAliveInitialDelay=1000,
  )
  defer server.close() |> ignore // Cleanup to prevent leaks
  inspect(server.listening(), content="false")
}

///|
async test "Node Net: Server listen with callback" {
  let mut callback_called = false
  let server = createNetServer()
  defer server.close() |> ignore // Cleanup to prevent leaks
  server.listen(0, host="127.0.0.1", callback=fn() { callback_called = true })
  |> ignore
  @js.sleep(96)
  inspect(callback_called, content="true")
  inspect(server.listening(), content="true")
  server.close() |> ignore
}

///|
async test "Node Net: Server listen and get address" {
  let server = createNetServer()
  defer server.close() |> ignore // Cleanup to prevent leaks
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
  server.close() |> ignore
}

///| Socket operations

///|
async test "Node Net: Socket can be created" {
  let socket = @net.createConnection(8080, host="127.0.0.1")
  defer socket.destroy() |> ignore // Cleanup to prevent leaks
  // Just check that socket was created without connecting
  inspect(socket.destroyed(), content="false")
  socket.destroy() |> ignore
}
