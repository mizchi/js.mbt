///|

///|
/// HTTPS Agent for managing connection pooling and TLS session caching
/// https://nodejs.org/api/https.html#class-httpsagent
#external
pub type Agent

///|
pub impl @js.JsImpl for Agent

///|
extern "js" fn ffi_new_agent(options : @js.Any) -> Agent =
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
  let opts = @js.from_entries_option([
    ("maxCachedSessions", max_cached_sessions.map(x => x)),
    ("servername", servername.map(x => x)),
    ("keepAlive", keep_alive.map(x => x)),
    ("keepAliveMsecs", keep_alive_msecs.map(x => x)),
    ("maxSockets", max_sockets.map(x => x)),
    ("maxFreeSockets", max_free_sockets.map(x => x)),
    ("timeout", timeout.map(x => x)),
  ])
  ffi_new_agent(opts)
}

///|
/// HTTPS Server for handling secure connections
/// https://nodejs.org/api/https.html#class-httpsserver
#external
pub type Server

///|
pub impl @js.JsImpl for Server

///|
pub impl @event.EventTargetImpl for Server

///|
extern "js" fn ffi_create_server(
  options : @js.Any,
  request_listener : @js.Any,
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
  let opts = @js.from_entries_option([
    ("key", key.map(x => x)),
    ("cert", cert.map(x => x)),
    ("pfx", pfx.map(x => x)),
    ("passphrase", passphrase.map(x => x)),
  ])
  ffi_create_server(opts, listener)
}

///|
/// Start listening on the specified port
pub fn Server::listen(self : Server, port : Int, callback : () -> Unit) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call2("listen", port, cb) |> ignore
}

///|
/// Close the server
pub fn Server::close(self : Server, callback : () -> Unit) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("close", [cb]) |> ignore
}

///|
/// ClientRequest for making HTTPS requests
#external
pub type ClientRequest

///|
pub impl @js.JsImpl for ClientRequest

///|
pub impl @event.EventTargetImpl for ClientRequest

///|
extern "js" fn ffi_request(
  options : @js.Any,
  callback : @js.Any,
) -> ClientRequest =
  #| (options, callback) => {
  #|   const https = require('https');
  #|   return https.request(options, callback);
  #| }

///|
/// Make an HTTPS request
pub fn request(
  url : String,
  callback : (@js.Object) -> Unit,
  method_? : String,
  host? : String,
  port? : Int,
  path? : String,
  headers? : @js.Object,
  agent? : Agent,
  rejectUnauthorized? : Bool,
) -> ClientRequest {
  let cb : @js.Any = @js.identity(callback)
  let obj = headers.unwrap_or(@js.Object::new())
  obj.set("url", url)
  if method_ is Some(v) {
    obj.set("method", v)
  }
  if host is Some(v) {
    obj.set("host", v)
  }
  if port is Some(v) {
    obj.set("port", v)
  }
  if path is Some(v) {
    obj.set("path", v)
  }
  if agent is Some(v) {
    obj.set("agent", v.to_any())
  }
  if rejectUnauthorized is Some(v) {
    obj.set("rejectUnauthorized", v)
  }
  ffi_request(obj.to_any(), cb)
}

///|
/// Write data to the request
pub fn ClientRequest::write(self : ClientRequest, data : String) -> Unit {
  self.call("write", [data]) |> ignore
}

///|
/// End the request
pub fn ClientRequest::end(self : ClientRequest) -> Unit {
  self.call0("end") |> ignore
}

///|
extern "js" fn ffi_get(url : String, callback : @js.Any) -> ClientRequest =
  #| (url, callback) => {
  #|   const https = require('https');
  #|   return https.get(url, callback);
  #| }

///|
/// Make an HTTPS GET request
pub fn get(url : String, callback : (@js.Object) -> Unit) -> ClientRequest {
  let cb : @js.Any = @js.identity(callback)
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
