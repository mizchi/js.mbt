///| AI SDK Type definitions
/// Based on TextStreamPart and related types from @ai-sdk/provider

///|
/// Provider metadata - additional provider-specific information
pub(all) struct ProviderMetadata {
  raw : @nostd.Any
}

///|
pub fn ProviderMetadata::from_any(value : @nostd.Any) -> ProviderMetadata? {
  if @nostd.is_undefined(value) || @nostd.is_null(value) {
    None
  } else {
    Some({ raw: value })
  }
}

///|
pub fn ProviderMetadata::as_any(self : ProviderMetadata) -> @nostd.Any {
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
pub fn LanguageModelUsage::from_any(value : @nostd.Any) -> LanguageModelUsage {
  let cached = value._get("cachedInputTokens")
  {
    input_tokens: value._get("inputTokens").cast(),
    output_tokens: value._get("outputTokens").cast(),
    total_tokens: value._get("totalTokens").cast(),
    cached_input_tokens: if @nostd.is_undefined(cached) {
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
  raw : @nostd.Any
}

///|
pub fn CallWarning::from_any(value : @nostd.Any) -> CallWarning {
  {
    type_: value._get("type").cast(),
    message: {
      let m = value._get("message")
      if @nostd.is_undefined(m) {
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
pub fn Source::from_any(value : @nostd.Any) -> Source {
  let source_type = value._get("sourceType")
  if @nostd.is_undefined(source_type) || source_type.cast() == "url" {
    UrlSource({
      id: value._get("id").cast(),
      url: value._get("url").cast(),
      title: {
        let t = value._get("title")
        if @nostd.is_undefined(t) {
          None
        } else {
          Some(t.cast())
        }
      },
      provider_metadata: ProviderMetadata::from_any(
        value._get("providerMetadata"),
      ),
    })
  } else {
    DocumentSource({
      id: value._get("id").cast(),
      title: {
        let t = value._get("title")
        if @nostd.is_undefined(t) {
          None
        } else {
          Some(t.cast())
        }
      },
      provider_metadata: ProviderMetadata::from_any(
        value._get("providerMetadata"),
      ),
    })
  }
}

///|
/// Generated file from model
pub(all) struct GeneratedFile {
  name : String?
  media_type : String?
  data : @nostd.Any
  raw : @nostd.Any
}

///|
pub fn GeneratedFile::from_any(value : @nostd.Any) -> GeneratedFile {
  {
    name: {
      let n = value._get("name")
      if @nostd.is_undefined(n) {
        None
      } else {
        Some(n.cast())
      }
    },
    media_type: {
      let m = value._get("mediaType")
      if @nostd.is_undefined(m) {
        None
      } else {
        Some(m.cast())
      }
    },
    data: value._get("data"),
    raw: value,
  }
}

///|
/// Tool call information
/// Note: AI SDK v6 uses 'input' instead of 'args'
pub(all) struct ToolCall {
  tool_call_id : String
  tool_name : String
  input : @nostd.Any
}

///|
pub fn ToolCall::from_any(value : @nostd.Any) -> ToolCall {
  {
    tool_call_id: value._get("toolCallId").cast(),
    tool_name: value._get("toolName").cast(),
    input: value._get("input"),
  }
}

///|
/// Tool result information
/// Note: AI SDK v6 uses 'input' and 'output' instead of 'args' and 'result'
pub(all) struct ToolResult {
  tool_call_id : String
  tool_name : String
  input : @nostd.Any
  output : @nostd.Any
}

///|
pub fn ToolResult::from_any(value : @nostd.Any) -> ToolResult {
  {
    tool_call_id: value._get("toolCallId").cast(),
    tool_name: value._get("toolName").cast(),
    input: value._get("input"),
    output: value._get("output"),
  }
}

///|
/// Tool error information
pub(all) struct ToolError {
  tool_call_id : String
  tool_name : String
  args : @nostd.Any
  error : @nostd.Any
}

///|
pub fn ToolError::from_any(value : @nostd.Any) -> ToolError {
  {
    tool_call_id: value._get("toolCallId").cast(),
    tool_name: value._get("toolName").cast(),
    args: value._get("args"),
    error: value._get("error"),
  }
}

///|
/// Tool output denied information
/// Represents when tool output is denied (e.g., by human-in-the-loop validation)
pub(all) struct ToolOutputDenied {
  tool_call_id : String
  tool_name : String
  input : @nostd.Any
}

///|
pub fn ToolOutputDenied::from_any(value : @nostd.Any) -> ToolOutputDenied {
  {
    tool_call_id: value._get("toolCallId").cast(),
    tool_name: value._get("toolName").cast(),
    input: value._get("input"),
  }
}

///|
/// Tool approval request information
/// Represents a request for human approval before executing a tool
pub(all) struct ToolApprovalRequest {
  tool_call_id : String
  tool_name : String
  input : @nostd.Any
}

///|
pub fn ToolApprovalRequest::from_any(value : @nostd.Any) -> ToolApprovalRequest {
  {
    tool_call_id: value._get("toolCallId").cast(),
    tool_name: value._get("toolName").cast(),
    input: value._get("input"),
  }
}

///|
/// Tool definition for AI SDK
pub(all) struct Tool {
  /// Tool description for the model
  description : String
  /// JSON Schema for input parameters (raw JSON schema object)
  input_schema : @nostd.Any
  /// Execute function (receives parsed args, returns result)
  execute : (@nostd.Any) -> @nostd.Any
}

///|
/// Create a typed tool with input/output type conversion.
/// Input type must be convertible from @nostd.Any (via @nostd.identity cast).
/// Output type must implement ToJson for serialization.
pub fn[Input, Output : ToJson] Tool::typed(
  description~ : String,
  input_schema~ : Json,
  execute : (Input) -> Output,
) -> Tool {
  {
    description,
    input_schema: @mbtconv.from_json(input_schema).cast(),
    execute: fn(args) {
      let typed_input : Input = @nostd.identity(args)
      let result = execute(typed_input)
      @mbtconv.from_json(result.to_json()).cast()
    },
  }
}

///|
/// Create an async typed tool with input/output type conversion.
/// Input type must be convertible from @nostd.Any (via @nostd.identity cast).
/// Output type must implement ToJson for serialization.
/// The execute function can be async for API calls, database access, etc.
pub fn[Input, Output : ToJson] Tool::typed_async(
  description~ : String,
  input_schema~ : Json,
  execute : async (Input) -> Output,
) -> Tool {
  // Wrap async function with promisify1 to return a Promise
  let promisified = @js.promisify1(async fn(args : @nostd.Any) -> @nostd.Any {
    let typed_input : Input = @nostd.identity(args)
    let result = execute(typed_input)
    @mbtconv.from_json(result.to_json()).cast()
  })
  {
    description,
    input_schema: @mbtconv.from_json(input_schema).cast(),
    execute: fn(args) { promisified(args) |> @nostd.identity },
  }
}

///|
/// Convert Tool to JS object format expected by AI SDK
/// Note: AI SDK v6 requires inputSchema to be wrapped with jsonSchema()
pub fn Tool::as_any(self : Tool) -> @nostd.Any {
  let ai_module = @node.require("ai")
  let json_schema_fn = ai_module._get("jsonSchema")
  let obj = @nostd.Object::new()
  obj._set("description", self.description |> @nostd.any)
  // Wrap with jsonSchema() helper from AI SDK
  let wrapped_schema = json_schema_fn.call_self([self.input_schema])
  obj._set("inputSchema", wrapped_schema)
  // Wrap execute function
  let execute_fn : @nostd.Any = @js.from_fn1(fn(
    args : @nostd.Any,
  ) -> @nostd.Any {
    (self.execute)(args)
  })
  obj._set("execute", execute_fn)
  obj
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
pub fn Tools::as_any(self : Tools) -> @nostd.Any {
  let obj = @nostd.Object::new()
  for name, tool in self.tools {
    obj._set(name, tool.as_any())
  }
  obj
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
pub fn ToolChoice::as_any(self : ToolChoice) -> @nostd.Any {
  match self {
    Auto => "auto" |> @js.any
    Required => "required" |> @js.any
    None_ => "none" |> @js.any
    Tool(name) => {
      let obj = @nostd.Object::new()
      obj._set("type", "tool" |> @nostd.any)
      obj._set("toolName", name |> @nostd.any)
      obj
    }
  }
}

///|
/// Language model request metadata
pub(all) struct LanguageModelRequestMetadata {
  raw : @nostd.Any
}

///|
pub fn LanguageModelRequestMetadata::from_any(
  value : @nostd.Any,
) -> LanguageModelRequestMetadata {
  { raw: value }
}

///|
/// Language model response metadata
pub(all) struct LanguageModelResponseMetadata {
  id : String?
  model_id : String?
  timestamp : @nostd.Any?
  raw : @nostd.Any
}

///|
pub fn LanguageModelResponseMetadata::from_any(
  value : @nostd.Any,
) -> LanguageModelResponseMetadata {
  {
    id: {
      let i = value._get("id")
      if @nostd.is_undefined(i) {
        None
      } else {
        Some(i.cast())
      }
    },
    model_id: {
      let m = value._get("modelId")
      if @nostd.is_undefined(m) {
        None
      } else {
        Some(m.cast())
      }
    },
    timestamp: {
      let t = value._get("timestamp")
      if @nostd.is_undefined(t) {
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
  Error(error~ : @nostd.Any)
  Raw(raw_value~ : @nostd.Any)
  // Unknown
  Unknown(type_~ : String, raw~ : @nostd.Any)
}

///|
/// Parse TextStreamPart from raw JavaScript object
pub fn TextStreamPart::from_any(value : @nostd.Any) -> TextStreamPart {
  let type_str : String = value._get("type").cast()
  match type_str {
    "text-start" =>
      TextStart(
        id=value._get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "text-end" =>
      TextEnd(
        id=value._get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "text-delta" =>
      TextDelta(
        id=value._get("id").cast(),
        text=value._get("text").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "reasoning-start" =>
      ReasoningStart(
        id=value._get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "reasoning-end" =>
      ReasoningEnd(
        id=value._get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "reasoning-delta" =>
      ReasoningDelta(
        id=value._get("id").cast(),
        text=value._get("text").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "tool-input-start" =>
      ToolInputStart(
        id=value._get("id").cast(),
        tool_name=value._get("toolName").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
        provider_executed={
          let p = value._get("providerExecuted")
          if @nostd.is_undefined(p) {
            None
          } else {
            Some(p.cast())
          }
        },
        dynamic={
          let d = value._get("dynamic")
          if @nostd.is_undefined(d) {
            None
          } else {
            Some(d.cast())
          }
        },
        title={
          let t = value._get("title")
          if @nostd.is_undefined(t) {
            None
          } else {
            Some(t.cast())
          }
        },
      )
    "tool-input-end" =>
      ToolInputEnd(
        id=value._get("id").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "tool-input-delta" =>
      ToolInputDelta(
        id=value._get("id").cast(),
        delta=value._get("delta").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "source" => SourcePart(source=Source::from_any(value))
    "file" => FilePart(file=GeneratedFile::from_any(value._get("file")))
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
      let warnings_raw = value._get("warnings")
      let warnings : Array[CallWarning] = if @nostd.is_undefined(warnings_raw) {
        []
      } else {
        let arr : Array[@nostd.Any] = @nostd.identity(warnings_raw)
        arr.map(CallWarning::from_any)
      }
      StartStep(
        request=LanguageModelRequestMetadata::from_any(value._get("request")),
        warnings~,
      )
    }
    "finish-step" =>
      FinishStep(
        response=LanguageModelResponseMetadata::from_any(value._get("response")),
        usage=LanguageModelUsage::from_any(value._get("usage")),
        finish_reason=FinishReason::from_string(
          value._get("finishReason").cast(),
        ),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "start" => Start
    "finish" =>
      Finish(
        finish_reason=FinishReason::from_string(
          value._get("finishReason").cast(),
        ),
        total_usage=LanguageModelUsage::from_any(value._get("totalUsage")),
      )
    "abort" => Abort
    "error" => Error(error=value._get("error"))
    "raw" => Raw(raw_value=value._get("rawValue"))
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
pub fn ReasoningOutput::from_any(value : @nostd.Any) -> ReasoningOutput {
  {
    text: value._get("text").cast(),
    provider_metadata: ProviderMetadata::from_any(
      value._get("providerMetadata"),
    ),
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
pub fn ContentPart::from_any(value : @nostd.Any) -> ContentPart {
  let type_str : String = value._get("type").cast()
  match type_str {
    "text" =>
      TextPart(
        text=value._get("text").cast(),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "reasoning" => ReasoningPart(reasoning=ReasoningOutput::from_any(value))
    "source" => SourceContentPart(source=Source::from_any(value))
    "file" =>
      FilePart(
        file=GeneratedFile::from_any(value._get("file")),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "tool-call" =>
      ToolCallContentPart(
        tool_call=ToolCall::from_any(value),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "tool-result" =>
      ToolResultContentPart(
        tool_result=ToolResult::from_any(value),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    "tool-error" =>
      ToolErrorContentPart(
        tool_error=ToolError::from_any(value),
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
        ),
      )
    _ =>
      TextPart(
        text="",
        provider_metadata=ProviderMetadata::from_any(
          value._get("providerMetadata"),
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
  raw : @nostd.Any
}

///|
pub fn GenerateTextResult::from_any(value : @nostd.Any) -> GenerateTextResult {
  // Parse content array
  let content_raw = value._get("content")
  let content : Array[ContentPart] = if @nostd.is_undefined(content_raw) ||
    @nostd.is_null(content_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(content_raw)
    arr.map(ContentPart::from_any)
  }
  // Parse reasoning array
  let reasoning_raw = value._get("reasoning")
  let reasoning : Array[ReasoningOutput] = if @nostd.is_undefined(reasoning_raw) ||
    @nostd.is_null(reasoning_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(reasoning_raw)
    arr.map(ReasoningOutput::from_any)
  }
  // Parse files array
  let files_raw = value._get("files")
  let files : Array[GeneratedFile] = if @nostd.is_undefined(files_raw) ||
    @nostd.is_null(files_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(files_raw)
    arr.map(GeneratedFile::from_any)
  }
  // Parse sources array
  let sources_raw = value._get("sources")
  let sources : Array[Source] = if @nostd.is_undefined(sources_raw) ||
    @nostd.is_null(sources_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(sources_raw)
    arr.map(Source::from_any)
  }
  // Parse tool_calls array
  let tool_calls_raw = value._get("toolCalls")
  let tool_calls : Array[ToolCall] = if @nostd.is_undefined(tool_calls_raw) ||
    @nostd.is_null(tool_calls_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(tool_calls_raw)
    arr.map(ToolCall::from_any)
  }
  // Parse tool_results array
  let tool_results_raw = value._get("toolResults")
  let tool_results : Array[ToolResult] = if @nostd.is_undefined(
      tool_results_raw,
    ) ||
    @nostd.is_null(tool_results_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(tool_results_raw)
    arr.map(ToolResult::from_any)
  }
  // Parse warnings array
  let warnings_raw = value._get("warnings")
  let warnings : Array[CallWarning] = if @nostd.is_undefined(warnings_raw) ||
    @nostd.is_null(warnings_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(warnings_raw)
    arr.map(CallWarning::from_any)
  }
  // Parse reasoning_text
  let reasoning_text_raw = value._get("reasoningText")
  let reasoning_text : String? = if @nostd.is_undefined(reasoning_text_raw) ||
    @nostd.is_null(reasoning_text_raw) {
    None
  } else {
    Some(reasoning_text_raw.cast())
  }
  {
    content,
    text: value._get("text").cast(),
    reasoning,
    reasoning_text,
    files,
    sources,
    tool_calls,
    tool_results,
    finish_reason: FinishReason::from_string(value._get("finishReason").cast()),
    usage: LanguageModelUsage::from_any(value._get("usage")),
    total_usage: LanguageModelUsage::from_any(value._get("totalUsage")),
    warnings,
    request: LanguageModelRequestMetadata::from_any(value._get("request")),
    response: LanguageModelResponseMetadata::from_any(value._get("response")),
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
  raw : @nostd.Any
}

///|
pub fn StepResult::from_any(value : @nostd.Any) -> StepResult {
  // Parse content array
  let content_raw = value._get("content")
  let content : Array[ContentPart] = if @nostd.is_undefined(content_raw) ||
    @nostd.is_null(content_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(content_raw)
    arr.map(ContentPart::from_any)
  }
  // Parse reasoning array
  let reasoning_raw = value._get("reasoning")
  let reasoning : Array[ReasoningOutput] = if @nostd.is_undefined(reasoning_raw) ||
    @nostd.is_null(reasoning_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(reasoning_raw)
    arr.map(ReasoningOutput::from_any)
  }
  // Parse warnings array
  let warnings_raw = value._get("warnings")
  let warnings : Array[CallWarning] = if @nostd.is_undefined(warnings_raw) ||
    @nostd.is_null(warnings_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @nostd.identity(warnings_raw)
    arr.map(CallWarning::from_any)
  }
  {
    content,
    text: value._get("text").cast(),
    reasoning,
    finish_reason: FinishReason::from_string(value._get("finishReason").cast()),
    usage: LanguageModelUsage::from_any(value._get("usage")),
    warnings,
    response: LanguageModelResponseMetadata::from_any(value._get("response")),
    raw: value,
  }
}
