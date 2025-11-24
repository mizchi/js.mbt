///|
/// Convert a file URL to a file path
#alias(file_url_to_path)
pub fn fileURLToPath(url : String, windows? : Bool) -> String {
  let url_module = @node.require("node:url")
  match windows {
    Some(w) =>
      url_module.call2(
        "fileURLToPath",
        url,
        @js.from_entries_option_cast([("windows", Some(w))]),
      )
      |> @js.identity
    None => url_module.call1("fileURLToPath", url) |> @js.identity
  }
}

///|
/// Convert a file URL object to a file path
#alias(file_url_to_path_from_url)
pub fn fileURLToPathFromURL(url : @weburl.URL, windows? : Bool) -> String {
  let url_module = @node.require("node:url")
  match windows {
    Some(w) =>
      url_module.call2(
        "fileURLToPath",
        url,
        @js.from_entries_option_cast([("windows", Some(w))]),
      )
      |> @js.identity
    None => url_module.call1("fileURLToPath", url) |> @js.identity
  }
}

///|
/// Convert a file path to a file URL
#alias(path_to_file_url)
pub fn pathToFileURL(path : String, windows? : Bool) -> @weburl.URL {
  let url_module = @node.require("node:url")
  match windows {
    Some(w) =>
      url_module.call2(
        "pathToFileURL",
        path,
        @js.from_entries_option_cast([("windows", Some(w))]),
      )
      |> @js.identity
    None => url_module.call1("pathToFileURL", path) |> @js.identity
  }
}

///|
/// Convert URL to HTTP options object
#alias(url_to_http_options)
pub fn urlToHttpOptions(url : @weburl.URL) -> @js.Js {
  let url_module = @node.require("node:url")
  url_module.call1("urlToHttpOptions", url)
}

///|
/// Format a URL object to string (legacy API)
pub fn format(url : @weburl.URL) -> String {
  let url_module = @node.require("node:url")
  url_module.call1("format", url) |> @js.identity
}
