///|
/// MCP Server Tests
test "McpServer::new creates server with correct info" {
  let server = McpServer::new("test-server", "1.0.0")
  inspect(server.info.name, content="test-server")
  inspect(server.info.version, content="1.0.0")
}

///|
test "JsonRpcRequest as_any" {
  // Test using from_js and as_any roundtrip instead of direct construction
  let obj = @nostd.Object::new()
  obj.set("jsonrpc", "2.0")
  obj.set("id", "test-123")
  obj.set("method", "test/method")
  let request = JsonRpcRequest::from_js(@js.identity(obj))
  match request {
    Some(req) => {
      let result = req.as_any()
      let jsonrpc : String = @js.identity(result._get("jsonrpc"))
      let method_name : String = @js.identity(result._get("method"))
      inspect(jsonrpc, content="2.0")
      inspect(method_name, content="test/method")
    }
    None => inspect("Failed to parse request")
  }
}

///|
test "Content::text creates text content" {
  let content = Content::text("Hello, world!")
  inspect(content.type_, content="Text")
  inspect(content.text, content="Some(\"Hello, world!\")")
}

///|
test "Content::image creates image content" {
  let content = Content::image("base64data", "image/png")
  inspect(content.type_, content="Image")
  inspect(content.data, content="Some(\"base64data\")")
  inspect(content.mime_type, content="Some(\"image/png\")")
}

///|
test "Content::resource creates resource content" {
  let content = Content::resource("file:///test.txt")
  inspect(content.type_, content="Resource")
  inspect(content.uri, content="Some(\"file:///test.txt\")")
}

///|
test "RequestId conversions" {
  let js_str : @nostd.Any = @js.identity("abc")
  inspect(RequestId::from_js(js_str), content="Some(String(\"abc\"))")
  let js_num : @nostd.Any = @js.identity(42)
  inspect(RequestId::from_js(js_num), content="Some(Number(42))")
}
