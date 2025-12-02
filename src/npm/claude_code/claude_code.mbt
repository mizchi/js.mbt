///| Claude Agent SDK bindings for MoonBit
/// Based on @anthropic-ai/claude-code TypeScript SDK

///|
fn claude_code_module() -> @nostd.Any {
  @node.require("@anthropic-ai/claude-code")
}

///|
/// Query handle for async iteration
#external
pub type Query

///|
pub fn Query::as_any(self : Query) -> @nostd.Any = "%identity"

///|
/// Get async iterator from Query
pub fn Query::async_iterator(self : Query) -> @js.AsyncIterator[@nostd.Any] {
  let any : @nostd.Any = self.as_any().cast()
  let key : String = @js.Symbol::asyncIterator() |> @nostd.identity
  let iter = any._call(key, [])
  @nostd.identity(iter)
}

///|
/// Typed async iterator wrapper for SDKMessage
pub(all) struct SDKMessageIterator {
  raw : @js.AsyncIterator[@nostd.Any]
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
  let opts = @nostd.Object::new()
  opts.set("prompt", prompt)
  if options is Some(o) {
    let options_any = o.as_any()
    // Merge options into opts
    let keys : Array[String] = @object.Object::keys(options_any)
      |> @nostd.identity
    for key in keys {
      opts.set(key, options_any._get(key))
    }
  }
  let result = claude_code_module()._get("query").call_self([opts])

  // MEMO: Lie
  let key : String = @js.Symbol::asyncIterator() |> @nostd.identity
  let iter = result._call(key, [])
  { raw: @nostd.identity(iter) }
}

///|
/// Query with async iterable prompt
/// For streaming prompts using SDKUserMessage
#alias(query_stream)
pub fn queryStream(
  prompt~ : @nostd.Any,
  options? : QueryOptions,
) -> SDKMessageIterator {
  let opts = @nostd.Object::new()
  opts.set("prompt", prompt)
  if options is Some(o) {
    let options_any = o.as_any()
    let keys : Array[String] = @object.Object::keys(options_any)
      |> @nostd.identity
    for key in keys {
      opts.set(key, options_any._get(key))
    }
  }
  let result = claude_code_module()._get("query").call_self([opts])

  // MEMO: Lie
  let key : String = @js.Symbol::asyncIterator() |> @nostd.identity
  let iter = result._call(key, [])
  { raw: @nostd.identity(iter) }
}

///|
/// Abort handler returned from query for interrupting execution
#external
pub type AbortHandle

///|
pub fn AbortHandle::as_any(self : AbortHandle) -> @nostd.Any = "%identity"

///|
/// Abort the current query
pub fn AbortHandle::abort(self : AbortHandle) -> Unit {
  let abort_fn : @nostd.Any = self.as_any()["abort"].cast()
  let _ = abort_fn.call_self([])

}

///|
/// Query with abort capability
/// Returns both the iterator and an abort handle
#alias(query_with_abort)
pub fn queryWithAbort(
  prompt~ : String,
  options? : QueryOptions,
) -> (SDKMessageIterator, AbortHandle) {
  let opts = @nostd.Object::new()
  opts.set("prompt", prompt)
  let abort_controller = @js.AbortController::new()
  let signal : @nostd.Any = @nostd.identity(abort_controller.signal())
  opts.set("abortSignal", signal)
  if options is Some(o) {
    let options_any = o.as_any()
    let keys : Array[String] = @object.Object::keys(options_any)
      |> @nostd.identity
    for key in keys {
      opts.set(key, options_any._get(key))
    }
  }
  let result = claude_code_module()._get("query").call_self([opts])

  // MEMO: Lie
  let key : String = @js.Symbol::asyncIterator() |> @nostd.identity
  let iter = result._call(key, [])
  ({ raw: @nostd.identity(iter) }, @nostd.identity(abort_controller))
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
