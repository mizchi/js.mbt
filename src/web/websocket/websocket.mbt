///| WebSocket API
/// https://developer.mozilla.org/ja/docs/Web/API/WebSocket
///
/// WebSocket プロトコルを使用してサーバーとの双方向通信を提供

///|
pub(all) struct WebSocket {
  url : String
  readyState : Int
  bufferedAmount : Int
  extensions : String
  protocol : String
  mut binaryType : String
}

///|
pub impl @js.JsImpl for WebSocket

///|
pub impl @event.EventTargetImpl for WebSocket

///|
/// WebSocket ready states
pub enum WebSocketReadyState {
  Connecting
  Open
  Closing
  Closed
} derive(Eq, Show)

///|
/// Convert WebSocketReadyState to Int
pub fn WebSocketReadyState::to_int(self : WebSocketReadyState) -> Int {
  match self {
    Connecting => 0
    Open => 1
    Closing => 2
    Closed => 3
  }
}

///|
/// Create WebSocketReadyState from Int
pub fn WebSocketReadyState::from_int(value : Int) -> WebSocketReadyState? {
  match value {
    0 => Some(Connecting)
    1 => Some(Open)
    2 => Some(Closing)
    3 => Some(Closed)
    _ => None
  }
}

///|
/// Create a new WebSocket
/// JS: new WebSocket(url, protocols?)
pub extern "js" fn WebSocket::new(
  url : String,
  protocols? : Array[String],
) -> WebSocket =
  #|(url, protocols) => {
  #|  if (protocols !== undefined) {
  #|    return new WebSocket(url, protocols);
  #|  }
  #|  return new WebSocket(url);
  #|}

///|
/// Close the connection
/// JS: webSocket.close(code?, reason?)
pub fn WebSocket::close(self : Self, code? : Int, reason? : String) -> Unit {
  match (code, reason) {
    (Some(c), Some(r)) => self.call("close", [c, r]) |> ignore
    (Some(c), None) => self.call1("close", c) |> ignore
    (None, _) => self.call0("close") |> ignore
  }
}

///|
/// Send data
/// JS: webSocket.send(data)
pub fn WebSocket::send_string(self : Self, data : String) -> Unit {
  self.call1("send", data) |> ignore
}

///|
/// Send binary data
/// JS: webSocket.send(data)
pub fn WebSocket::send_buffer(self : Self, data : @buffer.Buffer) -> Unit {
  self.call1("send", data) |> ignore
}

///|
/// Send ArrayBuffer
/// JS: webSocket.send(data)
pub fn WebSocket::send_arraybuffer(self : Self, data : @js.ArrayBuffer) -> Unit {
  self.call1("send", data) |> ignore
}

///|
/// Send Blob
/// JS: webSocket.send(data)
pub fn WebSocket::send_blob(self : Self, data : @blob.Blob) -> Unit {
  self.call1("send", data) |> ignore
}

///|
/// Set onopen event handler
/// JS: webSocket.onopen = handler
pub fn WebSocket::set_onopen(self : Self, handler : (@js.Js) -> Unit) -> Unit {
  self.set("onopen", @js.from_fn1(handler))
}

///|
/// Set onmessage event handler
/// JS: webSocket.onmessage = handler
pub fn WebSocket::set_onmessage(
  self : Self,
  handler : (@js.Js) -> Unit,
) -> Unit {
  self.set("onmessage", @js.from_fn1(handler))
}

///|
/// Set onerror event handler
/// JS: webSocket.onerror = handler
pub fn WebSocket::set_onerror(self : Self, handler : (@js.Js) -> Unit) -> Unit {
  self.set("onerror", @js.from_fn1(handler))
}

///|
/// Set onclose event handler
/// JS: webSocket.onclose = handler
pub fn WebSocket::set_onclose(self : Self, handler : (@js.Js) -> Unit) -> Unit {
  self.set("onclose", @js.from_fn1(handler))
}

///|
/// MessageEvent helper to get data
/// JS: event.data
pub fn get_message_data(event : @js.Js) -> String {
  event.get("data").cast()
}

///|
/// CloseEvent helper to get code
/// JS: event.code
pub fn get_close_code(event : @js.Js) -> Int {
  event.get("code").cast()
}

///|
/// CloseEvent helper to get reason
/// JS: event.reason
pub fn get_close_reason(event : @js.Js) -> String {
  event.get("reason").cast()
}

///|
/// CloseEvent helper to get wasClean
/// JS: event.wasClean
pub fn get_close_was_clean(event : @js.Js) -> Bool {
  event.get("wasClean").cast()
}
