///| AI SDK Type definitions
/// Based on TextStreamPart and related types from @ai-sdk/provider

///|
/// Provider metadata - additional provider-specific information
pub(all) struct ProviderMetadata {
  raw : @js.Any
}

///|
pub fn ProviderMetadata::from_any(value : @js.Any) -> ProviderMetadata? {
  if @js.is_undefined(value) || @js.is_null(value) {
    None
  } else {
    Some({ raw: value })
  }
}

///|
pub fn ProviderMetadata::to_any(self : ProviderMetadata) -> @js.Any {
  self.raw
}

///|
/// Language model usage statistics
/// Note: AI SDK v6 uses inputTokens/outputTokens instead of promptTokens/completionTokens
pub(all) struct LanguageModelUsage {
  input_tokens : Int
  output_tokens : Int
  total_tokens : Int
  cached_input_tokens : Int
}

///|
pub fn LanguageModelUsage::from_any(value : @js.Any) -> LanguageModelUsage {
  let cached = value.get("cachedInputTokens")
  {
    input_tokens: value.get("inputTokens").cast(),
    output_tokens: value.get("outputTokens").cast(),
    total_tokens: value.get("totalTokens").cast(),
    cached_input_tokens: if @js.is_undefined(cached) {
      0
    } else {
      cached.cast()
    },
  }
}

///|
/// Finish reason for model response
pub(all) enum FinishReason {
  Stop
  Length
  ContentFilter
  ToolCalls
  Error
  Other
  Unknown
} derive(Eq, Show)

///|
pub fn FinishReason::from_string(s : String) -> FinishReason {
  match s {
    "stop" => Stop
    "length" => Length
    "content-filter" => ContentFilter
    "tool-calls" => ToolCalls
    "error" => Error
    "other" => Other
    _ => Unknown
  }
}

///|
pub fn FinishReason::to_string(self : FinishReason) -> String {
  match self {
    Stop => "stop"
    Length => "length"
    ContentFilter => "content-filter"
    ToolCalls => "tool-calls"
    Error => "error"
    Other => "other"
    Unknown => "unknown"
  }
}

///|
/// Call warning from language model
pub(all) struct CallWarning {
  type_ : String
  message : String?
  raw : @js.Any
}

///|
pub fn CallWarning::from_any(value : @js.Any) -> CallWarning {
  {
    type_: value.get("type").cast(),
    message: {
      let m = value.get("message")
      if @js.is_undefined(m) {
        None
      } else {
        Some(m.cast())
      }
    },
    raw: value,
  }
}

///|
/// Source type - URL or Document
pub(all) enum SourceType {
  Url
  Document
} derive(Eq, Show)

///|
pub fn SourceType::from_string(s : String) -> SourceType {
  match s {
    "url" => Url
    "document" => Document
    _ => Url
  }
}

///|
/// Source from language model (URL source)
pub(all) struct SourceUrl {
  id : String
  url : String
  title : String?
  provider_metadata : ProviderMetadata?
}

///|
/// Source from language model (Document source)
pub(all) struct SourceDocument {
  id : String
  title : String?
  provider_metadata : ProviderMetadata?
}

///|
/// Source union type
pub(all) enum Source {
  UrlSource(SourceUrl)
  DocumentSource(SourceDocument)
}

///|
pub fn Source::from_any(value : @js.Any) -> Source {
  let source_type = value.get("sourceType")
  if @js.is_undefined(source_type) || source_type.cast() == "url" {
    UrlSource({
      id: value.get("id").cast(),
      url: value.get("url").cast(),
      title: {
        let t = value.get("title")
        if @js.is_undefined(t) {
          None
        } else {
          Some(t.cast())
        }
      },
      provider_metadata: ProviderMetadata::from_any(
        value.get("providerMetadata"),
      ),
    })
  } else {
    DocumentSource({
      id: value.get("id").cast(),
      title: {
        let t = value.get("title")
        if @js.is_undefined(t) {
          None
        } else {
          Some(t.cast())
        }
      },
      provider_metadata: ProviderMetadata::from_any(
        value.get("providerMetadata"),
      ),
    })
  }
}

///|
/// Generated file from model
pub(all) struct GeneratedFile {
  name : String?
  media_type : String?
  data : @js.Any
  raw : @js.Any
}

///|
pub fn GeneratedFile::from_any(value : @js.Any) -> GeneratedFile {
  {
    name: {
      let n = value.get("name")
      if @js.is_undefined(n) {
        None
      } else {
        Some(n.cast())
      }
    },
    media_type: {
      let m = value.get("mediaType")
      if @js.is_undefined(m) {
        None
      } else {
        Some(m.cast())
      }
    },
    data: value.get("data"),
    raw: value,
  }
}

///|
/// Tool call information
/// Note: AI SDK v6 uses 'input' instead of 'args'
pub(all) struct ToolCall {
  tool_call_id : String
  tool_name : String
  input : @js.Any
}

///|
pub fn ToolCall::from_any(value : @js.Any) -> ToolCall {
  {
    tool_call_id: value.get("toolCallId").cast(),
    tool_name: value.get("toolName").cast(),
    input: value.get("input"),
  }
}

///|
/// Tool result information
/// Note: AI SDK v6 uses 'input' and 'output' instead of 'args' and 'result'
pub(all) struct ToolResult {
  tool_call_id : String
  tool_name : String
  input : @js.Any
  output : @js.Any
}

///|
pub fn ToolResult::from_any(value : @js.Any) -> ToolResult {
  {
    tool_call_id: value.get("toolCallId").cast(),
    tool_name: value.get("toolName").cast(),
    input: value.get("input"),
    output: value.get("output"),
  }
}

///|
/// Tool error information
pub(all) struct ToolError {
  tool_call_id : String
  tool_name : String
  args : @js.Any
  error : @js.Any
}

///|
pub fn ToolError::from_any(value : @js.Any) -> ToolError {
  {
    tool_call_id: value.get("toolCallId").cast(),
    tool_name: value.get("toolName").cast(),
    args: value.get("args"),
    error: value.get("error"),
  }
}

///|
/// Tool output denied information
/// Represents when tool output is denied (e.g., by human-in-the-loop validation)
pub(all) struct ToolOutputDenied {
  tool_call_id : String
  tool_name : String
  input : @js.Any
}

///|
pub fn ToolOutputDenied::from_any(value : @js.Any) -> ToolOutputDenied {
  {
    tool_call_id: value.get("toolCallId").cast(),
    tool_name: value.get("toolName").cast(),
    input: value.get("input"),
  }
}

///|
/// Tool approval request information
/// Represents a request for human approval before executing a tool
pub(all) struct ToolApprovalRequest {
  tool_call_id : String
  tool_name : String
  input : @js.Any
}

///|
pub fn ToolApprovalRequest::from_any(value : @js.Any) -> ToolApprovalRequest {
  {
    tool_call_id: value.get("toolCallId").cast(),
    tool_name: value.get("toolName").cast(),
    input: value.get("input"),
  }
}

///|
/// Tool definition for AI SDK
pub(all) struct Tool {
  /// Tool description for the model
  description : String
  /// JSON Schema for input parameters (raw JSON schema object)
  input_schema : @js.Any
  /// Execute function (receives parsed args, returns result)
  execute : (@js.Any) -> @js.Any
}

///|
/// Create a typed tool with input/output type conversion.
/// Input type must be convertible from @js.Any (via @js.identity cast).
/// Output type must implement ToJson for serialization.
pub fn[Input, Output : ToJson] Tool::typed(
  description~ : String,
  input_schema~ : Json,
  execute : (Input) -> Output,
) -> Tool {
  {
    description,
    input_schema: @js.from_json(input_schema),
    execute: fn(args) {
      let typed_input : Input = @js.identity(args)
      let result = execute(typed_input)
      @js.from_json(result.to_json())
    },
  }
}

///|
/// Create an async typed tool with input/output type conversion.
/// Input type must be convertible from @js.Any (via @js.identity cast).
/// Output type must implement ToJson for serialization.
/// The execute function can be async for API calls, database access, etc.
pub fn[Input, Output : ToJson] Tool::typed_async(
  description~ : String,
  input_schema~ : Json,
  execute : async (Input) -> Output,
) -> Tool {
  // Wrap async function with promisify1 to return a Promise
  let promisified = @js.promisify1(async fn(args : @js.Any) -> @js.Any {
    let typed_input : Input = @js.identity(args)
    let result = execute(typed_input)
    @js.from_json(result.to_json())
  })
  {
    description,
    input_schema: @js.from_json(input_schema),
    execute: fn(args) { promisified(args) |> @js.identity },
  }
}

///|
/// Convert Tool to JS object format expected by AI SDK
/// Note: AI SDK v6 requires inputSchema to be wrapped with jsonSchema()
pub fn Tool::to_any(self : Tool) -> @js.Any {
  let ai_module = @node.require("ai")
  let json_schema_fn = ai_module.get("jsonSchema")
  let obj = @js.Object::new()
  obj.set("description", self.description)
  // Wrap with jsonSchema() helper from AI SDK
  let wrapped_schema = json_schema_fn.call_self([self.input_schema])
  obj.set("inputSchema", wrapped_schema)
  // Wrap execute function
  let execute_fn : @js.Any = @js.identity(fn(args : @js.Any) -> @js.Any {
    (self.execute)(args)
  })
  obj.set("execute", execute_fn)
  obj.to_any()
}

///|
/// Tool collection - maps tool names to tool definitions
pub(all) struct Tools {
  tools : Map[String, Tool]
}

///|
/// Create empty tools collection
pub fn Tools::new() -> Tools {
  { tools: {} }
}

///|
/// Add a tool to the collection
pub fn Tools::add(self : Tools, name : String, tool : Tool) -> Tools {
  self.tools[name] = tool
  self
}

///|
/// Convert Tools to JS object format
pub fn Tools::to_any(self : Tools) -> @js.Any {
  let obj = @js.Object::new()
  for name, tool in self.tools {
    obj.set(name, tool.to_any())
  }
  obj.to_any()
}

///|
/// Tool choice options
pub(all) enum ToolChoice {
  /// Model decides whether to use tools
  Auto
  /// Model must use at least one tool
  Required
  /// Model cannot use tools
  None_
  /// Force specific tool
  Tool(String)
}

///|
pub fn ToolChoice::to_any(self : ToolChoice) -> @js.Any {
  match self {
    Auto => "auto" |> @js.any
    Required => "required" |> @js.any
    None_ => "none" |> @js.any
    Tool(name) => {
      let obj = @js.Object::new()
      obj.set("type", "tool")
      obj.set("toolName", name)
      obj.to_any()
    }
  }
}

///|
/// Language model request metadata
pub(all) struct LanguageModelRequestMetadata {
  raw : @js.Any
}

///|
pub fn LanguageModelRequestMetadata::from_any(
  value : @js.Any,
) -> LanguageModelRequestMetadata {
  { raw: value }
}

///|
/// Language model response metadata
pub(all) struct LanguageModelResponseMetadata {
  id : String?
  model_id : String?
  timestamp : @js.Any?
  raw : @js.Any
}

///|
pub fn LanguageModelResponseMetadata::from_any(
  value : @js.Any,
) -> LanguageModelResponseMetadata {
  {
    id: {
      let i = value.get("id")
      if @js.is_undefined(i) {
        None
      } else {
        Some(i.cast())
      }
    },
    model_id: {
      let m = value.get("modelId")
      if @js.is_undefined(m) {
        None
      } else {
        Some(m.cast())
      }
    },
    timestamp: {
      let t = value.get("timestamp")
      if @js.is_undefined(t) {
        None
      } else {
        Some(t)
      }
    },
    raw: value,
  }
}

///|
/// TextStreamPart - Union type for all stream parts
pub(all) enum TextStreamPart {
  // Text parts
  TextStart(id~ : String, provider_metadata~ : ProviderMetadata?)
  TextEnd(id~ : String, provider_metadata~ : ProviderMetadata?)
  TextDelta(
    id~ : String,
    text~ : String,
    provider_metadata~ : ProviderMetadata?
  )
  // Reasoning parts
  ReasoningStart(id~ : String, provider_metadata~ : ProviderMetadata?)
  ReasoningEnd(id~ : String, provider_metadata~ : ProviderMetadata?)
  ReasoningDelta(
    id~ : String,
    text~ : String,
    provider_metadata~ : ProviderMetadata?
  )
  // Tool input parts
  ToolInputStart(
    id~ : String,
    tool_name~ : String,
    provider_metadata~ : ProviderMetadata?,
    provider_executed~ : Bool?,
    dynamic~ : Bool?,
    title~ : String?
  )
  ToolInputEnd(id~ : String, provider_metadata~ : ProviderMetadata?)
  ToolInputDelta(
    id~ : String,
    delta~ : String,
    provider_metadata~ : ProviderMetadata?
  )
  // Source
  SourcePart(source~ : Source)
  // File
  FilePart(file~ : GeneratedFile)
  // Tool parts
  ToolCallPart(tool_call~ : ToolCall)
  ToolResultPart(tool_result~ : ToolResult)
  ToolErrorPart(tool_error~ : ToolError)
  ToolOutputDeniedPart(tool_output_denied~ : ToolOutputDenied)
  ToolApprovalRequestPart(tool_approval_request~ : ToolApprovalRequest)
  // Step parts
  StartStep(
    request~ : LanguageModelRequestMetadata,
    warnings~ : Array[CallWarning]
  )
  FinishStep(
    response~ : LanguageModelResponseMetadata,
    usage~ : LanguageModelUsage,
    finish_reason~ : FinishReason,
    provider_metadata~ : ProviderMetadata?
  )
  // Stream lifecycle
  Start
  Finish(finish_reason~ : FinishReason, total_usage~ : LanguageModelUsage)
  Abort
  // Error and raw
  Error(error~ : @js.Any)
  Raw(raw_value~ : @js.Any)
  // Unknown
  Unknown(type_~ : String, raw~ : @js.Any)
}

///|
/// Parse TextStreamPart from raw JavaScript object
pub fn TextStreamPart::from_any(value : @js.Any) -> TextStreamPart {
  let type_str : String = value.get("type").cast()
  match type_str {
    "text-start" =>
      TextStart(
        id=value.get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "text-end" =>
      TextEnd(
        id=value.get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "text-delta" =>
      TextDelta(
        id=value.get("id").cast(),
        text=value.get("text").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "reasoning-start" =>
      ReasoningStart(
        id=value.get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "reasoning-end" =>
      ReasoningEnd(
        id=value.get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "reasoning-delta" =>
      ReasoningDelta(
        id=value.get("id").cast(),
        text=value.get("text").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "tool-input-start" =>
      ToolInputStart(
        id=value.get("id").cast(),
        tool_name=value.get("toolName").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
        provider_executed={
          let p = value.get("providerExecuted")
          if @js.is_undefined(p) {
            None
          } else {
            Some(p.cast())
          }
        },
        dynamic={
          let d = value.get("dynamic")
          if @js.is_undefined(d) {
            None
          } else {
            Some(d.cast())
          }
        },
        title={
          let t = value.get("title")
          if @js.is_undefined(t) {
            None
          } else {
            Some(t.cast())
          }
        },
      )
    "tool-input-end" =>
      ToolInputEnd(
        id=value.get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "tool-input-delta" =>
      ToolInputDelta(
        id=value.get("id").cast(),
        delta=value.get("delta").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "source" => SourcePart(source=Source::from_any(value))
    "file" => FilePart(file=GeneratedFile::from_any(value.get("file")))
    "tool-call" => ToolCallPart(tool_call=ToolCall::from_any(value))
    "tool-result" => ToolResultPart(tool_result=ToolResult::from_any(value))
    "tool-error" => ToolErrorPart(tool_error=ToolError::from_any(value))
    "tool-output-denied" =>
      ToolOutputDeniedPart(tool_output_denied=ToolOutputDenied::from_any(value))
    "tool-approval-request" =>
      ToolApprovalRequestPart(
        tool_approval_request=ToolApprovalRequest::from_any(value),
      )
    "start-step" => {
      let warnings_raw = value.get("warnings")
      let warnings : Array[CallWarning] = if @js.is_undefined(warnings_raw) {
        []
      } else {
        let arr : Array[@js.Any] = @js.identity(warnings_raw)
        arr.map(CallWarning::from_any)
      }
      StartStep(
        request=LanguageModelRequestMetadata::from_any(value.get("request")),
        warnings~,
      )
    }
    "finish-step" =>
      FinishStep(
        response=LanguageModelResponseMetadata::from_any(value.get("response")),
        usage=LanguageModelUsage::from_any(value.get("usage")),
        finish_reason=FinishReason::from_string(
          value.get("finishReason").cast(),
        ),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "start" => Start
    "finish" =>
      Finish(
        finish_reason=FinishReason::from_string(
          value.get("finishReason").cast(),
        ),
        total_usage=LanguageModelUsage::from_any(value.get("totalUsage")),
      )
    "abort" => Abort
    "error" => Error(error=value.get("error"))
    "raw" => Raw(raw_value=value.get("rawValue"))
    _ => Unknown(type_=type_str, raw=value)
  }
}

///|
/// Get the type string of a TextStreamPart
pub fn TextStreamPart::type_string(self : TextStreamPart) -> String {
  match self {
    TextStart(..) => "text-start"
    TextEnd(..) => "text-end"
    TextDelta(..) => "text-delta"
    ReasoningStart(..) => "reasoning-start"
    ReasoningEnd(..) => "reasoning-end"
    ReasoningDelta(..) => "reasoning-delta"
    ToolInputStart(..) => "tool-input-start"
    ToolInputEnd(..) => "tool-input-end"
    ToolInputDelta(..) => "tool-input-delta"
    SourcePart(..) => "source"
    FilePart(..) => "file"
    ToolCallPart(..) => "tool-call"
    ToolResultPart(..) => "tool-result"
    ToolErrorPart(..) => "tool-error"
    ToolOutputDeniedPart(..) => "tool-output-denied"
    ToolApprovalRequestPart(..) => "tool-approval-request"
    StartStep(..) => "start-step"
    FinishStep(..) => "finish-step"
    Start => "start"
    Finish(..) => "finish"
    Abort => "abort"
    Error(..) => "error"
    Raw(..) => "raw"
    Unknown(type_=t, ..) => t
  }
}

///|
/// Check if the stream part is a text-related part
pub fn TextStreamPart::is_text_part(self : TextStreamPart) -> Bool {
  match self {
    TextStart(..) | TextEnd(..) | TextDelta(..) => true
    _ => false
  }
}

///|
/// Check if the stream part is a reasoning-related part
pub fn TextStreamPart::is_reasoning_part(self : TextStreamPart) -> Bool {
  match self {
    ReasoningStart(..) | ReasoningEnd(..) | ReasoningDelta(..) => true
    _ => false
  }
}

///|
/// Check if the stream part is a tool-related part
pub fn TextStreamPart::is_tool_part(self : TextStreamPart) -> Bool {
  match self {
    ToolInputStart(..)
    | ToolInputEnd(..)
    | ToolInputDelta(..)
    | ToolCallPart(..)
    | ToolResultPart(..)
    | ToolErrorPart(..)
    | ToolOutputDeniedPart(..)
    | ToolApprovalRequestPart(..) => true
    _ => false
  }
}

///|
/// Extract text content if this is a TextDelta
pub fn TextStreamPart::get_text(self : TextStreamPart) -> String? {
  match self {
    TextDelta(text~, ..) => Some(text)
    _ => None
  }
}

///|
/// Extract reasoning text content if this is a ReasoningDelta
pub fn TextStreamPart::get_reasoning_text(self : TextStreamPart) -> String? {
  match self {
    ReasoningDelta(text~, ..) => Some(text)
    _ => None
  }
}

///|
/// Reasoning output from model
pub(all) struct ReasoningOutput {
  text : String
  provider_metadata : ProviderMetadata?
}

///|
pub fn ReasoningOutput::from_any(value : @js.Any) -> ReasoningOutput {
  {
    text: value.get("text").cast(),
    provider_metadata: ProviderMetadata::from_any(value.get("providerMetadata")),
  }
}

///|
/// Content part types for model output
pub(all) enum ContentPart {
  TextPart(text~ : String, provider_metadata~ : ProviderMetadata?)
  ReasoningPart(reasoning~ : ReasoningOutput)
  SourceContentPart(source~ : Source)
  FilePart(file~ : GeneratedFile, provider_metadata~ : ProviderMetadata?)
  ToolCallContentPart(
    tool_call~ : ToolCall,
    provider_metadata~ : ProviderMetadata?
  )
  ToolResultContentPart(
    tool_result~ : ToolResult,
    provider_metadata~ : ProviderMetadata?
  )
  ToolErrorContentPart(
    tool_error~ : ToolError,
    provider_metadata~ : ProviderMetadata?
  )
}

///|
pub fn ContentPart::from_any(value : @js.Any) -> ContentPart {
  let type_str : String = value.get("type").cast()
  match type_str {
    "text" =>
      TextPart(
        text=value.get("text").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "reasoning" => ReasoningPart(reasoning=ReasoningOutput::from_any(value))
    "source" => SourceContentPart(source=Source::from_any(value))
    "file" =>
      FilePart(
        file=GeneratedFile::from_any(value.get("file")),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "tool-call" =>
      ToolCallContentPart(
        tool_call=ToolCall::from_any(value),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "tool-result" =>
      ToolResultContentPart(
        tool_result=ToolResult::from_any(value),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    "tool-error" =>
      ToolErrorContentPart(
        tool_error=ToolError::from_any(value),
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
    _ =>
      TextPart(
        text="",
        provider_metadata=ProviderMetadata::from_any(
          value.get("providerMetadata"),
        ),
      )
  }
}

///|
/// Result from generateText call
pub(all) struct GenerateTextResult {
  /// The content that was generated
  content : Array[ContentPart]
  /// The text that was generated
  text : String
  /// The full reasoning from the model
  reasoning : Array[ReasoningOutput]
  /// The reasoning text (convenience accessor)
  reasoning_text : String?
  /// Generated files
  files : Array[GeneratedFile]
  /// Sources used as references
  sources : Array[Source]
  /// Tool calls made
  tool_calls : Array[ToolCall]
  /// Tool results
  tool_results : Array[ToolResult]
  /// Why generation finished
  finish_reason : FinishReason
  /// Token usage for last step
  usage : LanguageModelUsage
  /// Total token usage across all steps
  total_usage : LanguageModelUsage
  /// Warnings from provider
  warnings : Array[CallWarning]
  /// Request metadata
  request : LanguageModelRequestMetadata
  /// Response metadata
  response : LanguageModelResponseMetadata
  /// Raw result object
  raw : @js.Any
}

///|
pub fn GenerateTextResult::from_any(value : @js.Any) -> GenerateTextResult {
  // Parse content array
  let content_raw = value.get("content")
  let content : Array[ContentPart] = if @js.is_undefined(content_raw) ||
    @js.is_null(content_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(content_raw)
    arr.map(ContentPart::from_any)
  }
  // Parse reasoning array
  let reasoning_raw = value.get("reasoning")
  let reasoning : Array[ReasoningOutput] = if @js.is_undefined(reasoning_raw) ||
    @js.is_null(reasoning_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(reasoning_raw)
    arr.map(ReasoningOutput::from_any)
  }
  // Parse files array
  let files_raw = value.get("files")
  let files : Array[GeneratedFile] = if @js.is_undefined(files_raw) ||
    @js.is_null(files_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(files_raw)
    arr.map(GeneratedFile::from_any)
  }
  // Parse sources array
  let sources_raw = value.get("sources")
  let sources : Array[Source] = if @js.is_undefined(sources_raw) ||
    @js.is_null(sources_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(sources_raw)
    arr.map(Source::from_any)
  }
  // Parse tool_calls array
  let tool_calls_raw = value.get("toolCalls")
  let tool_calls : Array[ToolCall] = if @js.is_undefined(tool_calls_raw) ||
    @js.is_null(tool_calls_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(tool_calls_raw)
    arr.map(ToolCall::from_any)
  }
  // Parse tool_results array
  let tool_results_raw = value.get("toolResults")
  let tool_results : Array[ToolResult] = if @js.is_undefined(tool_results_raw) ||
    @js.is_null(tool_results_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(tool_results_raw)
    arr.map(ToolResult::from_any)
  }
  // Parse warnings array
  let warnings_raw = value.get("warnings")
  let warnings : Array[CallWarning] = if @js.is_undefined(warnings_raw) ||
    @js.is_null(warnings_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(warnings_raw)
    arr.map(CallWarning::from_any)
  }
  // Parse reasoning_text
  let reasoning_text_raw = value.get("reasoningText")
  let reasoning_text : String? = if @js.is_undefined(reasoning_text_raw) ||
    @js.is_null(reasoning_text_raw) {
    None
  } else {
    Some(reasoning_text_raw.cast())
  }
  {
    content,
    text: value.get("text").cast(),
    reasoning,
    reasoning_text,
    files,
    sources,
    tool_calls,
    tool_results,
    finish_reason: FinishReason::from_string(value.get("finishReason").cast()),
    usage: LanguageModelUsage::from_any(value.get("usage")),
    total_usage: LanguageModelUsage::from_any(value.get("totalUsage")),
    warnings,
    request: LanguageModelRequestMetadata::from_any(value.get("request")),
    response: LanguageModelResponseMetadata::from_any(value.get("response")),
    raw: value,
  }
}

///|
/// Step result from multi-step generation
pub(all) struct StepResult {
  /// Step content
  content : Array[ContentPart]
  /// Step text
  text : String
  /// Step reasoning
  reasoning : Array[ReasoningOutput]
  /// Step finish reason
  finish_reason : FinishReason
  /// Step usage
  usage : LanguageModelUsage
  /// Step warnings
  warnings : Array[CallWarning]
  /// Step response metadata
  response : LanguageModelResponseMetadata
  /// Raw step object
  raw : @js.Any
}

///|
pub fn StepResult::from_any(value : @js.Any) -> StepResult {
  // Parse content array
  let content_raw = value.get("content")
  let content : Array[ContentPart] = if @js.is_undefined(content_raw) ||
    @js.is_null(content_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(content_raw)
    arr.map(ContentPart::from_any)
  }
  // Parse reasoning array
  let reasoning_raw = value.get("reasoning")
  let reasoning : Array[ReasoningOutput] = if @js.is_undefined(reasoning_raw) ||
    @js.is_null(reasoning_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(reasoning_raw)
    arr.map(ReasoningOutput::from_any)
  }
  // Parse warnings array
  let warnings_raw = value.get("warnings")
  let warnings : Array[CallWarning] = if @js.is_undefined(warnings_raw) ||
    @js.is_null(warnings_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(warnings_raw)
    arr.map(CallWarning::from_any)
  }
  {
    content,
    text: value.get("text").cast(),
    reasoning,
    finish_reason: FinishReason::from_string(value.get("finishReason").cast()),
    usage: LanguageModelUsage::from_any(value.get("usage")),
    warnings,
    response: LanguageModelResponseMetadata::from_any(value.get("response")),
    raw: value,
  }
}
