///|
/// Test EventSource

///|
test "event_source_connecting returns 0" {
  assert_eq(event_source_connecting(), 0)
}

///|
test "event_source_open returns 1" {
  assert_eq(event_source_open(), 1)
}

///|
test "event_source_closed returns 2" {
  assert_eq(event_source_closed(), 2)
}

///|
test "EventSource constructor exists" {
  // Note: Creating EventSource requires a valid SSE endpoint
  // Just verify the type and methods exist at compile time
  let _ : (EventSource) -> Unit = fn(es) { es.close() }
  ()
}

///|
test "get_event_data extracts data from event" {
  let event : @nostd.Any = @nostd.from_entries([("data", @nostd.any("test data"))]).cast()
  assert_eq(get_event_data(event), "test data")
}

///|
test "get_last_event_id extracts lastEventId from event" {
  let event : @nostd.Any = @nostd.from_entries([("lastEventId", @nostd.any("123"))]).cast()
  assert_eq(get_last_event_id(event), "123")
}

///|
test "get_event_origin extracts origin from event" {
  let event : @nostd.Any = @nostd.from_entries([
    ("origin", @nostd.any("https://example.com")),
  ]).cast()
  assert_eq(get_event_origin(event), "https://example.com")
}
