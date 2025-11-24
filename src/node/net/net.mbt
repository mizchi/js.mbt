///|
/// node:net module
fn net_module() -> @js.Any {
  @node.require("node:net")
}

///| Socket class

///|
#external
pub type Socket

///|
pub impl @js.JsImpl for Socket

///|
pub impl @events.EventEmitterImpl for Socket

///|
/// Socket is a Duplex stream
pub fn Socket::as_duplex(self : Socket) -> @stream.Duplex {
  @js.identity(self)
}

///|
/// Connect the socket to a port and host
pub fn Socket::connect(self : Socket, port : Int, host? : String) -> Socket {
  match host {
    Some(h) => self.call2("connect", port, h) |> @js.identity
    None => self.call("connect", [port]).cast()
  }
}

///|
/// Write data to the socket
pub fn Socket::write(self : Socket, data : String) -> Bool {
  self.call("write", [data]).cast()
}

///|
/// End the socket connection
pub fn Socket::end(self : Socket) -> Socket {
  self.call0("end") |> @js.identity
}

///|
/// Destroy the socket
pub fn Socket::destroy(self : Socket) -> Socket {
  self.call0("destroy") |> @js.identity
}

///|
/// Pause reading data
pub fn Socket::pause(self : Socket) -> Socket {
  self.call0("pause") |> @js.identity
}

///|
/// Resume reading data
pub fn Socket::resume_(self : Socket) -> Socket {
  self.call0("resume") |> @js.identity
}

///|
/// Set the socket encoding
pub fn Socket::setEncoding(self : Socket, encoding : String) -> Socket {
  self.call("setEncoding", [encoding]).cast()
}

///|
/// Set keep alive
pub fn Socket::setKeepAlive(self : Socket, enable : Bool) -> Socket {
  self.call("setKeepAlive", [enable]).cast()
}

///|
/// Set no delay (disable Nagle algorithm)
pub fn Socket::setNoDelay(self : Socket, noDelay : Bool) -> Socket {
  self.call("setNoDelay", [noDelay]).cast()
}

///|
/// Set timeout
pub fn Socket::setTimeout(self : Socket, timeout : Int) -> Socket {
  self.call("setTimeout", [timeout]).cast()
}

///|
/// Get the remote address
pub fn Socket::remoteAddress(self : Socket) -> String? {
  self.get("remoteAddress") |> @js.identity_option
}

///|
/// Get the remote port
pub fn Socket::remotePort(self : Socket) -> Int? {
  self.get("remotePort") |> @js.identity_option
}

///|
/// Get the local address
pub fn Socket::localAddress(self : Socket) -> String? {
  self.get("localAddress") |> @js.identity_option
}

///|
/// Get the local port
pub fn Socket::localPort(self : Socket) -> Int? {
  self.get("localPort") |> @js.identity_option
}

///|
/// Check if the socket is destroyed
pub fn Socket::destroyed(self : Socket) -> Bool {
  self.get("destroyed").cast()
}

///|
/// Get bytes read
pub fn Socket::bytesRead(self : Socket) -> Int {
  self.get("bytesRead").cast()
}

///|
/// Get bytes written
pub fn Socket::bytesWritten(self : Socket) -> Int {
  self.get("bytesWritten").cast()
}

///| Server class

///|
#external
pub type Server

///|
pub impl @js.JsImpl for Server

///|
pub impl @events.EventEmitterImpl for Server

///|
/// Listen on a port and host
pub fn Server::listen(
  self : Server,
  port : Int,
  host? : String,
  backlog? : Int,
  callback? : () -> Unit,
) -> Server {
  // Register callback as 'listening' event listener if provided
  match callback {
    Some(cb) => self.once("listening", fn(_) { cb() })
    None => ()
  }

  // Call listen with port, host, and backlog
  match (host, backlog) {
    (Some(h), Some(b)) => self.call("listen", [port, h, b]).cast()
    (Some(h), None) => self.call2("listen", port, h) |> @js.identity
    (None, Some(b)) => self.call2("listen", port, b) |> @js.identity
    (None, None) => self.call("listen", [port]).cast()
  }
}

///|
/// Close the server
pub fn Server::close(self : Server) -> Server {
  self.call0("close") |> @js.identity
}

///|
/// Get the server address
pub fn Server::address(self : Server) -> @js.Any? {
  self.call0("address") |> @js.identity_option
}

///|
/// Check if the server is listening
pub fn Server::listening(self : Server) -> Bool {
  self.get("listening").cast()
}

///|
/// Get max connections
pub fn Server::maxConnections(self : Server) -> Int? {
  self.get("maxConnections") |> @js.identity_option
}

///|
/// Set max connections
pub fn Server::set_maxConnections(self : Server, max : Int) -> Unit {
  self.set("maxConnections", max |> @js.js)
}

///| Module functions

///|
/// Create a new Socket and connect
pub fn createConnection(port : Int, host? : String) -> Socket {
  match host {
    Some(h) => net_module().call2("createConnection", port, h) |> @js.identity
    None => net_module().call("createConnection", [port]).cast()
  }
}

///|
/// Alias for createConnection
pub fn connect(port : Int, host? : String) -> Socket {
  createConnection(port, host?)
}

///|
/// Create a new Server with options
pub fn createServer(
  allowHalfOpen? : Bool,
  pauseOnConnect? : Bool,
  noDelay? : Bool,
  keepAlive? : Bool,
  keepAliveInitialDelay? : Int,
) -> Server {
  let has_options = allowHalfOpen is Some(_) ||
    pauseOnConnect is Some(_) ||
    noDelay is Some(_) ||
    keepAlive is Some(_) ||
    keepAliveInitialDelay is Some(_)
  if has_options {
    net_module().call("createServer", [
      @js.from_entries_option([
        ("allowHalfOpen", allowHalfOpen.map(x => x)),
        ("pauseOnConnect", pauseOnConnect.map(x => x)),
        ("noDelay", noDelay.map(x => x)),
        ("keepAlive", keepAlive.map(x => x)),
        ("keepAliveInitialDelay", keepAliveInitialDelay.map(x => x)),
      ]),
    ])
    |> @js.identity
  } else {
    net_module().call0("createServer") |> @js.identity
  }
}

///|
/// Check if IP address is IPv4
pub fn isIPv4(input : String) -> Bool {
  net_module().call("isIPv4", [input]).cast()
}

///|
/// Check if IP address is IPv6
pub fn isIPv6(input : String) -> Bool {
  net_module().call("isIPv6", [input]).cast()
}

///|
/// Check IP version (returns 4, 6, or 0 for invalid)
pub fn isIP(input : String) -> Int {
  net_module().call("isIP", [input]).cast()
}
