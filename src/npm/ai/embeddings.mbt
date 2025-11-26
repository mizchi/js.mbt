///| AI SDK Embeddings - Vector embeddings for text
/// Based on https://v6.ai-sdk.dev/docs/ai-sdk-core/embeddings

// ============================================================
// Embedding Model
// ============================================================

///|
/// Embedding model handle
#external
pub type EmbeddingModel

///|
pub impl @js.JsImpl for EmbeddingModel

// ============================================================
// Embedding Usage
// ============================================================

///|
/// Token usage for embedding operations
pub(all) struct EmbeddingUsage {
  tokens : Int
}

///|
pub fn EmbeddingUsage::from_any(value : @js.Any) -> EmbeddingUsage {
  { tokens: value.get("tokens").cast() }
}

// ============================================================
// Embed Result
// ============================================================

///|
/// Result from embed() call
pub(all) struct EmbedResult {
  /// The embedding vector
  embedding : Array[Double]
  /// Token usage
  usage : EmbeddingUsage
  /// Raw response
  raw : @js.Any
}

///|
pub fn EmbedResult::from_any(value : @js.Any) -> EmbedResult {
  let embedding_raw = value.get("embedding")
  let embedding : Array[Double] = @js.identity(embedding_raw)
  { embedding, usage: EmbeddingUsage::from_any(value.get("usage")), raw: value }
}

// ============================================================
// EmbedMany Result
// ============================================================

///|
/// Result from embedMany() call
pub(all) struct EmbedManyResult {
  /// Array of embedding vectors (order preserved)
  embeddings : Array[Array[Double]]
  /// Total token usage
  usage : EmbeddingUsage
  /// Raw response
  raw : @js.Any
}

///|
pub fn EmbedManyResult::from_any(value : @js.Any) -> EmbedManyResult {
  let embeddings_raw = value.get("embeddings")
  let embeddings : Array[Array[Double]] = @js.identity(embeddings_raw)
  {
    embeddings,
    usage: EmbeddingUsage::from_any(value.get("usage")),
    raw: value,
  }
}

// ============================================================
// Embed Functions
// ============================================================

///|
/// Convert a single value into an embedding vector
pub async fn embed(
  /// Embedding model to use
  model~ : EmbeddingModel,
  /// The text to embed
  value~ : String,
  /// Maximum retries
  max_retries? : Int,
  /// Abort signal
  abort_signal? : @js.Any,
  /// Custom headers
  headers? : @js.Any,
) -> EmbedResult {
  let opts = @js.Object::new()
  opts.set("model", model.to_any())
  opts.set("value", value)
  if max_retries is Some(r) {
    opts.set("maxRetries", r)
  }
  if abort_signal is Some(s) {
    opts.set("abortSignal", s)
  }
  if headers is Some(h) {
    opts.set("headers", h)
  }
  let promise : @js.Promise[@js.Any] = ai_module()
    .get("embed")
    .call_self([opts.to_any()])
    |> @js.identity
  let result = promise.wait()
  EmbedResult::from_any(result)
}

///|
/// Batch embedding of multiple values for efficiency
#alias(embed_many)
pub async fn embedMany(
  /// Embedding model to use
  model~ : EmbeddingModel,
  /// Array of texts to embed
  values~ : Array[String],
  /// Maximum parallel calls
  max_parallel_calls? : Int,
  /// Maximum retries
  max_retries? : Int,
  /// Abort signal
  abort_signal? : @js.Any,
  /// Custom headers
  headers? : @js.Any,
) -> EmbedManyResult {
  let opts = @js.Object::new()
  opts.set("model", model.to_any())
  opts.set("values", values |> @js.from_array)
  if max_parallel_calls is Some(c) {
    opts.set("maxParallelCalls", c)
  }
  if max_retries is Some(r) {
    opts.set("maxRetries", r)
  }
  if abort_signal is Some(s) {
    opts.set("abortSignal", s)
  }
  if headers is Some(h) {
    opts.set("headers", h)
  }
  let promise : @js.Promise[@js.Any] = ai_module()
    .get("embedMany")
    .call_self([opts.to_any()])
    |> @js.identity
  let result = promise.wait()
  EmbedManyResult::from_any(result)
}

// ============================================================
// Cosine Similarity
// ============================================================

///|
/// Calculate cosine similarity between two embedding vectors
/// Returns a value between -1 and 1, where 1 means identical
#alias(cosine_similarity)
pub fn cosineSimilarity(a : Array[Double], b : Array[Double]) -> Double {
  if a.length() != b.length() {
    abort("Embedding vectors must have the same length")
  }
  let mut dot_product = 0.0
  let mut norm_a = 0.0
  let mut norm_b = 0.0
  for i = 0; i < a.length(); i = i + 1 {
    dot_product = dot_product + a[i] * b[i]
    norm_a = norm_a + a[i] * a[i]
    norm_b = norm_b + b[i] * b[i]
  }
  let magnitude = norm_a.sqrt() * norm_b.sqrt()
  if magnitude == 0.0 {
    0.0
  } else {
    dot_product / magnitude
  }
}
