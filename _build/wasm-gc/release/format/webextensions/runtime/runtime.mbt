///|
/// WebExtensions Runtime API
/// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/runtime

///|
fn runtime() -> @core.Any {
  let b : @core.Any = @webextensions.browser() |> @core.any
  b["runtime"]
}

///|
/// Get the extension's manifest
pub fn getManifest() -> @core.Any {
  runtime()._call("getManifest", []) |> @core.identity
}

///|
/// Get the URL of a resource within the extension
pub fn getUrl(path : String) -> String {
  runtime()._call("getURL", [@core.any(path)]).cast()
}

///|
/// Get the extension's ID
pub fn id() -> String {
  runtime()["id"].cast()
}

///|
/// MessageSender - info about message sender
pub struct MessageSender {
  tab : @core.Any
  frame_id : Int?
  id : String?
  url : String?
}

///|
pub fn MessageSender::from_any(obj : @core.Any) -> MessageSender {
  let o : @core.Any = obj |> @core.any
  {
    tab: o["tab"] |> @core.identity,
    frame_id: @core.identity_option(o["frameId"]),
    id: @core.identity_option(o["id"]),
    url: @core.identity_option(o["url"]),
  }
}

///|
/// Send a message to other parts of the extension
pub async fn sendMessage(message : @core.Any) -> @core.Any {
  ffi_send_message(message).wait()
}

///|
extern "js" fn ffi_send_message(message : @core.Any) -> @js.Promise[@core.Any] =
  #|async (message) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.runtime.sendMessage(message);
  #|}

///|
/// Send a message to a specific extension
pub async fn send_message_to_extension(
  extension_id : String,
  message : @core.Any,
) -> @core.Any {
  ffi_send_message_to_extension(extension_id, message).wait()
}

///|
extern "js" fn ffi_send_message_to_extension(
  extension_id : String,
  message : @core.Any,
) -> @js.Promise[@core.Any] =
  #|async (extensionId, message) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.runtime.sendMessage(extensionId, message);
  #|}

///|
/// Listen for messages from other parts of the extension
pub fn on_message(
  callback : (@core.Any, @core.Any, (@core.Any) -> Unit) -> Bool,
) -> Unit {
  ffi_on_message(callback)
}

///|
extern "js" fn ffi_on_message(
  callback : (@core.Any, @core.Any, (@core.Any) -> Unit) -> Bool,
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
pub fn Port::to_any(self : Port) -> @core.Any = "%identity"

///|
/// Get port name
pub fn Port::name(self : Port) -> String {
  self.to_any()["name"].cast()
}

///|
/// Post message to port
pub fn Port::post_message(self : Port, message : @core.Any) -> Unit {
  self.to_any()._call("postMessage", [@core.any(message)]) |> ignore
}

///|
/// Disconnect port
pub fn Port::disconnect(self : Port) -> Unit {
  self.to_any()._call("disconnect", []) |> ignore
}

///|
/// Add message listener to port
pub fn Port::on_message(self : Port, callback : (@core.Any) -> Unit) -> Unit {
  ffi_port_on_message(self.to_any() |> @core.identity, callback)
}

///|
extern "js" fn ffi_port_on_message(
  port : @core.Any,
  callback : (@core.Any) -> Unit,
) -> Unit =
  #|(port, callback) => {
  #|  port.onMessage.addListener(callback);
  #|}

///|
/// Add disconnect listener to port
pub fn Port::on_disconnect(self : Port, callback : () -> Unit) -> Unit {
  ffi_port_on_disconnect(self.to_any() |> @core.identity, callback)
}

///|
extern "js" fn ffi_port_on_disconnect(
  port : @core.Any,
  callback : () -> Unit,
) -> Unit =
  #|(port, callback) => {
  #|  port.onDisconnect.addListener(callback);
  #|}

///|
/// Connect to background script or other extension
pub fn connect(name? : String) -> Port {
  ffi_connect(name.unwrap_or("")) |> @core.identity
}

///|
extern "js" fn ffi_connect(name : String) -> @core.Any =
  #|(name) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  const options = name ? { name } : undefined;
  #|  return b.runtime.connect(options);
  #|}

///|
/// Listen for incoming connections
pub fn on_connect(callback : (Port) -> Unit) -> Unit {
  ffi_on_connect(fn(port) { callback(port |> @core.identity) })
}

///|
extern "js" fn ffi_on_connect(callback : (@core.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.runtime.onConnect.addListener(callback);
  #|}

///|
/// Listen for extension install/update
pub fn on_installed(callback : (@core.Any) -> Unit) -> Unit {
  ffi_on_installed(callback)
}

///|
extern "js" fn ffi_on_installed(callback : (@core.Any) -> Unit) -> Unit =
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
extern "js" fn ffi_get_platform_info() -> @js.Promise[@core.Any] =
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
pub fn PlatformInfo::from_any(obj : @core.Any) -> PlatformInfo {
  let o : @core.Any = obj |> @core.any
  { os: o["os"].cast(), arch: o["arch"].cast() }
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
  runtime()._call("reload", []) |> ignore
}

///|
/// Get the last error
pub fn last_error() -> @core.Any {
  runtime()["lastError"] |> @core.identity
}
