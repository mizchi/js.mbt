///| Tests for embeddings

///|
test "embedding usage from_any" {
  let raw = @nostd.from_entries([("tokens", 100 |> @nostd.any)]).cast()
  let usage = @ai.EmbeddingUsage::from_any(raw)
  assert_eq(usage.tokens, 100)
}

///|
test "embed result from_any" {
  let embedding_arr : Array[Double] = [0.1, 0.2, 0.3, 0.4, 0.5]
  let raw = @nostd.from_entries([
    ("embedding", embedding_arr |> @nostd.any |> @nostd.any),
    ("usage", @nostd.from_entries([("tokens", 50 |> @nostd.any)]).cast()),
  ]).cast()
  let result = @ai.EmbedResult::from_any(raw)
  assert_eq(result.embedding.length(), 5)
  assert_eq(result.usage.tokens, 50)
}

///|
test "embed many result from_any" {
  let emb1 : Array[Double] = [0.1, 0.2, 0.3]
  let emb2 : Array[Double] = [0.4, 0.5, 0.6]
  let embeddings_arr = [emb1 |> @nostd.any, emb2 |> @nostd.any]
  let raw = @nostd.from_entries([
    ("embeddings", embeddings_arr |> @nostd.any |> @nostd.any),
    ("usage", @nostd.from_entries([("tokens", 100 |> @nostd.any)]).cast()),
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
  let model : @ai.EmbeddingModel = @nostd.identity(
    @node.require("@ai-sdk/openai")
    ._get("openai")
    ._invoke([])
    ._get("textEmbeddingModel")
    ._invoke(["text-embedding-3-small" |> @nostd.any]),
  )
  let result = @ai.embed(model~, value="Hello, world!")
  @js.log("Embedding dimension: " + result.embedding.length().to_string())
  @js.log("Tokens used: " + result.usage.tokens.to_string())
}
