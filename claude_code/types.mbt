///| Claude Agent SDK Type definitions
/// Based on @anthropic-ai/claude-code TypeScript SDK

///|
/// Permission mode for Claude Code execution
pub(all) enum PermissionMode {
  /// Default permission mode - prompts for dangerous operations
  Default
  /// Accept file edits automatically
  AcceptEdits
  /// Bypass all permission prompts (requires explicit user consent)
  BypassPermissions
  /// Plan mode - for planning without execution
  Plan
} derive(Eq, Show)

///|
pub fn PermissionMode::to_string(self : PermissionMode) -> String {
  match self {
    Default => "default"
    AcceptEdits => "acceptEdits"
    BypassPermissions => "bypassPermissions"
    Plan => "plan"
  }
}

///|
pub fn PermissionMode::from_string(s : String) -> PermissionMode {
  match s {
    "default" => Default
    "acceptEdits" => AcceptEdits
    "bypassPermissions" => BypassPermissions
    "plan" => Plan
    _ => Default
  }
}

///|
/// Setting source for loading configuration
pub(all) enum SettingSource {
  /// User settings (~/.claude/settings.json)
  User
  /// Project settings (.claude/settings.json)
  Project
  /// Local settings (.claude/settings.local.json)
  Local
} derive(Eq, Show)

///|
pub fn SettingSource::to_string(self : SettingSource) -> String {
  match self {
    User => "user"
    Project => "project"
    Local => "local"
  }
}

///|
/// Model variants for Claude
pub(all) enum ClaudeModel {
  Sonnet
  Opus
  Haiku
  Custom(String)
} derive(Eq, Show)

///|
pub fn ClaudeModel::to_string(self : ClaudeModel) -> String {
  match self {
    Sonnet => "sonnet"
    Opus => "opus"
    Haiku => "haiku"
    Custom(s) => s
  }
}

///|
/// Tool use content block
pub(all) struct ToolUseBlock {
  id : String
  name : String
  input : @core.Any
  raw : @core.Any
}

///|
pub fn ToolUseBlock::from_any(value : @core.Any) -> ToolUseBlock {
  {
    id: value._get("id").cast(),
    name: value._get("name").cast(),
    input: value._get("input"),
    raw: value,
  }
}

///|
/// Tool result content block
pub(all) struct ToolResultBlock {
  tool_use_id : String
  content : String
  is_error : Bool
  raw : @core.Any
}

///|
pub fn ToolResultBlock::from_any(value : @core.Any) -> ToolResultBlock {
  let is_error_raw = value._get("is_error")
  {
    tool_use_id: value._get("tool_use_id").cast(),
    content: value._get("content").cast(),
    is_error: if @core.is_undefined(is_error_raw) {
      false
    } else {
      is_error_raw.cast()
    },
    raw: value,
  }
}

///|
/// Text content block
pub(all) struct TextBlock {
  text : String
  raw : @core.Any
}

///|
pub fn TextBlock::from_any(value : @core.Any) -> TextBlock {
  { text: value._get("text").cast(), raw: value }
}

///|
/// Content block union type
pub(all) enum ContentBlock {
  Text(TextBlock)
  ToolUse(ToolUseBlock)
  ToolResult(ToolResultBlock)
  Unknown(@core.Any)
}

///|
pub fn ContentBlock::from_any(value : @core.Any) -> ContentBlock {
  let type_str : String = value._get("type").cast()
  match type_str {
    "text" => Text(TextBlock::from_any(value))
    "tool_use" => ToolUse(ToolUseBlock::from_any(value))
    "tool_result" => ToolResult(ToolResultBlock::from_any(value))
    _ => Unknown(value)
  }
}

///|
/// Token usage statistics
pub(all) struct TokenUsage {
  input_tokens : Int
  output_tokens : Int
  cache_read_input_tokens : Int
  cache_creation_input_tokens : Int
}

///|
pub fn TokenUsage::from_any(value : @core.Any) -> TokenUsage {
  let cache_read = value._get("cache_read_input_tokens")
  let cache_creation = value._get("cache_creation_input_tokens")
  {
    input_tokens: value._get("input_tokens").cast(),
    output_tokens: value._get("output_tokens").cast(),
    cache_read_input_tokens: if @core.is_undefined(cache_read) {
      0
    } else {
      cache_read.cast()
    },
    cache_creation_input_tokens: if @core.is_undefined(cache_creation) {
      0
    } else {
      cache_creation.cast()
    },
  }
}

///|
/// Cost information
pub(all) struct CostInfo {
  input_cost : Double
  output_cost : Double
  total_cost : Double
}

///|
pub fn CostInfo::from_any(value : @core.Any) -> CostInfo {
  {
    input_cost: value._get("inputCost").cast(),
    output_cost: value._get("outputCost").cast(),
    total_cost: value._get("totalCost").cast(),
  }
}

///|
/// Permission denial information
pub(all) struct PermissionDenial {
  tool_name : String
  reason : String
}

///|
pub fn PermissionDenial::from_any(value : @core.Any) -> PermissionDenial {
  {
    tool_name: value._get("toolName").cast(),
    reason: value._get("reason").cast(),
  }
}

///|
/// SDK Assistant Message
pub(all) struct SDKAssistantMessage {
  role : String
  content : Array[ContentBlock]
  raw : @core.Any
}

///|
pub fn SDKAssistantMessage::from_any(value : @core.Any) -> SDKAssistantMessage {
  let content_raw = value._get("content")
  let content : Array[ContentBlock] = if @core.is_undefined(content_raw) ||
    @core.is_null(content_raw) {
    []
  } else {
    let arr : Array[@core.Any] = @core.identity(content_raw)
    arr.map(ContentBlock::from_any)
  }
  { role: "assistant", content, raw: value }
}

///|
/// SDK User Message
pub(all) struct SDKUserMessage {
  role : String
  content : String
  raw : @core.Any
}

///|
pub fn SDKUserMessage::from_any(value : @core.Any) -> SDKUserMessage {
  { role: "user", content: value._get("content").cast(), raw: value }
}

///|
/// SDK Result Message
pub(all) struct SDKResultMessage {
  success : Bool
  duration_ms : Int
  usage : TokenUsage
  cost : CostInfo?
  permission_denials : Array[PermissionDenial]
  raw : @core.Any
}

///|
pub fn SDKResultMessage::from_any(value : @core.Any) -> SDKResultMessage {
  let cost_raw = value._get("cost")
  let cost : CostInfo? = if @core.is_undefined(cost_raw) ||
    @core.is_null(cost_raw) {
    None
  } else {
    Some(CostInfo::from_any(cost_raw))
  }
  let denials_raw = value._get("permissionDenials")
  let denials : Array[PermissionDenial] = if @core.is_undefined(denials_raw) ||
    @core.is_null(denials_raw) {
    []
  } else {
    let arr : Array[@core.Any] = @core.identity(denials_raw)
    arr.map(PermissionDenial::from_any)
  }
  {
    success: value._get("success").cast(),
    duration_ms: value._get("durationMs").cast(),
    usage: TokenUsage::from_any(value._get("usage")),
    cost,
    permission_denials: denials,
    raw: value,
  }
}

///|
/// SDK System Message
pub(all) struct SDKSystemMessage {
  tools : Array[String]
  mcp_servers : Array[String]
  model : String
  permission_mode : PermissionMode
  raw : @core.Any
}

///|
pub fn SDKSystemMessage::from_any(value : @core.Any) -> SDKSystemMessage {
  let tools_raw = value._get("tools")
  let tools : Array[String] = if @core.is_undefined(tools_raw) ||
    @core.is_null(tools_raw) {
    []
  } else {
    let arr : Array[@core.Any] = @core.identity(tools_raw)
    arr.map(fn(v) { v.cast() })
  }
  let mcp_raw = value._get("mcpServers")
  let mcp_servers : Array[String] = if @core.is_undefined(mcp_raw) ||
    @core.is_null(mcp_raw) {
    []
  } else {
    let arr : Array[@core.Any] = @core.identity(mcp_raw)
    arr.map(fn(v) { v.cast() })
  }
  let perm_raw = value._get("permissionMode")
  let perm_mode = if @core.is_undefined(perm_raw) {
    PermissionMode::Default
  } else {
    PermissionMode::from_string(perm_raw.cast())
  }
  {
    tools,
    mcp_servers,
    model: value._get("model").cast(),
    permission_mode: perm_mode,
    raw: value,
  }
}

///|
/// SDK Partial Message (for streaming)
pub(all) struct SDKPartialMessage {
  content : Array[ContentBlock]
  raw : @core.Any
}

///|
pub fn SDKPartialMessage::from_any(value : @core.Any) -> SDKPartialMessage {
  let content_raw = value._get("content")
  let content : Array[ContentBlock] = if @core.is_undefined(content_raw) ||
    @core.is_null(content_raw) {
    []
  } else {
    let arr : Array[@core.Any] = @core.identity(content_raw)
    arr.map(ContentBlock::from_any)
  }
  { content, raw: value }
}

///|
/// SDK Message union type
pub(all) enum SDKMessage {
  Assistant(SDKAssistantMessage)
  User(SDKUserMessage)
  Result(SDKResultMessage)
  System(SDKSystemMessage)
  Partial(SDKPartialMessage)
  Unknown(@core.Any)
}

///|
pub fn SDKMessage::from_any(value : @core.Any) -> SDKMessage {
  let type_str : String = value._get("type").cast()
  match type_str {
    "assistant" => Assistant(SDKAssistantMessage::from_any(value))
    "user" => User(SDKUserMessage::from_any(value))
    "result" => Result(SDKResultMessage::from_any(value))
    "system" => System(SDKSystemMessage::from_any(value))
    "partial" => Partial(SDKPartialMessage::from_any(value))
    _ => Unknown(value)
  }
}

///|
/// MCP Server configuration - stdio type
pub(all) struct McpServerStdio {
  command : String
  args : Array[String]
  env : Map[String, String]
}

///|
pub fn McpServerStdio::as_any(self : McpServerStdio) -> @core.Any {
  let obj = @core.new_object()
  obj._set("type", "stdio" |> @core.any)
  obj._set("command", self.command |> @core.any)
  obj._set("args", self.args |> @core.any)
  let env_obj = @core.new_object()
  for k, v in self.env {
    env_obj._set(k, v |> @core.any)
  }
  obj._set("env", env_obj)
  obj
}

///|
/// MCP Server configuration - SSE type
pub(all) struct McpServerSse {
  url : String
  headers : Map[String, String]
}

///|
pub fn McpServerSse::as_any(self : McpServerSse) -> @core.Any {
  let obj = @core.new_object()
  obj._set("type", "sse" |> @core.any)
  obj._set("url", self.url |> @core.any)
  let headers_obj = @core.new_object()
  for k, v in self.headers {
    headers_obj._set(k, v |> @core.any)
  }
  obj._set("headers", headers_obj)
  obj
}

///|
/// MCP Server configuration union type
pub(all) enum McpServerConfig {
  Stdio(McpServerStdio)
  Sse(McpServerSse)
}

///|
pub fn McpServerConfig::as_any(self : McpServerConfig) -> @core.Any {
  match self {
    Stdio(cfg) => cfg.as_any()
    Sse(cfg) => cfg.as_any()
  }
}

///|
/// Agent definition for subagents
pub(all) struct AgentDefinition {
  /// Description of the agent's purpose
  description : String
  /// Allowed tools for this agent
  allowedTools : Array[String]?
  /// Disallowed tools for this agent
  disallowedTools : Array[String]?
  /// Custom system prompt
  systemPrompt : String?
  /// Model override
  model : ClaudeModel?
}

///|
pub fn AgentDefinition::as_any(self : AgentDefinition) -> @core.Any {
  let obj = @core.new_object()
  obj._set("description", self.description |> @core.any)
  if self.allowedTools is Some(tools) {
    obj._set("allowedTools", tools |> @core.any)
  }
  if self.disallowedTools is Some(tools) {
    obj._set("disallowedTools", tools |> @core.any)
  }
  if self.systemPrompt is Some(prompt) {
    obj._set("systemPrompt", prompt |> @core.any)
  }
  if self.model is Some(m) {
    obj._set("model", m.to_string() |> @core.any)
  }
  obj
}

///|
/// Query options for Claude Code SDK
pub(all) struct QueryOptions {
  /// Model to use
  model : ClaudeModel?
  /// Permission mode
  permissionMode : PermissionMode?
  /// System prompt
  systemPrompt : String?
  /// Working directory
  cwd : String?
  /// Maximum turns
  maxTurns : Int?
  /// Maximum thinking tokens
  maxThinkingTokens : Int?
  /// Allowed tools
  allowedTools : Array[String]?
  /// Disallowed tools
  disallowedTools : Array[String]?
  /// MCP servers
  mcpServers : Map[String, McpServerConfig]?
  /// Agent definitions
  agents : Map[String, AgentDefinition]?
  /// Setting sources to load
  settingSources : Array[SettingSource]?
  /// Include partial messages for streaming
  includePartialMessages : Bool?
  /// Resume from session ID
  resumeSession : String?
}

///|
pub fn QueryOptions::new() -> QueryOptions {
  {
    model: None,
    permissionMode: None,
    systemPrompt: None,
    cwd: None,
    maxTurns: None,
    maxThinkingTokens: None,
    allowedTools: None,
    disallowedTools: None,
    mcpServers: None,
    agents: None,
    settingSources: None,
    includePartialMessages: None,
    resumeSession: None,
  }
}

///|
pub fn QueryOptions::as_any(self : QueryOptions) -> @core.Any {
  let obj = @core.new_object()
  if self.model is Some(m) {
    obj._set("model", m.to_string() |> @core.any)
  }
  if self.permissionMode is Some(pm) {
    obj._set("permissionMode", pm.to_string() |> @core.any)
  }
  if self.systemPrompt is Some(sp) {
    obj._set("systemPrompt", sp |> @core.any)
  }
  if self.cwd is Some(c) {
    obj._set("cwd", c |> @core.any)
  }
  if self.maxTurns is Some(mt) {
    obj._set("maxTurns", mt |> @core.any)
  }
  if self.maxThinkingTokens is Some(mtt) {
    obj._set("maxThinkingTokens", mtt |> @core.any)
  }
  if self.allowedTools is Some(tools) {
    obj._set("allowedTools", tools |> @core.any)
  }
  if self.disallowedTools is Some(tools) {
    obj._set("disallowedTools", tools |> @core.any)
  }
  if self.mcpServers is Some(servers) {
    let servers_obj = @core.new_object()
    for name, config in servers {
      servers_obj._set(name, config.as_any())
    }
    obj._set("mcpServers", servers_obj)
  }
  if self.agents is Some(agents) {
    let agents_obj = @core.new_object()
    for name, agent in agents {
      agents_obj._set(name, agent.as_any())
    }
    obj._set("agents", agents_obj)
  }
  if self.settingSources is Some(sources) {
    obj._set(
      "settingSources",
      sources.map(fn(s) { s.to_string() |> @js.any }) |> @core.any,
    )
  }
  if self.includePartialMessages is Some(ipm) {
    obj._set("includePartialMessages", ipm |> @core.any)
  }
  if self.resumeSession is Some(r) {
    obj._set("resume", r |> @core.any)
  }
  obj
}
