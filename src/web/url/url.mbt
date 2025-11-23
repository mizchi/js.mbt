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
/// Create a new URL (internal)
extern "js" fn ffi_url_new(url : String, base? : String) -> URL =
  #| (url, base) => new URL(url, base)

///|
/// Create a new URL
pub fn URL::new(url : String, base? : String) -> URL raise @js.ThrowError {
  @js.throwable(fn() { ffi_url_new(url, base?) })
}

///|
/// Get the searchParams property
pub fn URL::searchParams(self : URL) -> URLSearchParams {
  self.get("searchParams") |> @js.unsafe_cast
}

///|
/// Convert URL to string
#alias(toString)
pub fn URL::to_string(self : URL) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
/// Convert URL to JSON
#alias(toJSON)
pub fn URL::to_json(self : URL) -> String {
  self.call0("toJSON") |> @js.unsafe_cast
}
