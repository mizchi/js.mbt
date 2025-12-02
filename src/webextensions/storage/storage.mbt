///|
/// WebExtensions Storage API
/// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/storage

///|
/// StorageArea - base type for storage areas
#external
pub type StorageArea

///|
pub fn StorageArea::as_any(self : StorageArea) -> @nostd.Any = "%identity"

///|
/// Get items from storage
/// keys: string | string[] | object with defaults | null (get all)
pub async fn StorageArea::get(
  self : StorageArea,
  keys : @nostd.Any,
) -> @nostd.Any {
  ffi_storage_get(self |> @nostd.identity, keys).wait()
}

///|
extern "js" fn ffi_storage_get(
  storage : @nostd.Any,
  keys : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #|async (storage, keys) => storage._get(keys)

///|
/// Get single item by key
pub async fn StorageArea::get_item(
  self : StorageArea,
  key : String,
) -> @nostd.Any {
  let result : @nostd.Any = self.as_any()._get(key) |> @nostd.any
  result[key] |> @nostd.identity
}

///|
/// Get all items from storage
pub async fn StorageArea::get_all(self : StorageArea) -> @nostd.Any {
  ffi_storage_get_all(self |> @nostd.identity).wait()
}

///|
extern "js" fn ffi_storage_get_all(
  storage : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #|async (storage) => storage._get(null)

///|
/// Set items in storage
pub async fn StorageArea::set(self : StorageArea, items : @nostd.Any) -> Unit {
  ffi_storage_set(self |> @nostd.identity, items).wait()
}

///|
extern "js" fn ffi_storage_set(
  storage : @nostd.Any,
  items : @nostd.Any,
) -> @js.Promise[Unit] =
  #|async (storage, items) => storage.set(items)

///|
/// Set single item
pub async fn StorageArea::set_item(
  self : StorageArea,
  key : String,
  value : @nostd.Any,
) -> Unit {
  let items = @nostd.Object::new()
  items[key] = @nostd.any(value)
  self.set(items |> @nostd.identity)
}

///|
/// Remove items from storage
pub async fn StorageArea::remove(self : StorageArea, keys : @nostd.Any) -> Unit {
  ffi_storage_remove(self |> @nostd.identity, keys).wait()
}

///|
extern "js" fn ffi_storage_remove(
  storage : @nostd.Any,
  keys : @nostd.Any,
) -> @js.Promise[Unit] =
  #|async (storage, keys) => storage.remove(keys)

///|
/// Remove single item
pub async fn StorageArea::remove_item(self : StorageArea, key : String) -> Unit {
  self.remove(key |> @nostd.any)
}

///|
/// Clear all items from storage
pub async fn StorageArea::clear(self : StorageArea) -> Unit {
  ffi_storage_clear(self |> @nostd.identity).wait()
}

///|
extern "js" fn ffi_storage_clear(storage : @nostd.Any) -> @js.Promise[Unit] =
  #|async (storage) => storage.clear()

///|
/// Get storage.local area
pub fn local_storage() -> StorageArea {
  let b : @nostd.Any = @webextensions.browser() |> @nostd.any
  b["storage"]["local"] |> @nostd.identity
}

///|
/// Get storage.sync area
pub fn sync_storage() -> StorageArea {
  let b : @nostd.Any = @webextensions.browser() |> @nostd.any
  b["storage"]["sync"] |> @nostd.identity
}

///|
/// Get storage.session area (Manifest V3)
pub fn session_storage() -> StorageArea {
  let b : @nostd.Any = @webextensions.browser() |> @nostd.any
  b["storage"]["session"] |> @nostd.identity
}

///|
/// Storage change info
pub struct StorageChange {
  old_value : @nostd.Any
  new_value : @nostd.Any
}

///|
/// Parse storage change from JS object
pub fn StorageChange::from_any(obj : @nostd.Any) -> StorageChange {
  let o : @nostd.Any = obj |> @nostd.any
  {
    old_value: o["oldValue"] |> @nostd.identity,
    new_value: o["newValue"] |> @nostd.identity,
  }
}

///|
/// Add listener for storage changes
pub fn on_changed(callback : (@nostd.Any, String) -> Unit) -> Unit {
  ffi_on_changed(callback)
}

///|
extern "js" fn ffi_on_changed(callback : (@nostd.Any, String) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.storage.onChanged.addListener((changes, areaName) => {
  #|    callback(changes, areaName);
  #|  });
  #|}
