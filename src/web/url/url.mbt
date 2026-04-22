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
} derive(Eq)

///|
pub impl Show for URL with output(self, logger) {
  logger.write_string("{href: ")
  logger.write_object(self.href)
  logger.write_string(", origin: ")
  logger.write_object(self.origin)
  logger.write_string(", protocol: ")
  logger.write_object(self.protocol)
  logger.write_string(", username: ")
  logger.write_object(self.username)
  logger.write_string(", password: ")
  logger.write_object(self.password)
  logger.write_string(", host: ")
  logger.write_object(self.host)
  logger.write_string(", hostname: ")
  logger.write_object(self.hostname)
  logger.write_string(", port: ")
  logger.write_object(self.port)
  logger.write_string(", pathname: ")
  logger.write_object(self.pathname)
  logger.write_string(", search: ")
  logger.write_object(self.search)
  logger.write_string(", hash: ")
  logger.write_object(self.hash)
  logger.write_string(", searchParams: ")
  logger.write_object(self.searchParams)
  logger.write_string("}")
}

///|
pub fn URL::as_any(self : URL) -> @core.Any = "%identity"

///|
/// Create a new URL (internal)
extern "js" fn ffi_url_new(url : String, base? : String) -> URL =
  #| (url, base) => new URL(url, base)

///|
/// Create a new URL
pub fn URL::new(url : String, base? : String) -> URL raise @core.JsError {
  @core.try_sync(fn() { @core.any(ffi_url_new(url, base?)) }).cast()
}

///|
/// Get the searchParams property
pub fn URL::searchParams(self : URL) -> URLSearchParams {
  self.as_any()["searchParams"].cast()
}

///|
/// Convert URL to string
#alias(toString)
pub fn URL::to_string(self : URL) -> String {
  self.as_any()._call("toString", []).cast()
}

///|
/// Convert URL to JSON
#alias(toJSON)
pub fn URL::to_json(self : URL) -> String {
  self.as_any()._call("toJSON", []).cast()
}
