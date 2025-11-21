///|
/// node:http module
fn http_module() -> Js {
  @node.require("node:http")
}

///| IncomingMessage class

///|
#external
pub type IncomingMessage

///|
pub impl JsImpl for IncomingMessage

///|
pub impl EventEmitterImpl for IncomingMessage

///|
/// IncomingMessage is a Readable stream
pub fn IncomingMessage::as_readable(self : IncomingMessage) -> Readable {
  unsafe_cast(self)
}

///|
/// Get HTTP version
pub fn IncomingMessage::httpVersion(self : IncomingMessage) -> String {
  self.get("httpVersion") |> unsafe_cast
}

///|
/// Get HTTP method
pub fn IncomingMessage::method_(self : IncomingMessage) -> String? {
  self.get("method") |> @js.unsafe_cast_option
}

///|
/// Get URL
pub fn IncomingMessage::url(self : IncomingMessage) -> String? {
  self.get("url") |> @js.unsafe_cast_option
}

///|
/// Get headers
pub fn IncomingMessage::headers(self : IncomingMessage) -> Js {
  self.get("headers")
}

///|
/// Get raw headers
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn IncomingMessage::rawHeaders(self : IncomingMessage) -> Array[String] {
  self.get("rawHeaders") |> unsafe_cast
}

///|
/// Get status code
pub fn IncomingMessage::statusCode(self : IncomingMessage) -> Int? {
  self.get("statusCode") |> @js.unsafe_cast_option
}

///|
/// Get status message
pub fn IncomingMessage::statusMessage(self : IncomingMessage) -> String? {
  self.get("statusMessage") |> @js.unsafe_cast_option
}

///|
/// Get socket
pub fn IncomingMessage::socket(self : IncomingMessage) -> Socket {
  self.get("socket") |> unsafe_cast
}

///|
/// Set timeout
pub fn IncomingMessage::setTimeout(
  self : IncomingMessage,
  msecs : Int,
  callback? : () -> Unit,
) -> IncomingMessage {
  match callback {
    Some(cb) => self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> unsafe_cast
    None => self.call("setTimeout", [msecs]) |> unsafe_cast
  }
}

///| ServerResponse class

///|
#external
pub type ServerResponse

///|
pub impl JsImpl for ServerResponse

///|
pub impl EventEmitterImpl for ServerResponse

///|
/// ServerResponse is a Writable stream
pub fn ServerResponse::as_writable(self : ServerResponse) -> Writable {
  unsafe_cast(self)
}

///|
/// Write response head
pub fn ServerResponse::writeHead(
  self : ServerResponse,
  statusCode : Int,
  statusMessage? : String,
  headers? : Js,
) -> ServerResponse {
  match (statusMessage, headers) {
    (Some(msg), Some(hdrs)) =>
      self.call("writeHead", [statusCode, msg, hdrs]) |> unsafe_cast
    (Some(msg), None) => self.call2("writeHead", statusCode, msg) |> unsafe_cast
    (None, Some(hdrs)) =>
      self.call2("writeHead", statusCode, hdrs) |> unsafe_cast
    (None, None) => self.call("writeHead", [statusCode]) |> unsafe_cast
  }
}

///|
/// Write data to response
pub fn ServerResponse::write(
  self : ServerResponse,
  chunk : String,
  encoding? : String,
) -> Bool {
  match encoding {
    Some(enc) => self.call2("write", chunk, enc) |> unsafe_cast
    None => self.call("write", [chunk]) |> unsafe_cast
  }
}

///|
/// End response
pub fn ServerResponse::end(
  self : ServerResponse,
  data? : String,
  encoding? : String,
) -> Unit {
  match (data, encoding) {
    (Some(d), Some(enc)) => self.call2("end", d, enc) |> ignore
    (Some(d), None) => self.call("end", [d]) |> ignore
    (None, _) => self.call0("end") |> ignore
  }
}

///|
/// Set header
pub fn ServerResponse::setHeader(
  self : ServerResponse,
  name : String,
  value : String,
) -> Unit {
  self.call2("setHeader", name, value) |> ignore
}

///|
/// Get header
pub fn ServerResponse::getHeader(
  self : ServerResponse,
  name : String,
) -> String? {
  self.call("getHeader", [name]) |> @js.unsafe_cast_option
}

///|
/// Remove header
pub fn ServerResponse::removeHeader(
  self : ServerResponse,
  name : String,
) -> Unit {
  self.call("removeHeader", [name]) |> ignore
}

///|
/// Get headers sent status
pub fn ServerResponse::headersSent(self : ServerResponse) -> Bool {
  self.get("headersSent") |> unsafe_cast
}

///|
/// Get status code
pub fn ServerResponse::statusCode(self : ServerResponse) -> Int {
  self.get("statusCode") |> unsafe_cast
}

///|
/// Set status code
pub fn ServerResponse::set_statusCode(
  self : ServerResponse,
  code : Int,
) -> Unit {
  self.set("statusCode", code |> @js.js)
}

///|
/// Get status message
pub fn ServerResponse::statusMessage(self : ServerResponse) -> String {
  self.get("statusMessage") |> unsafe_cast
}

///|
/// Set status message
pub fn ServerResponse::set_statusMessage(
  self : ServerResponse,
  message : String,
) -> Unit {
  self.set("statusMessage", message)
}

///|
/// Set timeout
pub fn ServerResponse::setTimeout(
  self : ServerResponse,
  msecs : Int,
  callback? : () -> Unit,
) -> ServerResponse {
  match callback {
    Some(cb) => self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> unsafe_cast
    None => self.call("setTimeout", [msecs]) |> unsafe_cast
  }
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
    (Some(h), None) => self.call2("listen", port, h) |> unsafe_cast
    (None, Some(b)) => self.call2("listen", port, b) |> unsafe_cast
    (None, None) => self.call("listen", [port]) |> unsafe_cast
  }
}

///|
/// Close the server
pub fn Server::close(self : Server, callback? : () -> Unit) -> Server {
  match callback {
    Some(cb) => self.call("close", [@js.from_fn0(cb)]) |> unsafe_cast
    None => self.call0("close") |> unsafe_cast
  }
}

///|
/// Get the server address
pub fn Server::address(self : Server) -> Js? {
  self.call0("address") |> @js.unsafe_cast_option
}

///|
/// Check if the server is listening
pub fn Server::listening(self : Server) -> Bool {
  self.get("listening") |> unsafe_cast
}

///|
/// Get max headers count
pub fn Server::maxHeadersCount(self : Server) -> Int? {
  self.get("maxHeadersCount") |> @js.unsafe_cast_option
}

///|
/// Set max headers count
pub fn Server::set_maxHeadersCount(self : Server, max : Int) -> Unit {
  self.set("maxHeadersCount", max |> @js.js)
}

///|
/// Set timeout
pub fn Server::setTimeout(
  self : Server,
  msecs : Int,
  callback? : () -> Unit,
) -> Server {
  match callback {
    Some(cb) => self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> unsafe_cast
    None => self.call("setTimeout", [msecs]) |> unsafe_cast
  }
}

///|
/// Get timeout
pub fn Server::timeout(self : Server) -> Int {
  self.get("timeout") |> unsafe_cast
}

///|
/// Set timeout value
pub fn Server::set_timeout(self : Server, msecs : Int) -> Unit {
  self.set("timeout", msecs |> @js.js)
}

///| ClientRequest class

///|
#external
pub type ClientRequest

///|
pub impl JsImpl for ClientRequest

///|
pub impl EventEmitterImpl for ClientRequest

///|
/// ClientRequest is a Writable stream
pub fn ClientRequest::as_writable(self : ClientRequest) -> Writable {
  unsafe_cast(self)
}

///|
/// Write data to request
pub fn ClientRequest::write(
  self : ClientRequest,
  chunk : String,
  encoding? : String,
) -> Bool {
  match encoding {
    Some(enc) => self.call2("write", chunk, enc) |> unsafe_cast
    None => self.call("write", [chunk]) |> unsafe_cast
  }
}

///|
/// End request
pub fn ClientRequest::end(
  self : ClientRequest,
  data? : String,
  encoding? : String,
) -> Unit {
  match (data, encoding) {
    (Some(d), Some(enc)) => self.call2("end", d, enc) |> ignore
    (Some(d), None) => self.call("end", [d]) |> ignore
    (None, _) => self.call0("end") |> ignore
  }
}

///|
/// Abort request
pub fn ClientRequest::abort(self : ClientRequest) -> Unit {
  self.call0("abort") |> ignore
}

///|
/// Set header
pub fn ClientRequest::setHeader(
  self : ClientRequest,
  name : String,
  value : String,
) -> Unit {
  self.call2("setHeader", name, value) |> ignore
}

///|
/// Get header
pub fn ClientRequest::getHeader(self : ClientRequest, name : String) -> String? {
  self.call("getHeader", [name]) |> @js.unsafe_cast_option
}

///|
/// Remove header
pub fn ClientRequest::removeHeader(self : ClientRequest, name : String) -> Unit {
  self.call("removeHeader", [name]) |> ignore
}

///|
/// Set timeout
pub fn ClientRequest::setTimeout(
  self : ClientRequest,
  msecs : Int,
  callback? : () -> Unit,
) -> ClientRequest {
  match callback {
    Some(cb) => self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> unsafe_cast
    None => self.call("setTimeout", [msecs]) |> unsafe_cast
  }
}

///| Module functions

///|
/// Create HTTP server
pub fn createServer(
  requestListener? : (IncomingMessage, ServerResponse) -> Unit,
) -> Server {
  match requestListener {
    Some(listener) =>
      http_module().call("createServer", [@js.from_fn2(listener)])
      |> unsafe_cast
    None => http_module().call0("createServer") |> unsafe_cast
  }
}

///|
/// Make HTTP request
pub fn request(
  url : String,
  options? : Js,
  callback? : (IncomingMessage) -> Unit,
) -> ClientRequest {
  match (options, callback) {
    (Some(opts), Some(cb)) =>
      http_module().call("request", [url, opts, @js.from_fn1(cb)])
      |> unsafe_cast
    (Some(opts), None) =>
      http_module().call2("request", url, opts) |> unsafe_cast
    (None, Some(cb)) =>
      http_module().call2("request", url, @js.from_fn1(cb)) |> unsafe_cast
    (None, None) => http_module().call("request", [url]) |> unsafe_cast
  }
}

///|
/// Make HTTP GET request
pub fn get(
  url : String,
  options? : Js,
  callback? : (IncomingMessage) -> Unit,
) -> ClientRequest {
  match (options, callback) {
    (Some(opts), Some(cb)) =>
      http_module().call("get", [url, opts, @js.from_fn1(cb)]) |> unsafe_cast
    (Some(opts), None) => http_module().call2("get", url, opts) |> unsafe_cast
    (None, Some(cb)) =>
      http_module().call2("get", url, @js.from_fn1(cb)) |> unsafe_cast
    (None, None) => http_module().call("get", [url]) |> unsafe_cast
  }
}

///|
/// Global max sockets
pub fn globalAgent() -> Js {
  http_module().get("globalAgent")
}

///|
/// HTTP status codes
pub fn status_codes() -> Js {
  http_module().get("STATUS_CODES")
}
