///|
/// node:net module
extern "js" fn net_module() -> @nostd.Any =
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
/// Note: Keep JsImpl for compatibility
///|
/// Socket is a Duplex stream
pub fn Socket::as_duplex(self : Socket) -> @stream.Duplex {
  @nostd.identity(self)
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
/// Note: Keep JsImpl for compatibility
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
    Some(cb) =>
      self.as_any()._call("once", [
        @nostd.any("listening"),
        @nostd.any(@js.from_fn1(fn(_ : @nostd.Any) { cb() })),
      ]) |> ignore
    None => ()
  }

  // Call listen with port, host, and backlog
  match (host, backlog) {
    (Some(h), Some(b)) =>
      self
      .as_any()
      ._call("listen", [@nostd.any(port), @nostd.any(h), @nostd.any(b)])
      .cast()
    (Some(h), None) =>
      self.as_any().call2("listen", @nostd.any(port), @nostd.any(h)) |> @nostd.identity
    (None, Some(b)) =>
      self.as_any().call2("listen", @nostd.any(port), @nostd.any(b)) |> @nostd.identity
    (None, None) => self.as_any()._call("listen", [@nostd.any(port)]).cast()
  }
}

///|
/// Close the server
pub fn Server::close(self : Server) -> Server {
  self.as_any().call0("close") |> @nostd.identity
}

///|
/// Get the server address
/// Returns AddressInfo for TCP servers, or null if not listening
pub fn Server::address(self : Server) -> AddressInfo? {
  let result = self.as_any().call0("address")
  if @js.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Check if the server is listening
pub fn Server::listening(self : Server) -> Bool {
  self.as_any()._get("listening").cast()
}

///|
/// Get max connections
pub fn Server::maxConnections(self : Server) -> Int? {
  self.as_any()._get("maxConnections") |> @nostd.identity_option
}

///|
/// Set max connections
pub fn Server::set_maxConnections(self : Server, max : Int) -> Unit {
  self.as_any()._set("maxConnections", @nostd.any(max))
}

///| Module functions

///|
/// Create a new Socket and connect
pub fn createConnection(port : Int, host? : String) -> Socket {
  match host {
    Some(h) =>
      net_module()
      .call2("createConnection", @nostd.any(port), @nostd.any(h))
      |> @nostd.identity
    None => net_module()._call("createConnection", [@nostd.any(port)]).cast()
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
    let opts : @nostd.Any = @mbtconv.from_option_map({
      "allowHalfOpen": allowHalfOpen.map(fn(x) { @nostd.any(x) }),
      "pauseOnConnect": pauseOnConnect.map(fn(x) { @nostd.any(x) }),
      "noDelay": noDelay.map(fn(x) { @nostd.any(x) }),
      "keepAlive": keepAlive.map(fn(x) { @nostd.any(x) }),
      "keepAliveInitialDelay": keepAliveInitialDelay.map(fn(x) { @nostd.any(x) }),
    }).cast()
    net_module().call1("createServer", opts) |> @nostd.identity
  } else {
    net_module().call0("createServer") |> @nostd.identity
  }
}

///|
/// Check if IP address is IPv4
pub fn isIPv4(input : String) -> Bool {
  net_module()._call("isIPv4", [@nostd.any(input)]).cast()
}

///|
/// Check if IP address is IPv6
pub fn isIPv6(input : String) -> Bool {
  net_module()._call("isIPv6", [@nostd.any(input)]).cast()
}

///|
/// Check IP version (returns 4, 6, or 0 for invalid)
pub fn isIP(input : String) -> Int {
  net_module()._call("isIP", [@nostd.any(input)]).cast()
}
