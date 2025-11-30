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
  let usage = LanguageModelUsage::from_any(obj.as_any())
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
  let usage = LanguageModelUsage::from_any(obj.as_any())
  assert_eq(usage.input_tokens, 10)
  assert_eq(usage.output_tokens, 20)
  assert_eq(usage.total_tokens, 30)
  assert_eq(usage.cached_input_tokens, 0)
}

///|
test "ProviderMetadata from_any with undefined" {
  let result = ProviderMetadata::from_any(@global.undefined())
  guard result is None
}

///|
test "ProviderMetadata from_any with value" {
  let obj = @js.Object::new()
  obj.set("key", "value")
  let result = ProviderMetadata::from_any(obj.as_any())
  guard result is Some(meta)
  assert_eq(meta.raw.get("key").cast(), "value")
}

///|
test "CallWarning from_any" {
  let obj = @js.Object::new()
  obj.set("type", "test-warning")
  obj.set("message", "Test message")
  let warning = CallWarning::from_any(obj.as_any())
  assert_eq(warning.type_, "test-warning")
  guard warning.message is Some(msg)
  assert_eq(msg, "Test message")
}

///|
test "CallWarning from_any without message" {
  let obj = @js.Object::new()
  obj.set("type", "test-warning")
  let warning = CallWarning::from_any(obj.as_any())
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
  let source = Source::from_any(obj.as_any())
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
  let source = Source::from_any(obj.as_any())
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
  let input_obj = @js.Object::new()
  input_obj.set("city", "Tokyo")
  obj.set("input", input_obj)
  let tool_call = ToolCall::from_any(obj.as_any())
  assert_eq(tool_call.tool_call_id, "call-1")
  assert_eq(tool_call.tool_name, "get_weather")
  let city : String = tool_call.input.get("city").cast()
  assert_eq(city, "Tokyo")
}

///|
test "ToolResult from_any" {
  let obj = @js.Object::new()
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "get_weather")
  let input_obj = @js.Object::new()
  input_obj.set("city", "Tokyo")
  obj.set("input", input_obj)
  obj.set("output", "Sunny, 25°C")
  let tool_result = ToolResult::from_any(obj.as_any())
  assert_eq(tool_result.tool_call_id, "call-1")
  assert_eq(tool_result.tool_name, "get_weather")
  let output : String = tool_result.output.cast()
  assert_eq(output, "Sunny, 25°C")
}

///|
test "TextStreamPart from_any text-start" {
  let obj = @js.Object::new()
  obj.set("type", "text-start")
  obj.set("id", "text-1")
  let part = TextStreamPart::from_any(obj.as_any())
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
  let part = TextStreamPart::from_any(obj.as_any())
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
  let part = TextStreamPart::from_any(obj.as_any())
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
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolInputStart(id~, tool_name~, ..)
  assert_eq(id, "tool-1")
  assert_eq(tool_name, "search")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any start" {
  let obj = @js.Object::new()
  obj.set("type", "start")
  let part = TextStreamPart::from_any(obj.as_any())
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
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is Finish(finish_reason~, total_usage~)
  assert_eq(finish_reason, FinishReason::Stop)
  assert_eq(total_usage.total_tokens, 150)
}

///|
test "TextStreamPart from_any error" {
  let obj = @js.Object::new()
  obj.set("type", "error")
  obj.set("error", "Something went wrong")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is Error(error~)
  let err : String = error.cast()
  assert_eq(err, "Something went wrong")
}

///|
test "TextStreamPart from_any abort" {
  let obj = @js.Object::new()
  obj.set("type", "abort")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is Abort
  assert_eq(part.type_string(), "abort")
}

///|
test "TextStreamPart from_any unknown" {
  let obj = @js.Object::new()
  obj.set("type", "custom-type")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is Unknown(type_~, ..)
  assert_eq(type_, "custom-type")
}

///|
test "ToolOutputDenied from_any" {
  let obj = @js.Object::new()
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "get_weather")
  let input_obj = @js.Object::new()
  input_obj.set("city", "Tokyo")
  obj.set("input", input_obj)
  let denied = ToolOutputDenied::from_any(obj.as_any())
  assert_eq(denied.tool_call_id, "call-1")
  assert_eq(denied.tool_name, "get_weather")
  let city : String = denied.input.get("city").cast()
  assert_eq(city, "Tokyo")
}

///|
test "ToolApprovalRequest from_any" {
  let obj = @js.Object::new()
  obj.set("toolCallId", "call-2")
  obj.set("toolName", "delete_file")
  let input_obj = @js.Object::new()
  input_obj.set("path", "/tmp/test.txt")
  obj.set("input", input_obj)
  let request = ToolApprovalRequest::from_any(obj.as_any())
  assert_eq(request.tool_call_id, "call-2")
  assert_eq(request.tool_name, "delete_file")
  let path : String = request.input.get("path").cast()
  assert_eq(path, "/tmp/test.txt")
}

///|
test "TextStreamPart from_any tool-output-denied" {
  let obj = @js.Object::new()
  obj.set("type", "tool-output-denied")
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "get_weather")
  let input_obj = @js.Object::new()
  input_obj.set("city", "Tokyo")
  obj.set("input", input_obj)
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolOutputDeniedPart(tool_output_denied~)
  assert_eq(tool_output_denied.tool_call_id, "call-1")
  assert_eq(tool_output_denied.tool_name, "get_weather")
  assert_eq(part.type_string(), "tool-output-denied")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any tool-approval-request" {
  let obj = @js.Object::new()
  obj.set("type", "tool-approval-request")
  obj.set("toolCallId", "call-2")
  obj.set("toolName", "delete_file")
  let input_obj = @js.Object::new()
  input_obj.set("path", "/tmp/test.txt")
  obj.set("input", input_obj)
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolApprovalRequestPart(tool_approval_request~)
  assert_eq(tool_approval_request.tool_call_id, "call-2")
  assert_eq(tool_approval_request.tool_name, "delete_file")
  assert_eq(part.type_string(), "tool-approval-request")
  assert_eq(part.is_tool_part(), true)
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
  let part = TextStreamPart::from_any(obj.as_any())
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
  let part = TextStreamPart::from_any(obj.as_any())
  guard part.get_text() is None
}

///|
test "TextStreamPart get_reasoning_text returns None for non-reasoning" {
  let obj = @js.Object::new()
  obj.set("type", "text-delta")
  obj.set("id", "text-1")
  obj.set("text", "Hello")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part.get_reasoning_text() is None
}

///|
test "TextStreamPart from_any text-end" {
  let obj = @js.Object::new()
  obj.set("type", "text-end")
  obj.set("id", "text-1")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is TextEnd(id~, ..)
  assert_eq(id, "text-1")
  assert_eq(part.type_string(), "text-end")
  assert_eq(part.is_text_part(), true)
}

///|
test "TextStreamPart from_any reasoning-start" {
  let obj = @js.Object::new()
  obj.set("type", "reasoning-start")
  obj.set("id", "reason-1")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ReasoningStart(id~, ..)
  assert_eq(id, "reason-1")
  assert_eq(part.type_string(), "reasoning-start")
  assert_eq(part.is_reasoning_part(), true)
}

///|
test "TextStreamPart from_any reasoning-end" {
  let obj = @js.Object::new()
  obj.set("type", "reasoning-end")
  obj.set("id", "reason-1")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ReasoningEnd(id~, ..)
  assert_eq(id, "reason-1")
  assert_eq(part.type_string(), "reasoning-end")
  assert_eq(part.is_reasoning_part(), true)
}

///|
test "TextStreamPart from_any tool-input-end" {
  let obj = @js.Object::new()
  obj.set("type", "tool-input-end")
  obj.set("id", "tool-1")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolInputEnd(id~, ..)
  assert_eq(id, "tool-1")
  assert_eq(part.type_string(), "tool-input-end")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any tool-input-delta" {
  let obj = @js.Object::new()
  obj.set("type", "tool-input-delta")
  obj.set("id", "tool-1")
  obj.set("delta", "{\"query\":")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolInputDelta(id~, delta~, ..)
  assert_eq(id, "tool-1")
  assert_eq(delta, "{\"query\":")
  assert_eq(part.type_string(), "tool-input-delta")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any tool-call" {
  let obj = @js.Object::new()
  obj.set("type", "tool-call")
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "search")
  let input_obj = @js.Object::new()
  input_obj.set("query", "weather")
  obj.set("input", input_obj)
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolCallPart(tool_call~)
  assert_eq(tool_call.tool_call_id, "call-1")
  assert_eq(tool_call.tool_name, "search")
  assert_eq(part.type_string(), "tool-call")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any tool-result" {
  let obj = @js.Object::new()
  obj.set("type", "tool-result")
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "search")
  let input_obj = @js.Object::new()
  input_obj.set("query", "weather")
  obj.set("input", input_obj)
  obj.set("output", "Sunny")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolResultPart(tool_result~)
  assert_eq(tool_result.tool_call_id, "call-1")
  assert_eq(tool_result.tool_name, "search")
  assert_eq(part.type_string(), "tool-result")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any tool-error" {
  let obj = @js.Object::new()
  obj.set("type", "tool-error")
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "search")
  let args_obj = @js.Object::new()
  args_obj.set("query", "weather")
  obj.set("args", args_obj)
  obj.set("error", "Network error")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is ToolErrorPart(tool_error~)
  assert_eq(tool_error.tool_call_id, "call-1")
  assert_eq(tool_error.tool_name, "search")
  assert_eq(part.type_string(), "tool-error")
  assert_eq(part.is_tool_part(), true)
}

///|
test "TextStreamPart from_any raw" {
  let obj = @js.Object::new()
  obj.set("type", "raw")
  obj.set("rawValue", "raw data")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is Raw(raw_value~)
  let val : String = raw_value.cast()
  assert_eq(val, "raw data")
  assert_eq(part.type_string(), "raw")
}

///|
test "TextStreamPart from_any start-step" {
  let obj = @js.Object::new()
  obj.set("type", "start-step")
  let request_obj = @js.Object::new()
  request_obj.set("id", "req-1")
  obj.set("request", request_obj)
  let warning_obj = @js.Object::new()
  warning_obj.set("type", "test-warning")
  obj.set("warnings", [warning_obj] |> @js.from_array)
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is StartStep(request~, warnings~)
  ignore(request)
  assert_eq(warnings.length(), 1)
  assert_eq(part.type_string(), "start-step")
}

///|
test "TextStreamPart from_any source" {
  let obj = @js.Object::new()
  obj.set("type", "source")
  obj.set("sourceType", "url")
  obj.set("id", "src-1")
  obj.set("url", "https://example.com")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is SourcePart(source~)
  guard source is UrlSource(src)
  assert_eq(src.id, "src-1")
  assert_eq(part.type_string(), "source")
}

///|
test "TextStreamPart from_any file" {
  let obj = @js.Object::new()
  obj.set("type", "file")
  let file_obj = @js.Object::new()
  file_obj.set("name", "image.png")
  file_obj.set("mediaType", "image/png")
  file_obj.set("data", "base64data")
  obj.set("file", file_obj)
  let part = TextStreamPart::from_any(obj.as_any())
  guard part is FilePart(file~)
  guard file.name is Some(name)
  assert_eq(name, "image.png")
  assert_eq(part.type_string(), "file")
}

///|
test "ToolError from_any" {
  let obj = @js.Object::new()
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "search")
  let args_obj = @js.Object::new()
  args_obj.set("query", "weather")
  obj.set("args", args_obj)
  obj.set("error", "Network error")
  let error = ToolError::from_any(obj.as_any())
  assert_eq(error.tool_call_id, "call-1")
  assert_eq(error.tool_name, "search")
  let err : String = error.error.cast()
  assert_eq(err, "Network error")
}

///|
test "GeneratedFile from_any" {
  let obj = @js.Object::new()
  obj.set("name", "output.png")
  obj.set("mediaType", "image/png")
  obj.set("data", "base64encodeddata")
  let file = GeneratedFile::from_any(obj.as_any())
  guard file.name is Some(name)
  assert_eq(name, "output.png")
  guard file.media_type is Some(media_type)
  assert_eq(media_type, "image/png")
}

///|
test "GeneratedFile from_any without optional fields" {
  let obj = @js.Object::new()
  obj.set("data", "base64encodeddata")
  let file = GeneratedFile::from_any(obj.as_any())
  guard file.name is None
  guard file.media_type is None
}

///|
test "ReasoningOutput from_any" {
  let obj = @js.Object::new()
  obj.set("text", "Let me think about this...")
  let output = ReasoningOutput::from_any(obj.as_any())
  assert_eq(output.text, "Let me think about this...")
}

///|
test "ContentPart from_any text" {
  let obj = @js.Object::new()
  obj.set("type", "text")
  obj.set("text", "Hello world")
  let part = ContentPart::from_any(obj.as_any())
  guard part is TextPart(text~, ..)
  assert_eq(text, "Hello world")
}

///|
test "ContentPart from_any reasoning" {
  let obj = @js.Object::new()
  obj.set("type", "reasoning")
  obj.set("text", "Thinking...")
  let part = ContentPart::from_any(obj.as_any())
  guard part is ReasoningPart(reasoning~)
  assert_eq(reasoning.text, "Thinking...")
}

///|
test "ContentPart from_any source" {
  let obj = @js.Object::new()
  obj.set("type", "source")
  obj.set("sourceType", "url")
  obj.set("id", "src-1")
  obj.set("url", "https://example.com")
  let part = ContentPart::from_any(obj.as_any())
  guard part is SourceContentPart(source~)
  guard source is UrlSource(src)
  assert_eq(src.id, "src-1")
}

///|
test "ContentPart from_any file" {
  let obj = @js.Object::new()
  obj.set("type", "file")
  let file_obj = @js.Object::new()
  file_obj.set("name", "doc.pdf")
  file_obj.set("data", "data")
  obj.set("file", file_obj)
  let part = ContentPart::from_any(obj.as_any())
  guard part is FilePart(file~, ..)
  guard file.name is Some(name)
  assert_eq(name, "doc.pdf")
}

///|
test "ContentPart from_any tool-call" {
  let obj = @js.Object::new()
  obj.set("type", "tool-call")
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "search")
  let input_obj = @js.Object::new()
  input_obj.set("q", "test")
  obj.set("input", input_obj)
  let part = ContentPart::from_any(obj.as_any())
  guard part is ToolCallContentPart(tool_call~, ..)
  assert_eq(tool_call.tool_call_id, "call-1")
}

///|
test "ContentPart from_any tool-result" {
  let obj = @js.Object::new()
  obj.set("type", "tool-result")
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "search")
  let input_obj = @js.Object::new()
  obj.set("input", input_obj)
  obj.set("output", "result")
  let part = ContentPart::from_any(obj.as_any())
  guard part is ToolResultContentPart(tool_result~, ..)
  assert_eq(tool_result.tool_call_id, "call-1")
}

///|
test "ContentPart from_any tool-error" {
  let obj = @js.Object::new()
  obj.set("type", "tool-error")
  obj.set("toolCallId", "call-1")
  obj.set("toolName", "search")
  let args_obj = @js.Object::new()
  obj.set("args", args_obj)
  obj.set("error", "Error message")
  let part = ContentPart::from_any(obj.as_any())
  guard part is ToolErrorContentPart(tool_error~, ..)
  assert_eq(tool_error.tool_call_id, "call-1")
}

///|
test "ContentPart from_any unknown type" {
  let obj = @js.Object::new()
  obj.set("type", "unknown-type")
  let part = ContentPart::from_any(obj.as_any())
  // Unknown types fall through to TextPart with empty text
  guard part is TextPart(text~, ..)
  assert_eq(text, "")
}

///|
test "LanguageModelResponseMetadata from_any" {
  let obj = @js.Object::new()
  obj.set("id", "resp-123")
  obj.set("modelId", "gpt-4")
  obj.set("timestamp", "2024-01-01T00:00:00Z")
  let meta = LanguageModelResponseMetadata::from_any(obj.as_any())
  guard meta.id is Some(id)
  assert_eq(id, "resp-123")
  guard meta.model_id is Some(model_id)
  assert_eq(model_id, "gpt-4")
  guard meta.timestamp is Some(_)
}

///|
test "LanguageModelResponseMetadata from_any without optional" {
  let obj = @js.Object::new()
  let meta = LanguageModelResponseMetadata::from_any(obj.as_any())
  guard meta.id is None
  guard meta.model_id is None
  guard meta.timestamp is None
}

///|
test "Tools new and add" {
  let tools = Tools::new()
  let tool = Tool::typed(
    description="Test tool",
    input_schema={
      "type": "object",
      "properties": { "x": { "type": "number" } },
    },
    fn(input : @js.Any) -> Int { input.get("x").cast() },
  )
  let updated = tools.add("test_tool", tool)
  assert_eq(updated.tools.length(), 1)
}

///|
test "ToolChoice as_any auto" {
  let choice = ToolChoice::Auto
  let any = choice.as_any()
  let val : String = any.cast()
  assert_eq(val, "auto")
}

///|
test "ToolChoice as_any required" {
  let choice = ToolChoice::Required
  let any = choice.as_any()
  let val : String = any.cast()
  assert_eq(val, "required")
}

///|
test "ToolChoice as_any none" {
  let choice = ToolChoice::None_
  let any = choice.as_any()
  let val : String = any.cast()
  assert_eq(val, "none")
}

///|
test "ToolChoice as_any tool" {
  let choice = ToolChoice::Tool("my_tool")
  let any = choice.as_any()
  let type_val : String = any.get("type").cast()
  let name_val : String = any.get("toolName").cast()
  assert_eq(type_val, "tool")
  assert_eq(name_val, "my_tool")
}

///|
test "ProviderMetadata as_any" {
  let obj = @js.Object::new()
  obj.set("key", "value")
  let meta : ProviderMetadata = { raw: obj.as_any() }
  let any = meta.as_any()
  let val : String = any.get("key").cast()
  assert_eq(val, "value")
}

///|
test "LanguageModelRequestMetadata from_any" {
  let obj = @js.Object::new()
  obj.set("requestId", "req-1")
  let meta = LanguageModelRequestMetadata::from_any(obj.as_any())
  // Just verify it can be created
  let val : String = meta.raw.get("requestId").cast()
  assert_eq(val, "req-1")
}

///|
test "ToolInputStart with all optional fields" {
  let obj = @js.Object::new()
  obj.set("type", "tool-input-start")
  obj.set("id", "tool-1")
  obj.set("toolName", "search")
  obj.set("providerExecuted", true)
  obj.set("dynamic", false)
  obj.set("title", "Search Tool")
  let part = TextStreamPart::from_any(obj.as_any())
  guard part
    is ToolInputStart(id~, tool_name~, provider_executed~, dynamic~, title~, ..)
  assert_eq(id, "tool-1")
  assert_eq(tool_name, "search")
  guard provider_executed is Some(pe)
  assert_eq(pe, true)
  guard dynamic is Some(d)
  assert_eq(d, false)
  guard title is Some(t)
  assert_eq(t, "Search Tool")
}
