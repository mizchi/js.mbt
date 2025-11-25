///|
extern "js" fn ffi_lookup(
  hostname : String,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (hostname, options, callback) => {
  #|   const dns = require('dns');
  #|   dns.lookup(hostname, options, callback);
  #| }

///|
/// Resolve a hostname to an IP address using OS facilities
pub fn lookup(
  hostname : String,
  callback : (@js.Object?, @js.Object) -> Unit,
  family? : Int,
  all? : Bool,
  order? : String,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  if family is None && all is None && order is None {
    ffi_lookup(hostname, @js.Object::new().to_any(), cb)
  } else {
    let opts = @js.from_entries_option([
      ("family", family.map(x => x)),
      ("all", all.map(x => x)),
      ("order", order.map(x => x)),
    ])
    ffi_lookup(hostname, opts, cb)
  }
}

///|
extern "js" fn ffi_resolve(
  hostname : String,
  rrtype : String,
  callback : @js.Any,
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve(hostname, rrtype, cb)
}

///|
extern "js" fn ffi_resolve4(hostname : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve4(hostname, cb)
}

///|
extern "js" fn ffi_resolve6(hostname : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve6(hostname, cb)
}

///|
extern "js" fn ffi_resolve_mx(hostname : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve_mx(hostname, cb)
}

///|
extern "js" fn ffi_resolve_txt(hostname : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve_txt(hostname, cb)
}

///|
extern "js" fn ffi_resolve_srv(hostname : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve_srv(hostname, cb)
}

///|
extern "js" fn ffi_resolve_ns(hostname : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve_ns(hostname, cb)
}

///|
extern "js" fn ffi_resolve_cname(hostname : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
  ffi_resolve_cname(hostname, cb)
}

///|
extern "js" fn ffi_reverse(ip : String, callback : @js.Any) -> Unit =
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
  let cb : @js.Any = @js.identity(callback)
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
