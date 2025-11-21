///|
/// Simple HTTP test to debug
test {
  it("Create HTTP server without listener", _ => {
    let server = @http.createServer()
    inspect(server.listening(), content="false")
    println("Server created successfully")
  })
}
