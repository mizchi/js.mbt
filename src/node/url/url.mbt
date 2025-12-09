///| node:url module bindings
/// https://nodejs.org/api/url.html

// FFI with #module for simple functions

///|
/// Convert a file URL string to a file path (simple form)
#module("node:url")
extern "js" fn ffi_fileURLToPath(url : String) -> String = "fileURLToPath"

///|
/// Convert a file URL object to a file path (simple form)
#module("node:url")
extern "js" fn ffi_fileURLToPath_url(url : @weburl.URL) -> String = "fileURLToPath"

///|
/// Convert a file path to a file URL (simple form)
#module("node:url")
extern "js" fn ffi_pathToFileURL(path : String) -> @weburl.URL = "pathToFileURL"

///|
/// Convert URL to HTTP options object
#module("node:url")
extern "js" fn ffi_urlToHttpOptions(url : @weburl.URL) -> @core.Any = "urlToHttpOptions"

///|
/// Format a URL object to string (legacy API)
#module("node:url")
extern "js" fn ffi_format(url : @weburl.URL) -> String = "format"

// Functions with optional parameters need inline require()

///|
extern "js" fn ffi_fileURLToPath_with_options(
  url : String,
  options : @core.Any,
) -> String =
  #| (url, options) => require("node:url").fileURLToPath(url, options)

///|
extern "js" fn ffi_fileURLToPath_url_with_options(
  url : @weburl.URL,
  options : @core.Any,
) -> String =
  #| (url, options) => require("node:url").fileURLToPath(url, options)

///|
extern "js" fn ffi_pathToFileURL_with_options(
  path : String,
  options : @core.Any,
) -> @weburl.URL =
  #| (path, options) => require("node:url").pathToFileURL(path, options)

// Public API

///|
/// Convert a file URL to a file path
#alias(file_url_to_path)
pub fn fileURLToPath(url : String, windows? : Bool) -> String {
  match windows {
    Some(w) => {
      let options = @core.new_object()
      options["windows"] = @core.any(w)
      ffi_fileURLToPath_with_options(url, options)
    }
    None => ffi_fileURLToPath(url)
  }
}

///|
/// Convert a file URL object to a file path
#alias(file_url_to_path_from_url)
pub fn fileURLToPathFromURL(url : @weburl.URL, windows? : Bool) -> String {
  match windows {
    Some(w) => {
      let options = @core.new_object()
      options["windows"] = @core.any(w)
      ffi_fileURLToPath_url_with_options(url, options)
    }
    None => ffi_fileURLToPath_url(url)
  }
}

///|
/// Convert a file path to a file URL
#alias(path_to_file_url)
pub fn pathToFileURL(path : String, windows? : Bool) -> @weburl.URL {
  match windows {
    Some(w) => {
      let options = @core.new_object()
      options["windows"] = @core.any(w)
      ffi_pathToFileURL_with_options(path, options)
    }
    None => ffi_pathToFileURL(path)
  }
}

///|
/// Convert URL to HTTP options object
#alias(url_to_http_options)
pub fn urlToHttpOptions(url : @weburl.URL) -> @core.Any {
  ffi_urlToHttpOptions(url)
}

///|
/// Format a URL object to string (legacy API)
pub fn format(url : @weburl.URL) -> String {
  ffi_format(url)
}
