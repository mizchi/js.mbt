///|
/// Location represents the location (URL) of the object it is linked to
/// https://developer.mozilla.org/en-US/docs/Web/API/Location
pub(all) struct Location {
  mut href : String
  protocol : String
  host : String
  hostname : String
  port : String
  mut pathname : String
  mut search : String
  mut hash : String
  origin : String
}

///|
pub impl @js.JsImpl for Location

///|
/// Returns the global location object
pub extern "js" fn location() -> Location =
  #| () => location

///|
/// Loads the resource at the URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/assign
pub fn Location::assign(self : Self, url : String) -> Unit {
  ignore(self.to_any().call("assign", [url]))
}

///|
/// Replaces the current resource with the one at the provided URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/replace
pub fn Location::replace(self : Self, url : String) -> Unit {
  ignore(self.to_any().call("replace", [url]))
}

///|
/// Reloads the current URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/reload
pub fn Location::reload(self : Self) -> Unit {
  ignore(self.to_any().call0("reload"))
}

///|
/// Returns the URL as a string
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/toString
pub fn Location::to_string(self : Self) -> String {
  self.to_any().call0("toString").cast()
}
