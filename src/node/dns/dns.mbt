///|
#module("node:dns")
extern "js" fn ffi_lookup(
  hostname : String,
  options : @core.Any,
  callback : @core.Any,
) -> Unit = "lookup"

///|
/// Resolve a hostname to an IP address using OS facilities
pub fn lookup(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
  family? : Int,
  all? : Bool,
  order? : String,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  if family is None && all is None && order is None {
    ffi_lookup(hostname, @core.new_object() |> @core.identity, cb)
  } else {
    let opts = @core.new_object()
    if family is Some(f) {
      opts["family"] = @core.any(f)
    }
    if all is Some(a) {
      opts["all"] = @core.any(a)
    }
    if order is Some(o) {
      opts["order"] = @core.any(o)
    }
    ffi_lookup(hostname, opts |> @core.identity, cb)
  }
}

///|
#module("node:dns")
extern "js" fn ffi_resolve(
  hostname : String,
  rrtype : String,
  callback : @core.Any,
) -> Unit = "resolve"

///|
/// Resolve a hostname using DNS protocol
pub fn resolve(
  hostname : String,
  rrtype : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve(hostname, rrtype, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_resolve4(hostname : String, callback : @core.Any) -> Unit = "resolve4"

///|
/// Resolve a hostname to IPv4 addresses
pub fn resolve4(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve4(hostname, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_resolve6(hostname : String, callback : @core.Any) -> Unit = "resolve6"

///|
/// Resolve a hostname to IPv6 addresses
pub fn resolve6(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve6(hostname, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_resolve_mx(hostname : String, callback : @core.Any) -> Unit = "resolveMx"

///|
/// Resolve MX records
pub fn resolve_mx(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve_mx(hostname, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_resolve_txt(hostname : String, callback : @core.Any) -> Unit = "resolveTxt"

///|
/// Resolve TXT records
pub fn resolve_txt(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve_txt(hostname, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_resolve_srv(hostname : String, callback : @core.Any) -> Unit = "resolveSrv"

///|
/// Resolve SRV records
pub fn resolve_srv(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve_srv(hostname, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_resolve_ns(hostname : String, callback : @core.Any) -> Unit = "resolveNs"

///|
/// Resolve NS (name server) records
pub fn resolve_ns(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve_ns(hostname, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_resolve_cname(
  hostname : String,
  callback : @core.Any,
) -> Unit = "resolveCname"

///|
/// Resolve CNAME records
pub fn resolve_cname(
  hostname : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_resolve_cname(hostname, cb)
}

///|
#module("node:dns")
extern "js" fn ffi_reverse(ip : String, callback : @core.Any) -> Unit = "reverse"

///|
/// Perform reverse DNS lookup
pub fn reverse(ip : String, callback : (@core.Any?, @core.Any) -> Unit) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_reverse(ip, cb)
}

///|
/// Get the current DNS server addresses
#module("node:dns")
pub extern "js" fn get_servers() -> @core.Any = "getServers"

///|
/// Set the DNS server addresses
#module("node:dns")
pub extern "js" fn set_servers(servers : Array[String]) -> Unit = "setServers"
