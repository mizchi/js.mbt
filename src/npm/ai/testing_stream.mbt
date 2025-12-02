///| Simulate Readable Stream
/// Creates a ReadableStream that emits provided values with optional delays

///|
/// Options for simulateReadableStream
pub(all) struct SimulateStreamOptions {
  /// Array of values to be emitted by the stream
  chunks : Array[@nostd.Any]
  /// Delay in milliseconds before emitting the first value (default: 0)
  initial_delay_ms : Int?
  /// Delay in milliseconds between emitting each value (default: 0)
  chunk_delay_ms : Int?
}

///|
/// Creates a ReadableStream that emits the provided values with optional delays.
/// Uses the AI SDK's simulateReadableStream under the hood.
pub fn simulate_readable_stream(options : SimulateStreamOptions) -> @nostd.Any {
  let test_module = require_test()
  let opts = @nostd.Object::new()
  opts._set("chunks", options.chunks |> @nostd.any)
  if options.initial_delay_ms is Some(delay) {
    opts._set("initialDelayInMs", delay |> @nostd.any)
  }
  if options.chunk_delay_ms is Some(delay) {
    opts._set("chunkDelayInMs", delay |> @nostd.any)
  }
  test_module._get("simulateReadableStream").call_self([opts])
}

///|
/// Simpler version that just takes chunks
pub fn simulate_stream(chunks : Array[@nostd.Any]) -> @nostd.Any {
  simulate_readable_stream({
    chunks,
    initial_delay_ms: None,
    chunk_delay_ms: None,
  })
}

///|
/// Simulate stream with delays
pub fn simulate_stream_with_delay(
  chunks : Array[@nostd.Any],
  chunk_delay_ms : Int,
) -> @nostd.Any {
  simulate_readable_stream({
    chunks,
    initial_delay_ms: Some(0),
    chunk_delay_ms: Some(chunk_delay_ms),
  })
}
