///|

///|
/// TLS Server for accepting encrypted connections
/// https://nodejs.org/api/tls.html#class-tlsserver
#external
pub type Server

///|
pub fn Server::as_any(self : Server) -> @nostd.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn Server::as_event_target(self : Server) -> @event.EventTarget = "%identity"

///|
pub impl @js.JsImpl for Server

///|
pub impl @event.EventTargetImpl for Server with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// TLS Socket for encrypted communications
/// https://nodejs.org/api/tls.html#class-tlstlssocket
#external
pub type TLSSocket

///|
pub fn TLSSocket::as_any(self : TLSSocket) -> @nostd.Any = "%identity"

///|
/// Cast to EventTarget for event handling
pub fn TLSSocket::as_event_target(self : TLSSocket) -> @event.EventTarget = "%identity"

///|
pub impl @js.JsImpl for TLSSocket

///|
pub impl @event.EventTargetImpl for TLSSocket with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Helper function to convert Array[String] to JavaScript array
fn array_to_js_array(arr : Array[String]) -> @js.Any {
  @js.from_array(arr)
}

///|
extern "js" fn ffi_create_server(
  options : @js.Any,
  secureConnectionListener : @js.Any,
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
  let cb : @js.Any = @js.identity(secureConnectionListener)
  let alpn_js = alpn_protocols.map(fn(v) { array_to_js_array(v).as_any() })
  let opts = @js.from_option_map({
    "key": key.map(fn(x) { @js.any(x) }),
    "cert": cert.map(fn(x) { @js.any(x) }),
    "ca": ca.map(fn(x) { @js.any(x) }),
    "pfx": pfx.map(fn(x) { @js.any(x) }),
    "passphrase": passphrase.map(fn(x) { @js.any(x) }),
    "rejectUnauthorized": rejectUnauthorized.map(fn(x) { @js.any(x) }),
    "requestCert": requestCert.map(fn(x) { @js.any(x) }),
    "ALPNProtocols": alpn_js,
  })
  ffi_create_server(opts, cb)
}

///|
/// Start listening on the specified port
pub fn Server::listen(self : Server, port : Int, callback : () -> Unit) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call2("listen", port, cb) |> ignore
}

///|
/// Close the server
pub fn Server::close(self : Server, callback : () -> Unit) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("close", [cb]) |> ignore
}

///|
extern "js" fn ffi_connect(options : @js.Any, callback : @js.Any) -> TLSSocket =
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
  let cb : @js.Any = @js.identity(callback)
  let alpn_js = alpn_protocols.map(fn(v) { array_to_js_array(v).as_any() })
  let opts = @js.from_option_map({
    "port": Some(@js.any(port)),
    "host": Some(@js.any(host)),
    "servername": servername.map(fn(x) { @js.any(x) }),
    "key": key.map(fn(x) { @js.any(x) }),
    "cert": cert.map(fn(x) { @js.any(x) }),
    "ca": ca.map(fn(x) { @js.any(x) }),
    "rejectUnauthorized": rejectUnauthorized.map(fn(x) { @js.any(x) }),
    "ALPNProtocols": alpn_js,
    "session": session.map(fn(x) { x.as_any() }),
  })
  ffi_connect(opts, cb)
}

///|
/// Get the peer certificate
pub fn TLSSocket::get_peer_certificate(
  self : TLSSocket,
  detailed : Bool,
) -> @js.Object {
  let val : @js.Any = self.call("getPeerCertificate", [detailed])
  @js.identity(val)
}

///|
/// Get the cipher information
pub fn TLSSocket::get_cipher(self : TLSSocket) -> @js.Object {
  let val : @js.Any = self.call0("getCipher")
  @js.identity(val)
}

///|
/// Get the negotiated TLS protocol version
pub fn TLSSocket::get_protocol(self : TLSSocket) -> String {
  let val : @js.Any = self.call0("getProtocol")
  @js.identity(val)
}

///|
/// Check if the connection is authorized
pub fn TLSSocket::authorized(self : TLSSocket) -> Bool {
  let val : @js.Any = self.get("authorized")
  @js.identity(val)
}

///|
/// Get the authorization error if not authorized
pub fn TLSSocket::authorization_error(self : TLSSocket) -> String? {
  let val : @js.Any = self.get("authorizationError")
  let is_null : Bool = @js.identity(@js.typeof_(val) == "undefined")
  if is_null {
    None
  } else {
    Some(@js.identity(val))
  }
}

///|
/// Write data to the socket
pub fn TLSSocket::write(self : TLSSocket, data : String) -> Unit {
  self.call("write", [data]) |> ignore
}

///|
/// End the socket
pub fn TLSSocket::end(self : TLSSocket) -> Unit {
  self.call0("end") |> ignore
}

///|
/// Register 'secureConnect' event handler
pub fn TLSSocket::on_secure_connect(
  self : TLSSocket,
  callback : () -> Unit,
) -> TLSSocket {
  self.addEventListener("secureConnect", fn(_e : @js.Any) { callback() })
  self
}

///|
/// Register 'data' event handler
pub fn TLSSocket::on_data(
  self : TLSSocket,
  callback : (@js.Object) -> Unit,
) -> TLSSocket {
  self.addEventListener("data", fn(e : @js.Any) { callback(@js.identity(e)) })
  self
}

///|
/// Register 'end' event handler
pub fn TLSSocket::on_end(self : TLSSocket, callback : () -> Unit) -> TLSSocket {
  self.addEventListener("end", fn(_e : @js.Any) { callback() })
  self
}

///|
/// Register 'error' event handler
pub fn TLSSocket::on_error(
  self : TLSSocket,
  callback : (@js.Object) -> Unit,
) -> TLSSocket {
  self.addEventListener("error", fn(e : @js.Any) { callback(@js.identity(e)) })
  self
}
