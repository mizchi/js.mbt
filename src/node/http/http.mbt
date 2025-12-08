///|
/// node:http module
extern "js" fn http_module() -> @core.Any =
  #| () => require("node:http")

///| IncomingMessage class

///|
pub(all) struct IncomingMessage {
  httpVersion : String
  url : String?
  headers : @core.Any
  rawHeaders : Array[String]
  statusCode : Int?
  statusMessage : String?
  socket : @net.Socket
}

///|
pub fn IncomingMessage::as_any(self : IncomingMessage) -> @core.Any = "%identity"

///|
/// IncomingMessage is a Readable stream
pub fn IncomingMessage::as_readable(self : IncomingMessage) -> @stream.Readable {
  @core.identity(self)
}

///|
/// Get HTTP method
pub fn IncomingMessage::method_(self : IncomingMessage) -> String? {
  self.as_any()._get("method") |> @core.identity_option
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
      self
      .as_any()
      ._call("setTimeout", [@core.any(msecs), @core.any(@core.from_fn0(cb))])
      .cast()
    None => self.as_any()._call("setTimeout", [@core.any(msecs)]).cast()
  }
}

///| ServerResponse class

///|
#external
pub type ServerResponse

///|
pub fn ServerResponse::as_any(self : ServerResponse) -> @core.Any = "%identity"

///|
/// ServerResponse is a Writable stream
pub fn ServerResponse::as_writable(self : ServerResponse) -> @stream.Writable {
  @core.identity(self)
}

///|
/// Write response head
pub fn ServerResponse::writeHead(
  self : ServerResponse,
  statusCode : Int,
  statusMessage? : String,
  headers? : @core.Any,
) -> ServerResponse {
  match (statusMessage, headers) {
    (Some(msg), Some(hdrs)) =>
      self
      .as_any()
      ._call("writeHead", [@core.any(statusCode), @core.any(msg), hdrs])
      .cast()
    (Some(msg), None) =>
      self
      .as_any()
      ._call("writeHead", [@core.any(statusCode), @core.any(msg)])
      .cast()
    (None, Some(hdrs)) =>
      self.as_any()._call("writeHead", [@core.any(statusCode), hdrs]).cast()
    (None, None) =>
      self.as_any()._call("writeHead", [@core.any(statusCode)]).cast()
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
    Some(enc) =>
      self.as_any()._call("write", [@core.any(chunk), @core.any(enc)]).cast()
    None => self.as_any()._call("write", [@core.any(chunk)]).cast()
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
    (Some(d), Some(enc)) =>
      self.as_any()._call("end", [@core.any(d), @core.any(enc)]) |> ignore
    (Some(d), None) => self.as_any()._call("end", [@core.any(d)]) |> ignore
    (None, _) => self.as_any()._call("end", []) |> ignore
  }
}

///|
/// Set header
pub fn ServerResponse::setHeader(
  self : ServerResponse,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setHeader", [@core.any(name), @core.any(value)])
  |> ignore
  |> ignore
}

///|
/// Get header
pub fn ServerResponse::getHeader(
  self : ServerResponse,
  name : String,
) -> String? {
  self.as_any()._call("getHeader", [@core.any(name)]) |> @core.identity_option
}

///|
/// Remove header
pub fn ServerResponse::removeHeader(
  self : ServerResponse,
  name : String,
) -> Unit {
  self.as_any()._call("removeHeader", [@core.any(name)]) |> ignore
}

///|
/// Get headers sent status
pub fn ServerResponse::headersSent(self : ServerResponse) -> Bool {
  self.as_any()._get("headersSent").cast()
}

///|
/// Get status code
pub fn ServerResponse::statusCode(self : ServerResponse) -> Int {
  self.as_any()._get("statusCode").cast()
}

///|
/// Set status code
pub fn ServerResponse::set_statusCode(
  self : ServerResponse,
  code : Int,
) -> Unit {
  self.as_any()._set("statusCode", @core.any(code))
}

///|
/// Get status message
pub fn ServerResponse::statusMessage(self : ServerResponse) -> String {
  self.as_any()._get("statusMessage").cast()
}

///|
/// Set status message
pub fn ServerResponse::set_statusMessage(
  self : ServerResponse,
  message : String,
) -> Unit {
  self.as_any()._set("statusMessage", @core.any(message))
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
      self
      .as_any()
      ._call("setTimeout", [@core.any(msecs), @core.any(@core.from_fn0(cb))])
      |> @core.identity
    None => self.as_any()._call("setTimeout", [@core.any(msecs)]).cast()
  }
}

///| Server class

///|
#external
pub type Server

///|
pub fn Server::as_any(self : Server) -> @core.Any = "%identity"

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
      self
      .as_any()
      ._call("once", [
        @core.any("listening"),
        @core.any(@core.from_fn1(fn(_ : @core.Any) { cb() })),
      ])
      |> ignore
    None => ()
  }

  // Call listen with port, host, and backlog
  match (host, backlog) {
    (Some(h), Some(b)) =>
      self
      .as_any()
      ._call("listen", [@core.any(port), @core.any(h), @core.any(b)])
      .cast()
    (Some(h), None) =>
      self.as_any()._call("listen", [@core.any(port), @core.any(h)]).cast()
    (None, Some(b)) =>
      self.as_any()._call("listen", [@core.any(port), @core.any(b)]).cast()
    (None, None) => self.as_any()._call("listen", [@core.any(port)]).cast()
  }
}

///|
/// Close the server
pub fn Server::close(self : Server, callback? : () -> Unit) -> Server {
  match callback {
    Some(cb) =>
      self.as_any()._call("close", [@core.any(@core.from_fn0(cb))]).cast()
    None => self.as_any()._call("close", []).cast()
  }
}

///|
/// Get the server address
/// Returns AddressInfo for TCP servers, or null if not listening
pub fn Server::address(self : Server) -> @net.AddressInfo? {
  let result = self.as_any()._call("address", [])
  if @core.is_null(result) {
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
/// Get max headers count
pub fn Server::maxHeadersCount(self : Server) -> Int? {
  self.as_any()._get("maxHeadersCount") |> @core.identity_option
}

///|
/// Set max headers count
pub fn Server::set_maxHeadersCount(self : Server, max : Int) -> Unit {
  self.as_any()._set("maxHeadersCount", @core.any(max))
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
      self
      .as_any()
      ._call("setTimeout", [@core.any(msecs), @core.any(@core.from_fn0(cb))])
      .cast()
    None => self.as_any()._call("setTimeout", [@core.any(msecs)]).cast()
  }
}

///|
/// Get timeout
pub fn Server::timeout(self : Server) -> Int {
  self.as_any()._get("timeout").cast()
}

///|
/// Set timeout value
pub fn Server::set_timeout(self : Server, msecs : Int) -> Unit {
  self.as_any()._set("timeout", @core.any(msecs))
}

///| ClientRequest class

///|
#external
pub type ClientRequest

///|
pub fn ClientRequest::as_any(self : ClientRequest) -> @core.Any = "%identity"

///|
/// ClientRequest is a Writable stream
pub fn ClientRequest::as_writable(self : ClientRequest) -> @stream.Writable {
  @core.identity(self)
}

///|
/// Write data to request
pub fn ClientRequest::write(
  self : ClientRequest,
  chunk : String,
  encoding? : String,
) -> Bool {
  match encoding {
    Some(enc) =>
      self.as_any()._call("write", [@core.any(chunk), @core.any(enc)]).cast()
    None => self.as_any()._call("write", [@core.any(chunk)]).cast()
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
    (Some(d), Some(enc)) =>
      self.as_any()._call("end", [@core.any(d), @core.any(enc)]) |> ignore
    (Some(d), None) => self.as_any()._call("end", [@core.any(d)]) |> ignore
    (None, _) => self.as_any()._call("end", []).cast()
  }
}

///|
/// Abort request
pub fn ClientRequest::abort(self : ClientRequest) -> Unit {
  self.as_any()._call("abort", []).cast()
}

///|
/// Set header
pub fn ClientRequest::setHeader(
  self : ClientRequest,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setHeader", [@core.any(name), @core.any(value)])
  |> ignore
  |> ignore
}

///|
/// Get header
pub fn ClientRequest::getHeader(self : ClientRequest, name : String) -> String? {
  self.as_any()._call("getHeader", [@core.any(name)]) |> @core.identity_option
}

///|
/// Remove header
pub fn ClientRequest::removeHeader(self : ClientRequest, name : String) -> Unit {
  self.as_any()._call("removeHeader", [@core.any(name)]) |> ignore
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
      self
      .as_any()
      ._call("setTimeout", [@core.any(msecs), @core.any(@core.from_fn0(cb))])
      .cast()
    None => self.as_any()._call("setTimeout", [@core.any(msecs)]).cast()
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
      http_module()
      ._call("createServer", [@core.any(@core.from_fn2(listener))])
      .cast()
    None => http_module()._call("createServer", []).cast()
  }
}

///|
/// Make HTTP request
pub fn request(
  url : String,
  options? : @core.Any,
  callback? : (IncomingMessage) -> Unit,
) -> ClientRequest {
  match (options, callback) {
    (Some(opts), Some(cb)) =>
      http_module()._call("request", [
        @core.any(url),
        opts,
        @core.any(@core.from_fn1(cb)),
      ])
      |> @core.identity
    (Some(opts), None) =>
      http_module()._call("request", [@core.any(url), opts]).cast()
    (None, Some(cb)) =>
      http_module()
      ._call("request", [@core.any(url), @core.any(@core.from_fn1(cb))])
      .cast()
    (None, None) => http_module()._call("request", [@core.any(url)]).cast()
  }
}

///|
/// Make HTTP GET request
pub fn get(
  url : String,
  options? : @core.Any,
  callback? : (IncomingMessage) -> Unit,
) -> ClientRequest {
  match (options, callback) {
    (Some(opts), Some(cb)) =>
      http_module()
      ._call("get", [@core.any(url), opts, @core.any(@core.from_fn1(cb))])
      .cast()
    (Some(opts), None) =>
      http_module()._call("get", [@core.any(url), opts]).cast()
    (None, Some(cb)) =>
      http_module()
      ._call("get", [@core.any(url), @core.any(@core.from_fn1(cb))])
      .cast()
    (None, None) => http_module()._call("get", [@core.any(url)]).cast()
  }
}

///|
/// Global max sockets
pub fn globalAgent() -> @core.Any {
  http_module()._get("globalAgent")
}

///|
/// HTTP status codes
pub fn status_codes() -> @core.Any {
  http_module()._get("STATUS_CODES")
}
