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
pub fn Socket::connect(
  self : Socket,
  port : Int,
  host? : String,
  callback? : () -> Unit,
) -> Socket {
  (match (host, callback) {
    (Some(h), Some(cb)) => self.call("connect", [port, h, unsafe_cast(cb)])
    (Some(h), None) => self.call("connect", [port, h])
    (None, Some(cb)) => self.call("connect", [port, unsafe_cast(cb)])
    (None, None) => self.call("connect", [port])
  })
  |> unsafe_cast
}

///|
/// Connect the socket with options
pub fn Socket::connect_with_options(
  self : Socket,
  options : Js,
  callback? : () -> Unit,
) -> Socket {
  (match callback {
    Some(cb) => self.call("connect", [options, unsafe_cast(cb)])
    None => self.call("connect", [options])
  })
  |> unsafe_cast
}

///|
/// Write data to the socket
pub fn Socket::write(
  self : Socket,
  data : String,
  encoding? : String,
  callback? : (Js?) -> Unit,
) -> Bool {
  (match (encoding, callback) {
    (Some(enc), Some(cb)) => self.call("write", [data, enc, unsafe_cast(cb)])
    (Some(enc), None) => self.call("write", [data, enc])
    (None, Some(cb)) => self.call("write", [data, unsafe_cast(cb)])
    (None, None) => self.call("write", [data])
  })
  |> unsafe_cast
}

///|
/// End the socket connection
pub fn Socket::end(
  self : Socket,
  data? : String,
  encoding? : String,
  callback? : () -> Unit,
) -> Socket {
  (match (data, encoding, callback) {
    (Some(d), Some(enc), Some(cb)) =>
      self.call("end", [d, enc, unsafe_cast(cb)])
    (Some(d), Some(enc), None) => self.call("end", [d, enc])
    (Some(d), None, Some(cb)) => self.call("end", [d, unsafe_cast(cb)])
    (Some(d), None, None) => self.call("end", [d])
    (None, _, Some(cb)) => self.call("end", [unsafe_cast(cb)])
    (None, _, None) => self.call("end", [])
  })
  |> unsafe_cast
}

///|
/// Destroy the socket
pub fn Socket::destroy(self : Socket, error? : Js) -> Socket {
  (match error {
    Some(err) => self.call("destroy", [err])
    None => self.call("destroy", [])
  })
  |> unsafe_cast
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
pub fn Socket::setKeepAlive(
  self : Socket,
  enable : Bool,
  initialDelay? : Int,
) -> Socket {
  (match initialDelay {
    Some(delay) => self.call("setKeepAlive", [enable, delay])
    None => self.call("setKeepAlive", [enable])
  })
  |> unsafe_cast
}

///|
/// Set no delay (disable Nagle algorithm)
pub fn Socket::setNoDelay(self : Socket, noDelay : Bool) -> Socket {
  self.call("setNoDelay", [noDelay]) |> unsafe_cast
}

///|
/// Set timeout
pub fn Socket::setTimeout(
  self : Socket,
  timeout : Int,
  callback? : () -> Unit,
) -> Socket {
  (match callback {
    Some(cb) => self.call("setTimeout", [timeout, unsafe_cast(cb)])
    None => self.call("setTimeout", [timeout])
  })
  |> unsafe_cast
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
  (match (host, backlog, callback) {
    (Some(h), Some(b), Some(cb)) =>
      self.call("listen", [port, h, b, unsafe_cast(cb)])
    (Some(h), Some(b), None) => self.call("listen", [port, h, b])
    (Some(h), None, Some(cb)) => self.call("listen", [port, h, unsafe_cast(cb)])
    (Some(h), None, None) => self.call("listen", [port, h])
    (None, Some(b), Some(cb)) => self.call("listen", [port, b, unsafe_cast(cb)])
    (None, Some(b), None) => self.call("listen", [port, b])
    (None, None, Some(cb)) => self.call("listen", [port, unsafe_cast(cb)])
    (None, None, None) => self.call("listen", [port])
  })
  |> unsafe_cast
}

///|
/// Listen with options
pub fn Server::listen_with_options(
  self : Server,
  options : Js,
  callback? : () -> Unit,
) -> Server {
  (match callback {
    Some(cb) => self.call("listen", [options, unsafe_cast(cb)])
    None => self.call("listen", [options])
  })
  |> unsafe_cast
}

///|
/// Close the server
pub fn Server::close(self : Server, callback? : (Js?) -> Unit) -> Server {
  (match callback {
    Some(cb) => self.call("close", [unsafe_cast(cb)])
    None => self.call("close", [])
  })
  |> unsafe_cast
}

///|
/// Get the server address
pub fn Server::address(self : Server) -> Js? {
  self.call("address", []) |> @js.unsafe_cast_option
}

///|
/// Get connections count
pub fn Server::getConnections(
  self : Server,
  callback : (Js?, Int?) -> Unit,
) -> Unit {
  ignore(self.call("getConnections", [unsafe_cast(callback)]))
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
/// Create a new Socket
pub fn createConnection(
  port : Int,
  host? : String,
  callback? : () -> Unit,
) -> Socket {
  (match (host, callback) {
    (Some(h), Some(cb)) =>
      net_module().call("createConnection", [port, h, unsafe_cast(cb)])
    (Some(h), None) => net_module().call("createConnection", [port, h])
    (None, Some(cb)) =>
      net_module().call("createConnection", [port, unsafe_cast(cb)])
    (None, None) => net_module().call("createConnection", [port])
  })
  |> unsafe_cast
}

///|
/// Create a new Socket with options
pub fn createConnection_with_options(
  options : Js,
  callback? : () -> Unit,
) -> Socket {
  (match callback {
    Some(cb) =>
      net_module().call("createConnection", [options, unsafe_cast(cb)])
    None => net_module().call("createConnection", [options])
  })
  |> unsafe_cast
}

///|
/// Alias for createConnection
pub fn connect(port : Int, host? : String, callback? : () -> Unit) -> Socket {
  createConnection(port, host?, callback?)
}

///|
/// Alias for createConnection with options
pub fn connect_with_options(options : Js, callback? : () -> Unit) -> Socket {
  createConnection_with_options(options, callback?)
}

///|
/// Create a new Server
pub fn createServer(
  options? : Js,
  connectionListener? : (Socket) -> Unit,
) -> Server {
  (match (options, connectionListener) {
    (Some(opts), Some(listener)) =>
      net_module().call("createServer", [opts, unsafe_cast(listener)])
    (Some(opts), None) => net_module().call("createServer", [opts])
    (None, Some(listener)) =>
      net_module().call("createServer", [unsafe_cast(listener)])
    (None, None) => net_module().call("createServer", [])
  })
  |> unsafe_cast
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
