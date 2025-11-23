///|

///|
/// DNS lookup options
pub struct LookupOptions {
  family : Int?
  all : Bool?
  order : String?
}

///|
/// Create default lookup options
pub fn LookupOptions::new() -> LookupOptions {
  { family: None, all: None, order: None }
}

///|
/// Convert LookupOptions to JavaScript object
pub fn LookupOptions::to_js(self : LookupOptions) -> @js.Js {
  let obj = @js.Object::new()
  match self.family {
    Some(v) => obj.set("family", v)
    None => ()
  }
  match self.all {
    Some(v) => obj.set("all", v)
    None => ()
  }
  match self.order {
    Some(v) => obj.set("order", v)
    None => ()
  }
  obj.to_js()
}

///|
extern "js" fn ffi_lookup(
  hostname : String,
  options : @js.Js,
  callback : @js.Js,
) -> Unit =
  #| (hostname, options, callback) => {
  #|   const dns = require('dns');
  #|   dns.lookup(hostname, options, callback);
  #| }

///|
/// Resolve a hostname to an IP address using OS facilities
pub fn lookup(
  hostname : String,
  options : LookupOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_lookup(hostname, options.to_js(), cb)
}

///|
extern "js" fn ffi_resolve(
  hostname : String,
  rrtype : String,
  callback : @js.Js,
) -> Unit =
  #| (hostname, rrtype, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolve(hostname, rrtype, callback);
  #| }

///|
/// Resolve a hostname using DNS protocol
pub fn resolve(
  hostname : String,
  rrtype : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve(hostname, rrtype, cb)
}

///|
extern "js" fn ffi_resolve4(hostname : String, callback : @js.Js) -> Unit =
  #| (hostname, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolve4(hostname, callback);
  #| }

///|
/// Resolve a hostname to IPv4 addresses
pub fn resolve4(
  hostname : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve4(hostname, cb)
}

///|
extern "js" fn ffi_resolve6(hostname : String, callback : @js.Js) -> Unit =
  #| (hostname, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolve6(hostname, callback);
  #| }

///|
/// Resolve a hostname to IPv6 addresses
pub fn resolve6(
  hostname : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve6(hostname, cb)
}

///|
extern "js" fn ffi_resolve_mx(hostname : String, callback : @js.Js) -> Unit =
  #| (hostname, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolveMx(hostname, callback);
  #| }

///|
/// Resolve MX records
pub fn resolve_mx(
  hostname : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve_mx(hostname, cb)
}

///|
extern "js" fn ffi_resolve_txt(hostname : String, callback : @js.Js) -> Unit =
  #| (hostname, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolveTxt(hostname, callback);
  #| }

///|
/// Resolve TXT records
pub fn resolve_txt(
  hostname : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve_txt(hostname, cb)
}

///|
extern "js" fn ffi_resolve_srv(hostname : String, callback : @js.Js) -> Unit =
  #| (hostname, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolveSrv(hostname, callback);
  #| }

///|
/// Resolve SRV records
pub fn resolve_srv(
  hostname : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve_srv(hostname, cb)
}

///|
extern "js" fn ffi_resolve_ns(hostname : String, callback : @js.Js) -> Unit =
  #| (hostname, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolveNs(hostname, callback);
  #| }

///|
/// Resolve NS (name server) records
pub fn resolve_ns(
  hostname : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve_ns(hostname, cb)
}

///|
extern "js" fn ffi_resolve_cname(hostname : String, callback : @js.Js) -> Unit =
  #| (hostname, callback) => {
  #|   const dns = require('dns');
  #|   dns.resolveCname(hostname, callback);
  #| }

///|
/// Resolve CNAME records
pub fn resolve_cname(
  hostname : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_resolve_cname(hostname, cb)
}

///|
extern "js" fn ffi_reverse(ip : String, callback : @js.Js) -> Unit =
  #| (ip, callback) => {
  #|   const dns = require('dns');
  #|   dns.reverse(ip, callback);
  #| }

///|
/// Perform reverse DNS lookup
pub fn reverse(
  ip : String,
  callback : (@js.Object?, @js.JsArray) -> Unit,
) -> Unit {
  let cb : @js.Js = @js.unsafe_cast(callback)
  ffi_reverse(ip, cb)
}

///|
extern "js" fn ffi_get_servers() -> @js.JsArray =
  #| () => {
  #|   const dns = require('dns');
  #|   return dns.getServers();
  #| }

///|
/// Get the current DNS server addresses
pub fn get_servers() -> @js.JsArray {
  ffi_get_servers()
}

///|
extern "js" fn ffi_set_servers(servers : @js.JsArray) -> Unit =
  #| (servers) => {
  #|   const dns = require('dns');
  #|   dns.setServers(servers);
  #| }

///|
/// Set the DNS server addresses
pub fn set_servers(servers : Array[String]) -> Unit {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < servers.length() {
    arr.call("push", [servers[i]]) |> ignore
    i = i + 1
  }
  ffi_set_servers(arr)
}
