///|
/// Navigator represents the state and identity of the user agent
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator
pub(all) struct Navigator {
  userAgent : String
  onLine : Bool
  language : String
  languages : Array[String]
  platform : String
  hardwareConcurrency : Int
  deviceMemory : Double?
  maxTouchPoints : Int
  vendor : String
  cookieEnabled : Bool
  doNotTrack : String?
  connection : @nostd.Any?
  permissions : @nostd.Any
  clipboard : @nostd.Any
  geolocation : @nostd.Any
}

///|
pub fn Navigator::as_any(self : Navigator) -> @nostd.Any = "%identity"

///|
/// Returns the global navigator object
pub extern "js" fn navigator() -> Navigator =
  #| () => navigator

///|
/// Vibrates the device
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/vibrate
pub fn Navigator::vibrate(self : Navigator, pattern : Int) -> Bool {
  self.as_any()._call("vibrate", [@nostd.any(pattern)]).cast()
}
