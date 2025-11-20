///|
/// Web URL API
/// https://developer.mozilla.org/en-US/docs/Web/API/URL

///|
pub(all) struct URL {
  mut href : String
  mut origin : String
  mut protocol : String
  mut username : String
  mut password : String
  mut host : String
  mut hostname : String
  mut port : String
  mut pathname : String
  mut search : String
  mut hash : String
  mut searchParams : URLSearchParams
} derive(Eq, Show)

///|
pub impl @js.JsImpl for URL

///|
/// Create a new URL
pub extern "js" fn URL::new(url : String, base? : String) -> URL =
  #| (url, base) => new URL(url, base)

///|
/// Get the href property
pub fn URL::href(self : URL) -> String {
  @js.unsafe_cast(self.get("href"))
}

///|
/// Set the href property
pub fn URL::set_href(self : URL, value : String) -> Unit {
  self.set("href", value)
}

///|
/// Get the origin property (read-only)
pub fn URL::origin(self : URL) -> String {
  @js.unsafe_cast(self.get("origin"))
}

///|
/// Get the protocol property
pub fn URL::protocol(self : URL) -> String {
  @js.unsafe_cast(self.get("protocol"))
}

///|
/// Set the protocol property
pub fn URL::set_protocol(self : URL, value : String) -> Unit {
  self.set("protocol", value)
}

///|
/// Get the host property
pub fn URL::host(self : URL) -> String {
  @js.unsafe_cast(self.get("host"))
}

///|
/// Set the host property
pub fn URL::set_host(self : URL, value : String) -> Unit {
  self.set("host", value)
}

///|
/// Get the hostname property
pub fn URL::hostname(self : URL) -> String {
  @js.unsafe_cast(self.get("hostname"))
}

///|
/// Set the hostname property
pub fn URL::set_hostname(self : URL, value : String) -> Unit {
  self.set("hostname", value)
}

///|
/// Get the port property
pub fn URL::port(self : URL) -> String {
  @js.unsafe_cast(self.get("port"))
}

///|
/// Set the port property
pub fn URL::set_port(self : URL, value : String) -> Unit {
  self.set("port", value)
}

///|
/// Get the pathname property
pub fn URL::pathname(self : URL) -> String {
  @js.unsafe_cast(self.get("pathname"))
}

///|
/// Set the pathname property
pub fn URL::set_pathname(self : URL, value : String) -> Unit {
  self.set("pathname", value)
}

///|
/// Get the search property
pub fn URL::search(self : URL) -> String {
  @js.unsafe_cast(self.get("search"))
}

///|
/// Set the search property
pub fn URL::set_search(self : URL, value : String) -> Unit {
  self.set("search", value)
}

///|
/// Get the hash property
pub fn URL::hash(self : URL) -> String {
  @js.unsafe_cast(self.get("hash"))
}

///|
/// Set the hash property
pub fn URL::set_hash(self : URL, value : String) -> Unit {
  self.set("hash", value)
}

///|
/// Get the searchParams property
pub fn URL::searchParams(self : URL) -> URLSearchParams {
  @js.unsafe_cast(self.get("searchParams"))
}

///|
/// Convert URL to string
#alias(toString)
pub fn URL::to_string(self : URL) -> String {
  @js.unsafe_cast(self.call("toString", []))
}

///|
/// Convert URL to JSON
#alias(toJSON)
pub fn URL::to_json(self : URL) -> String {
  @js.unsafe_cast(self.call("toJSON", []))
}
