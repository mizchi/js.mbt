///|

///|
/// TLS Server for accepting encrypted connections
/// https://nodejs.org/api/tls.html#class-tlsserver
#external
pub type Server

///|
pub impl @js.JsImpl for Server

///|
pub impl @event.EventTargetImpl for Server

///|
/// TLS Socket for encrypted communications
/// https://nodejs.org/api/tls.html#class-tlstlssocket
#external
pub type TLSSocket

///|
pub impl @js.JsImpl for TLSSocket

///|
pub impl @event.EventTargetImpl for TLSSocket

///|
/// Options for creating a TLS server
pub struct ServerOptions {
  key : String?
  cert : String?
  ca : String?
  pfx : String?
  passphrase : String?
  rejectUnauthorized : Bool?
  requestCert : Bool?
  alpn_protocols : Array[String]?
}

///|
/// Create default server options
pub fn ServerOptions::new() -> ServerOptions {
  {
    key: None,
    cert: None,
    ca: None,
    pfx: None,
    passphrase: None,
    rejectUnauthorized: None,
    requestCert: None,
    alpn_protocols: None,
  }
}

///|
/// Convert ServerOptions to JavaScript object
pub fn ServerOptions::to_js(self : ServerOptions) -> @js.Js {
  let obj = @js.Object::new()
  match self.key {
    Some(v) => obj.set("key", v)
    None => ()
  }
  match self.cert {
    Some(v) => obj.set("cert", v)
    None => ()
  }
  match self.ca {
    Some(v) => obj.set("ca", v)
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
  match self.rejectUnauthorized {
    Some(v) => obj.set("rejectUnauthorized", v)
    None => ()
  }
  match self.requestCert {
    Some(v) => obj.set("requestCert", v)
    None => ()
  }
  match self.alpn_protocols {
    Some(v) => {
      let arr = @js.JsArray::new()
      let mut i = 0
      while i < v.length() {
        arr.call("push", [v[i]]) |> ignore
        i = i + 1
      }
      obj.set("ALPNProtocols", arr)
    }
    None => ()
  }
  obj.to_js()
}

///|
extern "js" fn ffi_create_server(
  options : @js.Js,
  secureConnectionListener : @js.Js,
) -> Server =
  #| (options, secureConnectionListener) => {
  #|   const tls = require('tls');
  #|   return tls.createServer(options, secureConnectionListener);
  #| }

///|
/// Create a TLS server
pub fn create_server(
  options : ServerOptions,
  secureConnectionListener : (TLSSocket) -> Unit,
) -> Server {
  let cb : @js.Js = @js.unsafe_cast(secureConnectionListener)
  ffi_create_server(options.to_js(), cb)
}

///|
/// Start listening on the specified port
pub fn Server::listen(self : Server, port : Int, callback : () -> Unit) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  self.call2("listen", port, cb) |> ignore
}

///|
/// Close the server
pub fn Server::close(self : Server, callback : () -> Unit) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  self.call("close", [cb]) |> ignore
}

///|
/// Options for TLS connection
pub struct ConnectOptions {
  host : String?
  port : Int?
  servername : String?
  key : String?
  cert : String?
  ca : String?
  rejectUnauthorized : Bool?
  alpn_protocols : Array[String]?
  session : @js.Object?
}

///|
/// Create default connect options
pub fn ConnectOptions::new(port : Int, host : String) -> ConnectOptions {
  {
    host: Some(host),
    port: Some(port),
    servername: None,
    key: None,
    cert: None,
    ca: None,
    rejectUnauthorized: None,
    alpn_protocols: None,
    session: None,
  }
}

///|
/// Convert ConnectOptions to JavaScript object
pub fn ConnectOptions::to_js(self : ConnectOptions) -> @js.Js {
  let obj = @js.Object::new()
  match self.host {
    Some(v) => obj.set("host", v)
    None => ()
  }
  match self.port {
    Some(v) => obj.set("port", v)
    None => ()
  }
  match self.servername {
    Some(v) => obj.set("servername", v)
    None => ()
  }
  match self.key {
    Some(v) => obj.set("key", v)
    None => ()
  }
  match self.cert {
    Some(v) => obj.set("cert", v)
    None => ()
  }
  match self.ca {
    Some(v) => obj.set("ca", v)
    None => ()
  }
  match self.rejectUnauthorized {
    Some(v) => obj.set("rejectUnauthorized", v)
    None => ()
  }
  match self.alpn_protocols {
    Some(v) => {
      let arr = @js.JsArray::new()
      let mut i = 0
      while i < v.length() {
        arr.call("push", [v[i]]) |> ignore
        i = i + 1
      }
      obj.set("ALPNProtocols", arr)
    }
    None => ()
  }
  match self.session {
    Some(v) => obj.set("session", v)
    None => ()
  }
  obj.to_js()
}

///|
extern "js" fn ffi_connect(options : @js.Js, callback : @js.Js) -> TLSSocket =
  #| (options, callback) => {
  #|   const tls = require('tls');
  #|   return tls.connect(options, callback);
  #| }

///|
/// Connect to a TLS server
pub fn connect(options : ConnectOptions, callback : () -> Unit) -> TLSSocket {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_connect(options.to_js(), cb)
}

///|
/// Get the peer certificate
pub fn TLSSocket::get_peer_certificate(
  self : TLSSocket,
  detailed : Bool,
) -> @js.Object {
  let val : @js.Js = self.call("getPeerCertificate", [detailed])
  @js.unsafe_cast(val)
}

///|
/// Get the cipher information
pub fn TLSSocket::get_cipher(self : TLSSocket) -> @js.Object {
  let val : @js.Js = self.call0("getCipher")
  @js.unsafe_cast(val)
}

///|
/// Get the negotiated TLS protocol version
pub fn TLSSocket::get_protocol(self : TLSSocket) -> String {
  let val : @js.Js = self.call0("getProtocol")
  @js.unsafe_cast(val)
}

///|
/// Check if the connection is authorized
pub fn TLSSocket::authorized(self : TLSSocket) -> Bool {
  let val : @js.Js = self.get("authorized")
  @js.unsafe_cast(val)
}

///|
/// Get the authorization error if not authorized
pub fn TLSSocket::authorization_error(self : TLSSocket) -> String? {
  let val : @js.Js = self.get("authorizationError")
  let is_null : Bool = @js.unsafe_cast(@js.typeof_(val) == "undefined")
  if is_null {
    None
  } else {
    Some(@js.unsafe_cast(val))
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
  self.addEventListener("secureConnect", fn(_e : @js.Js) { callback() })
  self
}

///|
/// Register 'data' event handler
pub fn TLSSocket::on_data(
  self : TLSSocket,
  callback : (@js.Object) -> Unit,
) -> TLSSocket {
  self.addEventListener("data", fn(e : @js.Js) { callback(@js.unsafe_cast(e)) })
  self
}

///|
/// Register 'end' event handler
pub fn TLSSocket::on_end(self : TLSSocket, callback : () -> Unit) -> TLSSocket {
  self.addEventListener("end", fn(_e : @js.Js) { callback() })
  self
}

///|
/// Register 'error' event handler
pub fn TLSSocket::on_error(
  self : TLSSocket,
  callback : (@js.Object) -> Unit,
) -> TLSSocket {
  self.addEventListener("error", fn(e : @js.Js) { callback(@js.unsafe_cast(e)) })
  self
}
