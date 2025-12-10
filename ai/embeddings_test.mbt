///| Tests for embeddings

///|
test "embedding usage from_any" {
  let raw = @core.from_entries([("tokens", 100 |> @core.any)]).cast()
  let usage = @ai.EmbeddingUsage::from_any(raw)
  assert_eq(usage.tokens, 100)
}

///|
test "embed result from_any" {
  let embedding_arr : Array[Double] = [0.1, 0.2, 0.3, 0.4, 0.5]
  let raw = @core.from_entries([
    ("embedding", embedding_arr |> @core.any |> @core.any),
    ("usage", @core.from_entries([("tokens", 50 |> @core.any)]).cast()),
  ]).cast()
  let result = @ai.EmbedResult::from_any(raw)
  assert_eq(result.embedding.length(), 5)
  assert_eq(result.usage.tokens, 50)
}

///|
test "embed many result from_any" {
  let emb1 : Array[Double] = [0.1, 0.2, 0.3]
  let emb2 : Array[Double] = [0.4, 0.5, 0.6]
  let embeddings_arr = [emb1 |> @core.any, emb2 |> @core.any]
  let raw = @core.from_entries([
    ("embeddings", embeddings_arr |> @core.any |> @core.any),
    ("usage", @core.from_entries([("tokens", 100 |> @core.any)]).cast()),
  ]).cast()
  let result = @ai.EmbedManyResult::from_any(raw)
  assert_eq(result.embeddings.length(), 2)
  assert_eq(result.usage.tokens, 100)
}

///|
test "cosine similarity identical vectors" {
  let a : Array[Double] = [1.0, 0.0, 0.0]
  let b : Array[Double] = [1.0, 0.0, 0.0]
  let similarity = @ai.cosineSimilarity(a, b)
  // Should be 1.0 for identical vectors
  assert_true((similarity - 1.0).abs() < 0.0001)
}

///|
test "cosine similarity orthogonal vectors" {
  let a : Array[Double] = [1.0, 0.0, 0.0]
  let b : Array[Double] = [0.0, 1.0, 0.0]
  let similarity = @ai.cosineSimilarity(a, b)
  // Should be 0.0 for orthogonal vectors
  assert_true(similarity.abs() < 0.0001)
}

///|
test "cosine similarity opposite vectors" {
  let a : Array[Double] = [1.0, 0.0, 0.0]
  let b : Array[Double] = [-1.0, 0.0, 0.0]
  let similarity = @ai.cosineSimilarity(a, b)
  // Should be -1.0 for opposite vectors
  assert_true((similarity + 1.0).abs() < 0.0001)
}

///|
test "cosine similarity similar vectors" {
  let a : Array[Double] = [1.0, 2.0, 3.0]
  let b : Array[Double] = [1.0, 2.0, 3.5]
  let similarity = @ai.cosineSimilarity(a, b)
  // Should be close to 1.0 for similar vectors
  assert_true(similarity > 0.99)
}

///|
test "cosine similarity normalized" {
  let a : Array[Double] = [3.0, 4.0]
  let b : Array[Double] = [6.0, 8.0]
  let similarity = @ai.cosineSimilarity(a, b)
  // Should be 1.0 for parallel vectors regardless of magnitude
  assert_true((similarity - 1.0).abs() < 0.0001)
}

///|
#skip
async test "embed with mock" {
  // This test requires actual API key, so skip by default
  let provider = @ai.OpenAIProvider::require()
  let model : @ai.EmbeddingModel = provider
    .as_any()
    ._get("textEmbeddingModel")
    ._invoke(["text-embedding-3-small" |> @core.any])
    |> @core.identity
  let result = @ai.embed(model~, value="Hello, world!")
  println("Embedding dimension: " + result.embedding.length().to_string())
  println("Tokens used: " + result.usage.tokens.to_string())
}
