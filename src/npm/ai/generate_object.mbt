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
  object : @js.Any
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
  raw : @js.Any
}

///|
pub fn GenerateObjectResult::from_any(value : @js.Any) -> GenerateObjectResult {
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
    object: value.get("object"),
    finish_reason: FinishReason::from_string(value.get("finishReason").cast()),
    usage: LanguageModelUsage::from_any(value.get("usage")),
    warnings,
    response: LanguageModelResponseMetadata::from_any(value.get("response")),
    provider_metadata: ProviderMetadata::from_any(value.get("providerMetadata")),
    raw: value,
  }
}

///|
/// Get the generated object as typed value
pub fn[T] GenerateObjectResult::get_object(self : GenerateObjectResult) -> T {
  @js.identity(self.object)
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
  schema~ : @js.Any,
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
  abort_signal? : @js.Any,
) -> GenerateObjectResult {
  let opts = @js.Object::new()
  opts.set("model", model.as_any())
  // Wrap schema with jsonSchema() helper
  let json_schema_fn = ai_module().get("jsonSchema")
  let wrapped_schema = json_schema_fn.call_self([schema])
  opts.set("schema", wrapped_schema)
  if schema_name is Some(n) {
    opts.set("schemaName", n)
  }
  if schema_description is Some(d) {
    opts.set("schemaDescription", d)
  }
  if output is Some(o) {
    opts.set("output", o.to_string())
  }
  if enum_values is Some(vals) {
    opts.set("enum", vals |> @js.from_array)
  }
  if prompt is Some(p) {
    opts.set("prompt", p)
  }
  if system is Some(s) {
    opts.set("system", s)
  }
  if messages is Some(msgs) {
    opts.set("messages", msgs.map(_.as_any()) |> @js.from_array)
  }
  if max_tokens is Some(t) {
    opts.set("maxTokens", t)
  }
  if temperature is Some(t) {
    opts.set("temperature", t)
  }
  if max_retries is Some(r) {
    opts.set("maxRetries", r)
  }
  if abort_signal is Some(s) {
    opts.set("abortSignal", s)
  }
  let promise : @js.Promise[@js.Any] = ai_module()
    .get("generateObject")
    .call_self([opts.as_any()])
    |> @js.identity
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
  zod_schema~ : @js.Any,
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
  let opts = @js.Object::new()
  opts.set("model", model.as_any())
  opts.set("schema", zod_schema)
  if schema_name is Some(n) {
    opts.set("schemaName", n)
  }
  if schema_description is Some(d) {
    opts.set("schemaDescription", d)
  }
  if prompt is Some(p) {
    opts.set("prompt", p)
  }
  if system is Some(s) {
    opts.set("system", s)
  }
  if messages is Some(msgs) {
    opts.set("messages", msgs.map(_.as_any()) |> @js.from_array)
  }
  if max_tokens is Some(t) {
    opts.set("maxTokens", t)
  }
  if temperature is Some(t) {
    opts.set("temperature", t)
  }
  let promise : @js.Promise[@js.Any] = ai_module()
    .get("generateObject")
    .call_self([opts.as_any()])
    |> @js.identity
  let result = promise.wait()
  GenerateObjectResult::from_any(result)
}
