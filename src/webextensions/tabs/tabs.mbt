///|
/// WebExtensions Tabs API
/// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/tabs

///|
/// Tab - represents a browser tab
pub struct Tab {
  id : Int?
  index : Int
  window_id : Int
  highlighted : Bool
  active : Bool
  pinned : Bool
  url : String?
  title : String?
  fav_icon_url : String?
  status : String?
  incognito : Bool
  width : Int?
  height : Int?
}

///|
pub fn Tab::as_any(self : Tab) -> @core.Any = "%identity"

///|
pub fn Tab::from_any(obj : @core.Any) -> Tab {
  let o : @core.Any = obj |> @core.any
  {
    id: @core.identity_option(o["id"]),
    index: o["index"].cast(),
    window_id: o["windowId"].cast(),
    highlighted: o["highlighted"].cast(),
    active: o["active"].cast(),
    pinned: o["pinned"].cast(),
    url: @core.identity_option(o["url"]),
    title: @core.identity_option(o["title"]),
    fav_icon_url: @core.identity_option(o["favIconUrl"]),
    status: @core.identity_option(o["status"]),
    incognito: o["incognito"].cast(),
    width: @core.identity_option(o["width"]),
    height: @core.identity_option(o["height"]),
  }
}

///|
/// Query options for tabs.query()
pub(all) struct QueryOptions {
  active : Bool?
  current_window : Bool?
  highlighted : Bool?
  pinned : Bool?
  url : String?
  window_id : Int?
  index : Int?
  status : String?
}

///|
pub fn QueryOptions::default() -> QueryOptions {
  {
    active: None,
    current_window: None,
    highlighted: None,
    pinned: None,
    url: None,
    window_id: None,
    index: None,
    status: None,
  }
}

///|
fn QueryOptions::to_any(self : QueryOptions) -> @core.Any {
  let obj = @core.Object::new()
  if self.active is Some(v) {
    obj["active"] = @core.any(v)
  }
  if self.current_window is Some(v) {
    obj["currentWindow"] = @core.any(v)
  }
  if self.highlighted is Some(v) {
    obj["highlighted"] = @core.any(v)
  }
  if self.pinned is Some(v) {
    obj["pinned"] = @core.any(v)
  }
  if self.url is Some(v) {
    obj["url"] = @core.any(v)
  }
  if self.window_id is Some(v) {
    obj["windowId"] = @core.any(v)
  }
  if self.index is Some(v) {
    obj["index"] = @core.any(v)
  }
  if self.status is Some(v) {
    obj["status"] = @core.any(v)
  }
  obj |> @core.identity
}

///|
/// Query tabs
pub async fn query(
  options? : QueryOptions = QueryOptions::default(),
) -> Array[Tab] {
  let result = ffi_query(options.to_any()).wait()
  let arr : Array[@core.Any] = result |> @core.identity
  arr.map(Tab::from_any)
}

///|
extern "js" fn ffi_query(options : @core.Any) -> @js.Promise[@core.Any] =
  #|async (options) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.query(options);
  #|}

///|
/// Get current active tab in current window
pub async fn get_current() -> Tab? {
  let tabs = query(options={
    ..QueryOptions::default(),
    active: Some(true),
    current_window: Some(true),
  })
  if tabs.length() > 0 {
    Some(tabs[0])
  } else {
    None
  }
}

///|
/// Get a tab by ID
pub async fn get(tab_id : Int) -> Tab {
  let result = ffi_get(tab_id).wait()
  Tab::from_any(result)
}

///|
extern "js" fn ffi_get(tab_id : Int) -> @js.Promise[@core.Any] =
  #|async (tabId) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs._get(tabId);
  #|}

///|
/// Create options for tabs.create()
pub(all) struct CreateOptions {
  url : String?
  active : Bool?
  pinned : Bool?
  window_id : Int?
  index : Int?
  opener_tab_id : Int?
}

///|
pub fn CreateOptions::default() -> CreateOptions {
  {
    url: None,
    active: None,
    pinned: None,
    window_id: None,
    index: None,
    opener_tab_id: None,
  }
}

///|
fn CreateOptions::to_any(self : CreateOptions) -> @core.Any {
  let obj = @core.Object::new()
  if self.url is Some(v) {
    obj["url"] = @core.any(v)
  }
  if self.active is Some(v) {
    obj["active"] = @core.any(v)
  }
  if self.pinned is Some(v) {
    obj["pinned"] = @core.any(v)
  }
  if self.window_id is Some(v) {
    obj["windowId"] = @core.any(v)
  }
  if self.index is Some(v) {
    obj["index"] = @core.any(v)
  }
  if self.opener_tab_id is Some(v) {
    obj["openerTabId"] = @core.any(v)
  }
  obj |> @core.identity
}

///|
/// Create a new tab
pub async fn create(options? : CreateOptions = CreateOptions::default()) -> Tab {
  let result = ffi_create(options.to_any()).wait()
  Tab::from_any(result)
}

///|
extern "js" fn ffi_create(options : @core.Any) -> @js.Promise[@core.Any] =
  #|async (options) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.create(options);
  #|}

///|
/// Update options for tabs.update()
pub(all) struct UpdateOptions {
  url : String?
  active : Bool?
  pinned : Bool?
  highlighted : Bool?
  muted : Bool?
}

///|
pub fn UpdateOptions::default() -> UpdateOptions {
  { url: None, active: None, pinned: None, highlighted: None, muted: None }
}

///|
fn UpdateOptions::to_any(self : UpdateOptions) -> @core.Any {
  let obj = @core.Object::new()
  if self.url is Some(v) {
    obj["url"] = @core.any(v)
  }
  if self.active is Some(v) {
    obj["active"] = @core.any(v)
  }
  if self.pinned is Some(v) {
    obj["pinned"] = @core.any(v)
  }
  if self.highlighted is Some(v) {
    obj["highlighted"] = @core.any(v)
  }
  if self.muted is Some(v) {
    obj["muted"] = @core.any(v)
  }
  obj |> @core.identity
}

///|
/// Update a tab
pub async fn update(tab_id : Int, options : UpdateOptions) -> Tab {
  let result = ffi_update(tab_id, options.to_any()).wait()
  Tab::from_any(result)
}

///|
extern "js" fn ffi_update(
  tab_id : Int,
  options : @core.Any,
) -> @js.Promise[@core.Any] =
  #|async (tabId, options) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.update(tabId, options);
  #|}

///|
/// Remove/close tabs
pub async fn remove(tab_ids : Array[Int]) -> Unit {
  ffi_remove(tab_ids).wait()
}

///|
extern "js" fn ffi_remove(tab_ids : Array[Int]) -> @js.Promise[Unit] =
  #|async (tabIds) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.remove(tabIds);
  #|}

///|
/// Remove/close a single tab
pub async fn remove_tab(tab_id : Int) -> Unit {
  remove([tab_id])
}

///|
/// Reload a tab
pub async fn reload(tab_id : Int, bypass_cache? : Bool = false) -> Unit {
  let options = @core.Object::new()
  if bypass_cache {
    options["bypassCache"] = @core.any(true)
  }
  ffi_reload(tab_id, options |> @core.identity).wait()
}

///|
extern "js" fn ffi_reload(
  tab_id : Int,
  options : @core.Any,
) -> @js.Promise[Unit] =
  #|async (tabId, options) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.reload(tabId, options);
  #|}

///|
/// Duplicate a tab
pub async fn duplicate(tab_id : Int) -> Tab {
  let result = ffi_duplicate(tab_id).wait()
  Tab::from_any(result)
}

///|
extern "js" fn ffi_duplicate(tab_id : Int) -> @js.Promise[@core.Any] =
  #|async (tabId) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.duplicate(tabId);
  #|}

///|
/// Send message to content script in tab
pub async fn send_message(tab_id : Int, message : @core.Any) -> @core.Any {
  ffi_send_message(tab_id, message).wait()
}

///|
extern "js" fn ffi_send_message(
  tab_id : Int,
  message : @core.Any,
) -> @js.Promise[@core.Any] =
  #|async (tabId, message) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.sendMessage(tabId, message);
  #|}

///|
/// Listen for tab creation
pub fn on_created(callback : (Tab) -> Unit) -> Unit {
  ffi_on_created(fn(tab) { callback(Tab::from_any(tab)) })
}

///|
extern "js" fn ffi_on_created(callback : (@core.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onCreated.addListener(callback);
  #|}

///|
/// Listen for tab removal
pub fn on_removed(callback : (Int, @core.Any) -> Unit) -> Unit {
  ffi_on_removed(callback)
}

///|
extern "js" fn ffi_on_removed(callback : (Int, @core.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onRemoved.addListener(callback);
  #|}

///|
/// Listen for tab updates
pub fn on_updated(callback : (Int, @core.Any, Tab) -> Unit) -> Unit {
  ffi_on_updated(fn(tab_id, change_info, tab) {
    callback(tab_id, change_info, Tab::from_any(tab))
  })
}

///|
extern "js" fn ffi_on_updated(
  callback : (Int, @core.Any, @core.Any) -> Unit,
) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onUpdated.addListener(callback);
  #|}

///|
/// Listen for tab activation
pub fn on_activated(callback : (@core.Any) -> Unit) -> Unit {
  ffi_on_activated(callback)
}

///|
extern "js" fn ffi_on_activated(callback : (@core.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onActivated.addListener(callback);
  #|}
