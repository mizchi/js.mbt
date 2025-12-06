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
  warnings : Array[@core.Any]
}

///|
pub fn MockGenerateResult::as_any(self : MockGenerateResult) -> @core.Any {
  let obj = @core.new_object()
  obj._set("finishReason", self.finish_reason |> @core.any)
  let usage_obj = @core.new_object()
  usage_obj._set("inputTokens", self.usage.input_tokens |> @core.any)
  usage_obj._set("outputTokens", self.usage.output_tokens |> @core.any)
  usage_obj._set("totalTokens", self.usage.total_tokens |> @core.any)
  obj._set("usage", usage_obj)
  let content_arr = self.content.map(MockContentPart::as_any)
  obj._set("content", content_arr |> @core.any)
  obj._set("warnings", self.warnings |> @core.any)
  obj
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
  ToolCall(tool_call_id~ : String, tool_name~ : String, args~ : @core.Any)
}

///|
pub fn MockContentPart::as_any(self : MockContentPart) -> @core.Any {
  match self {
    Text(text) => {
      let obj = @core.new_object()
      obj._set("type", "text" |> @core.any)
      obj._set("text", text |> @core.any)
      obj
    }
    ToolCall(tool_call_id~, tool_name~, args~) => {
      let obj = @core.new_object()
      obj._set("type", "tool-call" |> @core.any)
      obj._set("toolCallId", tool_call_id |> @core.any)
      obj._set("toolName", tool_name |> @core.any)
      obj._set("args", args |> @core.any)
      obj
    }
  }
}

///|
/// Result from doStream
pub(all) struct MockStreamResult {
  /// The readable stream of chunks
  stream : @core.Any
}

///|
pub fn MockStreamResult::as_any(self : MockStreamResult) -> @core.Any {
  let obj = @core.new_object()
  obj._set("stream", self.stream)
  obj
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
  Fn(@core.Any)
}

///|
/// Handler type for doStream
pub(all) enum MockStreamHandler {
  /// Return a fixed result
  Result(MockStreamResult)
  /// Return different results for each call
  Results(Array[MockStreamResult])
  /// Custom function (JS function)
  Fn(@core.Any)
}

///|
/// Create a MockLanguageModelV3 instance
pub fn mock_language_model(options : MockLanguageModelOptions) -> @core.Any {
  let test_module = require_test()
  let mock_class = test_module._get("MockLanguageModelV3")
  let opts = @core.new_object()
  if options.provider is Some(p) {
    opts._set("provider", p |> @core.any)
  }
  if options.model_id is Some(m) {
    opts._set("modelId", m |> @core.any)
  }
  // Handle doGenerate
  match options.do_generate {
    Some(Result(r)) => opts._set("doGenerate", r.as_any())
    Some(Results(rs)) =>
      opts._set("doGenerate", rs.map(MockGenerateResult::as_any) |> @core.any)
    Some(Fn(f)) => opts._set("doGenerate", f)
    None => ()
  }
  // Handle doStream
  match options.do_stream {
    Some(Result(r)) => opts._set("doStream", r.as_any())
    Some(Results(rs)) =>
      opts._set("doStream", rs.map(MockStreamResult::as_any) |> @core.any)
    Some(Fn(f)) => opts._set("doStream", f)
    None => ()
  }
  // Call new MockLanguageModelV3(opts)
  let mock_class_any : @core.Any = mock_class.cast()
  let opts_any : @core.Any = opts.cast()
  @reflect.Reflect::construct(mock_class_any, [opts_any], None).cast()
}

///|
/// Create a simple mock model that returns fixed text
pub fn mock_model_with_text(text : String) -> @core.Any {
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
pub fn mock_model_with_stream(chunks : Array[@core.Any]) -> @core.Any {
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
pub fn text_delta_chunk(text : String) -> @core.Any {
  let obj = @core.new_object()
  obj._set("type", "text-delta" |> @core.any)
  obj._set("textDelta", text |> @core.any)
  obj
}

///|
/// Create finish chunk for streaming
pub fn finish_chunk(finish_reason : String, usage : MockUsage) -> @core.Any {
  let obj = @core.new_object()
  obj._set("type", "finish" |> @core.any)
  obj._set("finishReason", finish_reason |> @core.any)
  let usage_obj = @core.new_object()
  usage_obj._set("inputTokens", usage.input_tokens |> @core.any)
  usage_obj._set("outputTokens", usage.output_tokens |> @core.any)
  usage_obj._set("totalTokens", usage.total_tokens |> @core.any)
  obj._set("usage", usage_obj)
  obj
}

///|
/// Create tool call chunk for streaming
pub fn tool_call_chunk(
  tool_call_id : String,
  tool_name : String,
  args : @core.Any,
) -> @core.Any {
  let obj = @core.new_object()
  obj._set("type", "tool-call" |> @core.any)
  obj._set("toolCallId", tool_call_id |> @core.any)
  obj._set("toolName", tool_name |> @core.any)
  obj._set("args", args)
  obj
}
