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
  connection : @js.Any?
  permissions : @js.Any
  clipboard : @js.Any
  geolocation : @js.Any
}

///|
pub impl @js.JsImpl for Navigator

///|
/// Returns the global navigator object
pub extern "js" fn navigator() -> Navigator =
  #| () => navigator

///|
/// Vibrates the device
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/vibrate
pub fn Navigator::vibrate(self : Self, pattern : Int) -> Bool {
  self.call("vibrate", [pattern]).cast()
}
