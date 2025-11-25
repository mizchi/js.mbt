///| AI SDK bindings for MoonBit

///|
/// Message content types
pub(all) enum MessageContent {
  Text(String)
  Parts(Array[@js.Any])
}

///|
pub impl @js.JsImpl for MessageContent with to_any(self) {
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
pub impl @js.JsImpl for ModelMessage with to_any(self) {
  match self {
    AssistantMessage(content~) =>
      @js.from_map({
        "role": "assistant" |> @js.any,
        "content": @js.JsImpl::to_any(content),
      })
    UserMessage(content~) =>
      @js.from_map({
        "role": "user" |> @js.any,
        "content": @js.JsImpl::to_any(content),
      })
    SystemMessage(content~) =>
      @js.from_map({
        "role": "system" |> @js.any,
        "content": @js.JsImpl::to_any(content),
      })
    ToolMessage(content~) =>
      @js.from_map({
        "role": "tool" |> @js.any,
        "content": @js.JsImpl::to_any(content),
      })
  }
}

///|
/// npm:ai module handle
#external
pub type Ai

///|
/// Language model handle
#external
pub type Model

///|
pub impl @js.JsImpl for Ai

///|
pub impl @js.JsImpl for Model

///|
/// Load the AI SDK module
pub fn Ai::require() -> Self {
  @node.require("ai") |> @js.identity
}

///|
/// Generate text using the AI SDK (non-streaming)
pub async fn Ai::generate_text(
  self : Self,
  model~ : Model,
  messages? : Array[ModelMessage],
  prompt? : String,
  system? : String,
  max_tokens? : Int,
  temperature? : Double,
) -> GenerateTextResult {
  let opts = @js.Object::new()
  opts.set("model", model.to_any())
  match messages {
    Some(msgs) => opts.set("messages", msgs.map(_.to_any()) |> @js.from_array)
    None => ()
  }
  match prompt {
    Some(p) => opts.set("prompt", p)
    None => ()
  }
  match system {
    Some(s) => opts.set("system", s)
    None => ()
  }
  match max_tokens {
    Some(t) => opts.set("maxTokens", t)
    None => ()
  }
  match temperature {
    Some(t) => opts.set("temperature", t)
    None => ()
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.to_any().get("generateText").call_self([opts.to_any()]),
  )
  let result = promise.wait()
  GenerateTextResult::from_any(result)
}

///|
/// Stream text result wrapper
#external
pub type StreamTextResultHandle

///|
pub impl @js.JsImpl for StreamTextResultHandle

///|
/// Stream text using the AI SDK (streaming)
/// Note: This returns synchronously but the stream itself is async
pub fn Ai::stream_text(
  self : Self,
  model~ : Model,
  messages? : Array[ModelMessage],
  prompt? : String,
  system? : String,
  max_tokens? : Int,
  temperature? : Double,
) -> StreamTextResultHandle {
  let opts = @js.Object::new()
  opts.set("model", model.to_any())
  match messages {
    Some(msgs) => opts.set("messages", msgs.map(_.to_any()) |> @js.from_array)
    None => ()
  }
  match prompt {
    Some(p) => opts.set("prompt", p)
    None => ()
  }
  match system {
    Some(s) => opts.set("system", s)
    None => ()
  }
  match max_tokens {
    Some(t) => opts.set("maxTokens", t)
    None => ()
  }
  match temperature {
    Some(t) => opts.set("temperature", t)
    None => ()
  }
  let result = self.to_any().get("streamText").call_self([opts.to_any()])
  @js.identity(result)
}

///|
/// Get the full stream of TextStreamParts (raw iterator)
/// Note: fullStream is an AsyncIterable, so we call [Symbol.asyncIterator]()
pub fn StreamTextResultHandle::full_stream_raw(
  self : StreamTextResultHandle,
) -> @js.AsyncIterator[@js.Any] {
  let iterable = self.to_any().get("fullStream")
  // Call Symbol.asyncIterator method: iterable[Symbol.asyncIterator]()
  let iter = iterable.call(@js.Symbol::asyncIterator(), [])
  @js.identity(iter)
}

///|
/// Get the text stream (only text deltas)
/// Note: textStream is an AsyncIterable (ReadableStream), so we call [Symbol.asyncIterator]()
pub fn StreamTextResultHandle::text_stream(
  self : StreamTextResultHandle,
) -> @js.AsyncIterator[String] {
  let iterable = self.to_any().get("textStream")
  // Call Symbol.asyncIterator method: iterable[Symbol.asyncIterator]()
  let iter = iterable.call(@js.Symbol::asyncIterator(), [])
  @js.identity(iter)
}

///|
/// Get the final text (consumes stream)
pub async fn StreamTextResultHandle::text(
  self : StreamTextResultHandle,
) -> String {
  let promise : @js.Promise[String] = @js.identity(self.to_any().get("text"))
  promise.wait()
}

///|
/// Get the finish reason (consumes stream)
pub async fn StreamTextResultHandle::finish_reason(
  self : StreamTextResultHandle,
) -> FinishReason {
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.to_any().get("finishReason"),
  )
  let result = promise.wait()
  FinishReason::from_string(result.cast())
}

///|
/// Get the usage statistics (consumes stream)
pub async fn StreamTextResultHandle::usage(
  self : StreamTextResultHandle,
) -> LanguageModelUsage {
  let promise : @js.Promise[@js.Any] = @js.identity(self.to_any().get("usage"))
  let result = promise.wait()
  LanguageModelUsage::from_any(result)
}

///|
/// Get all steps (consumes stream)
pub async fn StreamTextResultHandle::steps(
  self : StreamTextResultHandle,
) -> Array[StepResult] {
  let promise : @js.Promise[@js.Any] = @js.identity(self.to_any().get("steps"))
  let result = promise.wait()
  let arr : Array[@js.Any] = @js.identity(result)
  arr.map(StepResult::from_any)
}

///|
#skip
async test "ai generate_text" {
  let ai : Ai = @js.identity(@node.require("ai"))
  let model : Model = @js.identity(
    @node.require("@ai-sdk/anthropic")
    .get("anthropic")
    .call_self(["claude-sonnet-4-20250514"]),
  )
  let result = ai.generate_text(model~, prompt="Say hello in one word") catch {
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
  let ai : Ai = @js.identity(@node.require("ai"))
  let model : Model = @js.identity(
    @node.require("@ai-sdk/anthropic")
    .get("anthropic")
    .call_self(["claude-sonnet-4-20250514"]),
  )
  // stream_text is synchronous
  let stream = ai.stream_text(model~, prompt="Count from 1 to 5")
  // Iterate over the text stream using async iterator
  let text_iter = stream.text_stream()
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
