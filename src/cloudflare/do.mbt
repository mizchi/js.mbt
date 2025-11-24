// Cloudflare Durable Objects bindings

///|
#external
pub type DurableObjectNamespace

///|
pub impl @js.JsImpl for DurableObjectNamespace

///|
/// Get a Durable Object stub by ID
pub fn DurableObjectNamespace::get(
  self : Self,
  id : DurableObjectId,
) -> DurableObjectStub {
  self.call1("get", id) |> @js.identity
}

///|
/// Get a Durable Object stub by ID string
pub fn DurableObjectNamespace::get_by_id_string(
  self : Self,
  id : String,
) -> DurableObjectStub {
  self.call1("get", id) |> @js.identity
}

///|
/// Get a Durable Object stub by name
pub fn DurableObjectNamespace::get_by_name(
  self : Self,
  name : String,
) -> DurableObjectStub {
  self.call("get", [self.id_from_name(name).to_js()]) |> @js.identity
}

///|
/// Create a new unique ID
pub fn DurableObjectNamespace::new_unique_id(self : Self) -> DurableObjectId {
  self.call0("newUniqueId") |> @js.identity
}

///|
/// Create a new unique ID with options
pub fn DurableObjectNamespace::new_unique_id_with_options(
  self : Self,
  options : DurableObjectIdOptions,
) -> DurableObjectId {
  self.call("newUniqueId", [options.to_js()]) |> @js.identity
}

///|
/// Create an ID from a name (deterministic)
pub fn DurableObjectNamespace::id_from_name(
  self : Self,
  name : String,
) -> DurableObjectId {
  self.call("idFromName", [name]) |> @js.identity
}

///|
/// Create an ID from a string
pub fn DurableObjectNamespace::id_from_string(
  self : Self,
  id : String,
) -> DurableObjectId {
  self.call("idFromString", [id]) |> @js.identity
}

///|
/// Options for creating Durable Object IDs
pub(all) struct DurableObjectIdOptions {
  jurisdiction : String? // "eu" | "fedramp"
}

///|
pub impl @js.JsImpl for DurableObjectIdOptions with to_js(self) {
  @js.from_entries_option_cast([("jurisdiction", self.jurisdiction)])
}

///|
/// Durable Object ID
#external
pub type DurableObjectId

///|
pub impl @js.JsImpl for DurableObjectId

///|
/// Convert ID to string
pub fn DurableObjectId::to_string(self : Self) -> String {
  self.call0("toString") |> @js.identity
}

///|
/// Check if two IDs are equal
pub fn DurableObjectId::equals(self : Self, other : DurableObjectId) -> Bool {
  self.call("equals", [other.to_js()]) |> @js.identity
}

///|
/// Get ID name (if created from name)
pub fn DurableObjectId::name(self : Self) -> String? {
  self.get("name") |> @js.identity
}

///|
/// Durable Object Stub (client interface)
#external
pub type DurableObjectStub

///|
pub impl @js.JsImpl for DurableObjectStub

///|
/// Get the ID of this stub
pub fn DurableObjectStub::id(self : Self) -> DurableObjectId {
  self.get("id") |> @js.identity
}

///|
/// Get the name of this stub
pub fn DurableObjectStub::name(self : Self) -> String? {
  self.get("name") |> @js.identity
}

///|
/// Send a fetch request to the Durable Object
pub fn DurableObjectStub::fetch(
  self : Self,
  request : @js.Js,
) -> @js.Promise[@js.Js] {
  self.call("fetch", [request]) |> @js.identity
}

///|
/// Send a fetch request with init options
pub fn DurableObjectStub::fetch_with_init(
  self : Self,
  request : @js.Js,
  init : @js.Js,
) -> @js.Promise[@js.Js] {
  self.call2("fetch", request, init) |> @js.identity
}

///|
/// Send a fetch request by URL
pub fn DurableObjectStub::fetch_url(
  self : Self,
  url : String,
) -> @js.Promise[@js.Js] {
  self.call("fetch", [url]) |> @js.identity
}

///|
/// Send a fetch request by URL with init options
pub fn DurableObjectStub::fetch_url_with_init(
  self : Self,
  url : String,
  init : @js.Js,
) -> @js.Promise[@js.Js] {
  self.call2("fetch", url, init) |> @js.identity
}

///|
/// Durable Object State (available inside DO class)
#external
pub type DurableObjectState

///|
pub impl @js.JsImpl for DurableObjectState

///|
/// Get the ID of this Durable Object
pub fn DurableObjectState::id(self : Self) -> DurableObjectId {
  self.get("id") |> @js.identity
}

///|
/// Get the storage interface
pub fn DurableObjectState::storage(self : Self) -> DurableObjectStorage {
  self.get("storage") |> @js.identity
}

///|
/// Wait until a promise completes before confirming writes
pub fn DurableObjectState::wait_until(self : Self, promise : @js.Js) -> Unit {
  self.call("waitUntil", [promise]) |> @js.identity
}

///|
/// Block concurrent requests until callback completes
pub fn DurableObjectState::block_concurrency_while(
  self : Self,
  callback : @js.Js,
) -> @js.Promise[Unit] {
  self.call("blockConcurrencyWhile", [callback]) |> @js.identity
}

///|
/// Durable Object Storage
#external
pub type DurableObjectStorage

///|
pub impl @js.JsImpl for DurableObjectStorage

///|
/// Get a value from storage
pub fn DurableObjectStorage::get(
  self : Self,
  key : String,
) -> @js.Promise[@js.Js?] {
  self.call("get", [key]) |> @js.identity
}

///|
/// Get a value with options
pub fn DurableObjectStorage::get_with_options(
  self : Self,
  key : String,
  options : DurableObjectGetOptions,
) -> @js.Promise[@js.Js?] {
  self.call2("get", key, options) |> @js.identity
}

///|
/// Get multiple values from storage
pub fn DurableObjectStorage::get_multiple(
  self : Self,
  keys : Array[String],
) -> @js.Promise[@js.Js] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call("get", [keys_js]) |> @js.identity
}

///|
/// Get multiple values with options
pub fn DurableObjectStorage::get_multiple_with_options(
  self : Self,
  keys : Array[String],
  options : DurableObjectGetOptions,
) -> @js.Promise[@js.Js] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call2("get", keys_js, options.to_js()) |> @js.identity
}

///|
/// Put a value into storage
pub fn DurableObjectStorage::put(
  self : Self,
  key : String,
  value : @js.Js,
) -> @js.Promise[Unit] {
  self.call2("put", key, value) |> @js.identity
}

///|
/// Put a value with options
pub fn DurableObjectStorage::put_with_options(
  self : Self,
  key : String,
  value : @js.Js,
  options : DurableObjectPutOptions,
) -> @js.Promise[Unit] {
  self.call("put", [key, value, options]) |> @js.identity
}

///|
/// Put multiple values into storage
pub fn DurableObjectStorage::put_multiple(
  self : Self,
  entries : @js.Js,
) -> @js.Promise[Unit] {
  self.call("put", [entries]) |> @js.identity
}

///|
/// Put multiple values with options
pub fn DurableObjectStorage::put_multiple_with_options(
  self : Self,
  entries : @js.Js,
  options : DurableObjectPutOptions,
) -> @js.Promise[Unit] {
  self.call2("put", entries, options.to_js()) |> @js.identity
}

///|
/// Delete a key from storage
pub fn DurableObjectStorage::delete(
  self : Self,
  key : String,
) -> @js.Promise[Bool] {
  self.call("delete", [key]) |> @js.identity
}

///|
/// Delete a key with options
pub fn DurableObjectStorage::delete_with_options(
  self : Self,
  key : String,
  options : DurableObjectPutOptions,
) -> @js.Promise[Bool] {
  self.call2("delete", key, options) |> @js.identity
}

///|
/// Delete multiple keys from storage
pub fn DurableObjectStorage::delete_multiple(
  self : Self,
  keys : Array[String],
) -> @js.Promise[Int] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call("delete", [keys_js]) |> @js.identity
}

///|
/// Delete multiple keys with options
pub fn DurableObjectStorage::delete_multiple_with_options(
  self : Self,
  keys : Array[String],
  options : DurableObjectPutOptions,
) -> @js.Promise[Int] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call2("delete", keys_js, options.to_js()) |> @js.identity
}

///|
/// Delete all keys in storage
pub fn DurableObjectStorage::delete_all(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAll") |> @js.identity
}

///|
/// Delete all keys with options
pub fn DurableObjectStorage::delete_all_with_options(
  self : Self,
  options : DurableObjectPutOptions,
) -> @js.Promise[Unit] {
  self.call("deleteAll", [options.to_js()]) |> @js.identity
}

///|
/// List keys in storage
pub fn DurableObjectStorage::list(self : Self) -> @js.Promise[@js.Js] {
  self.call0("list") |> @js.identity
}

///|
/// List keys with options
pub fn DurableObjectStorage::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> @js.Promise[@js.Js] {
  self.call("list", [options.to_js()]) |> @js.identity
}

///|
/// Execute a transaction
pub fn DurableObjectStorage::transaction(
  self : Self,
  closure : @js.Js,
) -> @js.Promise[@js.Js] {
  self.call("transaction", [closure]) |> @js.identity
}

///|
/// Get current alarm time
pub fn DurableObjectStorage::get_alarm(self : Self) -> @js.Promise[Int?] {
  self.call0("getAlarm") |> @js.identity
}

///|
/// Get alarm with options
pub fn DurableObjectStorage::get_alarm_with_options(
  self : Self,
  options : DurableObjectGetAlarmOptions,
) -> @js.Promise[Int?] {
  self.call("getAlarm", [options.to_js()]) |> @js.identity
}

///|
/// Set an alarm
pub fn DurableObjectStorage::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> @js.Promise[Unit] {
  self.call("setAlarm", [scheduled_time]) |> @js.identity
}

///|
/// Set alarm with options
pub fn DurableObjectStorage::set_alarm_with_options(
  self : Self,
  scheduled_time : Int,
  options : DurableObjectSetAlarmOptions,
) -> @js.Promise[Unit] {
  self.call2("setAlarm", scheduled_time, options) |> @js.identity
}

///|
/// Delete the alarm
pub fn DurableObjectStorage::delete_alarm(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAlarm") |> @js.identity
}

///|
/// Delete alarm with options
pub fn DurableObjectStorage::delete_alarm_with_options(
  self : Self,
  options : DurableObjectSetAlarmOptions,
) -> @js.Promise[Unit] {
  self.call("deleteAlarm", [options.to_js()]) |> @js.identity
}

///|
/// Sync storage to disk
pub fn DurableObjectStorage::sync(self : Self) -> @js.Promise[Unit] {
  self.call0("sync") |> @js.identity
}

///|
/// Options for get operations
pub(all) struct DurableObjectGetOptions {
  allowConcurrency : Bool?
  noCache : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectGetOptions with to_js(self) {
  @js.from_entries_option_cast([
    ("allowConcurrency", self.allowConcurrency),
    ("noCache", self.noCache),
  ])
}

///|
/// Options for put/delete operations
pub(all) struct DurableObjectPutOptions {
  allowConcurrency : Bool?
  allowUnconfirmed : Bool?
  noCache : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectPutOptions with to_js(self) {
  @js.from_entries_option_cast([
    ("allowConcurrency", self.allowConcurrency),
    ("allowUnconfirmed", self.allowUnconfirmed),
    ("noCache", self.noCache),
  ])
}

///|
/// Options for list operations
pub(all) struct DurableObjectListOptions {
  start : String?
  startAfter : String?
  end : String?
  prefix : String?
  reverse : Bool?
  limit : Int?
  allowConcurrency : Bool?
  noCache : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectListOptions with to_js(self) {
  @js.from_entries_option([
    ("start", self.start.map(x => x)),
    ("startAfter", self.startAfter.map(x => x)),
    ("end", self.end.map(x => x)),
    ("prefix", self.prefix.map(x => x)),
    ("reverse", self.reverse.map(x => x)),
    ("limit", self.limit.map(x => x)),
    ("allowConcurrency", self.allowConcurrency.map(x => x)),
    ("noCache", self.noCache.map(x => x)),
  ])
}

///|
/// Options for getAlarm
pub(all) struct DurableObjectGetAlarmOptions {
  allowConcurrency : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectGetAlarmOptions with to_js(self) {
  @js.from_entries_option_cast([("allowConcurrency", self.allowConcurrency)])
}

///|
/// Options for setAlarm/deleteAlarm
pub(all) struct DurableObjectSetAlarmOptions {
  allowConcurrency : Bool?
  allowUnconfirmed : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectSetAlarmOptions with to_js(self) {
  @js.from_entries_option_cast([
    ("allowConcurrency", self.allowConcurrency),
    ("allowUnconfirmed", self.allowUnconfirmed),
  ])
}

///|
/// Transaction context
#external
pub type DurableObjectTransaction

///|
pub impl @js.JsImpl for DurableObjectTransaction

///|
/// Get a value in transaction
pub fn DurableObjectTransaction::get(
  self : Self,
  key : String,
) -> @js.Promise[@js.Js?] {
  self.call("get", [key]) |> @js.identity
}

///|
/// Get multiple values in transaction
pub fn DurableObjectTransaction::get_multiple(
  self : Self,
  keys : Array[String],
) -> @js.Promise[@js.Js] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call("get", [keys_js]) |> @js.identity
}

///|
/// Put a value in transaction
pub fn DurableObjectTransaction::put(
  self : Self,
  key : String,
  value : @js.Js,
) -> @js.Promise[Unit] {
  self.call2("put", key, value) |> @js.identity
}

///|
/// Put multiple values in transaction
pub fn DurableObjectTransaction::put_multiple(
  self : Self,
  entries : @js.Js,
) -> @js.Promise[Unit] {
  self.call("put", [entries]) |> @js.identity
}

///|
/// Delete a key in transaction
pub fn DurableObjectTransaction::delete(
  self : Self,
  key : String,
) -> @js.Promise[Bool] {
  self.call("delete", [key]) |> @js.identity
}

///|
/// Delete multiple keys in transaction
pub fn DurableObjectTransaction::delete_multiple(
  self : Self,
  keys : Array[String],
) -> @js.Promise[Int] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call("delete", [keys_js]) |> @js.identity
}

///|
/// Delete all keys in transaction
pub fn DurableObjectTransaction::delete_all(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAll") |> @js.identity
}

///|
/// List keys in transaction
pub fn DurableObjectTransaction::list(self : Self) -> @js.Promise[@js.Js] {
  self.call0("list") |> @js.identity
}

///|
/// List keys with options in transaction
pub fn DurableObjectTransaction::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> @js.Promise[@js.Js] {
  self.call("list", [options.to_js()]) |> @js.identity
}

///|
/// Rollback the transaction
pub fn DurableObjectTransaction::rollback(self : Self) -> Unit {
  self.call0("rollback") |> @js.identity
}

///|
/// Get alarm in transaction
pub fn DurableObjectTransaction::get_alarm(self : Self) -> @js.Promise[Int?] {
  self.call0("getAlarm") |> @js.identity
}

///|
/// Set alarm in transaction
pub fn DurableObjectTransaction::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> @js.Promise[Unit] {
  self.call("setAlarm", [scheduled_time]) |> @js.identity
}

///|
/// Delete alarm in transaction
pub fn DurableObjectTransaction::delete_alarm(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAlarm") |> @js.identity
}
