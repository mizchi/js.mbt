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
  let role : String = js_obj._get("role").cast()
  assert_eq(role, "user")
  let content_type : String = js_obj._get("content")._get("type").cast()
  assert_eq(content_type, "text")
}

///|
test "PromptResult::as_any with description" {
  let result : PromptResult = {
    description: Some("A test prompt"),
    messages: [{ role: "assistant", content: Content::text("Hi there!") }],
  }
  let js_obj = result.as_any()
  let desc : String = js_obj._get("description").cast()
  assert_eq(desc, "A test prompt")
  let messages : Array[@core.Any] = @core.identity(js_obj._get("messages"))
  assert_eq(messages.length(), 1)
}

///|
test "PromptResult::as_any without description" {
  let result : PromptResult = { description: None, messages: [] }
  let js_obj = result.as_any()
  assert_true(@core.is_undefined(js_obj._get("description")))
}

// ============================================================
// Client Unit Tests
// ============================================================

///|
test "ToolInfo identity cast" {
  let raw = @core.from_entries([
    ("name", @core.any("test-tool")),
    ("description", @core.any("A test tool")),
    ("inputSchema", @core.from_entries([("type", @core.any("object"))])),
  ])
  let info : ToolInfo = @core.identity(raw)
  assert_eq(info.name, "test-tool")
  guard info.description is Some(desc)
  assert_eq(desc, "A test tool")
}

///|
test "ContentResult identity cast" {
  let raw = @core.from_entries([
    ("type", @core.any("text")),
    ("text", @core.any("Hello, world!")),
    ("raw", @core.from_entries([("type", @core.any("text"))])),
  ])
  let content : ContentResult = @core.identity(raw)
  assert_eq(content.type_(), "text")
  guard content.text is Some(text)
  assert_eq(text, "Hello, world!")
}

///|
test "ResourceInfo identity cast" {
  let raw = @core.from_entries([
    ("uri", @core.any("file:///test.txt")),
    ("name", @core.any("test.txt")),
    ("description", @core.any("A test file")),
    ("mime_type", @core.any("text/plain")),
  ])
  let info : ResourceInfo = @core.identity(raw)
  assert_eq(info.uri, "file:///test.txt")
  assert_eq(info.name, "test.txt")
  guard info.description is Some(desc)
  assert_eq(desc, "A test file")
  guard info.mime_type is Some(mime)
  assert_eq(mime, "text/plain")
}

///|
test "PromptArgumentInfo identity cast" {
  let raw = @core.from_entries([
    ("name", @core.any("query")),
    ("description", @core.any("The search query")),
    ("required", @core.any(true)),
  ])
  let info : PromptArgumentInfo = @core.identity(raw)
  assert_eq(info.name, "query")
  guard info.description is Some(desc)
  assert_eq(desc, "The search query")
  guard info.required is Some(req)
  assert_true(req)
}

///|
test "PromptInfo identity cast" {
  let raw = @core.from_entries([
    ("name", @core.any("greeting")),
    ("description", @core.any("A greeting prompt")),
  ])
  let info : PromptInfo = @core.identity(raw)
  assert_eq(info.name, "greeting")
  guard info.description is Some(desc)
  assert_eq(desc, "A greeting prompt")
}

///|
test "PromptMessageResult identity cast" {
  let content_raw = @core.from_entries([("type", "text" |> @core.any)])
  let raw = @core.from_entries([
    ("role", @core.any("assistant")),
    (
      "content",
      @core.from_entries([
        ("type", @core.any("text")),
        ("text", @core.any("Hello!")),
        ("raw", content_raw),
      ]),
    ),
  ])
  let msg : PromptMessageResult = @core.identity(raw)
  assert_eq(msg.role, "assistant")
  assert_eq(msg.content.type_(), "text")
  guard msg.content.text is Some(text)
  assert_eq(text, "Hello!")
}
