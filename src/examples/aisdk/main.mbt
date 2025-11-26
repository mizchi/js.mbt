///|
async fn main {
  // Load environment variables
  @dotenv.config() |> ignore
  println("[ai] Starting stream...")
  // Start streaming
  let stream = @ai.stream_text(
    model=@ai.anthropic("claude-sonnet-4-20250514"),
    prompt="Count from 1 to 10, one number per line",
  )
  // Iterate over text chunks
  let text_iter = stream.text_stream()
  let stdout = @process.stdout()
  while true {
    match text_iter.next() {
      Some(chunk) => stdout.write(chunk) |> ignore
      None => break
    }
  }
  println("\n\n[ai] Stream complete!")
  // Get final usage stats
  let usage = stream.usage()
  println("Tokens used: \{usage.total_tokens.to_string()}")
}
