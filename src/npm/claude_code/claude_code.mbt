///| Claude Agent SDK bindings for MoonBit
/// Based on @anthropic-ai/claude-code TypeScript SDK

///|
fn claude_code_module() -> @core.Any {
  @node.require("@anthropic-ai/claude-code")
}

///|
/// Query handle for async iteration
#external
pub type Query

///|
pub fn Query::as_any(self : Query) -> @core.Any = "%identity"

///|
/// Get async iterator from Query
pub fn Query::async_iterator(self : Query) -> @js.AsyncIterator[@core.Any] {
  let any : @core.Any = self.as_any().cast()
  let key : String = @js.Symbol::asyncIterator() |> @core.identity
  let iter = any._call(key, [])
  @core.identity(iter)
}

///|
/// Typed async iterator wrapper for SDKMessage
pub(all) struct SDKMessageIterator {
  raw : @js.AsyncIterator[@core.Any]
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
pub fn query(
  prompt~ : String,
  model? : ClaudeModel,
  permission_mode? : PermissionMode,
  system_prompt? : String,
  cwd? : String,
  max_turns? : Int,
  max_thinking_tokens? : Int,
  allowed_tools? : Array[String],
  disallowed_tools? : Array[String],
  mcp_servers? : Map[String, McpServerConfig],
  agents? : Map[String, AgentDefinition],
  setting_sources? : Array[SettingSource],
  include_partial_messages? : Bool,
  resume_session? : String,
) -> SDKMessageIterator {
  let opts = @core.new_object()
  opts._set("prompt", prompt |> @core.any)
  if model is Some(m) {
    opts._set("model", m.to_string() |> @core.any)
  }
  if permission_mode is Some(pm) {
    opts._set("permissionMode", pm.to_string() |> @core.any)
  }
  if system_prompt is Some(sp) {
    opts._set("systemPrompt", sp |> @core.any)
  }
  if cwd is Some(c) {
    opts._set("cwd", c |> @core.any)
  }
  if max_turns is Some(mt) {
    opts._set("maxTurns", mt |> @core.any)
  }
  if max_thinking_tokens is Some(mtt) {
    opts._set("maxThinkingTokens", mtt |> @core.any)
  }
  if allowed_tools is Some(tools) {
    opts._set("allowedTools", tools |> @core.any)
  }
  if disallowed_tools is Some(tools) {
    opts._set("disallowedTools", tools |> @core.any)
  }
  if mcp_servers is Some(servers) {
    let servers_obj = @core.new_object()
    for name, config in servers {
      servers_obj._set(name, config.as_any())
    }
    opts._set("mcpServers", servers_obj)
  }
  if agents is Some(agts) {
    let agents_obj = @core.new_object()
    for name, agent in agts {
      agents_obj._set(name, agent.as_any())
    }
    opts._set("agents", agents_obj)
  }
  if setting_sources is Some(sources) {
    opts._set(
      "settingSources",
      sources.map(fn(s) { s.to_string() |> @js.any }) |> @core.any,
    )
  }
  if include_partial_messages is Some(ipm) {
    opts._set("includePartialMessages", ipm |> @core.any)
  }
  if resume_session is Some(r) {
    opts._set("resume", r |> @core.any)
  }
  let result = claude_code_module()._get("query")._invoke([opts])

  // MEMO: Lie
  let key : String = @js.Symbol::asyncIterator() |> @core.identity
  let iter = result._call(key, [])
  { raw: @core.identity(iter) }
}

///|
/// Query with async iterable prompt
/// For streaming prompts using SDKUserMessage
#alias(query_stream)
pub fn queryStream(
  prompt~ : @core.Any,
  model? : ClaudeModel,
  permission_mode? : PermissionMode,
  system_prompt? : String,
  cwd? : String,
  max_turns? : Int,
  max_thinking_tokens? : Int,
  allowed_tools? : Array[String],
  disallowed_tools? : Array[String],
  mcp_servers? : Map[String, McpServerConfig],
  agents? : Map[String, AgentDefinition],
  setting_sources? : Array[SettingSource],
  include_partial_messages? : Bool,
  resume_session? : String,
) -> SDKMessageIterator {
  let opts = @core.new_object()
  opts._set("prompt", prompt)
  if model is Some(m) {
    opts._set("model", m.to_string() |> @core.any)
  }
  if permission_mode is Some(pm) {
    opts._set("permissionMode", pm.to_string() |> @core.any)
  }
  if system_prompt is Some(sp) {
    opts._set("systemPrompt", sp |> @core.any)
  }
  if cwd is Some(c) {
    opts._set("cwd", c |> @core.any)
  }
  if max_turns is Some(mt) {
    opts._set("maxTurns", mt |> @core.any)
  }
  if max_thinking_tokens is Some(mtt) {
    opts._set("maxThinkingTokens", mtt |> @core.any)
  }
  if allowed_tools is Some(tools) {
    opts._set("allowedTools", tools |> @core.any)
  }
  if disallowed_tools is Some(tools) {
    opts._set("disallowedTools", tools |> @core.any)
  }
  if mcp_servers is Some(servers) {
    let servers_obj = @core.new_object()
    for name, config in servers {
      servers_obj._set(name, config.as_any())
    }
    opts._set("mcpServers", servers_obj)
  }
  if agents is Some(agts) {
    let agents_obj = @core.new_object()
    for name, agent in agts {
      agents_obj._set(name, agent.as_any())
    }
    opts._set("agents", agents_obj)
  }
  if setting_sources is Some(sources) {
    opts._set(
      "settingSources",
      sources.map(fn(s) { s.to_string() |> @js.any }) |> @core.any,
    )
  }
  if include_partial_messages is Some(ipm) {
    opts._set("includePartialMessages", ipm |> @core.any)
  }
  if resume_session is Some(r) {
    opts._set("resume", r |> @core.any)
  }
  let result = claude_code_module()._get("query")._invoke([opts])

  // MEMO: Lie
  let key : String = @js.Symbol::asyncIterator() |> @core.identity
  let iter = result._call(key, [])
  { raw: @core.identity(iter) }
}

///|
/// Abort handler returned from query for interrupting execution
#external
pub type AbortHandle

///|
pub fn AbortHandle::as_any(self : AbortHandle) -> @core.Any = "%identity"

///|
/// Abort the current query
pub fn AbortHandle::abort(self : AbortHandle) -> Unit {
  let abort_fn : @core.Any = self.as_any()["abort"].cast()
  let _ = abort_fn._invoke([])

}

///|
/// Query with abort capability
/// Returns both the iterator and an abort handle
#alias(query_with_abort)
pub fn queryWithAbort(
  prompt~ : String,
  model? : ClaudeModel,
  permission_mode? : PermissionMode,
  system_prompt? : String,
  cwd? : String,
  max_turns? : Int,
  max_thinking_tokens? : Int,
  allowed_tools? : Array[String],
  disallowed_tools? : Array[String],
  mcp_servers? : Map[String, McpServerConfig],
  agents? : Map[String, AgentDefinition],
  setting_sources? : Array[SettingSource],
  include_partial_messages? : Bool,
  resume_session? : String,
) -> (SDKMessageIterator, AbortHandle) {
  let opts = @core.new_object()
  opts._set("prompt", prompt |> @core.any)
  let abort_controller = @js.AbortController::new()
  let signal : @core.Any = @core.identity(abort_controller.signal())
  opts._set("abortSignal", signal)
  if model is Some(m) {
    opts._set("model", m.to_string() |> @core.any)
  }
  if permission_mode is Some(pm) {
    opts._set("permissionMode", pm.to_string() |> @core.any)
  }
  if system_prompt is Some(sp) {
    opts._set("systemPrompt", sp |> @core.any)
  }
  if cwd is Some(c) {
    opts._set("cwd", c |> @core.any)
  }
  if max_turns is Some(mt) {
    opts._set("maxTurns", mt |> @core.any)
  }
  if max_thinking_tokens is Some(mtt) {
    opts._set("maxThinkingTokens", mtt |> @core.any)
  }
  if allowed_tools is Some(tools) {
    opts._set("allowedTools", tools |> @core.any)
  }
  if disallowed_tools is Some(tools) {
    opts._set("disallowedTools", tools |> @core.any)
  }
  if mcp_servers is Some(servers) {
    let servers_obj = @core.new_object()
    for name, config in servers {
      servers_obj._set(name, config.as_any())
    }
    opts._set("mcpServers", servers_obj)
  }
  if agents is Some(agts) {
    let agents_obj = @core.new_object()
    for name, agent in agts {
      agents_obj._set(name, agent.as_any())
    }
    opts._set("agents", agents_obj)
  }
  if setting_sources is Some(sources) {
    opts._set(
      "settingSources",
      sources.map(fn(s) { s.to_string() |> @js.any }) |> @core.any,
    )
  }
  if include_partial_messages is Some(ipm) {
    opts._set("includePartialMessages", ipm |> @core.any)
  }
  if resume_session is Some(r) {
    opts._set("resume", r |> @core.any)
  }
  let result = claude_code_module()._get("query")._invoke([opts])

  // MEMO: Lie
  let key : String = @js.Symbol::asyncIterator() |> @core.identity
  let iter = result._call(key, [])
  ({ raw: @core.identity(iter) }, @core.identity(abort_controller))
}

///|
/// Collect all messages from a query
/// Convenience function that awaits all messages
#alias(collect_messages)
pub async fn collectMessages(
  prompt~ : String,
  model? : ClaudeModel,
  permission_mode? : PermissionMode,
  system_prompt? : String,
  cwd? : String,
  max_turns? : Int,
  max_thinking_tokens? : Int,
  allowed_tools? : Array[String],
  disallowed_tools? : Array[String],
  mcp_servers? : Map[String, McpServerConfig],
  agents? : Map[String, AgentDefinition],
  setting_sources? : Array[SettingSource],
  include_partial_messages? : Bool,
  resume_session? : String,
) -> Array[SDKMessage] {
  let iter = query(
    prompt~,
    model?,
    permission_mode?,
    system_prompt?,
    cwd?,
    max_turns?,
    max_thinking_tokens?,
    allowed_tools?,
    disallowed_tools?,
    mcp_servers?,
    agents?,
    setting_sources?,
    include_partial_messages?,
    resume_session?,
  )
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
pub async fn simpleQuery(
  prompt~ : String,
  model? : ClaudeModel,
  permission_mode? : PermissionMode,
  system_prompt? : String,
  cwd? : String,
  max_turns? : Int,
  max_thinking_tokens? : Int,
  allowed_tools? : Array[String],
  disallowed_tools? : Array[String],
  mcp_servers? : Map[String, McpServerConfig],
  agents? : Map[String, AgentDefinition],
  setting_sources? : Array[SettingSource],
  include_partial_messages? : Bool,
  resume_session? : String,
) -> String {
  let messages = collectMessages(
    prompt~,
    model?,
    permission_mode?,
    system_prompt?,
    cwd?,
    max_turns?,
    max_thinking_tokens?,
    allowed_tools?,
    disallowed_tools?,
    mcp_servers?,
    agents?,
    setting_sources?,
    include_partial_messages?,
    resume_session?,
  )
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
            println("Assistant message:")
            for block in a.content {
              match block {
                Text(t) => println("  Text: " + t.text)
                ToolUse(tu) => println("  Tool: " + tu.name)
                _ => ()
              }
            }
          }
          Result(r) => {
            println("Result: success=" + r.success.to_string())
            println("  Duration: " + r.duration_ms.to_string() + "ms")
            println(
              "  Tokens: input=" +
              r.usage.input_tokens.to_string() +
              " output=" +
              r.usage.output_tokens.to_string(),
            )
          }
          System(s) => println("System: model=" + s.model)
          _ => println("Other message")
        }
      None => break
    }
  }
}
