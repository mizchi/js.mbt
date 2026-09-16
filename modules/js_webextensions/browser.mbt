///|
/// WebExtensions API - browser global
/// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API

///|
/// Get the browser global object
/// In Firefox: browser
/// In Chrome: chrome (with Promise polyfill)
pub extern "js" fn browser() -> @core.Any =
  #|() => {
  #|  if (typeof browser !== 'undefined') return browser;
  #|  if (typeof chrome !== 'undefined') return chrome;
  #|  throw new Error('WebExtensions API not available');
  #|}
