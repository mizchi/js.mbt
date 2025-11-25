///|

///|
/// HTTP/2 Session - base class for client and server sessions
/// https://nodejs.org/api/http2.html#class-http2session
#external
pub type Http2Session

///|
pub impl @js.JsImpl for Http2Session

///|
pub impl @event.EventTargetImpl for Http2Session

///|
/// HTTP/2 Server (unencrypted)
/// https://nodejs.org/api/http2.html#class-http2server
#external
pub type Http2Server

///|
pub impl @js.JsImpl for Http2Server

///|
pub impl @event.EventTargetImpl for Http2Server

///|
/// HTTP/2 Secure Server (TLS-encrypted)
/// https://nodejs.org/api/http2.html#class-http2secureserver
#external
pub type Http2SecureServer

///|
pub impl @js.JsImpl for Http2SecureServer

///|
pub impl @event.EventTargetImpl for Http2SecureServer

///|
/// HTTP/2 Stream - bidirectional communications channel
/// https://nodejs.org/api/http2.html#class-http2stream
#external
pub type Http2Stream

///|
pub impl @js.JsImpl for Http2Stream

///|
pub impl @event.EventTargetImpl for Http2Stream

///|
/// Client-side HTTP/2 stream
/// https://nodejs.org/api/http2.html#class-clienthttp2stream
#external
pub type ClientHttp2Stream

///|
pub impl @js.JsImpl for ClientHttp2Stream

///|
pub impl @event.EventTargetImpl for ClientHttp2Stream

///|
/// Server-side HTTP/2 stream
/// https://nodejs.org/api/http2.html#class-serverhttp2stream
#external
pub type ServerHttp2Stream

///|
pub impl @js.JsImpl for ServerHttp2Stream

///|
pub impl @event.EventTargetImpl for ServerHttp2Stream

///|
extern "js" fn ffi_create_server(
  options : @js.Any,
  request_handler : @js.Any,
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
  let opts = @js.from_entries_option([
    ("allowHTTP1", allow_http1.map(x => x)),
    ("maxDeflateDynamicTableSize", max_deflate_dynamic_table_size.map(x => x)),
    ("maxSessionMemory", max_session_memory.map(x => x)),
    ("maxHeaderListSize", max_header_list_size.map(x => x)),
    ("maxOutstandingPings", max_outstanding_pings.map(x => x)),
    ("maxSendHeaderBlockLength", max_send_header_block_length.map(x => x)),
    ("paddingStrategy", padding_strategy.map(x => x)),
  ])
  ffi_create_server(opts, @js.from_fn2(request_handler))
}

///|
extern "js" fn ffi_create_secure_server(
  options : @js.Any,
  request_handler : @js.Any,
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
  let opts = @js.from_entries_option([
    ("key", key.map(x => x)),
    ("cert", cert.map(x => x)),
    ("pfx", pfx.map(x => x)),
    ("passphrase", passphrase.map(x => x)),
    ("allowHTTP1", allow_http1.map(x => x)),
  ])
  ffi_create_secure_server(opts, @js.from_fn2(request_handler))
}

///|
/// Start listening on the specified port
pub fn Http2Server::listen(
  self : Http2Server,
  port : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call2("listen", port, cb) |> ignore
}

///|
/// Start listening on the specified port (secure server)
pub fn Http2SecureServer::listen(
  self : Http2SecureServer,
  port : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call2("listen", port, cb) |> ignore
}

///|
/// Close the server
pub fn Http2Server::close(self : Http2Server, callback : () -> Unit) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("close", [cb]) |> ignore
}

///|
/// Close the secure server
pub fn Http2SecureServer::close(
  self : Http2SecureServer,
  callback : () -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("close", [cb]) |> ignore
}

///|
extern "js" fn ffi_connect(
  authority : String,
  options : @js.Any,
) -> Http2Session =
  #| (authority, options) => {
  #|   const http2 = require('http2');
  #|   return http2.connect(authority, options);
  #| }

///|
/// Connect to an HTTP/2 server
pub fn connect(authority : String) -> Http2Session {
  ffi_connect(authority, @js.undefined())
}

///|
/// Request on an HTTP/2 session
pub fn Http2Session::request(
  self : Http2Session,
  headers : @js.Object,
) -> ClientHttp2Stream {
  self.call("request", [headers.to_any()]).cast()
}

///|
/// Close the session
pub fn Http2Session::close(self : Http2Session) -> Unit {
  self.call0("close") |> ignore
}

///|
/// Send a ping
pub fn Http2Session::ping(self : Http2Session, callback : () -> Unit) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("ping", [cb]) |> ignore
}

///|
/// Send response headers (server stream)
pub fn ServerHttp2Stream::respond(
  self : ServerHttp2Stream,
  headers : @js.Object,
) -> Unit {
  self.call("respond", [headers.to_any()]) |> ignore
}

///|
/// End the stream with data
pub fn ServerHttp2Stream::end(self : ServerHttp2Stream, data : String) -> Unit {
  self.call("end", [data]) |> ignore
}

///|
/// Write data to the stream
pub fn ClientHttp2Stream::write(
  self : ClientHttp2Stream,
  data : String,
) -> Unit {
  self.call("write", [data]) |> ignore
}

///|
/// End the client stream
pub fn ClientHttp2Stream::end(self : ClientHttp2Stream) -> Unit {
  self.call0("end") |> ignore
}

///|
/// Register 'data' event handler on client stream
pub fn ClientHttp2Stream::on_data(
  self : ClientHttp2Stream,
  callback : (@js.Object) -> Unit,
) -> ClientHttp2Stream {
  self.addEventListener("data", fn(e : @js.Any) { callback(@js.identity(e)) })
  self
}

///|
/// Register 'response' event handler on client stream
pub fn ClientHttp2Stream::on_response(
  self : ClientHttp2Stream,
  callback : (@js.Object) -> Unit,
) -> ClientHttp2Stream {
  self.addEventListener("response", fn(e : @js.Any) {
    callback(@js.identity(e))
  })
  self
}

///|
/// Register 'end' event handler on client stream
pub fn ClientHttp2Stream::on_end(
  self : ClientHttp2Stream,
  callback : () -> Unit,
) -> ClientHttp2Stream {
  self.addEventListener("end", fn(_e : @js.Any) { callback() })
  self
}
