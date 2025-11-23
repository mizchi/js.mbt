///|

///|
/// HTTPS Agent for managing connection pooling and TLS session caching
/// https://nodejs.org/api/https.html#class-httpsagent
#external
pub type Agent

///|
pub impl @js.JsImpl for Agent

///|
/// Options for creating an HTTPS Agent
pub struct AgentOptions {
  max_cached_sessions : Int?
  servername : String?
  keep_alive : Bool?
  keep_alive_msecs : Int?
  max_sockets : Int?
  max_free_sockets : Int?
  timeout : Int?
}

///|
/// Create a new HTTPS Agent with default options
pub fn AgentOptions::new() -> AgentOptions {
  {
    max_cached_sessions: None,
    servername: None,
    keep_alive: None,
    keep_alive_msecs: None,
    max_sockets: None,
    max_free_sockets: None,
    timeout: None,
  }
}

///|
/// Convert AgentOptions to JavaScript object
pub fn AgentOptions::to_js(self : AgentOptions) -> @js.Js {
  let obj = @js.Object::new()
  match self.max_cached_sessions {
    Some(v) => obj.set("maxCachedSessions", v)
    None => ()
  }
  match self.servername {
    Some(v) => obj.set("servername", v)
    None => ()
  }
  match self.keep_alive {
    Some(v) => obj.set("keepAlive", v)
    None => ()
  }
  match self.keep_alive_msecs {
    Some(v) => obj.set("keepAliveMsecs", v)
    None => ()
  }
  match self.max_sockets {
    Some(v) => obj.set("maxSockets", v)
    None => ()
  }
  match self.max_free_sockets {
    Some(v) => obj.set("maxFreeSockets", v)
    None => ()
  }
  match self.timeout {
    Some(v) => obj.set("timeout", v)
    None => ()
  }
  obj.to_js()
}

///|
extern "js" fn ffi_new_agent(options : @js.Js) -> Agent =
  #| (options) => {
  #|   const https = require('https');
  #|   return new https.Agent(options);
  #| }

///|
/// Create a new HTTPS Agent
pub fn Agent::new(options : AgentOptions) -> Agent {
  ffi_new_agent(options.to_js())
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
/// Options for creating an HTTPS Server
pub struct ServerOptions {
  key : String?
  cert : String?
  pfx : String?
  passphrase : String?
}

///|
/// Create a new ServerOptions with default values
pub fn ServerOptions::new() -> ServerOptions {
  { key: None, cert: None, pfx: None, passphrase: None }
}

///|
/// Convert ServerOptions to JavaScript object
pub fn ServerOptions::to_js(self : ServerOptions) -> @js.Js {
  let obj = @js.Object::new()
  match self.key {
    Some(v) => obj.set("key", v)
    None => ()
  }
  match self.cert {
    Some(v) => obj.set("cert", v)
    None => ()
  }
  match self.pfx {
    Some(v) => obj.set("pfx", v)
    None => ()
  }
  match self.passphrase {
    Some(v) => obj.set("passphrase", v)
    None => ()
  }
  obj.to_js()
}

///|
extern "js" fn ffi_create_server(
  options : @js.Js,
  request_listener : @js.Js,
) -> Server =
  #| (options, requestListener) => {
  #|   const https = require('https');
  #|   return https.createServer(options, requestListener);
  #| }

///|
/// Create an HTTPS server
pub fn create_server(
  options : ServerOptions,
  request_listener : (@js.Object, @js.Object) -> Unit,
) -> Server {
  let listener = @js.from_fn2(request_listener)
  ffi_create_server(options.to_js(), listener)
}

///|
/// Start listening on the specified port
pub fn Server::listen(self : Server, port : Int, callback : () -> Unit) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  self.call2("listen", port, cb) |> ignore
}

///|
/// Close the server
pub fn Server::close(self : Server, callback : () -> Unit) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
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
/// Options for making HTTPS requests
pub struct RequestOptions {
  method_ : String?
  host : String?
  port : Int?
  path : String?
  headers : @js.Object?
  agent : Agent?
  rejectUnauthorized : Bool?
}

///|
/// Create a new RequestOptions with default values
pub fn RequestOptions::new(url : String) -> RequestOptions {
  let obj = @js.Object::new()
  obj.set("url", url)
  {
    method_: None,
    host: None,
    port: None,
    path: None,
    headers: Some(obj),
    agent: None,
    rejectUnauthorized: None,
  }
}

///|
/// Convert RequestOptions to JavaScript object
pub fn RequestOptions::to_js(self : RequestOptions) -> @js.Js {
  let obj = match self.headers {
    Some(h) => h
    None => @js.Object::new()
  }
  match self.method_ {
    Some(v) => obj.set("method", v)
    None => ()
  }
  match self.host {
    Some(v) => obj.set("host", v)
    None => ()
  }
  match self.port {
    Some(v) => obj.set("port", v)
    None => ()
  }
  match self.path {
    Some(v) => obj.set("path", v)
    None => ()
  }
  match self.agent {
    Some(v) => obj.set("agent", v.to_js())
    None => ()
  }
  match self.rejectUnauthorized {
    Some(v) => obj.set("rejectUnauthorized", v)
    None => ()
  }
  obj.to_js()
}

///|
extern "js" fn ffi_request(
  options : @js.Js,
  callback : @js.Js,
) -> ClientRequest =
  #| (options, callback) => {
  #|   const https = require('https');
  #|   return https.request(options, callback);
  #| }

///|
/// Make an HTTPS request
pub fn request(
  options : RequestOptions,
  callback : (@js.Object) -> Unit,
) -> ClientRequest {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_request(options.to_js(), cb)
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
extern "js" fn ffi_get(url : String, callback : @js.Js) -> ClientRequest =
  #| (url, callback) => {
  #|   const https = require('https');
  #|   return https.get(url, callback);
  #| }

///|
/// Make an HTTPS GET request
pub fn get(url : String, callback : (@js.Object) -> Unit) -> ClientRequest {
  let cb : @js.Js = @js.unsafe_cast(callback)
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
