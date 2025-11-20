///|
/// Navigator represents the state and identity of the user agent
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator
#external
pub type Navigator

///|
pub impl JsImpl for Navigator

///|
/// Returns the global navigator object
pub extern "js" fn navigator() -> Navigator =
  #| () => navigator

///|
/// Returns the user agent string
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/userAgent
pub extern "js" fn Navigator::userAgent(self : Self) -> String =
  #| (nav) => nav.userAgent

///|
/// Returns whether the browser is online
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/onLine
pub extern "js" fn Navigator::onLine(self : Self) -> Bool =
  #| (nav) => nav.onLine

///|
/// Returns the browser's language
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/language
pub fn Navigator::language(self : Self) -> String {
  self.get("language") |> unsafe_cast
}

///|
/// Returns the browser's preferred languages
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/languages
pub fn Navigator::languages(self : Self) -> Js {
  self.get("languages")
}

///|
/// Returns the platform string
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/platform
pub fn Navigator::platform(self : Self) -> String {
  self.get("platform") |> unsafe_cast
}

///|
/// Returns the number of logical processors
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/hardwareConcurrency
pub fn Navigator::hardwareConcurrency(self : Self) -> Int {
  self.get("hardwareConcurrency") |> unsafe_cast
}

///|
/// Returns the device memory in GB
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/deviceMemory
pub fn Navigator::deviceMemory(self : Self) -> Double? {
  self.get("deviceMemory") |> @js.unsafe_cast_option()
}

///|
/// Returns the maximum touch points
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/maxTouchPoints
pub fn Navigator::maxTouchPoints(self : Self) -> Int {
  self.get("maxTouchPoints") |> unsafe_cast
}

///|
/// Returns the vendor name
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/vendor
pub fn Navigator::vendor(self : Self) -> String {
  self.get("vendor") |> unsafe_cast
}

///|
/// Returns whether cookies are enabled
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/cookieEnabled
pub fn Navigator::cookieEnabled(self : Self) -> Bool {
  self.get("cookieEnabled") |> unsafe_cast
}

///|
/// Returns whether Do Not Track is enabled
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/doNotTrack
pub fn Navigator::doNotTrack(self : Self) -> String? {
  self.get("doNotTrack") |> @js.unsafe_cast_option()
}

///|
/// Returns the connection information
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/connection
pub fn Navigator::connection(self : Self) -> Js? {
  self.get("connection") |> @js.unsafe_cast_option()
}

///|
/// Requests permission for a feature
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/permissions
pub fn Navigator::permissions(self : Self) -> Js {
  self.get("permissions")
}

///|
/// Returns the clipboard API
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/clipboard
pub fn Navigator::clipboard(self : Self) -> Js {
  self.get("clipboard")
}

///|
/// Returns the geolocation API
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/geolocation
pub fn Navigator::geolocation(self : Self) -> Js {
  self.get("geolocation")
}

///|
/// Vibrates the device
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/vibrate
pub fn Navigator::vibrate(self : Self, pattern : Int) -> Bool {
  self.call("vibrate", [pattern]) |> unsafe_cast
}
