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
  let empty_warnings : Array[@nostd.Any] = []
  let raw = @nostd.from_entries([
    ("object", @nostd.from_entries([("name", "test" |> @nostd.any)]).cast()),
    ("finishReason", @nostd.any("stop")),
    (
      "usage",
      @nostd.from_entries([
        ("inputTokens", @nostd.any(10)),
        ("outputTokens", @nostd.any(20)),
        ("totalTokens", @nostd.any(30)),
      ]).cast(),
    ),
    ("warnings", @js.from_array(empty_warnings) |> @nostd.any),
    ("response", @nostd.from_entries([("id", "resp-123" |> @nostd.any)]).cast()),
  ]).cast()
  let result = @ai.GenerateObjectResult::from_any(raw)
  assert_eq(result.finish_reason, @ai.FinishReason::Stop)
  assert_eq(result.usage.total_tokens, 30)
}

///|
test "generate object result get_object" {
  let empty_warnings : Array[@nostd.Any] = []
  let raw = @nostd.from_entries([
    (
      "object",
      @nostd.from_entries([
        ("name", @nostd.any("John")),
        ("age", @nostd.any(30)),
      ]).cast(),
    ),
    ("finishReason", @nostd.any("stop")),
    (
      "usage",
      @nostd.from_entries([
        ("inputTokens", @nostd.any(10)),
        ("outputTokens", @nostd.any(20)),
        ("totalTokens", @nostd.any(30)),
      ]).cast(),
    ),
    ("warnings", @js.from_array(empty_warnings) |> @nostd.any),
    ("response", @nostd.Object::new().as_any() |> @nostd.any),
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
  let schema = @nostd.from_entries([
    ("type", @nostd.any("object")),
    (
      "properties",
      @nostd.from_entries([
        ("name", @nostd.from_entries([("type", @nostd.any("string"))]).cast()),
        ("age", @nostd.from_entries([("type", @nostd.any("number"))]).cast()),
      ]).cast(),
    ),
    (
      "required",
      @js.from_array(["name" |> @js.any, "age" |> @js.any]) |> @nostd.any,
    ),
  ]).cast()
  let result = @ai.generateObject(
    model~,
    schema~,
    prompt="Generate a person with name Alice and age 25",
  )
  @js.log(result.object)
}
