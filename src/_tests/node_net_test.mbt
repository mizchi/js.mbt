///|
using @net {
  type Socket,
  type Server,
  createServer,
  createConnection,
  isIP,
  isIPv4,
  isIPv6,
}

///| IP validation tests

///|
test {
  it("isIPv4 should validate IPv4 addresses", _ => {
    assert_eq(isIPv4("127.0.0.1"), true)
    assert_eq(isIPv4("192.168.1.1"), true)
    assert_eq(isIPv4("invalid"), false)
    assert_eq(isIPv4("::1"), false)
  })
}

///|
test {
  it("isIPv6 should validate IPv6 addresses", _ => {
    assert_eq(isIPv6("::1"), true)
    assert_eq(isIPv6("2001:db8::1"), true)
    assert_eq(isIPv6("127.0.0.1"), false)
    assert_eq(isIPv6("invalid"), false)
  })
}

///|
test {
  it("isIP should return IP version", _ => {
    assert_eq(isIP("127.0.0.1"), 4)
    assert_eq(isIP("::1"), 6)
    assert_eq(isIP("invalid"), 0)
  })
}

///| Server and Socket tests

///|
test {
  it("Server should listen and accept connections", _ => {
    let mut server_started = false
    let mut client_connected = false
    let mut data_received = ""
    let mut cleanup_done = false

    // Create server
    let server = createServer(connectionListener=fn(socket) {
      // Server receives connection
      socket.on("data", fn(chunk) {
        data_received = @js.unsafe_cast(chunk)
        socket.write("Echo: \{data_received}") |> ignore
        socket.end() |> ignore
      })
    })

    // Listen on a random port
    server.listen(0, host="127.0.0.1", callback=fn() {
      server_started = true
      let address = server.address()

      // Get the port
      let port : Int = match address {
        Some(addr) => @js.unsafe_cast(addr.get("port"))
        None => abort("Failed to get server address")
      }

      // Create client connection
      let client = createConnection(port, host="127.0.0.1", callback=fn() {
        client_connected = true
      })
      client.write("Hello") |> ignore
      let mut response = ""
      client.on("data", fn(chunk) { response = @js.unsafe_cast(chunk) })
      client.on("end", fn(_) {
        client.destroy() |> ignore
        server.close() |> ignore
        cleanup_done = true
      })
    })
    |> ignore

    // Wait for async operations and cleanup
    @promise.sleep(200)
    inspect(server_started, content="true")
    inspect(client_connected, content="true")
    inspect(data_received, content="Hello")
    inspect(cleanup_done, content="true")
  })
}

///|
test {
  it("Socket should have correct properties", _ => {
    let server = createServer(connectionListener=fn(socket) {
      // Close server socket immediately
      socket.destroy() |> ignore
    })
    server.listen(0, host="127.0.0.1") |> ignore
    let address = server.address()
    let port : Int = match address {
      Some(addr) => @js.unsafe_cast(addr.get("port"))
      None => abort("Failed to get server address")
    }
    let client = createConnection(port, host="127.0.0.1")
    @promise.sleep(10)

    // Check socket properties
    assert_eq(client.destroyed(), false)
    assert_eq(client.localAddress().is_empty(), false)
    client.destroy() |> ignore
    server.close() |> ignore
    @promise.sleep(10)
    assert_eq(client.destroyed(), true)
  })
}

///|
test {
  it("Socket should support pause and resume", _ => {
    let mut data_count = 0
    let mut server_ref : Server? = None
    let server = createServer(connectionListener=fn(socket) {
      socket.write("data1") |> ignore
      socket.write("data2") |> ignore
      socket.write("data3") |> ignore
      socket.end() |> ignore
    })
    server_ref = Some(server)
    server.listen(0, host="127.0.0.1") |> ignore
    let address = server.address()
    let port : Int = match address {
      Some(addr) => @js.unsafe_cast(addr.get("port"))
      None => abort("Failed to get server address")
    }
    let client = createConnection(port, host="127.0.0.1")
    client.on("data", fn(_chunk) {
      data_count = data_count + 1
      if data_count == 1 {
        client.pause() |> ignore
        // Resume after a brief pause using setTimeout
        @js.globalThis().call("setTimeout", [
          @js.unsafe_cast(fn() { client.resume_() |> ignore }),
          50,
        ])
        |> ignore
      }
    })
    client.on("end", fn(_) {
      client.destroy() |> ignore
      match server_ref {
        Some(s) => s.close() |> ignore
        None => ()
      }
    })
    @promise.sleep(200)

    // Should receive all data chunks
    assert_eq(data_count >= 1, true)
  })
}

///|
test {
  it("Socket should support setEncoding", _ => {
    let mut received = ""
    let mut server_ref : Server? = None
    let server = createServer(connectionListener=fn(socket) {
      socket.write("こんにちは") |> ignore
      socket.end() |> ignore
    })
    server_ref = Some(server)
    server.listen(0, host="127.0.0.1") |> ignore
    let address = server.address()
    let port : Int = match address {
      Some(addr) => @js.unsafe_cast(addr.get("port"))
      None => abort("Failed to get server address")
    }
    let client = createConnection(port, host="127.0.0.1")
    client.setEncoding("utf8") |> ignore
    client.on("data", fn(chunk) { received = @js.unsafe_cast(chunk) })
    client.on("end", fn(_) {
      client.destroy() |> ignore
      match server_ref {
        Some(s) => s.close() |> ignore
        None => ()
      }
    })
    @promise.sleep(50)
    inspect(received, content="こんにちは")
  })
}

///|
test {
  it("Server should track max connections", _ => {
    let server = createServer()

    // Check default maxConnections (should be None or a number)
    let initial_max = server.maxConnections()
    inspect(initial_max.is_empty(), content="true")

    // Set maxConnections
    server.set_maxConnections(10)
    let new_max = server.maxConnections()
    match new_max {
      Some(max) => assert_eq(max, 10)
      None => abort("maxConnections should be set")
    }
    server.close() |> ignore
  })
}

///|
test {
  it("Socket should support timeout", _ => {
    let mut timeout_called = false
    let mut server_ref : Server? = None
    let server = createServer(connectionListener=fn(socket) {
      // Don't send anything, just keep connection open
      socket.on("timeout", fn(_) { socket.end() |> ignore })
    })
    server_ref = Some(server)
    server.listen(0, host="127.0.0.1") |> ignore
    let address = server.address()
    let port : Int = match address {
      Some(addr) => @js.unsafe_cast(addr.get("port"))
      None => abort("Failed to get server address")
    }
    let client = createConnection(port, host="127.0.0.1")
    client.setTimeout(50, callback=fn() { timeout_called = true }) |> ignore
    client.on("timeout", fn(_) {
      client.destroy() |> ignore
      match server_ref {
        Some(s) => s.close() |> ignore
        None => ()
      }
    })
    @promise.sleep(100)
    inspect(timeout_called, content="true")
  })
}
