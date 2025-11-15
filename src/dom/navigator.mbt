///|
/// Navigator represents the state and identity of the user agent
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator
#external
pub type Navigator

///|
pub impl Js for Navigator with to_js(self) {
  self |> js
}

///|
/// Returns the global navigator object
pub extern "js" fn navigator() -> Navigator =
  #| () => navigator

///|
/// Returns the user agent string
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/userAgent
pub extern "js" fn Navigator::user_agent(self : Self) -> String =
  #| (nav) => nav.userAgent

///|
/// Returns whether the browser is online
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/onLine
pub extern "js" fn Navigator::on_line(self : Self) -> Bool =
  #| (nav) => nav.onLine

///|
/// Returns the browser's language
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/language
pub fn Navigator::language(self : Self) -> String {
  unsafe_cast(self.to_js().get("language"))
}

///|
/// Returns the browser's preferred languages
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/languages
pub fn Navigator::languages(self : Self) -> Val {
  self.to_js().get("languages")
}

///|
/// Returns the platform string
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/platform
pub fn Navigator::platform(self : Self) -> String {
  unsafe_cast(self.to_js().get("platform"))
}

///|
/// Returns the number of logical processors
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/hardwareConcurrency
pub fn Navigator::hardware_concurrency(self : Self) -> Int {
  unsafe_cast(self.to_js().get("hardwareConcurrency"))
}

///|
/// Returns the device memory in GB
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/deviceMemory
pub fn Navigator::device_memory(self : Self) -> Double? {
  self.to_js().get("deviceMemory") |> unsafe_cast_option()
}

///|
/// Returns the maximum touch points
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/maxTouchPoints
pub fn Navigator::max_touch_points(self : Self) -> Int {
  unsafe_cast(self.to_js().get("maxTouchPoints"))
}

///|
/// Returns the vendor name
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/vendor
pub fn Navigator::vendor(self : Self) -> String {
  unsafe_cast(self.to_js().get("vendor"))
}

///|
/// Returns whether cookies are enabled
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/cookieEnabled
pub fn Navigator::cookie_enabled(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("cookieEnabled"))
}

///|
/// Returns whether Do Not Track is enabled
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/doNotTrack
pub fn Navigator::do_not_track(self : Self) -> String? {
  self.to_js().get("doNotTrack") |> unsafe_cast_option()
}

///|
/// Returns the connection information
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/connection
pub fn Navigator::connection(self : Self) -> Val? {
  self.to_js().get("connection") |> unsafe_cast_option()
}

///|
/// Requests permission for a feature
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/permissions
pub fn Navigator::permissions(self : Self) -> Val {
  self.to_js().get("permissions")
}

///|
/// Returns the clipboard API
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/clipboard
pub fn Navigator::clipboard(self : Self) -> Val {
  self.to_js().get("clipboard")
}

///|
/// Returns the geolocation API
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/geolocation
pub fn Navigator::geolocation(self : Self) -> Val {
  self.to_js().get("geolocation")
}

///|
/// Vibrates the device
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/vibrate
pub fn Navigator::vibrate(self : Self, pattern : Int) -> Bool {
  self.invoke("vibrate", [pattern |> js]) |> unsafe_cast
}
