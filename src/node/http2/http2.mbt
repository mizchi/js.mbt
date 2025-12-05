///|

///|
/// HTTP/2 Session - base class for client and server sessions
/// https://nodejs.org/api/http2.html#class-http2session
#external
pub type Http2Session

///|
pub fn Http2Session::as_any(self : Http2Session) -> @core.Any = "%identity"

///|
pub fn Http2Session::as_event_target(self : Http2Session) -> @event.EventTarget = "%identity"

///|
/// HTTP/2 Server (unencrypted)
/// https://nodejs.org/api/http2.html#class-http2server
#external
pub type Http2Server

///|
pub fn Http2Server::as_any(self : Http2Server) -> @core.Any = "%identity"

///|
pub fn Http2Server::as_event_target(self : Http2Server) -> @event.EventTarget = "%identity"

///|
/// HTTP/2 Secure Server (TLS-encrypted)
/// https://nodejs.org/api/http2.html#class-http2secureserver
#external
pub type Http2SecureServer

///|
pub fn Http2SecureServer::as_any(self : Http2SecureServer) -> @core.Any = "%identity"

///|
pub fn Http2SecureServer::as_event_target(
  self : Http2SecureServer,
) -> @event.EventTarget = "%identity"

///|
/// HTTP/2 Stream - bidirectional communications channel
/// https://nodejs.org/api/http2.html#class-http2stream
#external
pub type Http2Stream

///|
pub fn Http2Stream::as_any(self : Http2Stream) -> @core.Any = "%identity"

///|
pub fn Http2Stream::as_event_target(self : Http2Stream) -> @event.EventTarget = "%identity"

///|
/// Client-side HTTP/2 stream
/// https://nodejs.org/api/http2.html#class-clienthttp2stream
#external
pub type ClientHttp2Stream

///|
pub fn ClientHttp2Stream::as_any(self : ClientHttp2Stream) -> @core.Any = "%identity"

///|
pub fn ClientHttp2Stream::as_event_target(
  self : ClientHttp2Stream,
) -> @event.EventTarget = "%identity"

///|
/// Server-side HTTP/2 stream
/// https://nodejs.org/api/http2.html#class-serverhttp2stream
#external
pub type ServerHttp2Stream

///|
pub fn ServerHttp2Stream::as_any(self : ServerHttp2Stream) -> @core.Any = "%identity"

///|
pub fn ServerHttp2Stream::as_event_target(
  self : ServerHttp2Stream,
) -> @event.EventTarget = "%identity"

///|
extern "js" fn ffi_create_server(
  options : @core.Any,
  request_handler : @core.Any,
) -> Http2Server =
  #| (options, requestHandler) => {
  #|   const http2 = require('http2');
  #|   return http2.createServer(options, requestHandler);
  #| }

///|
/// Create an unencrypted HTTP/2 server
pub fn create_server(
  request_handler : (@js.Object, @js.Object) -> Unit,
  allow_http1? : Bool,
  max_deflate_dynamic_table_size? : Int,
  max_session_memory? : Int,
  max_header_list_size? : Int,
  max_outstanding_pings? : Int,
  max_send_header_block_length? : Int,
  padding_strategy? : Int,
) -> Http2Server {
  let entries : Array[(String, @core.Any)] = []
  if allow_http1 is Some(v) {
    entries.push(("allowHTTP1", @core.any(v)))
  }
  if max_deflate_dynamic_table_size is Some(v) {
    entries.push(("maxDeflateDynamicTableSize", @core.any(v)))
  }
  if max_session_memory is Some(v) {
    entries.push(("maxSessionMemory", @core.any(v)))
  }
  if max_header_list_size is Some(v) {
    entries.push(("maxHeaderListSize", @core.any(v)))
  }
  if max_outstanding_pings is Some(v) {
    entries.push(("maxOutstandingPings", @core.any(v)))
  }
  if max_send_header_block_length is Some(v) {
    entries.push(("maxSendHeaderBlockLength", @core.any(v)))
  }
  if padding_strategy is Some(v) {
    entries.push(("paddingStrategy", @core.any(v)))
  }
  let opts = @core.from_entries(entries)
  ffi_create_server(opts, @js.from_fn2(request_handler))
}

///|
extern "js" fn ffi_create_secure_server(
  options : @core.Any,
  request_handler : @core.Any,
) -> Http2SecureServer =
  #| (options, requestHandler) => {
  #|   const http2 = require('http2');
  #|   return http2.createSecureServer(options, requestHandler);
  #| }

///|
/// Create a TLS-encrypted HTTP/2 server
pub fn create_secure_server(
  request_handler : (@js.Object, @js.Object) -> Unit,
  key? : String,
  cert? : String,
  pfx? : String,
  passphrase? : String,
  allow_http1? : Bool,
) -> Http2SecureServer {
  let entries : Array[(String, @core.Any)] = []
  if key is Some(v) {
    entries.push(("key", @core.any(v)))
  }
  if cert is Some(v) {
    entries.push(("cert", @core.any(v)))
  }
  if pfx is Some(v) {
    entries.push(("pfx", @core.any(v)))
  }
  if passphrase is Some(v) {
    entries.push(("passphrase", @core.any(v)))
  }
  if allow_http1 is Some(v) {
    entries.push(("allowHTTP1", @core.any(v)))
  }
  let opts = @core.from_entries(entries)
  ffi_create_secure_server(opts, @js.from_fn2(request_handler))
}

///|
/// Start listening on the specified port
pub fn Http2Server::listen(
  self : Http2Server,
  port : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("listen", [@core.any(port), cb]) |> ignore
}

///|
/// Start listening on the specified port (secure server)
pub fn Http2SecureServer::listen(
  self : Http2SecureServer,
  port : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("listen", [@core.any(port), cb]) |> ignore
}

///|
/// Close the server
pub fn Http2Server::close(self : Http2Server, callback : () -> Unit) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("close", [cb]) |> ignore
}

///|
/// Close the secure server
pub fn Http2SecureServer::close(
  self : Http2SecureServer,
  callback : () -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("close", [cb]) |> ignore
}

///|
extern "js" fn ffi_connect(
  authority : String,
  options : @core.Any,
) -> Http2Session =
  #| (authority, options) => {
  #|   const http2 = require('http2');
  #|   return http2.connect(authority, options);
  #| }

///|
/// Connect to an HTTP/2 server
pub fn connect(authority : String) -> Http2Session {
  ffi_connect(authority, @global.undefined())
}

///|
/// Request on an HTTP/2 session
pub fn Http2Session::request(
  self : Http2Session,
  headers : @js.Object,
) -> ClientHttp2Stream {
  self.as_any()._call("request", [@core.any(headers)]).cast()
}

///|
/// Close the session
pub fn Http2Session::close(self : Http2Session) -> Unit {
  self.as_any()._call("close", []) |> ignore
}

///|
/// Send a ping
pub fn Http2Session::ping(self : Http2Session, callback : () -> Unit) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("ping", [cb]) |> ignore
}

///|
/// Send response headers (server stream)
pub fn ServerHttp2Stream::respond(
  self : ServerHttp2Stream,
  headers : @js.Object,
) -> Unit {
  self.as_any()._call("respond", [@core.any(headers)]) |> ignore
}

///|
/// End the stream with data
pub fn ServerHttp2Stream::end(self : ServerHttp2Stream, data : String) -> Unit {
  self.as_any()._call("end", [@core.any(data)]) |> ignore
}

///|
/// Write data to the stream
pub fn ClientHttp2Stream::write(
  self : ClientHttp2Stream,
  data : String,
) -> Unit {
  self.as_any()._call("write", [@core.any(data)]) |> ignore
}

///|
/// End the client stream
pub fn ClientHttp2Stream::end(self : ClientHttp2Stream) -> Unit {
  self.as_any()._call("end", []) |> ignore
}

///|
/// Register 'data' event handler on client stream
pub fn ClientHttp2Stream::on_data(
  self : ClientHttp2Stream,
  callback : (@js.Object) -> Unit,
) -> ClientHttp2Stream {
  self
  .as_event_target()
  .addEventListener("data", fn(e : @core.Any) { callback(@core.identity(e)) })
  self
}

///|
/// Register 'response' event handler on client stream
pub fn ClientHttp2Stream::on_response(
  self : ClientHttp2Stream,
  callback : (@js.Object) -> Unit,
) -> ClientHttp2Stream {
  self
  .as_event_target()
  .addEventListener("response", fn(e : @core.Any) {
    callback(@core.identity(e))
  })
  self
}

///|
/// Register 'end' event handler on client stream
pub fn ClientHttp2Stream::on_end(
  self : ClientHttp2Stream,
  callback : () -> Unit,
) -> ClientHttp2Stream {
  self
  .as_event_target()
  .addEventListener("end", fn(_e : @core.Any) { callback() })
  self
}
