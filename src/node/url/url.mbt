///|
extern "js" fn url_module() -> @core.Any =
  #| () => require("node:url")

///|
/// Convert a file URL to a file path
#alias(file_url_to_path)
pub fn fileURLToPath(url : String, windows? : Bool) -> String {
  let url_module = url_module()
  match windows {
    Some(w) => {
      let entries : Array[(String, @core.Any)] = []
      entries.push(("windows", @core.any(w)))
      let options = @core.from_entries(entries)
      url_module._call("fileURLToPath", [@core.any(url), options]).cast()
    }
    None => url_module._call("fileURLToPath", [@core.any(url)]).cast()
  }
}

///|
/// Convert a file URL object to a file path
#alias(file_url_to_path_from_url)
pub fn fileURLToPathFromURL(url : @weburl.URL, windows? : Bool) -> String {
  let url_module : @core.Any = @core.any(url_module())
  match windows {
    Some(w) => {
      let entries : Array[(String, @core.Any)] = []
      entries.push(("windows", @core.any(w)))
      let options = @core.from_entries(entries)
      url_module._call("fileURLToPath", [url.as_any(), options]).cast()
    }
    None => url_module._call("fileURLToPath", [url.as_any()]).cast()
  }
}

///|
/// Convert a file path to a file URL
#alias(path_to_file_url)
pub fn pathToFileURL(path : String, windows? : Bool) -> @weburl.URL {
  let url_module = url_module()
  match windows {
    Some(w) => {
      let entries : Array[(String, @core.Any)] = []
      entries.push(("windows", @core.any(w)))
      let options = @core.from_entries(entries)
      url_module._call("pathToFileURL", [@core.any(path), options]).cast()
    }
    None => url_module._call("pathToFileURL", [@core.any(path)]).cast()
  }
}

///|
/// Convert URL to HTTP options object
#alias(url_to_http_options)
pub fn urlToHttpOptions(url : @weburl.URL) -> @core.Any {
  let url_module : @core.Any = @core.any(url_module())
  url_module._call("urlToHttpOptions", [url.as_any()]).cast()
}

///|
/// Format a URL object to string (legacy API)
pub fn format(url : @weburl.URL) -> String {
  let url_module : @core.Any = @core.any(url_module())
  url_module._call("format", [url.as_any()]).cast()
}
