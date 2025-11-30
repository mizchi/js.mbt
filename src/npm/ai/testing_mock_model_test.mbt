///| Mock model tests

///|
test "mock_model_with_text creates working model" {
  let model = mock_model_with_text("Hello, World!")
  // Check the model has expected properties
  let provider : String = model.get("provider").cast()
  let model_id : String = model.get("modelId").cast()
  assert_eq(provider, "mock-provider")
  assert_eq(model_id, "mock-model-id")
}

///|
test "MockContentPart Text as_any" {
  let part = MockContentPart::Text("Hello")
  let any = part.as_any()
  let type_ : String = any.get("type").cast()
  let text : String = any.get("text").cast()
  assert_eq(type_, "text")
  assert_eq(text, "Hello")
}

///|
test "MockContentPart ToolCall as_any" {
  let part = MockContentPart::ToolCall(
    tool_call_id="call-1",
    tool_name="get_weather",
    args={ "location": "Tokyo" } |> @js.from_json,
  )
  let any = part.as_any()
  let type_ : String = any.get("type").cast()
  let tool_name : String = any.get("toolName").cast()
  assert_eq(type_, "tool-call")
  assert_eq(tool_name, "get_weather")
}

///|
test "MockGenerateResult as_any" {
  let result : MockGenerateResult = {
    finish_reason: "stop",
    usage: { input_tokens: 10, output_tokens: 20, total_tokens: 30 },
    content: [MockContentPart::Text("Hello")],
    warnings: [],
  }
  let any = result.as_any()
  let finish_reason : String = any.get("finishReason").cast()
  let input_tokens : Int = any.get("usage").get("inputTokens").cast()
  assert_eq(finish_reason, "stop")
  assert_eq(input_tokens, 10)
}

///|
test "text_delta_chunk creates correct structure" {
  let chunk = text_delta_chunk("Hello")
  let type_ : String = chunk.get("type").cast()
  let text : String = chunk.get("textDelta").cast()
  assert_eq(type_, "text-delta")
  assert_eq(text, "Hello")
}

///|
test "finish_chunk creates correct structure" {
  let chunk = finish_chunk("stop", {
    input_tokens: 10,
    output_tokens: 20,
    total_tokens: 30,
  })
  let type_ : String = chunk.get("type").cast()
  let finish_reason : String = chunk.get("finishReason").cast()
  let input : Int = chunk.get("usage").get("inputTokens").cast()
  assert_eq(type_, "finish")
  assert_eq(finish_reason, "stop")
  assert_eq(input, 10)
}

///|
test "tool_call_chunk creates correct structure" {
  let chunk = tool_call_chunk(
    "call-1",
    "get_weather",
    ({ "location": "Tokyo" } |> @mbtconv.from_json).cast(),
  )
  let type_ : String = chunk.get("type").cast()
  let tool_name : String = chunk.get("toolName").cast()
  let location : String = chunk.get("args").get("location").cast()
  assert_eq(type_, "tool-call")
  assert_eq(tool_name, "get_weather")
  assert_eq(location, "Tokyo")
}

///|
test "mock_language_model with custom provider" {
  let model = mock_language_model({
    provider: Some("my-provider"),
    model_id: Some("my-model"),
    do_generate: None,
    do_stream: None,
  })
  let provider : String = model.get("provider").cast()
  let model_id : String = model.get("modelId").cast()
  assert_eq(provider, "my-provider")
  assert_eq(model_id, "my-model")
}
