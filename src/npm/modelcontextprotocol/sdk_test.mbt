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
  let messages : Array[@nostd.Any] = @nostd.identity(js_obj._get("messages"))
  assert_eq(messages.length(), 1)
}

///|
test "PromptResult::as_any without description" {
  let result : PromptResult = { description: None, messages: [] }
  let js_obj = result.as_any()
  assert_true(@nostd.is_undefined(js_obj._get("description")))
}

// ============================================================
// Client Unit Tests
// ============================================================

///|
test "ToolInfo identity cast" {
  let raw = @nostd.from_entries([
    ("name", @nostd.any("test-tool")),
    ("description", @nostd.any("A test tool")),
    ("inputSchema", @nostd.from_entries([("type", @nostd.any("object"))])),
  ])
  let info : ToolInfo = @nostd.identity(raw)
  assert_eq(info.name, "test-tool")
  guard info.description is Some(desc)
  assert_eq(desc, "A test tool")
}

///|
test "ContentResult identity cast" {
  let raw = @nostd.from_entries([
    ("type", @nostd.any("text")),
    ("text", @nostd.any("Hello, world!")),
    ("raw", @nostd.from_entries([("type", @nostd.any("text"))])),
  ])
  let content : ContentResult = @nostd.identity(raw)
  assert_eq(content.type_(), "text")
  guard content.text is Some(text)
  assert_eq(text, "Hello, world!")
}

///|
test "ResourceInfo identity cast" {
  let raw = @nostd.from_entries([
    ("uri", @nostd.any("file:///test.txt")),
    ("name", @nostd.any("test.txt")),
    ("description", @nostd.any("A test file")),
    ("mime_type", @nostd.any("text/plain")),
  ])
  let info : ResourceInfo = @nostd.identity(raw)
  assert_eq(info.uri, "file:///test.txt")
  assert_eq(info.name, "test.txt")
  guard info.description is Some(desc)
  assert_eq(desc, "A test file")
  guard info.mime_type is Some(mime)
  assert_eq(mime, "text/plain")
}

///|
test "PromptArgumentInfo identity cast" {
  let raw = @nostd.from_entries([
    ("name", @nostd.any("query")),
    ("description", @nostd.any("The search query")),
    ("required", @nostd.any(true)),
  ])
  let info : PromptArgumentInfo = @nostd.identity(raw)
  assert_eq(info.name, "query")
  guard info.description is Some(desc)
  assert_eq(desc, "The search query")
  guard info.required is Some(req)
  assert_true(req)
}

///|
test "PromptInfo identity cast" {
  let raw = @nostd.from_entries([
    ("name", @nostd.any("greeting")),
    ("description", @nostd.any("A greeting prompt")),
  ])
  let info : PromptInfo = @nostd.identity(raw)
  assert_eq(info.name, "greeting")
  guard info.description is Some(desc)
  assert_eq(desc, "A greeting prompt")
}

///|
test "PromptMessageResult identity cast" {
  let content_raw = @nostd.from_entries([("type", "text" |> @nostd.any)])
  let raw = @nostd.from_entries([
    ("role", @nostd.any("assistant")),
    (
      "content",
      @nostd.from_entries([
        ("type", @nostd.any("text")),
        ("text", @nostd.any("Hello!")),
        ("raw", content_raw),
      ]),
    ),
  ])
  let msg : PromptMessageResult = @nostd.identity(raw)
  assert_eq(msg.role, "assistant")
  assert_eq(msg.content.type_(), "text")
  guard msg.content.text is Some(text)
  assert_eq(text, "Hello!")
}
