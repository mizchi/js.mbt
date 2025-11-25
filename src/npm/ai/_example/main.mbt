///| AI SDK Example - Generate Text

///|
fn get_anthropic_model(model_id : String) -> @ai.Model {
  @js.identity(
    @node.require("@ai-sdk/anthropic").get("anthropic").call_self([model_id]),
  )
}

///|
async fn run_generate_text() -> Unit {
  let ai = @ai.Ai::require()
  let model = get_anthropic_model("claude-sonnet-4-20250514")
  @js.log("=== Generate Text Test ===")
  let result = ai.generate_text(
    model~,
    prompt="Say hello in exactly one word.",
    max_tokens=50,
  ) catch {
    @js.ThrowError::Error(e) => {
      @js.log("Error: " + e.message)
      @js.log("Stack: " + e.stack)
      return
    }
    e => {
      @js.log(e)
      return
    }
  }
  @js.log("Text: " + result.text)
  @js.log("Finish reason: " + result.finish_reason.to_string())
  @js.log(
    "Usage - Input: " +
    result.usage.input_tokens.to_string() +
    ", Output: " +
    result.usage.output_tokens.to_string() +
    ", Total: " +
    result.usage.total_tokens.to_string(),
  )
  // Check response metadata
  match result.response.model_id {
    Some(id) => @js.log("Model ID: " + id)
    None => @js.log("Model ID: (none)")
  }
}

///|
async fn run_stream_text() -> Unit {
  let ai = @ai.Ai::require()
  let model = get_anthropic_model("claude-sonnet-4-20250514")
  @js.log("\n=== Stream Text Test ===")
  // stream_text is synchronous, stream consumption is async
  let stream = ai.stream_text(
    model~,
    prompt="Count from 1 to 5, one number per line.",
    max_tokens=100,
  )
  // Stream text chunks
  @js.log("Streaming chunks:")
  let text_iter = stream.text_stream()
  while true {
    match text_iter.next() {
      Some(chunk) => @process.stdout().call("write", [chunk]) |> ignore
      None => break
    }
  }
  @js.log("\n\nStream completed.")
  // Get final usage
  let usage = stream.usage() catch {
    e => {
      @js.log(e)
      return
    }
  }
  @js.log("Total tokens: " + usage.total_tokens.to_string())
  let finish = stream.finish_reason() catch {
    e => {
      @js.log(e)
      return
    }
  }
  @js.log("Finish reason: " + finish.to_string())
}

///|
async fn run_full_stream() -> Unit {
  let ai = @ai.Ai::require()
  let model = get_anthropic_model("claude-sonnet-4-20250514")
  @js.log("\n=== Full Stream Test ===")
  // stream_text is synchronous
  let stream = ai.stream_text(model~, prompt="Hi!", max_tokens=20)
  // Use full_stream_raw to see all stream parts
  let full_iter = stream.full_stream_raw()
  while true {
    match full_iter.next() {
      Some(part) => {
        let parsed = @ai.TextStreamPart::from_any(part)
        @js.log("Part type: " + parsed.type_string())
        match parsed.get_text() {
          Some(text) => @js.log("  Text: " + text)
          None => ()
        }
      }
      None => break
    }
  }
  @js.log("Full stream completed.")
}

///|
async fn run_all() -> Unit noraise {
  run_generate_text() catch {
    _ => ()
  }
  run_stream_text() catch {
    _ => ()
  }
  run_full_stream() catch {
    _ => ()
  }
}

///|
fn main {
  @js.log("AI SDK MoonBit Bindings Test\n")
  @js.run_async(run_all)
}
