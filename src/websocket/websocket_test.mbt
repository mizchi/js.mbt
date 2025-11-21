///|
/// Test WebSocket

///|
test "websocket_connecting returns 0" {
  assert_eq(websocket_connecting(), 0)
}

///|
test "websocket_open returns 1" {
  assert_eq(websocket_open(), 1)
}

///|
test "websocket_closing returns 2" {
  assert_eq(websocket_closing(), 2)
}

///|
test "websocket_closed returns 3" {
  assert_eq(websocket_closed(), 3)
}

///|
test "get_close_code extracts code from event" {
  let event = @js.from_map({ "code": @js.unsafe_cast(1000) })
  let code = get_close_code(event)
  inspect(code, content="1000")
}

///|
test "get_close_reason extracts reason from event" {
  let event = @js.from_map({ "reason": @js.unsafe_cast("Normal closure") })
  let reason = get_close_reason(event)
  inspect(reason, content="Normal closure")
}

///|
test "get_close_was_clean extracts wasClean from event" {
  let event = @js.from_map({ "wasClean": @js.unsafe_cast(true) })
  let was_clean = get_close_was_clean(event)
  inspect(was_clean, content="true")
}
