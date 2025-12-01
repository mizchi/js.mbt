///|
/// Chrome - unified wrapper for WebExtensions APIs
/// Provides access to storage, runtime, and tabs APIs through a single object

///|
/// Chrome wrapper providing access to all WebExtensions APIs
pub(all) struct Chrome {
  /// Storage APIs (local, sync, session)
  storage : Storage
  /// Runtime API
  runtime : Runtime
  /// Tabs API
  tabs : Tabs
}

///|
/// Initialize Chrome wrapper
pub fn chrome() -> Chrome {
  { storage: Storage::new(), runtime: Runtime::new(), tabs: Tabs::new() }
}

///|
/// Storage wrapper
pub(all) struct Storage {
  /// Local storage area
  local_area : @storage.StorageArea
  /// Sync storage area
  sync_area : @storage.StorageArea
  /// Session storage area (Manifest V3)
  session_area : @storage.StorageArea
}

///|
fn Storage::new() -> Storage {
  {
    local_area: @storage.local_storage(),
    sync_area: @storage.sync_storage(),
    session_area: @storage.session_storage(),
  }
}

///|
/// Add listener for storage changes
pub fn Storage::on_changed(
  self : Storage,
  callback : (@nostd.Any, String) -> Unit,
) -> Unit {
  ignore(self)
  @storage.on_changed(callback)
}

///|
/// Runtime wrapper
pub(all) struct Runtime {
  /// Extension ID
  id : String
}

///|
fn Runtime::new() -> Runtime {
  { id: @runtime.id() }
}

///|
/// Get the extension's manifest
pub fn Runtime::get_manifest(self : Runtime) -> @nostd.Any {
  ignore(self)
  @runtime.get_manifest()
}

///|
/// Get URL of a resource within the extension
pub fn Runtime::get_url(self : Runtime, path : String) -> String {
  ignore(self)
  @runtime.get_url(path)
}

///|
/// Send a message to other parts of the extension
pub async fn Runtime::send_message(
  self : Runtime,
  message : @nostd.Any,
) -> @nostd.Any {
  ignore(self)
  @runtime.send_message(message)
}

///|
/// Listen for messages
pub fn Runtime::on_message(
  self : Runtime,
  callback : (@nostd.Any, @nostd.Any, (@nostd.Any) -> Unit) -> Bool,
) -> Unit {
  ignore(self)
  @runtime.on_message(callback)
}

///|
/// Connect to background script
pub fn Runtime::connect(self : Runtime, name? : String) -> @runtime.Port {
  ignore(self)
  @runtime.connect(name?)
}

///|
/// Listen for incoming connections
pub fn Runtime::on_connect(
  self : Runtime,
  callback : (@runtime.Port) -> Unit,
) -> Unit {
  ignore(self)
  @runtime.on_connect(callback)
}

///|
/// Listen for extension install/update
pub fn Runtime::on_installed(
  self : Runtime,
  callback : (@nostd.Any) -> Unit,
) -> Unit {
  ignore(self)
  @runtime.on_installed(callback)
}

///|
/// Listen for browser startup
pub fn Runtime::on_startup(self : Runtime, callback : () -> Unit) -> Unit {
  ignore(self)
  @runtime.on_startup(callback)
}

///|
/// Get platform info
pub async fn Runtime::get_platform_info(
  self : Runtime,
) -> @runtime.PlatformInfo {
  ignore(self)
  @runtime.get_platform_info()
}

///|
/// Open options page
pub async fn Runtime::open_options_page(self : Runtime) -> Unit {
  ignore(self)
  @runtime.open_options_page()
}

///|
/// Reload the extension
pub fn Runtime::reload(self : Runtime) -> Unit {
  ignore(self)
  @runtime.reload()
}

///|
/// Tabs wrapper
pub(all) struct Tabs {
  // Placeholder field to avoid empty struct issues
  priv _placeholder : Unit
}

///|
fn Tabs::new() -> Tabs {
  { _placeholder: () }
}

///|
/// Query tabs
pub async fn Tabs::query(
  self : Tabs,
  options? : @tabs.QueryOptions = @tabs.QueryOptions::default(),
) -> Array[@tabs.Tab] {
  ignore(self)
  @tabs.query(options~)
}

///|
/// Get current active tab
pub async fn Tabs::get_current(self : Tabs) -> @tabs.Tab? {
  ignore(self)
  @tabs.get_current()
}

///|
/// TODO: Support latter
/// Get tab by ID
// pub async fn Tabs::get(self : Tabs, tab_id : Int) -> @tabs.Tab {
//   // ignore(self)
//   (self |> @nostd.any)._get(tab_id)
// }

///|
/// Create a new tab
pub async fn Tabs::create(
  self : Tabs,
  options? : @tabs.CreateOptions = @tabs.CreateOptions::default(),
) -> @tabs.Tab {
  ignore(self)
  @tabs.create(options~)
}

///|
/// Update a tab
pub async fn Tabs::update(
  self : Tabs,
  tab_id : Int,
  options : @tabs.UpdateOptions,
) -> @tabs.Tab {
  ignore(self)
  @tabs.update(tab_id, options)
}

///|
/// Remove tabs
pub async fn Tabs::remove(self : Tabs, tab_ids : Array[Int]) -> Unit {
  ignore(self)
  @tabs.remove(tab_ids)
}

///|
/// Remove a single tab
pub async fn Tabs::remove_tab(self : Tabs, tab_id : Int) -> Unit {
  ignore(self)
  @tabs.remove_tab(tab_id)
}

///|
/// Reload a tab
pub async fn Tabs::reload(
  self : Tabs,
  tab_id : Int,
  bypass_cache? : Bool = false,
) -> Unit {
  ignore(self)
  @tabs.reload(tab_id, bypass_cache~)
}

///|
/// Duplicate a tab
pub async fn Tabs::duplicate(self : Tabs, tab_id : Int) -> @tabs.Tab {
  ignore(self)
  @tabs.duplicate(tab_id)
}

///|
/// Send message to content script in tab
pub async fn Tabs::send_message(
  self : Tabs,
  tab_id : Int,
  message : @nostd.Any,
) -> @nostd.Any {
  ignore(self)
  @tabs.send_message(tab_id, message)
}

///|
/// Listen for tab creation
pub fn Tabs::on_created(self : Tabs, callback : (@tabs.Tab) -> Unit) -> Unit {
  ignore(self)
  @tabs.on_created(callback)
}

///|
/// Listen for tab removal
pub fn Tabs::on_removed(
  self : Tabs,
  callback : (Int, @nostd.Any) -> Unit,
) -> Unit {
  ignore(self)
  @tabs.on_removed(callback)
}

///|
/// Listen for tab updates
pub fn Tabs::on_updated(
  self : Tabs,
  callback : (Int, @nostd.Any, @tabs.Tab) -> Unit,
) -> Unit {
  ignore(self)
  @tabs.on_updated(callback)
}

///|
/// Listen for tab activation
pub fn Tabs::on_activated(self : Tabs, callback : (@nostd.Any) -> Unit) -> Unit {
  ignore(self)
  @tabs.on_activated(callback)
}
