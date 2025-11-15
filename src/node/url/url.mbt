///|
using @js {type Val, js, trait Js}

///|
extern "js" fn ffi_typeof(v : Val) -> String =
  #|(v) => typeof v

///|
extern "js" fn ffi_new_url(ctor : Val, input : String) -> Val =
  #|(ctor, input) => new ctor(input)

///|
extern "js" fn ffi_new_url_with_base(
  ctor : Val,
  input : String,
  base : String,
) -> Val =
  #|(ctor, input, base) => new ctor(input, base)

///|
extern "js" fn ffi_new_search_params(ctor : Val) -> Val =
  #|(ctor) => new ctor()

///|
extern "js" fn ffi_new_search_params_with_init(
  ctor : Val,
  init : String,
) -> Val =
  #|(ctor, init) => new ctor(init)

///|
extern "js" fn ffi_is_null(v : Val) -> Bool =
  #|(v) => v === null

///|
#external
pub type URL

///|
pub impl Js for URL with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type URLSearchParams

///|
pub impl Js for URLSearchParams with to_js(self) -> Val {
  self |> js
}

///|
/// Get the URL constructor
fn url_constructor() -> Val {
  @node.require("node:url").get("URL")
}

///|
/// Create a new URL from input string
pub fn URL::new(input : String, base? : String) -> URL {
  let ctor = url_constructor()
  match base {
    Some(b) => ffi_new_url_with_base(ctor, input, b).cast()
    None => ffi_new_url(ctor, input).cast()
  }
}

///|
/// Check if a string can be parsed as a valid URL
#alias(can_parse)
pub fn URL::canParse(input : String, base? : String) -> Bool {
  let ctor = url_constructor()
  match base {
    Some(b) => ctor.call_method("canParse", [input, b]).cast()
    None => ctor.call_method("canParse", [input]).cast()
  }
}

///|
/// Parse a string and return URL or None if invalid
pub fn URL::parse(input : String, base? : String) -> URL? {
  let ctor = url_constructor()
  let result = match base {
    Some(b) => ctor.call_method("parse", [input, b])
    None => ctor.call_method("parse", [input])
  }
  // parse returns null on failure
  if ffi_is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get the full URL string
pub fn URL::href(self : Self) -> String {
  self.to_js().get("href").cast()
}

///|
/// Set the full URL string
#alias(set_href)
pub fn URL::setHref(self : Self, value : String) -> Unit {
  self.to_js().set("href", value)
}

///|
/// Get the origin (read-only)
pub fn URL::origin(self : Self) -> String {
  self.to_js().get("origin").cast()
}

///|
/// Get the protocol
pub fn URL::protocol(self : Self) -> String {
  self.to_js().get("protocol").cast()
}

///|
/// Set the protocol
#alias(set_protocol)
pub fn URL::setProtocol(self : Self, value : String) -> Unit {
  self.to_js().set("protocol", value)
}

///|
/// Get the username
pub fn URL::username(self : Self) -> String {
  self.to_js().get("username").cast()
}

///|
/// Set the username
#alias(set_username)
pub fn URL::setUsername(self : Self, value : String) -> Unit {
  self.to_js().set("username", value)
}

///|
/// Get the password
pub fn URL::password(self : Self) -> String {
  self.to_js().get("password").cast()
}

///|
/// Set the password
#alias(set_password)
pub fn URL::setPassword(self : Self, value : String) -> Unit {
  self.to_js().set("password", value)
}

///|
/// Get the host (hostname + port)
pub fn URL::host(self : Self) -> String {
  self.to_js().get("host").cast()
}

///|
/// Set the host
#alias(set_host)
pub fn URL::setHost(self : Self, value : String) -> Unit {
  self.to_js().set("host", value)
}

///|
/// Get the hostname (without port)
pub fn URL::hostname(self : Self) -> String {
  self.to_js().get("hostname").cast()
}

///|
/// Set the hostname
#alias(set_hostname)
pub fn URL::setHostname(self : Self, value : String) -> Unit {
  self.to_js().set("hostname", value)
}

///|
/// Get the port
pub fn URL::port(self : Self) -> String {
  self.to_js().get("port").cast()
}

///|
/// Set the port
#alias(set_port)
pub fn URL::setPort(self : Self, value : String) -> Unit {
  self.to_js().set("port", value)
}

///|
/// Get the pathname
pub fn URL::pathname(self : Self) -> String {
  self.to_js().get("pathname").cast()
}

///|
/// Set the pathname
#alias(set_pathname)
pub fn URL::setPathname(self : Self, value : String) -> Unit {
  self.to_js().set("pathname", value)
}

///|
/// Get the search string (including '?')
pub fn URL::search(self : Self) -> String {
  self.to_js().get("search").cast()
}

///|
/// Set the search string
#alias(set_search)
pub fn URL::setSearch(self : Self, value : String) -> Unit {
  self.to_js().set("search", value)
}

///|
/// Get the hash (including '#')
pub fn URL::hash(self : Self) -> String {
  self.to_js().get("hash").cast()
}

///|
/// Set the hash
#alias(set_hash)
pub fn URL::setHash(self : Self, value : String) -> Unit {
  self.to_js().set("hash", value)
}

///|
/// Get the URLSearchParams object
#alias(search_params)
pub fn URL::searchParams(self : Self) -> URLSearchParams {
  self.to_js().get("searchParams").cast()
}

///|
/// Convert URL to string
#alias(to_string)
pub fn URL::toString(self : Self) -> String {
  self.to_js().call_method("toString", []).cast()
}

///|
/// Convert URL to JSON (same as toString)
#alias(to_json)
pub fn URL::toJSON(self : Self) -> String {
  self.to_js().call_method("toJSON", []).cast()
}

///|
/// URLSearchParams constructor from string
pub fn URLSearchParams::new(init? : String) -> URLSearchParams {
  let ctor = @node.require("node:url").get("URLSearchParams")
  match init {
    Some(s) => ffi_new_search_params_with_init(ctor, s).cast()
    None => ffi_new_search_params(ctor).cast()
  }
}

///|
/// Append a key-value pair
pub fn URLSearchParams::append(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.to_js().call_method("append", [name, value]) |> ignore
}

///|
/// Delete all parameters with the given name
pub fn URLSearchParams::delete(
  self : Self,
  name : String,
  value? : String,
) -> Unit {
  match value {
    Some(v) => self.to_js().call_method("delete", [name, v]) |> ignore
    None => self.to_js().call_method("delete", [name]) |> ignore
  }
}

///|
/// Get the first value for a parameter
pub fn URLSearchParams::get(self : Self, name : String) -> String? {
  let result = self.to_js().call_method("get", [name])
  if ffi_typeof(result) == "string" {
    Some(result.cast())
  } else {
    None
  }
}

///|
/// Get all values for a parameter
#alias(get_all)
pub fn URLSearchParams::getAll(self : Self, name : String) -> Array[String] {
  let result = self.to_js().call_method("getAll", [name])
  // Convert JS array to MoonBit array
  let arr : Array[String] = []
  let length : Int = result.get("length").cast()
  let mut i = 0
  while i < length {
    arr.push(result.call_method("at", [i]).cast())
    i = i + 1
  }
  arr
}

///|
/// Check if a parameter exists
pub fn URLSearchParams::has(
  self : Self,
  name : String,
  value? : String,
) -> Bool {
  match value {
    Some(v) => self.to_js().call_method("has", [name, v]).cast()
    None => self.to_js().call_method("has", [name]).cast()
  }
}

///|
/// Set a parameter (replaces all existing values)
pub fn URLSearchParams::set(self : Self, name : String, value : String) -> Unit {
  self.to_js().call_method("set", [name, value]) |> ignore
}

///|
/// Sort all parameters by name
pub fn URLSearchParams::sort(self : Self) -> Unit {
  self.to_js().call_method("sort", []) |> ignore
}

///|
/// Convert to query string
#alias(to_string)
pub fn URLSearchParams::toString(self : Self) -> String {
  self.to_js().call_method("toString", []).cast()
}

///|
/// Get the size (number of parameters)
pub fn URLSearchParams::size(self : Self) -> Int {
  self.to_js().get("size").cast()
}
