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
pub fn Tab::from_any(obj : @js.Any) -> Tab {
  {
    id: obj.get("id") |> @js.identity,
    index: obj.get("index") |> @js.identity,
    window_id: obj.get("windowId") |> @js.identity,
    highlighted: obj.get("highlighted") |> @js.identity,
    active: obj.get("active") |> @js.identity,
    pinned: obj.get("pinned") |> @js.identity,
    url: obj.get("url") |> @js.identity,
    title: obj.get("title") |> @js.identity,
    fav_icon_url: obj.get("favIconUrl") |> @js.identity,
    status: obj.get("status") |> @js.identity,
    incognito: obj.get("incognito") |> @js.identity,
    width: obj.get("width") |> @js.identity,
    height: obj.get("height") |> @js.identity,
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
fn QueryOptions::as_any(self : QueryOptions) -> @js.Any {
  let obj = @js.Object::new()
  if self.active is Some(v) {
    obj.set("active", v)
  }
  if self.current_window is Some(v) {
    obj.set("currentWindow", v)
  }
  if self.highlighted is Some(v) {
    obj.set("highlighted", v)
  }
  if self.pinned is Some(v) {
    obj.set("pinned", v)
  }
  if self.url is Some(v) {
    obj.set("url", v)
  }
  if self.window_id is Some(v) {
    obj.set("windowId", v)
  }
  if self.index is Some(v) {
    obj.set("index", v)
  }
  if self.status is Some(v) {
    obj.set("status", v)
  }
  obj.as_any()
}

///|
/// Query tabs
pub async fn query(
  options? : QueryOptions = QueryOptions::default(),
) -> Array[Tab] {
  let result = ffi_query(options.as_any()).wait()
  let arr : Array[@js.Any] = result |> @js.identity
  arr.map(Tab::from_any)
}

///|
extern "js" fn ffi_query(options : @js.Any) -> @js.Promise[@js.Any] =
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
extern "js" fn ffi_get(tab_id : Int) -> @js.Promise[@js.Any] =
  #|async (tabId) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.get(tabId);
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
fn CreateOptions::as_any(self : CreateOptions) -> @js.Any {
  let obj = @js.Object::new()
  if self.url is Some(v) {
    obj.set("url", v)
  }
  if self.active is Some(v) {
    obj.set("active", v)
  }
  if self.pinned is Some(v) {
    obj.set("pinned", v)
  }
  if self.window_id is Some(v) {
    obj.set("windowId", v)
  }
  if self.index is Some(v) {
    obj.set("index", v)
  }
  if self.opener_tab_id is Some(v) {
    obj.set("openerTabId", v)
  }
  obj.as_any()
}

///|
/// Create a new tab
pub async fn create(options? : CreateOptions = CreateOptions::default()) -> Tab {
  let result = ffi_create(options.as_any()).wait()
  Tab::from_any(result)
}

///|
extern "js" fn ffi_create(options : @js.Any) -> @js.Promise[@js.Any] =
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
fn UpdateOptions::as_any(self : UpdateOptions) -> @js.Any {
  let obj = @js.Object::new()
  if self.url is Some(v) {
    obj.set("url", v)
  }
  if self.active is Some(v) {
    obj.set("active", v)
  }
  if self.pinned is Some(v) {
    obj.set("pinned", v)
  }
  if self.highlighted is Some(v) {
    obj.set("highlighted", v)
  }
  if self.muted is Some(v) {
    obj.set("muted", v)
  }
  obj.as_any()
}

///|
/// Update a tab
pub async fn update(tab_id : Int, options : UpdateOptions) -> Tab {
  let result = ffi_update(tab_id, options.as_any()).wait()
  Tab::from_any(result)
}

///|
extern "js" fn ffi_update(
  tab_id : Int,
  options : @js.Any,
) -> @js.Promise[@js.Any] =
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
  let options = @js.Object::new()
  if bypass_cache {
    options.set("bypassCache", true)
  }
  ffi_reload(tab_id, options.as_any()).wait()
}

///|
extern "js" fn ffi_reload(tab_id : Int, options : @js.Any) -> @js.Promise[Unit] =
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
extern "js" fn ffi_duplicate(tab_id : Int) -> @js.Promise[@js.Any] =
  #|async (tabId) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  return b.tabs.duplicate(tabId);
  #|}

///|
/// Send message to content script in tab
pub async fn send_message(tab_id : Int, message : @js.Any) -> @js.Any {
  ffi_send_message(tab_id, message).wait()
}

///|
extern "js" fn ffi_send_message(
  tab_id : Int,
  message : @js.Any,
) -> @js.Promise[@js.Any] =
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
extern "js" fn ffi_on_created(callback : (@js.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onCreated.addListener(callback);
  #|}

///|
/// Listen for tab removal
pub fn on_removed(callback : (Int, @js.Any) -> Unit) -> Unit {
  ffi_on_removed(callback)
}

///|
extern "js" fn ffi_on_removed(callback : (Int, @js.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onRemoved.addListener(callback);
  #|}

///|
/// Listen for tab updates
pub fn on_updated(callback : (Int, @js.Any, Tab) -> Unit) -> Unit {
  ffi_on_updated(fn(tab_id, change_info, tab) {
    callback(tab_id, change_info, Tab::from_any(tab))
  })
}

///|
extern "js" fn ffi_on_updated(
  callback : (Int, @js.Any, @js.Any) -> Unit,
) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onUpdated.addListener(callback);
  #|}

///|
/// Listen for tab activation
pub fn on_activated(callback : (@js.Any) -> Unit) -> Unit {
  ffi_on_activated(callback)
}

///|
extern "js" fn ffi_on_activated(callback : (@js.Any) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.tabs.onActivated.addListener(callback);
  #|}
