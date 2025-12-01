///|
extern "js" fn url_module() -> @js.Any =
  #| () => require("node:url")

///|
/// Convert a file URL to a file path
#alias(file_url_to_path)
pub fn fileURLToPath(url : String, windows? : Bool) -> String {
  let url_module = url_module()
  match windows {
    Some(w) =>
      url_module
      .call2(
        "fileURLToPath",
        url,
        @js.from_option_map({ "windows": Some(@js.any(w)) }),
      )
      .cast()
    None => url_module.call1("fileURLToPath", url).cast()
  }
}

///|
/// Convert a file URL object to a file path
#alias(file_url_to_path_from_url)
pub fn fileURLToPathFromURL(url : @weburl.URL, windows? : Bool) -> String {
  let url_module : @nostd.Any = @nostd.any(url_module())
  match windows {
    Some(w) =>
      url_module
      ._call("fileURLToPath", [
        url.as_any(),
        @nostd.any(@js.from_option_map({ "windows": Some(@js.any(w)) })),
      ])
      .cast()
    None => url_module._call("fileURLToPath", [url.as_any()]).cast()
  }
}

///|
/// Convert a file path to a file URL
#alias(path_to_file_url)
pub fn pathToFileURL(path : String, windows? : Bool) -> @weburl.URL {
  let url_module = url_module()
  match windows {
    Some(w) =>
      url_module
      .call2(
        "pathToFileURL",
        path,
        @js.from_option_map({ "windows": Some(@js.any(w)) }),
      )
      .cast()
    None => url_module.call1("pathToFileURL", path).cast()
  }
}

///|
/// Convert URL to HTTP options object
#alias(url_to_http_options)
pub fn urlToHttpOptions(url : @weburl.URL) -> @js.Any {
  let url_module : @nostd.Any = @nostd.any(url_module())
  url_module._call("urlToHttpOptions", [url.as_any()]).cast()
}

///|
/// Format a URL object to string (legacy API)
pub fn format(url : @weburl.URL) -> String {
  let url_module : @nostd.Any = @nostd.any(url_module())
  url_module._call("format", [url.as_any()]).cast()
}
