///| AI SDK Example - Generate Text

///|
/// Helper to create Anthropic model
fn anthropic(model_id : String) -> @ai.Model {
  (@node.require("@ai-sdk/anthropic") |> @nostd.any)
  ._get("anthropic")
  ._invoke([model_id |> @nostd.any])
  .cast()
}

///|
/// Format usage for display
fn format_usage(usage : @ai.LanguageModelUsage) -> String {
  "Input: \{usage.input_tokens}, Output: \{usage.output_tokens}, Total: \{usage.total_tokens}"
}

///|
/// Example: generate_text - simple one-shot generation
async fn example_generate_text(model : @ai.Model) -> Unit {
  @js.log("=== Generate Text ===")
  let result = @ai.generateText(
    model~,
    prompt="Say hello in one word.",
    max_tokens=50,
  ) catch {
    e => {
      @js.log("Error: \{e}")
      return
    }
  }
  @js.log("Text: \{result.text}")
  @js.log("Finish: \{result.finish_reason}")
  @js.log("Usage: \{format_usage(result.usage)}")
}

///|
/// Example: stream_text - streaming text chunks
async fn example_stream_text(model : @ai.Model) -> Unit {
  @js.log("\n=== Stream Text ===")
  let stream = @ai.streamText(
    model~,
    prompt="Count from 1 to 5.",
    max_tokens=100,
  )

  // Stream text chunks to stdout
  let iter = stream.textStream()
  loop iter.next() {
    Some(chunk) => {
      @process.stdout().write(chunk |> @nostd.any) |> ignore
      continue iter.next()
    }
    None => ()
  }
  @js.log("")

  // Final stats
  let usage = stream.usage() catch {
    e => {
      @js.log("Error: \{e}")
      return
    }
  }
  let finish = stream.finishReason() catch {
    e => {
      @js.log("Error: \{e}")
      return
    }
  }
  @js.log("Finish: \{finish}, Tokens: \{usage.total_tokens}")
}

///|
/// Example: full_stream - typed stream parts
async fn example_full_stream(model : @ai.Model) -> Unit {
  @js.log("\n=== Full Stream (typed) ===")
  let stream = @ai.streamText(model~, prompt="Hi!", max_tokens=20)
  // Use typed fullStream() instead of fullStreamRaw()
  let iter = stream.fullStream()
  loop iter.next() {
    None => ()
    Some(part) => {
      // part is already TextStreamPart, no need for from_any
      let text = match part.get_text() {
        Some(t) => " -> \"\{t}\""
        None => ""
      }
      @js.log("[\{part.type_string()}]\{text}")
      continue iter.next()
    }
  }
}

///|
/// Input type for weather tool - fields map to JSON schema properties
pub(all) struct WeatherInput {
  location : String
}

///|
/// Output type for weather tool
pub(all) struct WeatherOutput {
  location : String
  temperature : Int
  condition : String
} derive(ToJson)

///|
/// Example: tools - function calling with typed tools
async fn example_tools(model : @ai.Model) -> Unit {
  // Create async typed tool with Tool::typed_async
  let weather_tool = @ai.Tool::typed_async(
    description="Get the current weather for a location",
    input_schema={
      "type": "object",
      "properties": {
        "location": { "type": "string", "description": "The city name" },
      },
      "required": ["location"],
    },
    async fn(input : WeatherInput) -> WeatherOutput {
      // Can perform async operations here (API calls, DB queries, etc.)
      { location: input.location, temperature: 22, condition: "sunny" }
    },
  )
  let tools = @ai.Tools::new().add("getWeather", weather_tool)

  // Call with tools
  let result = @ai.generateText(
    model~,
    prompt="What's the weather in Tokyo?",
    tools~,
    max_steps=2,
    max_tokens=200,
  ) catch {
    @js.ThrowError::Error(e) => {
      @js.log("Error: \{e.message}")
      @js.log("Stack: \{e.stack}")
      return
    }
    e => {
      @js.log("Error: \{e}")
      return
    }
  }

  // Show tool calls
  if result.tool_calls.length() > 0 {
    @js.log("Tool calls:")
    for tc in result.tool_calls {
      let input_str = @js.JSON::stringify(tc.input)
      @js.log("  - \{tc.tool_name}(\{input_str})")
    }
  }

  // Show tool results
  if result.tool_results.length() > 0 {
    for tr in result.tool_results {
      let output_str = @js.JSON::stringify(tr.output)
      @js.log("  - \{tr.tool_name}: \{output_str}")
    }
  }
}

///|
async fn main {
  let model = anthropic("claude-sonnet-4-20250514")
  example_generate_text(model)
  example_stream_text(model)
  example_full_stream(model)
  example_tools(model)
}
