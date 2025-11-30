// Cloudflare Durable Objects bindings

///|
#external
pub type DurableObjectNamespace

///|
pub fn DurableObjectNamespace::as_any(
  self : DurableObjectNamespace,
) -> @nostd.Any = "%identity"

///|
/// Get a Durable Object stub by ID
pub fn DurableObjectNamespace::get(
  self : DurableObjectNamespace,
  id : DurableObjectId,
) -> DurableObjectStub {
  @nostd.any(self)._call("get", [@nostd.any(id)]).cast()
}

///|
/// Get a Durable Object stub by ID string
pub fn DurableObjectNamespace::get_by_id_string(
  self : DurableObjectNamespace,
  id : String,
) -> DurableObjectStub {
  @nostd.any(self)._call("get", [@nostd.any(id)]).cast()
}

///|
/// Get a Durable Object stub by name
pub fn DurableObjectNamespace::get_by_name(
  self : DurableObjectNamespace,
  name : String,
) -> DurableObjectStub {
  @nostd.any(self)._call("get", [@nostd.any(self.id_from_name(name))]).cast()
}

///|
/// Create a new unique ID
pub fn DurableObjectNamespace::new_unique_id(
  self : DurableObjectNamespace,
) -> DurableObjectId {
  @nostd.any(self)._call("newUniqueId", []).cast()
}

///|
/// Create a new unique ID with options
pub fn DurableObjectNamespace::new_unique_id_with_options(
  self : DurableObjectNamespace,
  options : DurableObjectIdOptions,
) -> DurableObjectId {
  @nostd.any(self)._call("newUniqueId", [options.to_js()]).cast()
}

///|
/// Create an ID from a name (deterministic)
pub fn DurableObjectNamespace::id_from_name(
  self : DurableObjectNamespace,
  name : String,
) -> DurableObjectId {
  @nostd.any(self)._call("idFromName", [@nostd.any(name)]).cast()
}

///|
/// Create an ID from a string
pub fn DurableObjectNamespace::id_from_string(
  self : DurableObjectNamespace,
  id : String,
) -> DurableObjectId {
  @nostd.any(self)._call("idFromString", [@nostd.any(id)]).cast()
}

///|
/// Options for creating Durable Object IDs
pub(all) struct DurableObjectIdOptions {
  jurisdiction : String? // "eu" | "fedramp"
}

///|
pub fn DurableObjectIdOptions::to_js(self : DurableObjectIdOptions) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if self.jurisdiction is Some(v) {
    obj["jurisdiction"] = @nostd.any(v)
  }
  obj
}

///|
/// Durable Object ID
pub(all) struct DurableObjectId {
  name : String?
}

///|
pub fn DurableObjectId::as_any(self : DurableObjectId) -> @nostd.Any = "%identity"

///|
/// Convert ID to string
pub fn DurableObjectId::to_string(self : DurableObjectId) -> String {
  @nostd.any(self)._call("toString", []).cast()
}

///|
/// Check if two IDs are equal
pub fn DurableObjectId::equals(
  self : DurableObjectId,
  other : DurableObjectId,
) -> Bool {
  @nostd.any(self)._call("equals", [@nostd.any(other)]).cast()
}

///|
/// Durable Object Stub (client interface)
pub(all) struct DurableObjectStub {
  id : DurableObjectId
  name : String?
}

///|
pub fn DurableObjectStub::as_any(self : DurableObjectStub) -> @nostd.Any = "%identity"

///|
/// Send a fetch request to the Durable Object
pub async fn DurableObjectStub::fetch(
  self : DurableObjectStub,
  request : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("fetch", [request])
    .cast()
  promise.wait()
}

///|
/// Send a fetch request with init options
pub async fn DurableObjectStub::fetch_with_init(
  self : DurableObjectStub,
  request : @nostd.Any,
  init : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("fetch", [request, init])
    .cast()
  promise.wait()
}

///|
/// Send a fetch request by URL
pub async fn DurableObjectStub::fetch_url(
  self : DurableObjectStub,
  url : String,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("fetch", [@nostd.any(url)])
    .cast()
  promise.wait()
}

///|
/// Send a fetch request by URL with init options
pub async fn DurableObjectStub::fetch_url_with_init(
  self : DurableObjectStub,
  url : String,
  init : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("fetch", [@nostd.any(url), init])
    .cast()
  promise.wait()
}

///|
/// Durable Object State (available inside DO class)
pub(all) struct DurableObjectState {
  id : DurableObjectId
  storage : DurableObjectStorage
}

///|
pub fn DurableObjectState::as_any(self : DurableObjectState) -> @nostd.Any = "%identity"

///|
/// Wait until a promise completes before confirming writes
pub fn DurableObjectState::wait_until(
  self : DurableObjectState,
  promise : @nostd.Any,
) -> Unit {
  @nostd.any(self)._call("waitUntil", [promise]).cast()
}

///|
/// Block concurrent requests until callback completes
pub async fn DurableObjectState::block_concurrency_while(
  self : DurableObjectState,
  callback : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("blockConcurrencyWhile", [callback])
    .cast()
  promise.wait()
}

///|
/// Durable Object Storage
#external
pub type DurableObjectStorage

///|
pub fn DurableObjectStorage::as_any(self : DurableObjectStorage) -> @nostd.Any = "%identity"

///|
/// Get a value from storage
pub async fn DurableObjectStorage::get(
  self : DurableObjectStorage,
  key : String,
) -> @nostd.Any? {
  let promise : @js.Promise[@nostd.Any?] = @nostd
    .any(self)
    ._call("get", [@nostd.any(key)])
    .cast()
  promise.wait()
}

///|
/// Get a value with options
pub async fn DurableObjectStorage::get_with_options(
  self : DurableObjectStorage,
  key : String,
  options : DurableObjectGetOptions,
) -> @nostd.Any? {
  let promise : @js.Promise[@nostd.Any?] = @nostd
    .any(self)
    ._call("get", [@nostd.any(key), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Get multiple values from storage
pub async fn DurableObjectStorage::get_multiple(
  self : DurableObjectStorage,
  keys : Array[String],
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("get", [@nostd.any(keys)])
    .cast()
  promise.wait()
}

///|
/// Get multiple values with options
pub async fn DurableObjectStorage::get_multiple_with_options(
  self : DurableObjectStorage,
  keys : Array[String],
  options : DurableObjectGetOptions,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("get", [@nostd.any(keys), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Put a value into storage
pub async fn DurableObjectStorage::put(
  self : DurableObjectStorage,
  key : String,
  value : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("put", [@nostd.any(key), value])
    .cast()
  promise.wait()
}

///|
/// Put a value with options
pub async fn DurableObjectStorage::put_with_options(
  self : DurableObjectStorage,
  key : String,
  value : @nostd.Any,
  options : DurableObjectPutOptions,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("put", [@nostd.any(key), value, options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Put multiple values into storage
pub async fn DurableObjectStorage::put_multiple(
  self : DurableObjectStorage,
  entries : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("put", [entries])
    .cast()
  promise.wait()
}

///|
/// Put multiple values with options
pub async fn DurableObjectStorage::put_multiple_with_options(
  self : DurableObjectStorage,
  entries : @nostd.Any,
  options : DurableObjectPutOptions,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("put", [entries, options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Delete a key from storage
pub async fn DurableObjectStorage::delete(
  self : DurableObjectStorage,
  key : String,
) -> Bool {
  let promise : @js.Promise[Bool] = @nostd
    .any(self)
    ._call("delete", [@nostd.any(key)])
    .cast()
  promise.wait()
}

///|
/// Delete a key with options
pub async fn DurableObjectStorage::delete_with_options(
  self : DurableObjectStorage,
  key : String,
  options : DurableObjectPutOptions,
) -> Bool {
  let promise : @js.Promise[Bool] = @nostd
    .any(self)
    ._call("delete", [@nostd.any(key), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Delete multiple keys from storage
pub async fn DurableObjectStorage::delete_multiple(
  self : DurableObjectStorage,
  keys : Array[String],
) -> Int {
  let promise : @js.Promise[Int] = @nostd
    .any(self)
    ._call("delete", [@nostd.any(keys)])
    .cast()
  promise.wait()
}

///|
/// Delete multiple keys with options
pub async fn DurableObjectStorage::delete_multiple_with_options(
  self : DurableObjectStorage,
  keys : Array[String],
  options : DurableObjectPutOptions,
) -> Int {
  let promise : @js.Promise[Int] = @nostd
    .any(self)
    ._call("delete", [@nostd.any(keys), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Delete all keys in storage
pub async fn DurableObjectStorage::delete_all(
  self : DurableObjectStorage,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("deleteAll", [])
    .cast()
  promise.wait()
}

///|
/// Delete all keys with options
pub async fn DurableObjectStorage::delete_all_with_options(
  self : DurableObjectStorage,
  options : DurableObjectPutOptions,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("deleteAll", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// List keys in storage
pub async fn DurableObjectStorage::list(
  self : DurableObjectStorage,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("list", [])
    .cast()
  promise.wait()
}

///|
/// List keys with options
pub async fn DurableObjectStorage::list_with_options(
  self : DurableObjectStorage,
  options : DurableObjectListOptions,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("list", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Execute a transaction
pub async fn DurableObjectStorage::transaction(
  self : DurableObjectStorage,
  closure : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("transaction", [closure])
    .cast()
  promise.wait()
}

///|
/// Get current alarm time
pub async fn DurableObjectStorage::get_alarm(
  self : DurableObjectStorage,
) -> Int? {
  let promise : @js.Promise[Int?] = @nostd
    .any(self)
    ._call("getAlarm", [])
    .cast()
  promise.wait()
}

///|
/// Get alarm with options
pub async fn DurableObjectStorage::get_alarm_with_options(
  self : DurableObjectStorage,
  options : DurableObjectGetAlarmOptions,
) -> Int? {
  let promise : @js.Promise[Int?] = @nostd
    .any(self)
    ._call("getAlarm", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Set an alarm
pub async fn DurableObjectStorage::set_alarm(
  self : DurableObjectStorage,
  scheduled_time : Int,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("setAlarm", [@nostd.any(scheduled_time)])
    .cast()
  promise.wait()
}

///|
/// Set alarm with options
pub async fn DurableObjectStorage::set_alarm_with_options(
  self : DurableObjectStorage,
  scheduled_time : Int,
  options : DurableObjectSetAlarmOptions,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("setAlarm", [@nostd.any(scheduled_time), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Delete the alarm
pub async fn DurableObjectStorage::delete_alarm(
  self : DurableObjectStorage,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("deleteAlarm", [])
    .cast()
  promise.wait()
}

///|
/// Delete alarm with options
pub async fn DurableObjectStorage::delete_alarm_with_options(
  self : DurableObjectStorage,
  options : DurableObjectSetAlarmOptions,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("deleteAlarm", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Sync storage to disk
pub async fn DurableObjectStorage::sync(self : DurableObjectStorage) -> Unit {
  let promise : @js.Promise[Unit] = @nostd.any(self)._call("sync", []).cast()
  promise.wait()
}

///|
/// Options for get operations
pub(all) struct DurableObjectGetOptions {
  allowConcurrency : Bool?
  noCache : Bool?
}

///|
pub fn DurableObjectGetOptions::to_js(self : DurableObjectGetOptions) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @nostd.any(v)
  }
  if self.noCache is Some(v) {
    obj["noCache"] = @nostd.any(v)
  }
  obj
}

///|
/// Options for put/delete operations
pub(all) struct DurableObjectPutOptions {
  allowConcurrency : Bool?
  allowUnconfirmed : Bool?
  noCache : Bool?
}

///|
pub fn DurableObjectPutOptions::to_js(self : DurableObjectPutOptions) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @nostd.any(v)
  }
  if self.allowUnconfirmed is Some(v) {
    obj["allowUnconfirmed"] = @nostd.any(v)
  }
  if self.noCache is Some(v) {
    obj["noCache"] = @nostd.any(v)
  }
  obj
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
pub fn DurableObjectListOptions::to_js(self : DurableObjectListOptions) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if self.start is Some(v) {
    obj["start"] = @nostd.any(v)
  }
  if self.startAfter is Some(v) {
    obj["startAfter"] = @nostd.any(v)
  }
  if self.end is Some(v) {
    obj["end"] = @nostd.any(v)
  }
  if self.prefix is Some(v) {
    obj["prefix"] = @nostd.any(v)
  }
  if self.reverse is Some(v) {
    obj["reverse"] = @nostd.any(v)
  }
  if self.limit is Some(v) {
    obj["limit"] = @nostd.any(v)
  }
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @nostd.any(v)
  }
  if self.noCache is Some(v) {
    obj["noCache"] = @nostd.any(v)
  }
  obj
}

///|
/// Options for getAlarm
pub(all) struct DurableObjectGetAlarmOptions {
  allowConcurrency : Bool?
}

///|
pub fn DurableObjectGetAlarmOptions::to_js(
  self : DurableObjectGetAlarmOptions,
) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @nostd.any(v)
  }
  obj
}

///|
/// Options for setAlarm/deleteAlarm
pub(all) struct DurableObjectSetAlarmOptions {
  allowConcurrency : Bool?
  allowUnconfirmed : Bool?
}

///|
pub fn DurableObjectSetAlarmOptions::to_js(
  self : DurableObjectSetAlarmOptions,
) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @nostd.any(v)
  }
  if self.allowUnconfirmed is Some(v) {
    obj["allowUnconfirmed"] = @nostd.any(v)
  }
  obj
}

///|
/// Transaction context
#external
pub type DurableObjectTransaction

///|
pub fn DurableObjectTransaction::as_any(
  self : DurableObjectTransaction,
) -> @nostd.Any = "%identity"

///|
/// Get a value in transaction
pub async fn DurableObjectTransaction::get(
  self : DurableObjectTransaction,
  key : String,
) -> @nostd.Any? {
  let promise : @js.Promise[@nostd.Any?] = @nostd
    .any(self)
    ._call("get", [@nostd.any(key)])
    .cast()
  promise.wait()
}

///|
/// Get multiple values in transaction
pub async fn DurableObjectTransaction::get_multiple(
  self : DurableObjectTransaction,
  keys : Array[String],
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("get", [@nostd.any(keys)])
    .cast()
  promise.wait()
}

///|
/// Put a value in transaction
pub async fn DurableObjectTransaction::put(
  self : DurableObjectTransaction,
  key : String,
  value : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("put", [@nostd.any(key), value])
    .cast()
  promise.wait()
}

///|
/// Put multiple values in transaction
pub async fn DurableObjectTransaction::put_multiple(
  self : DurableObjectTransaction,
  entries : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("put", [entries])
    .cast()
  promise.wait()
}

///|
/// Delete a key in transaction
pub async fn DurableObjectTransaction::delete(
  self : DurableObjectTransaction,
  key : String,
) -> Bool {
  let promise : @js.Promise[Bool] = @nostd
    .any(self)
    ._call("delete", [@nostd.any(key)])
    .cast()
  promise.wait()
}

///|
/// Delete multiple keys in transaction
pub async fn DurableObjectTransaction::delete_multiple(
  self : DurableObjectTransaction,
  keys : Array[String],
) -> Int {
  let promise : @js.Promise[Int] = @nostd
    .any(self)
    ._call("delete", [@nostd.any(keys)])
    .cast()
  promise.wait()
}

///|
/// Delete all keys in transaction
pub async fn DurableObjectTransaction::delete_all(
  self : DurableObjectTransaction,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("deleteAll", [])
    .cast()
  promise.wait()
}

///|
/// List keys in transaction
pub async fn DurableObjectTransaction::list(
  self : DurableObjectTransaction,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("list", [])
    .cast()
  promise.wait()
}

///|
/// List keys with options in transaction
pub async fn DurableObjectTransaction::list_with_options(
  self : DurableObjectTransaction,
  options : DurableObjectListOptions,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = @nostd
    .any(self)
    ._call("list", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Rollback the transaction
pub fn DurableObjectTransaction::rollback(
  self : DurableObjectTransaction,
) -> Unit {
  @nostd.any(self)._call("rollback", []).cast()
}

///|
/// Get alarm in transaction
pub async fn DurableObjectTransaction::get_alarm(
  self : DurableObjectTransaction,
) -> Int? {
  let promise : @js.Promise[Int?] = @nostd
    .any(self)
    ._call("getAlarm", [])
    .cast()
  promise.wait()
}

///|
/// Set alarm in transaction
pub async fn DurableObjectTransaction::set_alarm(
  self : DurableObjectTransaction,
  scheduled_time : Int,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("setAlarm", [@nostd.any(scheduled_time)])
    .cast()
  promise.wait()
}

///|
/// Delete alarm in transaction
pub async fn DurableObjectTransaction::delete_alarm(
  self : DurableObjectTransaction,
) -> Unit {
  let promise : @js.Promise[Unit] = @nostd
    .any(self)
    ._call("deleteAlarm", [])
    .cast()
  promise.wait()
}
