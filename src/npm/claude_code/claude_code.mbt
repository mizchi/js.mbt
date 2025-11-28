///| Claude Agent SDK bindings for MoonBit
/// Based on @anthropic-ai/claude-code TypeScript SDK

///|
fn claude_code_module() -> @js.Any {
  @node.require("@anthropic-ai/claude-code")
}

///|
/// Query handle for async iteration
#external
pub type Query

///|
pub impl @js.JsImpl for Query

///|
/// Get async iterator from Query
pub fn Query::async_iterator(self : Query) -> @js.AsyncIterator[@js.Any] {
  let iter = self.to_any().call(@js.Symbol::asyncIterator(), [])
  @js.identity(iter)
}

///|
/// Typed async iterator wrapper for SDKMessage
pub(all) struct SDKMessageIterator {
  raw : @js.AsyncIterator[@js.Any]
}

///|
/// Get next SDKMessage from the stream
pub async fn SDKMessageIterator::next(self : SDKMessageIterator) -> SDKMessage? {
  match self.raw.next() {
    Some(raw) => Some(SDKMessage::from_any(raw))
    None => None
  }
}

///|
/// Query Claude Code SDK
/// Returns an async iterator of SDKMessage
pub fn query(prompt~ : String, options? : QueryOptions) -> SDKMessageIterator {
  let opts = @js.Object::new()
  opts.set("prompt", prompt)
  if options is Some(o) {
    let options_any = o.to_any()
    // Merge options into opts
    let keys : Array[String] = @js.Object::keys(options_any) |> @js.identity
    for key in keys {
      opts.set(key, options_any.get(key))
    }
  }
  let result = claude_code_module().get("query").call_self([opts.to_any()])
  let iter = result.call(@js.Symbol::asyncIterator(), [])
  { raw: @js.identity(iter) }
}

///|
/// Query with async iterable prompt
/// For streaming prompts using SDKUserMessage
#alias(query_stream)
pub fn queryStream(
  prompt~ : @js.Any,
  options? : QueryOptions,
) -> SDKMessageIterator {
  let opts = @js.Object::new()
  opts.set("prompt", prompt)
  if options is Some(o) {
    let options_any = o.to_any()
    let keys : Array[String] = @js.Object::keys(options_any) |> @js.identity
    for key in keys {
      opts.set(key, options_any.get(key))
    }
  }
  let result = claude_code_module().get("query").call_self([opts.to_any()])
  let iter = result.call(@js.Symbol::asyncIterator(), [])
  { raw: @js.identity(iter) }
}

///|
/// Abort handler returned from query for interrupting execution
#external
pub type AbortHandle

///|
pub impl @js.JsImpl for AbortHandle

///|
/// Abort the current query
pub fn AbortHandle::abort(self : AbortHandle) -> Unit {
  let _ = self.to_any().get("abort").call_self([])

}

///|
/// Query with abort capability
/// Returns both the iterator and an abort handle
#alias(query_with_abort)
pub fn queryWithAbort(
  prompt~ : String,
  options? : QueryOptions,
) -> (SDKMessageIterator, AbortHandle) {
  let opts = @js.Object::new()
  opts.set("prompt", prompt)
  let abort_controller = @js.AbortController::new()
  let signal : @js.Any = @js.identity(abort_controller.signal())
  opts.set("abortSignal", signal)
  if options is Some(o) {
    let options_any = o.to_any()
    let keys : Array[String] = @js.Object::keys(options_any) |> @js.identity
    for key in keys {
      opts.set(key, options_any.get(key))
    }
  }
  let result = claude_code_module().get("query").call_self([opts.to_any()])
  let iter = result.call(@js.Symbol::asyncIterator(), [])
  ({ raw: @js.identity(iter) }, @js.identity(abort_controller))
}

///|
/// Collect all messages from a query
/// Convenience function that awaits all messages
#alias(collect_messages)
pub async fn collectMessages(
  prompt~ : String,
  options? : QueryOptions,
) -> Array[SDKMessage] {
  let iter = query(prompt~, options?)
  let messages : Array[SDKMessage] = []
  while true {
    match iter.next() {
      Some(msg) => messages.push(msg)
      None => break
    }
  }
  messages
}

///|
/// Get the final result from messages
/// Returns the last Result message or None
pub fn get_result(messages : Array[SDKMessage]) -> SDKResultMessage? {
  for i = messages.length() - 1; i >= 0; i = i - 1 {
    match messages[i] {
      Result(r) => return Some(r)
      _ => continue
    }
  }
  None
}

///|
/// Get all text content from messages
/// Extracts text from assistant messages
pub fn get_text(messages : Array[SDKMessage]) -> String {
  let texts : Array[String] = []
  for msg in messages {
    match msg {
      Assistant(a) =>
        for block in a.content {
          match block {
            Text(t) => texts.push(t.text)
            _ => ()
          }
        }
      _ => ()
    }
  }
  texts.iter().fold(init="", fn(acc, s) { acc + s })
}

///|
/// Simple query that returns just the text response
/// Convenience function for simple use cases
#alias(simple_query)
pub async fn simpleQuery(prompt~ : String, options? : QueryOptions) -> String {
  let messages = collectMessages(prompt~, options?)
  get_text(messages)
}

///|
#skip
async test "claude_code_sdk query" {
  let iter = query(prompt="Say hello in one word")
  while true {
    match iter.next() {
      Some(msg) =>
        match msg {
          Assistant(a) => {
            @js.log("Assistant message:")
            for block in a.content {
              match block {
                Text(t) => @js.log("  Text: " + t.text)
                ToolUse(tu) => @js.log("  Tool: " + tu.name)
                _ => ()
              }
            }
          }
          Result(r) => {
            @js.log("Result: success=" + r.success.to_string())
            @js.log("  Duration: " + r.duration_ms.to_string() + "ms")
            @js.log(
              "  Tokens: input=" +
              r.usage.input_tokens.to_string() +
              " output=" +
              r.usage.output_tokens.to_string(),
            )
          }
          System(s) => @js.log("System: model=" + s.model)
          _ => @js.log("Other message")
        }
      None => break
    }
  }
}
