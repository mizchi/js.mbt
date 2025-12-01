///| AI SDK bindings for MoonBit

///|
/// Message content types
pub(all) enum MessageContent {
  Text(String)
  Parts(Array[@nostd.Any])
}

///|
pub fn MessageContent::as_any(self : MessageContent) -> @nostd.Any {
  match self {
    Text(text) => text |> @js.any
    Parts(parts) => parts |> @js.from_array
  }
}

///|
/// Model message types for conversation
pub(all) enum ModelMessage {
  UserMessage(content~ : MessageContent)
  AssistantMessage(content~ : MessageContent)
  SystemMessage(content~ : MessageContent)
  ToolMessage(content~ : MessageContent)
}

///|
pub fn ModelMessage::as_any(self : ModelMessage) -> @nostd.Any {
  match self {
    AssistantMessage(content~) =>
      @mbtconv.from_map({
        "role": @nostd.any("assistant"),
        "content": @nostd.any(content.as_any()),
      }).cast()
    UserMessage(content~) =>
      @mbtconv.from_map({
        "role": @nostd.any("user"),
        "content": @nostd.any(content.as_any()),
      }).cast()
    SystemMessage(content~) =>
      @mbtconv.from_map({
        "role": @nostd.any("system"),
        "content": @nostd.any(content.as_any()),
      }).cast()
    ToolMessage(content~) =>
      @mbtconv.from_map({
        "role": @nostd.any("tool"),
        "content": @nostd.any(content.as_any()),
      }).cast()
  }
}

///|
/// Language model handle
#external
pub type Model

///|
pub fn Model::as_any(self : Model) -> @nostd.Any = "%identity"

///|
fn ai_module() -> @nostd.Any {
  @node.require("ai")
}

///|
/// Generate text using the AI SDK (non-streaming)
#alias(generate_text)
pub async fn generateText(
  model~ : Model,
  messages? : Array[ModelMessage],
  prompt? : String,
  system? : String,
  max_tokens? : Int,
  temperature? : Double,
  tools? : Tools,
  tool_choice? : ToolChoice,
  max_steps? : Int,
  stop_when? : StopCondition,
  prepare_step? : PrepareStep,
  active_tools? : Array[String],
) -> GenerateTextResult {
  let opts = @nostd.Object::new()
  opts.set("model", model.as_any())
  if messages is Some(msgs) {
    opts.set("messages", msgs.map(_.as_any()) |> @js.from_array)
  }
  if prompt is Some(p) {
    opts.set("prompt", p)
  }
  if system is Some(s) {
    opts.set("system", s)
  }
  if max_tokens is Some(t) {
    opts.set("maxTokens", t)
  }
  if temperature is Some(t) {
    opts.set("temperature", t)
  }
  if tools is Some(t) {
    opts.set("tools", t.as_any())
  }
  if tool_choice is Some(tc) {
    opts.set("toolChoice", tc.as_any())
  }
  if max_steps is Some(ms) {
    opts.set("maxSteps", ms)
  }
  if stop_when is Some(sw) {
    opts.set("stopWhen", sw.as_any())
  }
  if prepare_step is Some(ps) {
    opts.set("prepareStep", ps.as_any())
  }
  if active_tools is Some(at) {
    opts.set("activeTools", at |> @js.from_array)
  }
  let promise : @js.Promise[@nostd.Any] = ai_module()
    ._get("generateText")
    .call_self([opts.as_any()])
    |> @js.identity
  let result = promise.wait()
  GenerateTextResult::from_any(result)
}

///|
/// Stream text result wrapper
#external
pub type StreamTextResultHandle

///|
pub fn StreamTextResultHandle::as_any(
  self : StreamTextResultHandle,
) -> @nostd.Any = "%identity"

///|
/// Stream text using the AI SDK (streaming)
/// Note: This returns synchronously but the stream itself is async
#alias(stream_text)
pub fn streamText(
  model~ : Model,
  messages? : Array[ModelMessage],
  prompt? : String,
  system? : String,
  max_tokens? : Int,
  temperature? : Double,
  tools? : Tools,
  tool_choice? : ToolChoice,
  max_steps? : Int,
  stop_when? : StopCondition,
  prepare_step? : PrepareStep,
  active_tools? : Array[String],
) -> StreamTextResultHandle {
  let opts = @nostd.Object::new()
  opts.set("model", model.as_any())
  if messages is Some(msgs) {
    opts.set("messages", msgs.map(_.as_any()) |> @js.from_array)
  }
  if prompt is Some(p) {
    opts.set("prompt", p)
  }
  if system is Some(s) {
    opts.set("system", s)
  }
  if max_tokens is Some(t) {
    opts.set("maxTokens", t)
  }
  if temperature is Some(t) {
    opts.set("temperature", t)
  }
  if tools is Some(t) {
    opts.set("tools", t.as_any())
  }
  if tool_choice is Some(tc) {
    opts.set("toolChoice", tc.as_any())
  }
  if max_steps is Some(ms) {
    opts.set("maxSteps", ms)
  }
  if stop_when is Some(sw) {
    opts.set("stopWhen", sw.as_any())
  }
  if prepare_step is Some(ps) {
    opts.set("prepareStep", ps.as_any())
  }
  if active_tools is Some(at) {
    opts.set("activeTools", at |> @js.from_array)
  }
  let result = ai_module()._get("streamText").call_self([opts.as_any()])
  @js.identity(result)
}

///|
/// Get the full stream of TextStreamParts (raw iterator)
/// Note: fullStream is an AsyncIterable, so we call [Symbol.asyncIterator]()
#alias(full_stream_raw)
pub fn StreamTextResultHandle::fullStreamRaw(
  self : StreamTextResultHandle,
) -> @js.AsyncIterator[@nostd.Any] {
  let iterable = self.as_any()._get("fullStream")
  // Call Symbol.asyncIterator method: iterable[Symbol.asyncIterator]()
  let iter = iterable._call(@js.Symbol::asyncIterator(), [])
  @js.identity(iter)
}

///|
/// Typed async iterator wrapper that converts raw JS values to TextStreamPart
pub(all) struct TextStreamPartIterator {
  raw : @js.AsyncIterator[@nostd.Any]
}

///|
/// Get next TextStreamPart from the stream
pub async fn TextStreamPartIterator::next(
  self : TextStreamPartIterator,
) -> TextStreamPart? {
  match self.raw.next() {
    Some(raw) => Some(TextStreamPart::from_any(raw))
    None => None
  }
}

///|
/// Get the full stream as typed TextStreamPart iterator
#alias(full_stream)
pub fn StreamTextResultHandle::fullStream(
  self : StreamTextResultHandle,
) -> TextStreamPartIterator {
  let iterable = self.as_any()._get("fullStream")
  let iter = iterable._call(@js.Symbol::asyncIterator(), [])
  { raw: @js.identity(iter) }
}

///|
/// Get the text stream (only text deltas)
/// Note: textStream is an AsyncIterable (ReadableStream), so we call [Symbol.asyncIterator]()
#alias(text_stream)
pub fn StreamTextResultHandle::textStream(
  self : StreamTextResultHandle,
) -> @js.AsyncIterator[String] {
  let iterable = self.as_any()._get("textStream")
  // Call Symbol.asyncIterator method: iterable[Symbol.asyncIterator]()
  let iter = iterable._call(@js.Symbol::asyncIterator(), [])
  @js.identity(iter)
}

///|
/// Get the final text (consumes stream)
pub async fn StreamTextResultHandle::text(
  self : StreamTextResultHandle,
) -> String {
  let promise : @js.Promise[String] = @js.identity(self.as_any()._get("text"))
  promise.wait()
}

///|
/// Get the finish reason (consumes stream)
#alias(finish_reason)
pub async fn StreamTextResultHandle::finishReason(
  self : StreamTextResultHandle,
) -> FinishReason {
  let promise : @js.Promise[@nostd.Any] = @js.identity(
    self.as_any()._get("finishReason"),
  )
  let result = promise.wait()
  FinishReason::from_string(result.cast())
}

///|
/// Get the usage statistics (consumes stream)
pub async fn StreamTextResultHandle::usage(
  self : StreamTextResultHandle,
) -> LanguageModelUsage {
  let promise : @js.Promise[@nostd.Any] = @js.identity(
    self.as_any()._get("usage"),
  )
  let result = promise.wait()
  LanguageModelUsage::from_any(result)
}

///|
/// Get all steps (consumes stream)
pub async fn StreamTextResultHandle::steps(
  self : StreamTextResultHandle,
) -> Array[StepResult] {
  let promise : @js.Promise[@nostd.Any] = @js.identity(
    self.as_any()._get("steps"),
  )
  let result = promise.wait()
  let arr : Array[@nostd.Any] = @js.identity(result)
  arr.map(StepResult::from_any)
}

///|
#skip
async test "ai generate_text" {
  let model = anthropic("claude-sonnet-4-20250514")
  let result = generateText(model~, prompt="Say hello in one word") catch {
    @js.ThrowError::Error(e) => {
      @js.log(e)
      return
    }
    e => {
      @js.log(e)
      return
    }
  }
  @js.log("Text: " + result.text)
  @js.log("Finish reason: " + result.finish_reason.to_string())
  @js.log("Tokens used: " + result.usage.total_tokens.to_string())
}

///|
#skip
async test "ai stream_text" {
  let model = anthropic("claude-sonnet-4-20250514")
  // stream_text is synchronous
  let stream = streamText(model~, prompt="Count from 1 to 5")
  // Iterate over the text stream using async iterator
  let text_iter = stream.textStream()
  while true {
    match text_iter.next() {
      Some(chunk) => @js.log("Chunk: " + chunk)
      None => break
    }
  }
  // Get final results
  let text = stream.text() catch {
    e => {
      @js.log(e)
      return
    }
  }
  @js.log("Final text: " + text)
}
