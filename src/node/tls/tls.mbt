///|

///|
/// TLS Server for accepting encrypted connections
/// https://nodejs.org/api/tls.html#class-tlsserver
#external
pub type Server

///|
pub fn Server::as_any(self : Server) -> @core.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn Server::as_event_target(self : Server) -> @event.EventTarget = "%identity"

///|
/// TLS Socket for encrypted communications
/// https://nodejs.org/api/tls.html#class-tlstlssocket
#external
pub type TLSSocket

///|
pub fn TLSSocket::as_any(self : TLSSocket) -> @core.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn TLSSocket::as_event_target(self : TLSSocket) -> @event.EventTarget = "%identity"

///|
/// Helper function to convert Array[String] to JavaScript array
fn array_to_js_array(arr : Array[String]) -> @core.Any {
  @core.any(arr)
}

///|
extern "js" fn ffi_create_server(
  options : @core.Any,
  secureConnectionListener : @core.Any,
) -> Server =
  #| (options, secureConnectionListener) => {
  #|   const tls = require('tls');
  #|   return tls.createServer(options, secureConnectionListener);
  #| }

///|
/// Create a TLS server
pub fn create_server(
  secureConnectionListener : (TLSSocket) -> Unit,
  key? : String,
  cert? : String,
  ca? : String,
  pfx? : String,
  passphrase? : String,
  rejectUnauthorized? : Bool,
  requestCert? : Bool,
  alpn_protocols? : Array[String],
) -> Server {
  let cb : @core.Any = @core.identity(secureConnectionListener)
  let alpn_js = alpn_protocols.map(fn(v) -> @core.Any {
    @core.identity(array_to_js_array(v))
  })
  let entries : Array[(String, @core.Any)] = []
  if key is Some(v) {
    entries.push(("key", @core.any(v)))
  }
  if cert is Some(v) {
    entries.push(("cert", @core.any(v)))
  }
  if ca is Some(v) {
    entries.push(("ca", @core.any(v)))
  }
  if pfx is Some(v) {
    entries.push(("pfx", @core.any(v)))
  }
  if passphrase is Some(v) {
    entries.push(("passphrase", @core.any(v)))
  }
  if rejectUnauthorized is Some(v) {
    entries.push(("rejectUnauthorized", @core.any(v)))
  }
  if requestCert is Some(v) {
    entries.push(("requestCert", @core.any(v)))
  }
  if alpn_js is Some(v) {
    entries.push(("ALPNProtocols", @core.identity(v)))
  }
  let opts = @core.from_entries(entries).cast()
  ffi_create_server(opts, cb)
}

///|
/// Start listening on the specified port
pub fn Server::listen(self : Server, port : Int, callback : () -> Unit) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("listen", [@core.any(port), cb]) |> ignore
}

///|
/// Close the server
pub fn Server::close(self : Server, callback : () -> Unit) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("close", [cb]) |> ignore
}

///|
extern "js" fn ffi_connect(
  options : @core.Any,
  callback : @core.Any,
) -> TLSSocket =
  #| (options, callback) => {
  #|   const tls = require('tls');
  #|   return tls.connect(options, callback);
  #| }

///|
/// Connect to a TLS server
pub fn connect(
  port : Int,
  host : String,
  callback : () -> Unit,
  servername? : String,
  key? : String,
  cert? : String,
  ca? : String,
  rejectUnauthorized? : Bool,
  alpn_protocols? : Array[String],
  session? : @js.Object,
) -> TLSSocket {
  let cb : @core.Any = @core.identity(callback)
  let alpn_js = alpn_protocols.map(fn(v) -> @core.Any {
    @core.identity(array_to_js_array(v))
  })
  let entries : Array[(String, @core.Any)] = []
  entries.push(("port", @core.any(port)))
  entries.push(("host", @core.any(host)))
  if servername is Some(v) {
    entries.push(("servername", @core.any(v)))
  }
  if key is Some(v) {
    entries.push(("key", @core.any(v)))
  }
  if cert is Some(v) {
    entries.push(("cert", @core.any(v)))
  }
  if ca is Some(v) {
    entries.push(("ca", @core.any(v)))
  }
  if rejectUnauthorized is Some(v) {
    entries.push(("rejectUnauthorized", @core.any(v)))
  }
  if alpn_js is Some(v) {
    entries.push(("ALPNProtocols", @core.identity(v)))
  }
  if session is Some(v) {
    entries.push(("session", @core.identity(@core.any(v))))
  }
  let opts = @core.from_entries(entries).cast()
  ffi_connect(opts, cb)
}

///|
/// Get the peer certificate
pub fn TLSSocket::get_peer_certificate(
  self : TLSSocket,
  detailed : Bool,
) -> @js.Object {
  let val : @core.Any = self
    .as_any()
    ._call("getPeerCertificate", [@core.any(detailed)])
  @core.identity(val)
}

///|
/// Get the cipher information
pub fn TLSSocket::get_cipher(self : TLSSocket) -> @js.Object {
  let val : @core.Any = self.as_any()._call("getCipher", [])
  @core.identity(val)
}

///|
/// Get the negotiated TLS protocol version
pub fn TLSSocket::get_protocol(self : TLSSocket) -> String {
  let val : @core.Any = self.as_any()._call("getProtocol", [])
  @core.identity(val)
}

///|
/// Check if the connection is authorized
pub fn TLSSocket::authorized(self : TLSSocket) -> Bool {
  let val : @core.Any = self.as_any()._get("authorized")
  @core.identity(val)
}

///|
/// Get the authorization error if not authorized
pub fn TLSSocket::authorization_error(self : TLSSocket) -> String? {
  let val : @core.Any = self.as_any()._get("authorizationError")
  let is_null : Bool = @core.identity(@core.typeof_(val) == "undefined")
  if is_null {
    None
  } else {
    Some(@core.identity(val))
  }
}

///|
/// Write data to the socket
pub fn TLSSocket::write(self : TLSSocket, data : String) -> Unit {
  self.as_any()._call("write", [@core.any(data)]) |> ignore
}

///|
/// End the socket
pub fn TLSSocket::end(self : TLSSocket) -> Unit {
  self.as_any()._call("end", []) |> ignore
}

///|
/// Register 'secureConnect' event handler
pub fn TLSSocket::on_secure_connect(
  self : TLSSocket,
  callback : () -> Unit,
) -> TLSSocket {
  self
  .as_event_target()
  .addEventListener("secureConnect", fn(_e : @core.Any) { callback() })
  self
}

///|
/// Register 'data' event handler
pub fn TLSSocket::on_data(
  self : TLSSocket,
  callback : (@js.Object) -> Unit,
) -> TLSSocket {
  self
  .as_event_target()
  .addEventListener("data", fn(e : @core.Any) { callback(@core.identity(e)) })
  self
}

///|
/// Register 'end' event handler
pub fn TLSSocket::on_end(self : TLSSocket, callback : () -> Unit) -> TLSSocket {
  self
  .as_event_target()
  .addEventListener("end", fn(_e : @core.Any) { callback() })
  self
}

///|
/// Register 'error' event handler
pub fn TLSSocket::on_error(
  self : TLSSocket,
  callback : (@js.Object) -> Unit,
) -> TLSSocket {
  self
  .as_event_target()
  .addEventListener("error", fn(e : @core.Any) { callback(@core.identity(e)) })
  self
}
