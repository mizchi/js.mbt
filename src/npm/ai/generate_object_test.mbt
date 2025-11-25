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
  let raw = @js.from_map({
    "object": @js.from_map({ "name": "test" |> @js.any }),
    "finishReason": "stop" |> @js.any,
    "usage": @js.from_map({
      "inputTokens": 10 |> @js.any,
      "outputTokens": 20 |> @js.any,
      "totalTokens": 30 |> @js.any,
    }),
    "warnings": @js.from_array([]) |> @js.any,
    "response": @js.from_map({ "id": "resp-123" |> @js.any }),
  })
  let result = @ai.GenerateObjectResult::from_any(raw)
  assert_eq(result.finish_reason, @ai.FinishReason::Stop)
  assert_eq(result.usage.total_tokens, 30)
}

///|
test "generate object result get_object" {
  let raw = @js.from_map({
    "object": @js.from_map({ "name": "John" |> @js.any, "age": 30 |> @js.any }),
    "finishReason": "stop" |> @js.any,
    "usage": @js.from_map({
      "inputTokens": 10 |> @js.any,
      "outputTokens": 20 |> @js.any,
      "totalTokens": 30 |> @js.any,
    }),
    "warnings": @js.from_array([]) |> @js.any,
    "response": @js.from_map({}),
  })
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
  let ai = @ai.Ai::require()
  let model : @ai.Model = @js.identity(
    @node.require("@ai-sdk/anthropic")
    .get("anthropic")
    .call_self(["claude-sonnet-4-20250514"]),
  )
  let schema = @js.from_map({
    "type": "object" |> @js.any,
    "properties": @js.from_map({
      "name": @js.from_map({ "type": "string" |> @js.any }),
      "age": @js.from_map({ "type": "number" |> @js.any }),
    }),
    "required": @js.from_array(["name" |> @js.any, "age" |> @js.any]) |> @js.any,
  })
  let result = ai.generateObject(
    model~,
    schema~,
    prompt="Generate a person with name Alice and age 25",
  )
  @js.log(result.object)
}
