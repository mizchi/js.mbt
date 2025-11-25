///| AI Types tests

///|
test "FinishReason from_string" {
  assert_eq(FinishReason::from_string("stop"), FinishReason::Stop)
  assert_eq(FinishReason::from_string("length"), FinishReason::Length)
  assert_eq(
    FinishReason::from_string("content-filter"),
    FinishReason::ContentFilter,
  )
  assert_eq(FinishReason::from_string("tool-calls"), FinishReason::ToolCalls)
  assert_eq(FinishReason::from_string("error"), FinishReason::Error)
  assert_eq(FinishReason::from_string("other"), FinishReason::Other)
  assert_eq(FinishReason::from_string("unknown"), FinishReason::Unknown)
  assert_eq(FinishReason::from_string("invalid"), FinishReason::Unknown)
}

///|
test "FinishReason to_string" {
  assert_eq(FinishReason::Stop.to_string(), "stop")
  assert_eq(FinishReason::Length.to_string(), "length")
  assert_eq(FinishReason::ContentFilter.to_string(), "content-filter")
  assert_eq(FinishReason::ToolCalls.to_string(), "tool-calls")
  assert_eq(FinishReason::Error.to_string(), "error")
  assert_eq(FinishReason::Other.to_string(), "other")
  assert_eq(FinishReason::Unknown.to_string(), "unknown")
}

///|
test "LanguageModelUsage from_any" {
  let obj = @js.Object::new()
  obj.set("inputTokens", 10)
  obj.set("outputTokens", 20)
  obj.set("totalTokens", 30)
  obj.set("cachedInputTokens", 5)
  let usage = LanguageModelUsage::from_any(obj.to_any())
  assert_eq(usage.input_tokens, 10)
  assert_eq(usage.output_tokens, 20)
  assert_eq(usage.total_tokens, 30)
  assert_eq(usage.cached_input_tokens, 5)
}

///|
test "LanguageModelUsage from_any without cached" {
  let obj = @js.Object::new()
  obj.set("inputTokens", 10)
  obj.set("outputTokens", 20)
  obj.set("totalTokens", 30)
  let usage = LanguageModelUsage::from_any(obj.to_any())
  assert_eq(usage.input_tokens, 10)
  assert_eq(usage.output_tokens, 20)
  assert_eq(usage.total_tokens, 30)
  assert_eq(usage.cached_input_tokens, 0)
}

///|
test "ProviderMetadata from_any with undefined" {
  let result = ProviderMetadata::from_any(@js.undefined())
  guard result is None
}

///|
test "ProviderMetadata from_any with value" {
  let obj = @js.Object::new()
  obj.set("key", "value")
  let result = ProviderMetadata::from_any(obj.to_any())
  guard result is Some(meta)
  assert_eq(meta.raw.get("key").cast(), "value")
}

///|
test "CallWarning from_any" {
  let obj = @js.Object::new()
  obj.set("type", "test-warning")
  obj.set("message", "Test message")
  let warning = CallWarning::from_any(obj.to_any())
  assert_eq(warning.type_, "test-warning")
  guard warning.message is Some(msg)
  assert_eq(msg, "Test message")
}

///|
test "CallWarning from_any without message" {
  let obj = @js.Object::new()
  obj.set("type", "test-warning")
  let warning = CallWarning::from_any(obj.to_any())
  assert_eq(warning.type_, "test-warning")
  guard warning.message is None
}

///|
test "SourceType from_string" {
  assert_eq(SourceType::from_string("url"), SourceType::Url)
  assert_eq(SourceType::from_string("document"), SourceType::Document)
  assert_eq(SourceType::from_string("unknown"), SourceType::Url)
}

///|
test "Source from_any url" {
  let obj = @js.Object::new()
  obj.set("type", "source")
  obj.set("sourceType", "url")
  obj.set("id", "src-1")
  obj.set("url", "https://example.com")
  obj.set("title", "Example")
  let source = Source::from_any(obj.to_any())
  guard source is UrlSource(src)
  assert_eq(src.id, "src-1")
  assert_eq(src.url, "https://example.com")
  guard src.title is Some(title)
  assert_eq(title, "Example")
}

///|
test "Source from_any document" {
  let obj = @js.Object::new()
  obj.set("type", "source")
  obj.set("sourceType", "document")
  obj.set("id", "doc-1")
  obj.set("title", "Document")
  let source = Source::from_any(obj.to_any())
  guard source is DocumentSource(doc)
  assert_eq(doc.id, "doc-1")
  guard doc.title is Some(title)
  assert_eq(title, "Document")
}

///|
test "ToolCall from_any" {
  let obj = @js.Object::new()
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "get_weather")
  let args_obj = @js.Object::new()
  args_obj.set("city", "Tokyo")
  obj.set("args", args_obj)
  let tool_call = ToolCall::from_any(obj.to_any())
  assert_eq(tool_call.tool_call_id, "call-1")
  assert_eq(tool_call.tool_name, "get_weather")
  let city : String = tool_call.args.get("city").cast()
  assert_eq(city, "Tokyo")
}

///|
test "ToolResult from_any" {
  let obj = @js.Object::new()
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "get_weather")
  let args_obj = @js.Object::new()
  args_obj.set("city", "Tokyo")
  obj.set("args", args_obj)
  obj.set("result", "Sunny, 25°C")
  let tool_result = ToolResult::from_any(obj.to_any())
  assert_eq(tool_result.tool_call_id, "call-1")
  assert_eq(tool_result.tool_name, "get_weather")
  let result : String = tool_result.result.cast()
  assert_eq(result, "Sunny, 25°C")
}

///|
test "TextStreamPart from_any text-start" {
  let obj = @js.Object::new()
  obj.set("type", "text-start")
  obj.set("id", "text-1")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is TextStart(id~, ..)
  assert_eq(id, "text-1")
  assert_eq(part.type_string(), "text-start")
  assert_eq(part.is_text_part(), true)
}

///|
test "TextStreamPart from_any text-delta" {
  let obj = @js.Object::new()
  obj.set("type", "text-delta")
  obj.set("id", "text-1")
  obj.set("text", "Hello")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is TextDelta(id~, text~, ..)
  assert_eq(id, "text-1")
  assert_eq(text, "Hello")
  guard part.get_text() is Some(t)
  assert_eq(t, "Hello")
}

///|
test "TextStreamPart from_any reasoning-delta" {
  let obj = @js.Object::new()
  obj.set("type", "reasoning-delta")
  obj.set("id", "reason-1")
  obj.set("text", "Thinking...")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is ReasoningDelta(id~, text~, ..)
  assert_eq(id, "reason-1")
  assert_eq(text, "Thinking...")
  assert_eq(part.is_reasoning_part(), true)
  guard part.get_reasoning_text() is Some(t)
  assert_eq(t, "Thinking...")
}

///|
test "TextStreamPart from_any tool-input-start" {
  let obj = @js.Object::new()
  obj.set("type", "tool-input-start")
  obj.set("id", "tool-1")
  obj.set("toolName", "search")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is ToolInputStart(id~, tool_name~, ..)
  assert_eq(id, "tool-1")
  assert_eq(tool_name, "search")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any start" {
  let obj = @js.Object::new()
  obj.set("type", "start")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is Start
  assert_eq(part.type_string(), "start")
}

///|
test "TextStreamPart from_any finish" {
  let obj = @js.Object::new()
  obj.set("type", "finish")
  obj.set("finishReason", "stop")
  let usage_obj = @js.Object::new()
  usage_obj.set("promptTokens", 100)
  usage_obj.set("completionTokens", 50)
  usage_obj.set("totalTokens", 150)
  obj.set("totalUsage", usage_obj)
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is Finish(finish_reason~, total_usage~)
  assert_eq(finish_reason, FinishReason::Stop)
  assert_eq(total_usage.total_tokens, 150)
}

///|
test "TextStreamPart from_any error" {
  let obj = @js.Object::new()
  obj.set("type", "error")
  obj.set("error", "Something went wrong")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is Error(error~)
  let err : String = error.cast()
  assert_eq(err, "Something went wrong")
}

///|
test "TextStreamPart from_any abort" {
  let obj = @js.Object::new()
  obj.set("type", "abort")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is Abort
  assert_eq(part.type_string(), "abort")
}

///|
test "TextStreamPart from_any unknown" {
  let obj = @js.Object::new()
  obj.set("type", "custom-type")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is Unknown(type_~, ..)
  assert_eq(type_, "custom-type")
}

///|
test "TextStreamPart from_any finish-step" {
  let obj = @js.Object::new()
  obj.set("type", "finish-step")
  let response_obj = @js.Object::new()
  response_obj.set("id", "resp-1")
  response_obj.set("modelId", "gpt-4")
  obj.set("response", response_obj)
  let usage_obj = @js.Object::new()
  usage_obj.set("promptTokens", 10)
  usage_obj.set("completionTokens", 20)
  usage_obj.set("totalTokens", 30)
  obj.set("usage", usage_obj)
  obj.set("finishReason", "stop")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part is FinishStep(response~, usage~, finish_reason~, ..)
  guard response.id is Some(id)
  assert_eq(id, "resp-1")
  guard response.model_id is Some(model)
  assert_eq(model, "gpt-4")
  assert_eq(usage.total_tokens, 30)
  assert_eq(finish_reason, FinishReason::Stop)
}

///|
test "TextStreamPart get_text returns None for non-text-delta" {
  let obj = @js.Object::new()
  obj.set("type", "start")
  let part = TextStreamPart::from_any(obj.to_any())
  guard part.get_text() is None
}
