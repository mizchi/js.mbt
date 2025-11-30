///| Tests for MCP SDK bindings

// ============================================================
// Server Unit Tests
// ============================================================

///|
test "PromptMessage::as_any creates correct structure" {
  let msg : PromptMessage = {
    role: "user",
    content: Content::text("Hello, world!"),
  }
  let js_obj = msg.as_any()
  let role : String = js_obj.get("role").cast()
  assert_eq(role, "user")
  let content_type : String = js_obj.get("content").get("type").cast()
  assert_eq(content_type, "text")
}

///|
test "PromptResult::as_any with description" {
  let result : PromptResult = {
    description: Some("A test prompt"),
    messages: [{ role: "assistant", content: Content::text("Hi there!") }],
  }
  let js_obj = result.as_any()
  let desc : String = js_obj.get("description").cast()
  assert_eq(desc, "A test prompt")
  let messages : Array[@js.Any] = @js.identity(js_obj.get("messages"))
  assert_eq(messages.length(), 1)
}

///|
test "PromptResult::as_any without description" {
  let result : PromptResult = { description: None, messages: [] }
  let js_obj = result.as_any()
  assert_true(@js.is_undefined(js_obj.get("description")))
}

// ============================================================
// Client Unit Tests
// ============================================================

///|
test "ToolInfo identity cast" {
  let raw = @mbtconv.from_map({
    "name": "test-tool" |> @nostd.any,
    "description": "A test tool" |> @nostd.any,
    "inputSchema": @mbtconv.from_map({ "type": "object" |> @nostd.any }),
  })
  let info : ToolInfo = @js.identity(raw)
  assert_eq(info.name, "test-tool")
  guard info.description is Some(desc)
  assert_eq(desc, "A test tool")
}

///|
test "ContentResult identity cast" {
  let raw = @mbtconv.from_map({
    "type": "text" |> @nostd.any,
    "text": "Hello, world!" |> @nostd.any,
    "raw": @mbtconv.from_map({ "type": "text" |> @nostd.any }),
  })
  let content : ContentResult = @js.identity(raw)
  assert_eq(content.type_(), "text")
  guard content.text is Some(text)
  assert_eq(text, "Hello, world!")
}

///|
test "ResourceInfo identity cast" {
  let raw = @mbtconv.from_map({
    "uri": "file:///test.txt" |> @nostd.any,
    "name": "test.txt" |> @nostd.any,
    "description": "A test file" |> @nostd.any,
    "mime_type": "text/plain" |> @nostd.any,
  })
  let info : ResourceInfo = @js.identity(raw)
  assert_eq(info.uri, "file:///test.txt")
  assert_eq(info.name, "test.txt")
  guard info.description is Some(desc)
  assert_eq(desc, "A test file")
  guard info.mime_type is Some(mime)
  assert_eq(mime, "text/plain")
}

///|
test "PromptArgumentInfo identity cast" {
  let raw = @mbtconv.from_map({
    "name": "query" |> @nostd.any,
    "description": "The search query" |> @nostd.any,
    "required": true |> @nostd.any,
  })
  let info : PromptArgumentInfo = @js.identity(raw)
  assert_eq(info.name, "query")
  guard info.description is Some(desc)
  assert_eq(desc, "The search query")
  guard info.required is Some(req)
  assert_true(req)
}

///|
test "PromptInfo identity cast" {
  let raw = @mbtconv.from_map({
    "name": "greeting" |> @nostd.any,
    "description": "A greeting prompt" |> @nostd.any,
  })
  let info : PromptInfo = @js.identity(raw)
  assert_eq(info.name, "greeting")
  guard info.description is Some(desc)
  assert_eq(desc, "A greeting prompt")
}

///|
test "PromptMessageResult identity cast" {
  let content_raw = @mbtconv.from_map({ "type": "text" |> @nostd.any })
  let raw = @mbtconv.from_map({
    "role": "assistant" |> @nostd.any,
    "content": @mbtconv.from_map({
      "type": "text" |> @nostd.any,
      "text": "Hello!" |> @nostd.any,
      "raw": content_raw,
    }),
  })
  let msg : PromptMessageResult = @js.identity(raw)
  assert_eq(msg.role, "assistant")
  assert_eq(msg.content.type_(), "text")
  guard msg.content.text is Some(text)
  assert_eq(text, "Hello!")
}
