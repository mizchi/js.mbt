///| Stream tests

///|
test "simulate_stream creates readable stream" {
  let chunks = ["a", "b", "c"].map(fn(s) { s |> @js.any })
  let stream = simulate_stream(chunks)
  // Check that stream is a ReadableStream
  assert_false(@js.is_undefined(stream))
  assert_false(@js.is_null(stream))
}

///|
test "SimulateStreamOptions to readable stream" {
  let options : SimulateStreamOptions = {
    chunks: ["hello", "world"].map(fn(s) { s |> @js.any }),
    initial_delay_ms: None,
    chunk_delay_ms: None,
  }
  let stream = simulate_readable_stream(options)
  assert_false(@js.is_undefined(stream))
}

///|
async test "convert_array_to_readable_stream and back" {
  let arr = ["a", "b", "c"].map(fn(s) { s |> @js.any })
  let stream = convert_array_to_readable_stream(arr)
  let result = convert_readable_stream_to_array(stream)
  assert_eq(result.length(), 3)
  let first : String = result[0].cast()
  let second : String = result[1].cast()
  let third : String = result[2].cast()
  assert_eq(first, "a")
  assert_eq(second, "b")
  assert_eq(third, "c")
}
