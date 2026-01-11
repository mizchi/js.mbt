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
pub fn Location::as_any(self : Location) -> @core.Any = "%identity"

///|
/// Returns the global location object
pub extern "js" fn location() -> Location =
  #| () => location

///|
/// Loads the resource at the URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/assign
pub fn Location::assign(self : Location, url : String) -> Unit {
  self.as_any()._call("assign", [@core.any(url)]) |> ignore
}

///|
/// Replaces the current resource with the one at the provided URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/replace
pub fn Location::replace(self : Location, url : String) -> Unit {
  self.as_any()._call("replace", [@core.any(url)]) |> ignore
}

///|
/// Reloads the current URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/reload
pub fn Location::reload(self : Location) -> Unit {
  self.as_any()._call("reload", []) |> ignore
}

///|
/// Returns the URL as a string
/// https://developer.mozilla.org/en-US/docs/Web/API/Location/toString
pub fn Location::to_string(self : Location) -> String {
  self.as_any()._call("toString", []).cast()
}
