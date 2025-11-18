///|
/// Convert a file URL to a file path
#alias(file_url_to_path)
pub fn fileURLToPath(url : String, windows? : Bool) -> String {
  let url_module = @node.require("node:url")
  match windows {
    Some(w) => {
      let options = @js.Object::new()
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
      let options = @js.Object::new()
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
      let options = @js.Object::new()
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
