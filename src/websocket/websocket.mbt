///| WebSocket API
/// https://developer.mozilla.org/ja/docs/Web/API/WebSocket
///
/// WebSocket プロトコルを使用してサーバーとの双方向通信を提供

///|
#external
pub type WebSocket

///|
pub impl @js.JsImpl for WebSocket

///|
pub impl @event.EventTargetImpl for WebSocket

///|
/// WebSocket ready states
pub fn websocket_connecting() -> Int {
  0
}

///|
pub fn websocket_open() -> Int {
  1
}

///|
pub fn websocket_closing() -> Int {
  2
}

///|
pub fn websocket_closed() -> Int {
  3
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
/// Get the URL of the WebSocket
/// JS: webSocket.url
pub fn WebSocket::url(self : Self) -> @js.Js {
  self.get("url")
}

///|
/// Get the ready state
/// JS: webSocket.readyState
pub fn WebSocket::readyState(self : Self) -> @js.Js {
  self.get("readyState")
}

///|
/// Get the buffered amount
/// JS: webSocket.bufferedAmount
pub fn WebSocket::bufferedAmount(self : Self) -> @js.Js {
  self.get("bufferedAmount")
}

///|
/// Get the extensions
/// JS: webSocket.extensions
pub fn WebSocket::extensions(self : Self) -> @js.Js {
  self.get("extensions")
}

///|
/// Get the protocol
/// JS: webSocket.protocol
pub fn WebSocket::protocol(self : Self) -> @js.Js {
  self.get("protocol")
}

///|
/// Get the binary type
/// JS: webSocket.binaryType
pub fn WebSocket::binaryType(self : Self) -> @js.Js {
  self.get("binaryType")
}

///|
/// Set the binary type
/// JS: webSocket.binaryType = binaryType
pub fn WebSocket::set_binaryType(self : Self, binaryType : String) -> Unit {
  self.set("binaryType", binaryType)
}

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
pub fn WebSocket::send_arraybuffer(
  self : Self,
  data : @arraybuffer.ArrayBuffer,
) -> Unit {
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
pub fn get_message_data(event : @js.Js) -> @js.Js {
  event.get("data")
}

///|
/// CloseEvent helper to get code
/// JS: event.code
pub fn get_close_code(event : @js.Js) -> @js.Js {
  event.get("code")
}

///|
/// CloseEvent helper to get reason
/// JS: event.reason
pub fn get_close_reason(event : @js.Js) -> @js.Js {
  event.get("reason")
}

///|
/// CloseEvent helper to get wasClean
/// JS: event.wasClean
pub fn get_close_was_clean(event : @js.Js) -> @js.Js {
  event.get("wasClean")
}
