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
pub(all) struct LanguageModelUsage {
  prompt_tokens : Int
  completion_tokens : Int
  total_tokens : Int
}

///|
pub fn LanguageModelUsage::from_any(value : @js.Any) -> LanguageModelUsage {
  {
    prompt_tokens: value.get("promptTokens").cast(),
    completion_tokens: value.get("completionTokens").cast(),
    total_tokens: value.get("totalTokens").cast(),
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
pub(all) struct ToolCall {
  tool_call_id : String
  tool_name : String
  args : @js.Any
}

///|
pub fn ToolCall::from_any(value : @js.Any) -> ToolCall {
  {
    tool_call_id: value.get("toolCallId").cast(),
    tool_name: value.get("toolName").cast(),
    args: value.get("args"),
  }
}

///|
/// Tool result information
pub(all) struct ToolResult {
  tool_call_id : String
  tool_name : String
  args : @js.Any
  result : @js.Any
}

///|
pub fn ToolResult::from_any(value : @js.Any) -> ToolResult {
  {
    tool_call_id: value.get("toolCallId").cast(),
    tool_name: value.get("toolName").cast(),
    args: value.get("args"),
    result: value.get("result"),
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
    | ToolErrorPart(..) => true
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
