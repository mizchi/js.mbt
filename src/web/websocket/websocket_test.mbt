///|
/// Test WebSocket

///|
test "WebSocketReadyState::from_int and to_int" {
  // Test round-trip conversion
  assert_eq(WebSocketReadyState::from_int(0).map(fn(s) { s.to_int() }), Some(0))
  assert_eq(WebSocketReadyState::from_int(1).map(fn(s) { s.to_int() }), Some(1))
  assert_eq(WebSocketReadyState::from_int(2).map(fn(s) { s.to_int() }), Some(2))
  assert_eq(WebSocketReadyState::from_int(3).map(fn(s) { s.to_int() }), Some(3))
  assert_eq(WebSocketReadyState::from_int(999), None)
}

///|
test "get_close_code extracts code from event" {
  let event : @js.Any = @mbtconv.from_map({ "code": @nostd.any(1000) }).cast()
  let code = get_close_code(event)
  inspect(code, content="1000")
}

///|
test "get_close_reason extracts reason from event" {
  let event : @js.Any = @mbtconv.from_map({
    "reason": @nostd.any("Normal closure"),
  }).cast()
  let reason = get_close_reason(event)
  inspect(reason, content="Normal closure")
}

///|
test "get_close_was_clean extracts wasClean from event" {
  let event : @js.Any = @mbtconv.from_map({ "wasClean": @nostd.any(true) }).cast()
  let was_clean = get_close_was_clean(event)
  inspect(was_clean, content="true")
}
