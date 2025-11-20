///|
/// node:net module
fn net_module() -> Js {
  @node.require("node:net")
}

///| Socket class

///|
#external
pub type Socket

///|
pub impl JsImpl for Socket

///|
pub impl EventEmitterImpl for Socket

///|
/// Socket is a Duplex stream
pub fn Socket::as_duplex(self : Socket) -> Duplex {
  unsafe_cast(self)
}

///|
/// Connect the socket to a port and host
pub fn Socket::connect(self : Socket, port : Int, host? : String) -> Socket {
  match host {
    Some(h) => self.call("connect", [port, h]) |> unsafe_cast
    None => self.call("connect", [port]) |> unsafe_cast
  }
}

///|
/// Write data to the socket
pub fn Socket::write(self : Socket, data : String) -> Bool {
  self.call("write", [data]) |> unsafe_cast
}

///|
/// End the socket connection
pub fn Socket::end(self : Socket) -> Socket {
  self.call("end", []) |> unsafe_cast
}

///|
/// Destroy the socket
pub fn Socket::destroy(self : Socket) -> Socket {
  self.call("destroy", []) |> unsafe_cast
}

///|
/// Pause reading data
pub fn Socket::pause(self : Socket) -> Socket {
  self.call("pause", []) |> unsafe_cast
}

///|
/// Resume reading data
pub fn Socket::resume_(self : Socket) -> Socket {
  self.call("resume", []) |> unsafe_cast
}

///|
/// Set the socket encoding
pub fn Socket::setEncoding(self : Socket, encoding : String) -> Socket {
  self.call("setEncoding", [encoding]) |> unsafe_cast
}

///|
/// Set keep alive
pub fn Socket::setKeepAlive(self : Socket, enable : Bool) -> Socket {
  self.call("setKeepAlive", [enable]) |> unsafe_cast
}

///|
/// Set no delay (disable Nagle algorithm)
pub fn Socket::setNoDelay(self : Socket, noDelay : Bool) -> Socket {
  self.call("setNoDelay", [noDelay]) |> unsafe_cast
}

///|
/// Set timeout
pub fn Socket::setTimeout(self : Socket, timeout : Int) -> Socket {
  self.call("setTimeout", [timeout]) |> unsafe_cast
}

///|
/// Get the remote address
pub fn Socket::remoteAddress(self : Socket) -> String? {
  self.get("remoteAddress") |> @js.unsafe_cast_option
}

///|
/// Get the remote port
pub fn Socket::remotePort(self : Socket) -> Int? {
  self.get("remotePort") |> @js.unsafe_cast_option
}

///|
/// Get the local address
pub fn Socket::localAddress(self : Socket) -> String? {
  self.get("localAddress") |> @js.unsafe_cast_option
}

///|
/// Get the local port
pub fn Socket::localPort(self : Socket) -> Int? {
  self.get("localPort") |> @js.unsafe_cast_option
}

///|
/// Check if the socket is destroyed
pub fn Socket::destroyed(self : Socket) -> Bool {
  self.get("destroyed") |> unsafe_cast
}

///|
/// Get bytes read
pub fn Socket::bytesRead(self : Socket) -> Int {
  self.get("bytesRead") |> unsafe_cast
}

///|
/// Get bytes written
pub fn Socket::bytesWritten(self : Socket) -> Int {
  self.get("bytesWritten") |> unsafe_cast
}

///| Server class

///|
#external
pub type Server

///|
pub impl JsImpl for Server

///|
pub impl EventEmitterImpl for Server

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
    (Some(h), Some(b)) => self.call("listen", [port, h, b]) |> unsafe_cast
    (Some(h), None) => self.call("listen", [port, h]) |> unsafe_cast
    (None, Some(b)) => self.call("listen", [port, b]) |> unsafe_cast
    (None, None) => self.call("listen", [port]) |> unsafe_cast
  }
}

///|
/// Close the server
pub fn Server::close(self : Server) -> Server {
  self.call("close", []) |> unsafe_cast
}

///|
/// Get the server address
pub fn Server::address(self : Server) -> Js? {
  self.call("address", []) |> @js.unsafe_cast_option
}

///|
/// Check if the server is listening
pub fn Server::listening(self : Server) -> Bool {
  self.get("listening") |> unsafe_cast
}

///|
/// Get max connections
pub fn Server::maxConnections(self : Server) -> Int? {
  self.get("maxConnections") |> @js.unsafe_cast_option
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
    Some(h) => net_module().call("createConnection", [port, h]) |> unsafe_cast
    None => net_module().call("createConnection", [port]) |> unsafe_cast
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
  let has_options = not(allowHalfOpen.is_empty()) ||
    not(pauseOnConnect.is_empty()) ||
    not(noDelay.is_empty()) ||
    not(keepAlive.is_empty()) ||
    not(keepAliveInitialDelay.is_empty())
  if has_options {
    net_module().call("createServer", [
      @js.from_entries_option([
        ("allowHalfOpen", allowHalfOpen.map(fn(x) { x })),
        ("pauseOnConnect", pauseOnConnect.map(fn(x) { x })),
        ("noDelay", noDelay.map(fn(x) { x })),
        ("keepAlive", keepAlive.map(fn(x) { x })),
        ("keepAliveInitialDelay", keepAliveInitialDelay.map(fn(x) { x })),
      ]),
    ])
    |> unsafe_cast
  } else {
    net_module().call("createServer", []) |> unsafe_cast
  }
}

///|
/// Check if IP address is IPv4
pub fn isIPv4(input : String) -> Bool {
  net_module().call("isIPv4", [input]) |> unsafe_cast
}

///|
/// Check if IP address is IPv6
pub fn isIPv6(input : String) -> Bool {
  net_module().call("isIPv6", [input]) |> unsafe_cast
}

///|
/// Check IP version (returns 4, 6, or 0 for invalid)
pub fn isIP(input : String) -> Int {
  net_module().call("isIP", [input]) |> unsafe_cast
}
