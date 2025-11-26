///| Tests for MCP SDK bindings

// ============================================================
// Server Unit Tests
// ============================================================

///|
test "PromptMessage::to_any creates correct structure" {
  let msg : PromptMessage = {
    role: "user",
    content: Content::text("Hello, world!"),
  }
  let js_obj = msg.to_any()
  let role : String = js_obj.get("role").cast()
  assert_eq(role, "user")
  let content_type : String = js_obj.get("content").get("type").cast()
  assert_eq(content_type, "text")
}

///|
test "PromptResult::to_any with description" {
  let result : PromptResult = {
    description: Some("A test prompt"),
    messages: [{ role: "assistant", content: Content::text("Hi there!") }],
  }
  let js_obj = result.to_any()
  let desc : String = js_obj.get("description").cast()
  assert_eq(desc, "A test prompt")
  let messages : Array[@js.Any] = @js.identity(js_obj.get("messages"))
  assert_eq(messages.length(), 1)
}

///|
test "PromptResult::to_any without description" {
  let result : PromptResult = { description: None, messages: [] }
  let js_obj = result.to_any()
  assert_true(@js.is_undefined(js_obj.get("description")))
}

// ============================================================
// Client Unit Tests
// ============================================================

///|
test "ToolInfo identity cast" {
  let raw = @js.from_map({
    "name": "test-tool" |> @js.any,
    "description": "A test tool" |> @js.any,
    "inputSchema": @js.from_map({ "type": "object" |> @js.any }),
  })
  let info : ToolInfo = @js.identity(raw)
  assert_eq(info.name, "test-tool")
  guard info.description is Some(desc)
  assert_eq(desc, "A test tool")
}

///|
test "ContentResult identity cast" {
  let raw = @js.from_map({
    "type": "text" |> @js.any,
    "text": "Hello, world!" |> @js.any,
    "raw": @js.from_map({ "type": "text" |> @js.any }),
  })
  let content : ContentResult = @js.identity(raw)
  assert_eq(content.type_(), "text")
  guard content.text is Some(text)
  assert_eq(text, "Hello, world!")
}

///|
test "ResourceInfo identity cast" {
  let raw = @js.from_map({
    "uri": "file:///test.txt" |> @js.any,
    "name": "test.txt" |> @js.any,
    "description": "A test file" |> @js.any,
    "mime_type": "text/plain" |> @js.any,
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
  let raw = @js.from_map({
    "name": "query" |> @js.any,
    "description": "The search query" |> @js.any,
    "required": true |> @js.any,
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
  let raw = @js.from_map({
    "name": "greeting" |> @js.any,
    "description": "A greeting prompt" |> @js.any,
  })
  let info : PromptInfo = @js.identity(raw)
  assert_eq(info.name, "greeting")
  guard info.description is Some(desc)
  assert_eq(desc, "A greeting prompt")
}

///|
test "PromptMessageResult identity cast" {
  let content_raw = @js.from_map({ "type": "text" |> @js.any })
  let raw = @js.from_map({
    "role": "assistant" |> @js.any,
    "content": @js.from_map({
      "type": "text" |> @js.any,
      "text": "Hello!" |> @js.any,
      "raw": content_raw,
    }),
  })
  let msg : PromptMessageResult = @js.identity(raw)
  assert_eq(msg.role, "assistant")
  assert_eq(msg.content.type_(), "text")
  guard msg.content.text is Some(text)
  assert_eq(text, "Hello!")
}
