///|
/// node:http module
fn http_module() -> @js.Any {
  @node.require("node:http")
}

///| IncomingMessage class

///|
pub(all) struct IncomingMessage {
  httpVersion : String
  url : String?
  headers : @js.Any
  rawHeaders : Array[String]
  statusCode : Int?
  statusMessage : String?
  socket : @net.Socket
}

///|
pub impl @js.JsImpl for IncomingMessage

///|
pub impl @events.EventEmitterImpl for IncomingMessage

///|
/// IncomingMessage is a Readable stream
pub fn IncomingMessage::as_readable(self : IncomingMessage) -> @stream.Readable {
  @js.identity(self)
}

///|
/// Get HTTP method
pub fn IncomingMessage::method_(self : IncomingMessage) -> String? {
  self.get("method") |> @js.identity_option
}

///|
/// Set timeout
pub fn IncomingMessage::setTimeout(
  self : IncomingMessage,
  msecs : Int,
  callback? : () -> Unit,
) -> IncomingMessage {
  match callback {
    Some(cb) =>
      self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> @js.identity
    None => self.call("setTimeout", [msecs]).cast()
  }
}

///| ServerResponse class

///|
#external
pub type ServerResponse

///|
pub impl @js.JsImpl for ServerResponse

///|
pub impl @events.EventEmitterImpl for ServerResponse

///|
/// ServerResponse is a Writable stream
pub fn ServerResponse::as_writable(self : ServerResponse) -> @stream.Writable {
  @js.identity(self)
}

///|
/// Write response head
pub fn ServerResponse::writeHead(
  self : ServerResponse,
  statusCode : Int,
  statusMessage? : String,
  headers? : @js.Any,
) -> ServerResponse {
  match (statusMessage, headers) {
    (Some(msg), Some(hdrs)) =>
      self.call("writeHead", [statusCode, msg, hdrs]).cast()
    (Some(msg), None) =>
      self.call2("writeHead", statusCode, msg) |> @js.identity
    (None, Some(hdrs)) =>
      self.call2("writeHead", statusCode, hdrs) |> @js.identity
    (None, None) => self.call("writeHead", [statusCode]).cast()
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
    Some(enc) => self.call2("write", chunk, enc) |> @js.identity
    None => self.call("write", [chunk]).cast()
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
  self.call("getHeader", [name]) |> @js.identity_option
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
  self.get("headersSent").cast()
}

///|
/// Get status code
pub fn ServerResponse::statusCode(self : ServerResponse) -> Int {
  self.get("statusCode").cast()
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
  self.get("statusMessage").cast()
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
    Some(cb) =>
      self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> @js.identity
    None => self.call("setTimeout", [msecs]).cast()
  }
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
pub fn Server::close(self : Server, callback? : () -> Unit) -> Server {
  match callback {
    Some(cb) => self.call("close", [@js.from_fn0(cb)]).cast()
    None => self.call0("close") |> @js.identity
  }
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
/// Get max headers count
pub fn Server::maxHeadersCount(self : Server) -> Int? {
  self.get("maxHeadersCount") |> @js.identity_option
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
    Some(cb) =>
      self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> @js.identity
    None => self.call("setTimeout", [msecs]).cast()
  }
}

///|
/// Get timeout
pub fn Server::timeout(self : Server) -> Int {
  self.get("timeout").cast()
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
pub impl @js.JsImpl for ClientRequest

///|
pub impl @events.EventEmitterImpl for ClientRequest

///|
/// ClientRequest is a Writable stream
pub fn ClientRequest::as_writable(self : ClientRequest) -> @stream.Writable {
  @js.identity(self)
}

///|
/// Write data to request
pub fn ClientRequest::write(
  self : ClientRequest,
  chunk : String,
  encoding? : String,
) -> Bool {
  match encoding {
    Some(enc) => self.call2("write", chunk, enc) |> @js.identity
    None => self.call("write", [chunk]).cast()
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
  self.call("getHeader", [name]) |> @js.identity_option
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
    Some(cb) =>
      self.call2("setTimeout", msecs, @js.from_fn0(cb)) |> @js.identity
    None => self.call("setTimeout", [msecs]).cast()
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
      |> @js.identity
    None => http_module().call0("createServer") |> @js.identity
  }
}

///|
/// Make HTTP request
pub fn request(
  url : String,
  options? : @js.Any,
  callback? : (IncomingMessage) -> Unit,
) -> ClientRequest {
  match (options, callback) {
    (Some(opts), Some(cb)) =>
      http_module().call("request", [url, opts, @js.from_fn1(cb)])
      |> @js.identity
    (Some(opts), None) =>
      http_module().call2("request", url, opts) |> @js.identity
    (None, Some(cb)) =>
      http_module().call2("request", url, @js.from_fn1(cb)) |> @js.identity
    (None, None) => http_module().call("request", [url]).cast()
  }
}

///|
/// Make HTTP GET request
pub fn get(
  url : String,
  options? : @js.Any,
  callback? : (IncomingMessage) -> Unit,
) -> ClientRequest {
  match (options, callback) {
    (Some(opts), Some(cb)) =>
      http_module().call("get", [url, opts, @js.from_fn1(cb)]).cast()
    (Some(opts), None) => http_module().call2("get", url, opts) |> @js.identity
    (None, Some(cb)) =>
      http_module().call2("get", url, @js.from_fn1(cb)) |> @js.identity
    (None, None) => http_module().call("get", [url]).cast()
  }
}

///|
/// Global max sockets
pub fn globalAgent() -> @js.Any {
  http_module().get("globalAgent")
}

///|
/// HTTP status codes
pub fn status_codes() -> @js.Any {
  http_module().get("STATUS_CODES")
}
