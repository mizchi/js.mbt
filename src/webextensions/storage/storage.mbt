///|
/// WebExtensions Storage API
/// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/storage

///|
/// StorageArea - base type for storage areas
#external
pub type StorageArea

///|
pub impl @js.JsImpl for StorageArea

///|
/// Get items from storage
/// keys: string | string[] | object with defaults | null (get all)
pub async fn StorageArea::get(self : StorageArea, keys : @js.Any) -> @js.Any {
  ffi_storage_get(self |> @js.identity, keys).wait()
}

///|
extern "js" fn ffi_storage_get(
  storage : @js.Any,
  keys : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (storage, keys) => storage.get(keys)

///|
/// Get single item by key
pub async fn StorageArea::get_item(self : StorageArea, key : String) -> @js.Any {
  let result = self.get(key |> @js.any)
  result.get(key)
}

///|
/// Get all items from storage
pub async fn StorageArea::get_all(self : StorageArea) -> @js.Any {
  ffi_storage_get_all(self |> @js.identity).wait()
}

///|
extern "js" fn ffi_storage_get_all(storage : @js.Any) -> @js.Promise[@js.Any] =
  #|async (storage) => storage.get(null)

///|
/// Set items in storage
pub async fn StorageArea::set(self : StorageArea, items : @js.Any) -> Unit {
  ffi_storage_set(self |> @js.identity, items).wait()
}

///|
extern "js" fn ffi_storage_set(
  storage : @js.Any,
  items : @js.Any,
) -> @js.Promise[Unit] =
  #|async (storage, items) => storage.set(items)

///|
/// Set single item
pub async fn StorageArea::set_item(
  self : StorageArea,
  key : String,
  value : @js.Any,
) -> Unit {
  let items = @js.Object::new()
  items.set(key, value)
  self.set(items.to_any())
}

///|
/// Remove items from storage
pub async fn StorageArea::remove(self : StorageArea, keys : @js.Any) -> Unit {
  ffi_storage_remove(self |> @js.identity, keys).wait()
}

///|
extern "js" fn ffi_storage_remove(
  storage : @js.Any,
  keys : @js.Any,
) -> @js.Promise[Unit] =
  #|async (storage, keys) => storage.remove(keys)

///|
/// Remove single item
pub async fn StorageArea::remove_item(self : StorageArea, key : String) -> Unit {
  self.remove(key |> @js.any)
}

///|
/// Clear all items from storage
pub async fn StorageArea::clear(self : StorageArea) -> Unit {
  ffi_storage_clear(self |> @js.identity).wait()
}

///|
extern "js" fn ffi_storage_clear(storage : @js.Any) -> @js.Promise[Unit] =
  #|async (storage) => storage.clear()

///|
/// Get storage.local area
pub fn local_storage() -> StorageArea {
  @webextensions.browser().get("storage").get("local") |> @js.identity
}

///|
/// Get storage.sync area
pub fn sync_storage() -> StorageArea {
  @webextensions.browser().get("storage").get("sync") |> @js.identity
}

///|
/// Get storage.session area (Manifest V3)
pub fn session_storage() -> StorageArea {
  @webextensions.browser().get("storage").get("session") |> @js.identity
}

///|
/// Storage change info
pub struct StorageChange {
  old_value : @js.Any
  new_value : @js.Any
}

///|
/// Parse storage change from JS object
pub fn StorageChange::from_any(obj : @js.Any) -> StorageChange {
  { old_value: obj.get("oldValue"), new_value: obj.get("newValue") }
}

///|
/// Add listener for storage changes
pub fn on_changed(callback : (@js.Any, String) -> Unit) -> Unit {
  ffi_on_changed(callback)
}

///|
extern "js" fn ffi_on_changed(callback : (@js.Any, String) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.storage.onChanged.addListener((changes, areaName) => {
  #|    callback(changes, areaName);
  #|  });
  #|}
