///| EventSource API
/// https://developer.mozilla.org/ja/docs/Web/API/EventSource
///
/// Server-Sent Events (SSE) を受信するためのインターフェース

///|
pub(all) struct EventSource {
  url : String
  readyState : Int
  withCredentials : Bool
}

///|
pub fn EventSource::as_any(self : EventSource) -> @nostd.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn EventSource::as_event_target(self : EventSource) -> EventTarget = "%identity"

///|
pub impl EventTargetImpl for EventSource with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// EventSource ready state: CONNECTING
pub fn event_source_connecting() -> Int {
  0
}

///|
/// EventSource ready state: OPEN
pub fn event_source_open() -> Int {
  1
}

///|
/// EventSource ready state: CLOSED
pub fn event_source_closed() -> Int {
  2
}

///|
/// Create a new EventSource
/// JS: new EventSource(url, options?)
pub extern "js" fn EventSource::new(
  url : String,
  withCredentials? : Bool,
) -> EventSource =
  #|(url, withCredentials) => {
  #|  if (withCredentials !== undefined) {
  #|    return new EventSource(url, { withCredentials });
  #|  }
  #|  return new EventSource(url);
  #|}

///|
/// Close the connection
/// JS: eventSource.close()
pub fn EventSource::close(self : Self) -> Unit {
  self.as_any()._call("close", []) |> ignore
}

///|
/// Set onopen event handler
/// JS: eventSource.onopen = handler
pub fn EventSource::set_onopen(
  self : Self,
  handler : (@js.Any) -> Unit,
) -> Unit {
  self.as_any()["onopen"] = @nostd.any(@js.from_fn1(handler))
}

///|
/// Set onmessage event handler
/// JS: eventSource.onmessage = handler
pub fn EventSource::set_onmessage(
  self : Self,
  handler : (@js.Any) -> Unit,
) -> Unit {
  self.as_any()["onmessage"] = @nostd.any(@js.from_fn1(handler))
}

///|
/// Set onerror event handler
/// JS: eventSource.onerror = handler
pub fn EventSource::set_onerror(
  self : Self,
  handler : (@js.Any) -> Unit,
) -> Unit {
  self.as_any()["onerror"] = @nostd.any(@js.from_fn1(handler))
}

///|
/// MessageEvent helper to get data
/// JS: event.data
pub fn get_event_data(event : @js.Any) -> String {
  event.get("data").cast()
}

///|
/// MessageEvent helper to get lastEventId
/// JS: event.lastEventId
pub fn get_last_event_id(event : @js.Any) -> String {
  event.get("lastEventId").cast()
}

///|
/// MessageEvent helper to get origin
/// JS: event.origin
pub fn get_event_origin(event : @js.Any) -> String {
  event.get("origin").cast()
}
