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
pub impl Js for URL

///|
#external
pub type URLSearchParams

///|
pub impl Js for URLSearchParams

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
    Some(b) => unsafe_cast(ffi_new_url_with_base(ctor, input, b))
    None => unsafe_cast(ffi_new_url(ctor, input))
  }
}

///|
/// Check if a string can be parsed as a valid URL
#alias(can_parse)
pub fn URL::canParse(input : String, base? : String) -> Bool {
  let ctor = url_constructor()
  match base {
    Some(b) => unsafe_cast(ctor.invoke("canParse", [input, b]))
    None => unsafe_cast(ctor.invoke("canParse", [input]))
  }
}

///|
/// Parse a string and return URL or None if invalid
pub fn URL::parse(input : String, base? : String) -> URL? {
  let ctor = url_constructor()
  let result = match base {
    Some(b) => ctor.invoke("parse", [input, b])
    None => ctor.invoke("parse", [input])
  }
  // parse returns null on failure
  if ffi_is_null(result) {
    None
  } else {
    Some(unsafe_cast(result))
  }
}

///|
/// Get the full URL string
pub fn URL::href(self : Self) -> String {
  unsafe_cast(self.get("href"))
}

///|
/// Set the full URL string
#alias(set_href)
pub fn URL::setHref(self : Self, value : String) -> Unit {
  self.set("href", value)
}

///|
/// Get the origin (read-only)
pub fn URL::origin(self : Self) -> String {
  unsafe_cast(self.get("origin"))
}

///|
/// Get the protocol
pub fn URL::protocol(self : Self) -> String {
  unsafe_cast(self.get("protocol"))
}

///|
/// Set the protocol
#alias(set_protocol)
pub fn URL::setProtocol(self : Self, value : String) -> Unit {
  self.set("protocol", value)
}

///|
/// Get the username
pub fn URL::username(self : Self) -> String {
  unsafe_cast(self.get("username"))
}

///|
/// Set the username
#alias(set_username)
pub fn URL::setUsername(self : Self, value : String) -> Unit {
  self.set("username", value)
}

///|
/// Get the password
pub fn URL::password(self : Self) -> String {
  unsafe_cast(self.get("password"))
}

///|
/// Set the password
#alias(set_password)
pub fn URL::setPassword(self : Self, value : String) -> Unit {
  self.set("password", value)
}

///|
/// Get the host (hostname + port)
pub fn URL::host(self : Self) -> String {
  unsafe_cast(self.get("host"))
}

///|
/// Set the host
#alias(set_host)
pub fn URL::setHost(self : Self, value : String) -> Unit {
  self.set("host", value)
}

///|
/// Get the hostname (without port)
pub fn URL::hostname(self : Self) -> String {
  unsafe_cast(self.get("hostname"))
}

///|
/// Set the hostname
#alias(set_hostname)
pub fn URL::setHostname(self : Self, value : String) -> Unit {
  self.set("hostname", value)
}

///|
/// Get the port
pub fn URL::port(self : Self) -> String {
  unsafe_cast(self.get("port"))
}

///|
/// Set the port
#alias(set_port)
pub fn URL::setPort(self : Self, value : String) -> Unit {
  self.set("port", value)
}

///|
/// Get the pathname
pub fn URL::pathname(self : Self) -> String {
  unsafe_cast(self.get("pathname"))
}

///|
/// Set the pathname
#alias(set_pathname)
pub fn URL::setPathname(self : Self, value : String) -> Unit {
  self.set("pathname", value)
}

///|
/// Get the search string (including '?')
pub fn URL::search(self : Self) -> String {
  unsafe_cast(self.get("search"))
}

///|
/// Set the search string
#alias(set_search)
pub fn URL::setSearch(self : Self, value : String) -> Unit {
  self.set("search", value)
}

///|
/// Get the hash (including '#')
pub fn URL::hash(self : Self) -> String {
  unsafe_cast(self.get("hash"))
}

///|
/// Set the hash
#alias(set_hash)
pub fn URL::setHash(self : Self, value : String) -> Unit {
  self.set("hash", value)
}

///|
/// Get the URLSearchParams object
#alias(search_params)
pub fn URL::searchParams(self : Self) -> URLSearchParams {
  unsafe_cast(self.get("searchParams"))
}

///|
/// Convert URL to string
#alias(to_string)
pub fn URL::toString(self : Self) -> String {
  self.invoke("toString", []) |> unsafe_cast
}

///|
/// Convert URL to JSON (same as toString)
#alias(to_json)
pub fn URL::toJSON(self : Self) -> String {
  self.invoke("toJSON", []) |> unsafe_cast
}

///|
/// URLSearchParams constructor from string
pub fn URLSearchParams::new(init? : String) -> URLSearchParams {
  let ctor = @node.require("node:url").get("URLSearchParams")
  match init {
    Some(s) => unsafe_cast(ffi_new_search_params_with_init(ctor, s))
    None => unsafe_cast(ffi_new_search_params(ctor))
  }
}

///|
/// Append a key-value pair
pub fn URLSearchParams::append(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.invoke("append", [name, value]) |> ignore
}

///|
/// Delete all parameters with the given name
pub fn URLSearchParams::delete(
  self : Self,
  name : String,
  value? : String,
) -> Unit {
  match value {
    Some(v) => self.invoke("delete", [name, v]) |> ignore
    None => self.invoke("delete", [name]) |> ignore
  }
}

///|
/// Get the first value for a parameter
pub fn URLSearchParams::get(self : Self, name : String) -> String? {
  let result = self.invoke("get", [name])
  if ffi_typeof(result) == "string" {
    Some(unsafe_cast(result))
  } else {
    None
  }
}

///|
/// Get all values for a parameter
#alias(get_all)
pub fn URLSearchParams::getAll(self : Self, name : String) -> Array[String] {
  let result = self.invoke("getAll", [name])
  // Convert JS array to MoonBit array
  let arr : Array[String] = []
  let length : Int = unsafe_cast(result.get("length"))
  let mut i = 0
  while i < length {
    arr.push(unsafe_cast(result.invoke("at", [i])))
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
    Some(v) => self.invoke("has", [name, v]) |> unsafe_cast
    None => self.invoke("has", [name]) |> unsafe_cast
  }
}

///|
/// Set a parameter (replaces all existing values)
pub fn URLSearchParams::set(self : Self, name : String, value : String) -> Unit {
  self.invoke("set", [name, value]) |> ignore
}

///|
/// Sort all parameters by name
pub fn URLSearchParams::sort(self : Self) -> Unit {
  self.invoke("sort", []) |> ignore
}

///|
/// Convert to query string
#alias(to_string)
pub fn URLSearchParams::toString(self : Self) -> String {
  self.invoke("toString", []) |> unsafe_cast
}

///|
/// Get the size (number of parameters)
pub fn URLSearchParams::size(self : Self) -> Int {
  // avoid original get
  unsafe_cast(self.to_js().get("size"))
}

///|
/// Convert a file URL to a file path
#alias(file_url_to_path)
pub fn fileURLToPath(url : String, windows? : Bool) -> String {
  let url_module = @node.require("node:url")
  match windows {
    Some(w) => {
      let options = @js.new_empty_object()
      options.set("windows", w)
      unsafe_cast(url_module.invoke("fileURLToPath", [url, options]))
    }
    None => unsafe_cast(url_module.invoke("fileURLToPath", [url]))
  }
}

///|
/// Convert a file URL object to a file path
#alias(file_url_to_path_from_url)
pub fn fileURLToPathFromURL(url : URL, windows? : Bool) -> String {
  let url_module = @node.require("node:url")
  match windows {
    Some(w) => {
      let options = @js.new_empty_object()
      options.set("windows", w)
      unsafe_cast(url_module.invoke("fileURLToPath", [url, options]))
    }
    None => unsafe_cast(url_module.invoke("fileURLToPath", [url]))
  }
}

///|
/// Convert a file path to a file URL
#alias(path_to_file_url)
pub fn pathToFileURL(path : String, windows? : Bool) -> URL {
  let url_module = @node.require("node:url")
  match windows {
    Some(w) => {
      let options = @js.new_empty_object()
      options.set("windows", w)
      unsafe_cast(url_module.invoke("pathToFileURL", [path, options]))
    }
    None => unsafe_cast(url_module.invoke("pathToFileURL", [path]))
  }
}

///|
/// Convert URL to HTTP options object
#alias(url_to_http_options)
pub fn urlToHttpOptions(url : URL) -> Val {
  let url_module = @node.require("node:url")
  url_module.invoke("urlToHttpOptions", [url])
}

///|
/// Format a URL object to string (legacy API)
pub fn format(url : URL) -> String {
  let url_module = @node.require("node:url")
  unsafe_cast(url_module.invoke("format", [url]))
}
