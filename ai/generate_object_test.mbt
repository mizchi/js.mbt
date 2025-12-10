///| Tests for generateObject

///|
test "output strategy to_string" {
  assert_eq(@ai.OutputStrategy::Object.to_string(), "object")
  assert_eq(@ai.OutputStrategy::Array.to_string(), "array")
  assert_eq(@ai.OutputStrategy::Enum.to_string(), "enum")
  assert_eq(@ai.OutputStrategy::NoSchema.to_string(), "no-schema")
}

///|
test "generate object result from_any" {
  let empty_warnings : Array[@core.Any] = []
  let raw = @core.from_entries([
    ("object", @core.from_entries([("name", "test" |> @core.any)]).cast()),
    ("finishReason", @core.any("stop")),
    (
      "usage",
      @core.from_entries([
        ("inputTokens", @core.any(10)),
        ("outputTokens", @core.any(20)),
        ("totalTokens", @core.any(30)),
      ]).cast(),
    ),
    ("warnings", @core.any(empty_warnings) |> @core.any),
    ("response", @core.from_entries([("id", "resp-123" |> @core.any)]).cast()),
  ]).cast()
  let result = @ai.GenerateObjectResult::from_any(raw)
  assert_eq(result.finish_reason, @ai.FinishReason::Stop)
  assert_eq(result.usage.total_tokens, 30)
}

///|
test "generate object result get_object" {
  let empty_warnings : Array[@core.Any] = []
  let raw = @core.from_entries([
    (
      "object",
      @core.from_entries([("name", @core.any("John")), ("age", @core.any(30))]).cast(),
    ),
    ("finishReason", @core.any("stop")),
    (
      "usage",
      @core.from_entries([
        ("inputTokens", @core.any(10)),
        ("outputTokens", @core.any(20)),
        ("totalTokens", @core.any(30)),
      ]).cast(),
    ),
    ("warnings", @core.any(empty_warnings)),
    ("response", @core.new_object()),
  ]).cast()
  let result = @ai.GenerateObjectResult::from_any(raw)
  // Get object as raw Any
  let obj = result.object
  let name : String = obj._get("name").cast()
  assert_eq(name, "John")
}

///|
#skip
async test "generateObject with mock" {
  // This test requires actual API key, so skip by default
  let model = @ai.anthropic("claude-sonnet-4-20250514")
  let schema = @core.from_entries([
    ("type", @core.any("object")),
    (
      "properties",
      @core.from_entries([
        ("name", @core.from_entries([("type", @core.any("string"))]).cast()),
        ("age", @core.from_entries([("type", @core.any("number"))]).cast()),
      ]).cast(),
    ),
    ("required", @core.any(["name" |> @js.any, "age" |> @js.any]) |> @core.any),
  ]).cast()
  let result = @ai.generateObject(
    model~,
    schema~,
    prompt="Generate a person with name Alice and age 25",
  )
  @js.log(result.object)
}
