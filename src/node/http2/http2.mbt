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
/// Options for creating HTTP/2 server
pub struct ServerOptions {
  allow_http1 : Bool?
  max_deflate_dynamic_table_size : Int?
  max_session_memory : Int?
  max_header_list_size : Int?
  max_outstanding_pings : Int?
  max_send_header_block_length : Int?
  padding_strategy : Int?
}

///|
/// Create default server options
pub fn ServerOptions::new() -> ServerOptions {
  {
    allow_http1: None,
    max_deflate_dynamic_table_size: None,
    max_session_memory: None,
    max_header_list_size: None,
    max_outstanding_pings: None,
    max_send_header_block_length: None,
    padding_strategy: None,
  }
}

///|
/// Convert ServerOptions to JavaScript object
pub fn ServerOptions::to_js(self : ServerOptions) -> @js.Any {
  let obj = @js.Object::new()
  match self.allow_http1 {
    Some(v) => obj.set("allowHTTP1", v)
    None => ()
  }
  match self.max_deflate_dynamic_table_size {
    Some(v) => obj.set("maxDeflateDynamicTableSize", v)
    None => ()
  }
  match self.max_session_memory {
    Some(v) => obj.set("maxSessionMemory", v)
    None => ()
  }
  match self.max_header_list_size {
    Some(v) => obj.set("maxHeaderListSize", v)
    None => ()
  }
  match self.max_outstanding_pings {
    Some(v) => obj.set("maxOutstandingPings", v)
    None => ()
  }
  match self.max_send_header_block_length {
    Some(v) => obj.set("maxSendHeaderBlockLength", v)
    None => ()
  }
  match self.padding_strategy {
    Some(v) => obj.set("paddingStrategy", v)
    None => ()
  }
  obj.to_js()
}

///|
/// Secure server options (extends ServerOptions with TLS)
pub struct SecureServerOptions {
  key : String?
  cert : String?
  pfx : String?
  passphrase : String?
  allow_http1 : Bool?
}

///|
/// Create default secure server options
pub fn SecureServerOptions::new() -> SecureServerOptions {
  { key: None, cert: None, pfx: None, passphrase: None, allow_http1: None }
}

///|
/// Convert SecureServerOptions to JavaScript object
pub fn SecureServerOptions::to_js(self : SecureServerOptions) -> @js.Any {
  let obj = @js.Object::new()
  match self.key {
    Some(v) => obj.set("key", v)
    None => ()
  }
  match self.cert {
    Some(v) => obj.set("cert", v)
    None => ()
  }
  match self.pfx {
    Some(v) => obj.set("pfx", v)
    None => ()
  }
  match self.passphrase {
    Some(v) => obj.set("passphrase", v)
    None => ()
  }
  match self.allow_http1 {
    Some(v) => obj.set("allowHTTP1", v)
    None => ()
  }
  obj.to_js()
}

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
  options : ServerOptions,
  request_handler : (@js.Object, @js.Object) -> Unit,
) -> Http2Server {
  ffi_create_server(options.to_js(), @js.from_fn2(request_handler))
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
  options : SecureServerOptions,
  request_handler : (@js.Object, @js.Object) -> Unit,
) -> Http2SecureServer {
  ffi_create_secure_server(options.to_js(), @js.from_fn2(request_handler))
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
  self.call("request", [headers.to_js()]).cast()
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
  self.call("respond", [headers.to_js()]) |> ignore
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
