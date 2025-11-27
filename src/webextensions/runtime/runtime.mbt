///|
/// WebExtensions Runtime API
/// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/runtime

///|
fn runtime() -> @js.Any {
  @webextensions.browser().get("runtime")
}

///|
/// Get the extension's manifest
pub fn get_manifest() -> @js.Any {
  runtime().call("getManifest", [])
}

///|
/// Get the URL of a resource within the extension
pub fn get_url(path : String) -> String {
  runtime().call("getURL", [path |> @js.any]) |> @js.identity
}

///|
/// Get the extension's ID
pub fn id() -> String {
  runtime().get("id") |> @js.identity
}

///|
/// MessageSender - info about message sender
pub struct MessageSender {
  tab : @js.Any
  frame_id : Int?
  id : String?
  url : String?
}

///|
pub fn MessageSender::from_any(obj : @js.Any) -> MessageSender {
  {
    tab: obj.get("tab"),
    frame_id: obj.get("frameId") |> @js.identity,
    id: obj.get("id") |> @js.identity,
    url: obj.get("url") |> @js.identity,
  }
}

///|
/// Send a message to other parts of the extension
pub async fn send_message(message : @js.Any) -> @js.Any {
  ffi_send_message(message).wait()
}

///|
extern "js" fn ffi_send_message(message : @js.Any) -> @js.Promise[@js.Any] =
  #|async (message) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.runtime.sendMessage(message);
  #|}

///|
/// Send a message to a specific extension
pub async fn send_message_to_extension(
  extension_id : String,
  message : @js.Any,
) -> @js.Any {
  ffi_send_message_to_extension(extension_id, message).wait()
}

///|
extern "js" fn ffi_send_message_to_extension(
  extension_id : String,
  message : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (extensionId, message) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.runtime.sendMessage(extensionId, message);
  #|}

///|
/// Listen for messages from other parts of the extension
pub fn on_message(
  callback : (@js.Any, @js.Any, (@js.Any) -> Unit) -> Bool,
) -> Unit {
  ffi_on_message(callback)
}

///|
extern "js" fn ffi_on_message(
  callback : (@js.Any, @js.Any, (@js.Any) -> Unit) -> Bool,
) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.runtime.onMessage.addListener((message, sender, sendResponse) => {
  #|    return callback(message, sender, sendResponse);
  #|  });
  #|}

///|
/// Port - long-lived connection
#external
pub type Port

///|
pub impl @js.JsImpl for Port

///|
/// Get port name
pub fn Port::name(self : Port) -> String {
  (self |> @js.identity : @js.Any).get("name") |> @js.identity
}

///|
/// Post message to port
pub fn Port::post_message(self : Port, message : @js.Any) -> Unit {
  let port : @js.Any = self |> @js.identity
  port.call("postMessage", [message]) |> ignore
}

///|
/// Disconnect port
pub fn Port::disconnect(self : Port) -> Unit {
  let port : @js.Any = self |> @js.identity
  port.call("disconnect", []) |> ignore
}

///|
/// Add message listener to port
pub fn Port::on_message(self : Port, callback : (@js.Any) -> Unit) -> Unit {
  ffi_port_on_message(self |> @js.identity, callback)
}

///|
extern "js" fn ffi_port_on_message(
  port : @js.Any,
  callback : (@js.Any) -> Unit,
) -> Unit =
  #|(port, callback) => {
  #|  port.onMessage.addListener(callback);
  #|}

///|
/// Add disconnect listener to port
pub fn Port::on_disconnect(self : Port, callback : () -> Unit) -> Unit {
  ffi_port_on_disconnect(self |> @js.identity, callback)
}

///|
extern "js" fn ffi_port_on_disconnect(
  port : @js.Any,
  callback : () -> Unit,
) -> Unit =
  #|(port, callback) => {
  #|  port.onDisconnect.addListener(callback);
  #|}

///|
/// Connect to background script or other extension
pub fn connect(name? : String) -> Port {
  ffi_connect(name.unwrap_or("")) |> @js.identity
}

///|
extern "js" fn ffi_connect(name : String) -> @js.Any =
  #|(name) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  const options = name ? { name } : undefined;
  #|  return b.runtime.connect(options);
  #|}

///|
/// Listen for incoming connections
pub fn on_connect(callback : (Port) -> Unit) -> Unit {
  ffi_on_connect(fn(port) { callback(port |> @js.identity) })
}

///|
extern "js" fn ffi_on_connect(callback : (@js.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.runtime.onConnect.addListener(callback);
  #|}

///|
/// Listen for extension install/update
pub fn on_installed(callback : (@js.Any) -> Unit) -> Unit {
  ffi_on_installed(callback)
}

///|
extern "js" fn ffi_on_installed(callback : (@js.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.runtime.onInstalled.addListener(callback);
  #|}

///|
/// Listen for browser startup
pub fn on_startup(callback : () -> Unit) -> Unit {
  ffi_on_startup(callback)
}

///|
extern "js" fn ffi_on_startup(callback : () -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.runtime.onStartup.addListener(callback);
  #|}

///|
/// Get platform info
pub async fn get_platform_info() -> PlatformInfo {
  let result = ffi_get_platform_info().wait()
  PlatformInfo::from_any(result)
}

///|
extern "js" fn ffi_get_platform_info() -> @js.Promise[@js.Any] =
  #|async () => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.runtime.getPlatformInfo();
  #|}

///|
/// Platform info
pub struct PlatformInfo {
  os : String
  arch : String
}

///|
pub fn PlatformInfo::from_any(obj : @js.Any) -> PlatformInfo {
  { os: obj.get("os") |> @js.identity, arch: obj.get("arch") |> @js.identity }
}

///|
/// Open the extension's options page
pub async fn open_options_page() -> Unit {
  ffi_open_options_page().wait()
}

///|
extern "js" fn ffi_open_options_page() -> @js.Promise[Unit] =
  #|async () => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.runtime.openOptionsPage();
  #|}

///|
/// Reload the extension
pub fn reload() -> Unit {
  runtime().call("reload", []) |> ignore
}

///|
/// Get the last error
pub fn last_error() -> @js.Any {
  runtime().get("lastError")
}
