///| AI SDK generateObject - Structured data generation
/// Based on https://v6.ai-sdk.dev/docs/ai-sdk-core/generating-structured-data

// ============================================================
// Output Strategy
// ============================================================

///|
/// Output strategy for generateObject
pub(all) enum OutputStrategy {
  /// Generate a single object matching the schema (default)
  Object
  /// Generate an array of objects matching the schema
  Array
  /// Return one of the specified enum values
  Enum
  /// Generate without schema validation
  NoSchema
}

///|
pub fn OutputStrategy::to_string(self : OutputStrategy) -> String {
  match self {
    Object => "object"
    Array => "array"
    Enum => "enum"
    NoSchema => "no-schema"
  }
}

// ============================================================
// GenerateObject Result
// ============================================================

///|
/// Result from generateObject call
pub(all) struct GenerateObjectResult {
  /// The generated object (type depends on schema)
  object : @nostd.Any
  /// The finish reason
  finish_reason : FinishReason
  /// Token usage
  usage : LanguageModelUsage
  /// Warnings from provider
  warnings : Array[CallWarning]
  /// Response metadata
  response : LanguageModelResponseMetadata
  /// Provider metadata
  provider_metadata : ProviderMetadata?
  /// Raw result object
  raw : @nostd.Any
}

///|
pub fn GenerateObjectResult::from_any(
  value : @nostd.Any,
) -> GenerateObjectResult {
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
    object: value._get("object"),
    finish_reason: FinishReason::from_string(value._get("finishReason").cast()),
    usage: LanguageModelUsage::from_any(value._get("usage")),
    warnings,
    response: LanguageModelResponseMetadata::from_any(value._get("response")),
    provider_metadata: ProviderMetadata::from_any(
      value._get("providerMetadata"),
    ),
    raw: value,
  }
}

///|
/// Get the generated object as typed value
pub fn[T] GenerateObjectResult::get_object(self : GenerateObjectResult) -> T {
  @nostd.identity(self.object)
}

// ============================================================
// GenerateObject Function
// ============================================================

///|
/// Generate structured data from a prompt
/// The schema is used to validate and type the generated data
#alias(generate_object)
pub async fn generateObject(
  model~ : Model,
  /// JSON schema for the output object
  schema~ : @nostd.Any,
  /// Schema name (helps LLM understand expected output)
  schema_name? : String,
  /// Schema description
  schema_description? : String,
  /// Output strategy (object, array, enum, no-schema)
  output? : OutputStrategy,
  /// Enum values (required when output is Enum)
  enum_values? : Array[String],
  /// Prompt for generation
  prompt? : String,
  /// System message
  system? : String,
  /// Messages for conversation
  messages? : Array[ModelMessage],
  /// Maximum tokens
  max_tokens? : Int,
  /// Temperature for randomness
  temperature? : Double,
  /// Maximum retries
  max_retries? : Int,
  /// Abort signal
  abort_signal? : @nostd.Any,
) -> GenerateObjectResult {
  let opts = @nostd.Object::new()
  opts._set("model", model.as_any())
  // Wrap schema with jsonSchema() helper
  let json_schema_fn = ai_module()._get("jsonSchema")
  let wrapped_schema = json_schema_fn._invoke([schema])
  opts._set("schema", wrapped_schema)
  if schema_name is Some(n) {
    opts._set("schemaName", n |> @nostd.any)
  }
  if schema_description is Some(d) {
    opts._set("schemaDescription", d |> @nostd.any)
  }
  if output is Some(o) {
    opts._set("output", o.to_string() |> @nostd.any)
  }
  if enum_values is Some(vals) {
    opts._set("enum", vals |> @nostd.any)
  }
  if prompt is Some(p) {
    opts._set("prompt", p |> @nostd.any)
  }
  if system is Some(s) {
    opts._set("system", s |> @nostd.any)
  }
  if messages is Some(msgs) {
    opts._set("messages", msgs.map(_.as_any()) |> @nostd.any)
  }
  if max_tokens is Some(t) {
    opts._set("maxTokens", t |> @nostd.any)
  }
  if temperature is Some(t) {
    opts._set("temperature", t |> @nostd.any)
  }
  if max_retries is Some(r) {
    opts._set("maxRetries", r |> @nostd.any)
  }
  if abort_signal is Some(s) {
    opts._set("abortSignal", s)
  }
  let promise : @js.Promise[@nostd.Any] = ai_module()
    ._get("generateObject")
    ._invoke([opts])
    |> @nostd.identity
  let result = promise.wait()
  GenerateObjectResult::from_any(result)
}

///|
/// Generate structured data with a Zod schema
/// This version accepts a zod schema object directly
#alias(generate_object_with_zod)
pub async fn generateObjectWithZod(
  model~ : Model,
  /// Zod schema object (from @zod)
  zod_schema~ : @nostd.Any,
  /// Schema name (helps LLM understand expected output)
  schema_name? : String,
  /// Schema description
  schema_description? : String,
  /// Prompt for generation
  prompt? : String,
  /// System message
  system? : String,
  /// Messages for conversation
  messages? : Array[ModelMessage],
  /// Maximum tokens
  max_tokens? : Int,
  /// Temperature for randomness
  temperature? : Double,
) -> GenerateObjectResult {
  let opts = @nostd.Object::new()
  opts._set("model", model.as_any())
  opts._set("schema", zod_schema)
  if schema_name is Some(n) {
    opts._set("schemaName", n |> @nostd.any)
  }
  if schema_description is Some(d) {
    opts._set("schemaDescription", d |> @nostd.any)
  }
  if prompt is Some(p) {
    opts._set("prompt", p |> @nostd.any)
  }
  if system is Some(s) {
    opts._set("system", s |> @nostd.any)
  }
  if messages is Some(msgs) {
    opts._set("messages", msgs.map(_.as_any()) |> @nostd.any)
  }
  if max_tokens is Some(t) {
    opts._set("maxTokens", t |> @nostd.any)
  }
  if temperature is Some(t) {
    opts._set("temperature", t |> @nostd.any)
  }
  let promise : @js.Promise[@nostd.Any] = ai_module()
    ._get("generateObject")
    ._invoke([opts])
    |> @nostd.identity
  let result = promise.wait()
  GenerateObjectResult::from_any(result)
}
