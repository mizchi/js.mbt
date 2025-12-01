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
  let empty_warnings : Array[@js.Any] = []
  let raw = @mbtconv.from_map({
    "object": @nostd.from_entries([("name", "test" |> @nostd.any)]).cast(),
    "finishReason": "stop" |> @nostd.any,
    "usage": @mbtconv.from_map({
      "inputTokens": 10 |> @nostd.any,
      "outputTokens": 20 |> @nostd.any,
      "totalTokens": 30 |> @nostd.any,
    }).cast(),
    "warnings": @js.from_array(empty_warnings) |> @nostd.any,
    "response": @nostd.from_entries([("id", "resp-123" |> @nostd.any)]).cast(),
  }).cast()
  let result = @ai.GenerateObjectResult::from_any(raw)
  assert_eq(result.finish_reason, @ai.FinishReason::Stop)
  assert_eq(result.usage.total_tokens, 30)
}

///|
test "generate object result get_object" {
  let empty_warnings : Array[@js.Any] = []
  let raw = @mbtconv.from_map({
    "object": @mbtconv.from_map({
      "name": "John" |> @nostd.any,
      "age": 30 |> @nostd.any,
    }).cast(),
    "finishReason": "stop" |> @nostd.any,
    "usage": @mbtconv.from_map({
      "inputTokens": 10 |> @nostd.any,
      "outputTokens": 20 |> @nostd.any,
      "totalTokens": 30 |> @nostd.any,
    }).cast(),
    "warnings": @js.from_array(empty_warnings) |> @nostd.any,
    "response": @js.Object::new().as_any() |> @nostd.any,
  }).cast()
  let result = @ai.GenerateObjectResult::from_any(raw)
  // Get object as raw Any
  let obj = result.object
  let name : String = obj.get("name").cast()
  assert_eq(name, "John")
}

///|
#skip
async test "generateObject with mock" {
  // This test requires actual API key, so skip by default
  let model = @ai.anthropic("claude-sonnet-4-20250514")
  let schema = @mbtconv.from_map({
    "type": "object" |> @nostd.any,
    "properties": @mbtconv.from_map({
      "name": @nostd.from_entries([("type", "string" |> @nostd.any)]).cast(),
      "age": @nostd.from_entries([("type", "number" |> @nostd.any)]).cast(),
    }).cast(),
    "required": @js.from_array(["name" |> @js.any, "age" |> @js.any])
    |> @nostd.any,
  }).cast()
  let result = @ai.generateObject(
    model~,
    schema~,
    prompt="Generate a person with name Alice and age 25",
  )
  @js.log(result.object)
}
