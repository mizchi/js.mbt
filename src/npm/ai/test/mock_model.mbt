///| Mock Language Model V3
/// A mock language model for testing without making real API calls

///|
/// Result from doGenerate
pub(all) struct MockGenerateResult {
  /// The finish reason
  finish_reason : String
  /// Token usage
  usage : MockUsage
  /// Generated content
  content : Array[MockContentPart]
  /// Warnings (optional)
  warnings : Array[@js.Any]
}

///|
pub fn MockGenerateResult::to_any(self : MockGenerateResult) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("finishReason", self.finish_reason)
  let usage_obj = @js.Object::new()
  usage_obj.set("inputTokens", self.usage.input_tokens)
  usage_obj.set("outputTokens", self.usage.output_tokens)
  usage_obj.set("totalTokens", self.usage.total_tokens)
  obj.set("usage", usage_obj)
  let content_arr = self.content.map(MockContentPart::to_any)
  obj.set("content", content_arr |> @js.from_array)
  obj.set("warnings", self.warnings |> @js.from_array)
  obj.to_any()
}

///|
/// Token usage
pub(all) struct MockUsage {
  input_tokens : Int
  output_tokens : Int
  total_tokens : Int
}

///|
/// Content part
pub(all) enum MockContentPart {
  Text(String)
  ToolCall(tool_call_id~ : String, tool_name~ : String, args~ : @js.Any)
}

///|
pub fn MockContentPart::to_any(self : MockContentPart) -> @js.Any {
  match self {
    Text(text) => {
      let obj = @js.Object::new()
      obj.set("type", "text")
      obj.set("text", text)
      obj.to_any()
    }
    ToolCall(tool_call_id~, tool_name~, args~) => {
      let obj = @js.Object::new()
      obj.set("type", "tool-call")
      obj.set("toolCallId", tool_call_id)
      obj.set("toolName", tool_name)
      obj.set("args", args)
      obj.to_any()
    }
  }
}

///|
/// Result from doStream
pub(all) struct MockStreamResult {
  /// The readable stream of chunks
  stream : @js.Any
}

///|
pub fn MockStreamResult::to_any(self : MockStreamResult) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("stream", self.stream)
  obj.to_any()
}

///|
/// Options for creating a MockLanguageModelV3
pub(all) struct MockLanguageModelOptions {
  /// Provider name (default: "mock-provider")
  provider : String?
  /// Model ID (default: "mock-model-id")
  model_id : String?
  /// doGenerate implementation or result
  do_generate : MockGenerateHandler?
  /// doStream implementation or result
  do_stream : MockStreamHandler?
}

///|
/// Handler type for doGenerate
pub(all) enum MockGenerateHandler {
  /// Return a fixed result
  Result(MockGenerateResult)
  /// Return different results for each call
  Results(Array[MockGenerateResult])
  /// Custom function (JS function)
  Fn(@js.Any)
}

///|
/// Handler type for doStream
pub(all) enum MockStreamHandler {
  /// Return a fixed result
  Result(MockStreamResult)
  /// Return different results for each call
  Results(Array[MockStreamResult])
  /// Custom function (JS function)
  Fn(@js.Any)
}

///|
/// Create a MockLanguageModelV3 instance
pub fn mock_language_model(options : MockLanguageModelOptions) -> @js.Any {
  let test_module = require_test()
  let mock_class = test_module.get("MockLanguageModelV3")
  let opts = @js.Object::new()
  if options.provider is Some(p) {
    opts.set("provider", p)
  }
  if options.model_id is Some(m) {
    opts.set("modelId", m)
  }
  // Handle doGenerate
  match options.do_generate {
    Some(Result(r)) => opts.set("doGenerate", r.to_any())
    Some(Results(rs)) =>
      opts.set(
        "doGenerate",
        rs.map(MockGenerateResult::to_any) |> @js.from_array,
      )
    Some(Fn(f)) => opts.set("doGenerate", f)
    None => ()
  }
  // Handle doStream
  match options.do_stream {
    Some(Result(r)) => opts.set("doStream", r.to_any())
    Some(Results(rs)) =>
      opts.set("doStream", rs.map(MockStreamResult::to_any) |> @js.from_array)
    Some(Fn(f)) => opts.set("doStream", f)
    None => ()
  }
  // Call new MockLanguageModelV3(opts)
  @reflect.construct(mock_class, [opts.to_any()], None)
}

///|
/// Create a simple mock model that returns fixed text
pub fn mock_model_with_text(text : String) -> @js.Any {
  mock_language_model({
    provider: None,
    model_id: None,
    do_generate: Some(
      Result({
        finish_reason: "stop",
        usage: { input_tokens: 10, output_tokens: 20, total_tokens: 30 },
        content: [Text(text)],
        warnings: [],
      }),
    ),
    do_stream: None,
  })
}

///|
/// Create a mock model with streaming support
pub fn mock_model_with_stream(chunks : Array[@js.Any]) -> @js.Any {
  let stream = simulate_stream(chunks)
  mock_language_model({
    provider: None,
    model_id: None,
    do_generate: None,
    do_stream: Some(Result({ stream, })),
  })
}

///|
/// Create text delta chunk for streaming
pub fn text_delta_chunk(text : String) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("type", "text-delta")
  obj.set("textDelta", text)
  obj.to_any()
}

///|
/// Create finish chunk for streaming
pub fn finish_chunk(finish_reason : String, usage : MockUsage) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("type", "finish")
  obj.set("finishReason", finish_reason)
  let usage_obj = @js.Object::new()
  usage_obj.set("inputTokens", usage.input_tokens)
  usage_obj.set("outputTokens", usage.output_tokens)
  usage_obj.set("totalTokens", usage.total_tokens)
  obj.set("usage", usage_obj)
  obj.to_any()
}

///|
/// Create tool call chunk for streaming
pub fn tool_call_chunk(
  tool_call_id : String,
  tool_name : String,
  args : @js.Any,
) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("type", "tool-call")
  obj.set("toolCallId", tool_call_id)
  obj.set("toolName", tool_name)
  obj.set("args", args)
  obj.to_any()
}
