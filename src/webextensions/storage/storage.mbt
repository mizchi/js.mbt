///|
/// WebExtensions Storage API
/// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/storage

///|
/// StorageArea - base type for storage areas
#external
pub type StorageArea

///|
pub fn StorageArea::as_any(self : StorageArea) -> @core.Any = "%identity"

///|
/// Get items from storage
/// keys: string | string[] | object with defaults | null (get all)
pub async fn StorageArea::get(
  self : StorageArea,
  keys : @core.Any,
) -> @core.Any {
  ffi_storage_get(self |> @core.identity, keys).wait()
}

///|
extern "js" fn ffi_storage_get(
  storage : @core.Any,
  keys : @core.Any,
) -> @js.Promise[@core.Any] =
  #|async (storage, keys) => storage._get(keys)

///|
/// Get single item by key
pub async fn StorageArea::get_item(
  self : StorageArea,
  key : String,
) -> @core.Any {
  let result : @core.Any = self.as_any()._get(key) |> @core.any
  result[key] |> @core.identity
}

///|
/// Get all items from storage
pub async fn StorageArea::get_all(self : StorageArea) -> @core.Any {
  ffi_storage_get_all(self |> @core.identity).wait()
}

///|
extern "js" fn ffi_storage_get_all(
  storage : @core.Any,
) -> @js.Promise[@core.Any] =
  #|async (storage) => storage._get(null)

///|
/// Set items in storage
pub async fn StorageArea::set(self : StorageArea, items : @core.Any) -> Unit {
  ffi_storage_set(self |> @core.identity, items).wait()
}

///|
extern "js" fn ffi_storage_set(
  storage : @core.Any,
  items : @core.Any,
) -> @js.Promise[Unit] =
  #|async (storage, items) => storage.set(items)

///|
/// Set single item
pub async fn StorageArea::set_item(
  self : StorageArea,
  key : String,
  value : @core.Any,
) -> Unit {
  let items = @core.Object::new()
  items[key] = @core.any(value)
  self.set(items |> @core.identity)
}

///|
/// Remove items from storage
pub async fn StorageArea::remove(self : StorageArea, keys : @core.Any) -> Unit {
  ffi_storage_remove(self |> @core.identity, keys).wait()
}

///|
extern "js" fn ffi_storage_remove(
  storage : @core.Any,
  keys : @core.Any,
) -> @js.Promise[Unit] =
  #|async (storage, keys) => storage.remove(keys)

///|
/// Remove single item
pub async fn StorageArea::remove_item(self : StorageArea, key : String) -> Unit {
  self.remove(key |> @core.any)
}

///|
/// Clear all items from storage
pub async fn StorageArea::clear(self : StorageArea) -> Unit {
  ffi_storage_clear(self |> @core.identity).wait()
}

///|
extern "js" fn ffi_storage_clear(storage : @core.Any) -> @js.Promise[Unit] =
  #|async (storage) => storage.clear()

///|
/// Get storage.local area
pub fn local_storage() -> StorageArea {
  let b : @core.Any = @webextensions.browser() |> @core.any
  b["storage"]["local"] |> @core.identity
}

///|
/// Get storage.sync area
pub fn sync_storage() -> StorageArea {
  let b : @core.Any = @webextensions.browser() |> @core.any
  b["storage"]["sync"] |> @core.identity
}

///|
/// Get storage.session area (Manifest V3)
pub fn session_storage() -> StorageArea {
  let b : @core.Any = @webextensions.browser() |> @core.any
  b["storage"]["session"] |> @core.identity
}

///|
/// Storage change info
pub struct StorageChange {
  old_value : @core.Any
  new_value : @core.Any
}

///|
/// Parse storage change from JS object
pub fn StorageChange::from_any(obj : @core.Any) -> StorageChange {
  let o : @core.Any = obj |> @core.any
  {
    old_value: o["oldValue"] |> @core.identity,
    new_value: o["newValue"] |> @core.identity,
  }
}

///|
/// Add listener for storage changes
pub fn on_changed(callback : (@core.Any, String) -> Unit) -> Unit {
  ffi_on_changed(callback)
}

///|
extern "js" fn ffi_on_changed(callback : (@core.Any, String) -> Unit) -> Unit =
  #|(callback) => {
  #|  const b = typeof browser !== 'undefined' ? browser : chrome;
  #|  b.storage.onChanged.addListener((changes, areaName) => {
  #|    callback(changes, areaName);
  #|  });
  #|}
