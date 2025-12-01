///|
/// node:net module
extern "js" fn net_module() -> @js.Any =
  #| () => require("node:net")

///|
/// AddressInfo - Result of server.address() when listening on TCP
#external
pub type AddressInfo

///|
pub fn AddressInfo::as_any(self : AddressInfo) -> @nostd.Any = "%identity"

///|
/// Get the port number
pub fn AddressInfo::port(self : AddressInfo) -> Int {
  self.as_any()["port"].cast()
}

///|
/// Get the IP address (e.g., "127.0.0.1" or "::1")
pub fn AddressInfo::address(self : AddressInfo) -> String {
  self.as_any()["address"].cast()
}

///|
/// Get the IP family ("IPv4" or "IPv6")
pub fn AddressInfo::family(self : AddressInfo) -> String {
  self.as_any()["family"].cast()
}

///| Socket class

///|
#external
pub type Socket

///|
pub fn Socket::as_any(self : Socket) -> @nostd.Any = "%identity"

///|
/// Note: Keep JsImpl for EventEmitterImpl compatibility
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
    Some(h) =>
      self.as_any()._call("connect", [@nostd.any(port), @nostd.any(h)]).cast()
    None => self.as_any()._call("connect", [@nostd.any(port)]).cast()
  }
}

///|
/// Write data to the socket
pub fn Socket::write(self : Socket, data : String) -> Bool {
  self.as_any()._call("write", [@nostd.any(data)]).cast()
}

///|
/// End the socket connection
pub fn Socket::end(self : Socket) -> Socket {
  self.as_any()._call("end", []).cast()
}

///|
/// Destroy the socket
pub fn Socket::destroy(self : Socket) -> Socket {
  self.as_any()._call("destroy", []).cast()
}

///|
/// Pause reading data
pub fn Socket::pause(self : Socket) -> Socket {
  self.as_any()._call("pause", []).cast()
}

///|
/// Resume reading data
pub fn Socket::resume_(self : Socket) -> Socket {
  self.as_any()._call("resume", []).cast()
}

///|
/// Set the socket encoding
pub fn Socket::setEncoding(self : Socket, encoding : String) -> Socket {
  self.as_any()._call("setEncoding", [@nostd.any(encoding)]).cast()
}

///|
/// Set keep alive
pub fn Socket::setKeepAlive(self : Socket, enable : Bool) -> Socket {
  self.as_any()._call("setKeepAlive", [@nostd.any(enable)]).cast()
}

///|
/// Set no delay (disable Nagle algorithm)
pub fn Socket::setNoDelay(self : Socket, noDelay : Bool) -> Socket {
  self.as_any()._call("setNoDelay", [@nostd.any(noDelay)]).cast()
}

///|
/// Set timeout
pub fn Socket::setTimeout(self : Socket, timeout : Int) -> Socket {
  self.as_any()._call("setTimeout", [@nostd.any(timeout)]).cast()
}

///|
/// Get the remote address
pub fn Socket::remoteAddress(self : Socket) -> String? {
  self.as_any()["remoteAddress"] |> @nostd.identity_option
}

///|
/// Get the remote port
pub fn Socket::remotePort(self : Socket) -> Int? {
  self.as_any()["remotePort"] |> @nostd.identity_option
}

///|
/// Get the local address
pub fn Socket::localAddress(self : Socket) -> String? {
  self.as_any()["localAddress"] |> @nostd.identity_option
}

///|
/// Get the local port
pub fn Socket::localPort(self : Socket) -> Int? {
  self.as_any()["localPort"] |> @nostd.identity_option
}

///|
/// Check if the socket is destroyed
pub fn Socket::destroyed(self : Socket) -> Bool {
  self.as_any()["destroyed"].cast()
}

///|
/// Get bytes read
pub fn Socket::bytesRead(self : Socket) -> Int {
  self.as_any()["bytesRead"].cast()
}

///|
/// Get bytes written
pub fn Socket::bytesWritten(self : Socket) -> Int {
  self.as_any()["bytesWritten"].cast()
}

///| Server class

///|
#external
pub type Server

///|
pub fn Server::as_any(self : Server) -> @nostd.Any = "%identity"

///|
/// Note: Keep JsImpl for EventEmitterImpl compatibility
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
/// Returns AddressInfo for TCP servers, or null if not listening
pub fn Server::address(self : Server) -> AddressInfo? {
  let result = self.call0("address")
  if @js.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
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
  self.set("maxConnections", max |> @js.any)
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
      @js.from_option_map({
        "allowHalfOpen": allowHalfOpen.map(fn(x) { @js.any(x) }),
        "pauseOnConnect": pauseOnConnect.map(fn(x) { @js.any(x) }),
        "noDelay": noDelay.map(fn(x) { @js.any(x) }),
        "keepAlive": keepAlive.map(fn(x) { @js.any(x) }),
        "keepAliveInitialDelay": keepAliveInitialDelay.map(fn(x) { @js.any(x) }),
      }),
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
