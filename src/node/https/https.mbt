///|

///|
/// HTTPS Agent for managing connection pooling and TLS session caching
/// https://nodejs.org/api/https.html#class-httpsagent
#external
pub type Agent

///|
extern "js" fn ffi_new_agent(options : @core.Any) -> Agent =
  #| (options) => {
  #|   const https = require('https');
  #|   return new https.Agent(options);
  #| }

///|
/// Create a new HTTPS Agent
pub fn Agent::new(
  max_cached_sessions? : Int,
  servername? : String,
  keep_alive? : Bool,
  keep_alive_msecs? : Int,
  max_sockets? : Int,
  max_free_sockets? : Int,
  timeout? : Int,
) -> Agent {
  let entries : Array[(String, @core.Any)] = []
  if max_cached_sessions is Some(v) {
    entries.push(("maxCachedSessions", @core.any(v)))
  }
  if servername is Some(v) {
    entries.push(("servername", @core.any(v)))
  }
  if keep_alive is Some(v) {
    entries.push(("keepAlive", @core.any(v)))
  }
  if keep_alive_msecs is Some(v) {
    entries.push(("keepAliveMsecs", @core.any(v)))
  }
  if max_sockets is Some(v) {
    entries.push(("maxSockets", @core.any(v)))
  }
  if max_free_sockets is Some(v) {
    entries.push(("maxFreeSockets", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  let opts = @core.from_entries(entries).cast()
  ffi_new_agent(opts)
}

///|
/// HTTPS Server for handling secure connections
/// https://nodejs.org/api/https.html#class-httpsserver
#external
pub type Server

///|
pub fn Server::as_any(self : Server) -> @core.Any = "%identity"

///|
pub fn Server::as_event_target(self : Server) -> @event.EventTarget = "%identity"

///|
extern "js" fn ffi_create_server(
  options : @core.Any,
  request_listener : @core.Any,
) -> Server =
  #| (options, requestListener) => {
  #|   const https = require('https');
  #|   return https.createServer(options, requestListener);
  #| }

///|
/// Create an HTTPS server
pub fn create_server(
  request_listener : (@js.Object, @js.Object) -> Unit,
  key? : String,
  cert? : String,
  pfx? : String,
  passphrase? : String,
) -> Server {
  let listener = @js.from_fn2(request_listener)
  let entries : Array[(String, @core.Any)] = []
  if key is Some(v) {
    entries.push(("key", @core.any(v)))
  }
  if cert is Some(v) {
    entries.push(("cert", @core.any(v)))
  }
  if pfx is Some(v) {
    entries.push(("pfx", @core.any(v)))
  }
  if passphrase is Some(v) {
    entries.push(("passphrase", @core.any(v)))
  }
  let opts = @core.from_entries(entries).cast()
  ffi_create_server(opts, listener)
}

///|
/// Start listening on the specified port
pub fn Server::listen(self : Server, port : Int, callback : () -> Unit) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("listen", [@core.any(port), cb]) |> ignore
}

///|
/// Close the server
pub fn Server::close(self : Server, callback : () -> Unit) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  self.as_any()._call("close", [cb]) |> ignore
}

///|
/// ClientRequest for making HTTPS requests
#external
pub type ClientRequest

///|
pub fn ClientRequest::as_any(self : ClientRequest) -> @core.Any = "%identity"

///|
pub fn ClientRequest::as_event_target(
  self : ClientRequest,
) -> @event.EventTarget = "%identity"

///|
extern "js" fn ffi_request(
  options : @core.Any,
  callback : @core.Any,
) -> ClientRequest =
  #| (options, callback) => {
  #|   const https = require('https');
  #|   return https.request(options, callback);
  #| }

///|
/// Make an HTTPS request
pub fn request(
  url : String,
  callback : (@core.Any) -> Unit,
  method_? : String,
  host? : String,
  port? : Int,
  path? : String,
  headers? : @core.Any,
  agent? : Agent,
  rejectUnauthorized? : Bool,
) -> ClientRequest {
  let cb : @core.Any = @core.identity(callback)
  let obj = headers.unwrap_or(@core.new_object())
  obj._set("url", url |> @core.any)
  if method_ is Some(v) {
    obj._set("method", v |> @core.any)
  }
  if host is Some(v) {
    obj._set("host", v |> @core.any)
  }
  if port is Some(v) {
    obj._set("port", v |> @core.any)
  }
  if path is Some(v) {
    obj._set("path", v |> @core.any)
  }
  if agent is Some(v) {
    obj._set("agent", v |> @core.any)
  }
  if rejectUnauthorized is Some(v) {
    obj._set("rejectUnauthorized", v |> @core.any)
  }
  ffi_request(obj, cb)
}

///|
/// Write data to the request
pub fn ClientRequest::write(self : ClientRequest, data : String) -> Unit {
  self.as_any()._call("write", [@core.any(data)]) |> ignore
}

///|
/// End the request
pub fn ClientRequest::end(self : ClientRequest) -> Unit {
  self.as_any()._call("end", []) |> ignore
}

///|
extern "js" fn ffi_get(url : String, callback : @core.Any) -> ClientRequest =
  #| (url, callback) => {
  #|   const https = require('https');
  #|   return https._get(url, callback);
  #| }

///|
/// Make an HTTPS GET request
pub fn get(url : String, callback : (@js.Object) -> Unit) -> ClientRequest {
  let cb : @core.Any = @core.identity(callback)
  ffi_get(url, cb)
}

///|
extern "js" fn ffi_global_agent() -> Agent =
  #| () => {
  #|   const https = require('https');
  #|   return https.globalAgent;
  #| }

///|
/// Get the global HTTPS agent
pub fn global_agent() -> Agent {
  ffi_global_agent()
}
