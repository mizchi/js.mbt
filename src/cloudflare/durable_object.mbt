// Cloudflare Durable Objects bindings

///|
#external
pub type DurableObjectNamespace

///|
pub fn DurableObjectNamespace::as_any(
  self : DurableObjectNamespace,
) -> @core.Any = "%identity"

///|
/// Get a Durable Object stub by ID
pub fn DurableObjectNamespace::get(
  self : DurableObjectNamespace,
  id : DurableObjectId,
) -> DurableObjectStub {
  @core.any(self)._call("get", [@core.any(id)]).cast()
}

///|
/// Get a Durable Object stub by ID string
pub fn DurableObjectNamespace::get_by_id_string(
  self : DurableObjectNamespace,
  id : String,
) -> DurableObjectStub {
  @core.any(self)._call("get", [@core.any(id)]).cast()
}

///|
/// Get a Durable Object stub by name
pub fn DurableObjectNamespace::get_by_name(
  self : DurableObjectNamespace,
  name : String,
) -> DurableObjectStub {
  @core.any(self)._call("get", [@core.any(self.id_from_name(name))]).cast()
}

///|
/// Create a new unique ID
pub fn DurableObjectNamespace::new_unique_id(
  self : DurableObjectNamespace,
) -> DurableObjectId {
  @core.any(self)._call("newUniqueId", []).cast()
}

///|
/// Create a new unique ID with options
pub fn DurableObjectNamespace::new_unique_id_with_options(
  self : DurableObjectNamespace,
  options : DurableObjectIdOptions,
) -> DurableObjectId {
  @core.any(self)._call("newUniqueId", [options.to_js()]).cast()
}

///|
/// Create an ID from a name (deterministic)
pub fn DurableObjectNamespace::id_from_name(
  self : DurableObjectNamespace,
  name : String,
) -> DurableObjectId {
  @core.any(self)._call("idFromName", [@core.any(name)]).cast()
}

///|
/// Create an ID from a string
pub fn DurableObjectNamespace::id_from_string(
  self : DurableObjectNamespace,
  id : String,
) -> DurableObjectId {
  @core.any(self)._call("idFromString", [@core.any(id)]).cast()
}

///|
/// Options for creating Durable Object IDs
pub(all) struct DurableObjectIdOptions {
  jurisdiction : String? // "eu" | "fedramp"
}

///|
pub fn DurableObjectIdOptions::to_js(
  self : DurableObjectIdOptions,
) -> @core.Any {
  let obj = @core.new_object()
  if self.jurisdiction is Some(v) {
    obj["jurisdiction"] = @core.any(v)
  }
  obj
}

///|
/// Durable Object ID
pub(all) struct DurableObjectId {
  name : String?
}

///|
pub fn DurableObjectId::as_any(self : DurableObjectId) -> @core.Any = "%identity"

///|
/// Convert ID to string
pub fn DurableObjectId::to_string(self : DurableObjectId) -> String {
  @core.any(self)._call("toString", []).cast()
}

///|
/// Check if two IDs are equal
pub fn DurableObjectId::equals(
  self : DurableObjectId,
  other : DurableObjectId,
) -> Bool {
  @core.any(self)._call("equals", [@core.any(other)]).cast()
}

///|
/// Durable Object Stub (client interface)
pub(all) struct DurableObjectStub {
  id : DurableObjectId
  name : String?
}

///|
pub fn DurableObjectStub::as_any(self : DurableObjectStub) -> @core.Any = "%identity"

///|
/// Send a fetch request to the Durable Object
pub async fn DurableObjectStub::fetch(
  self : DurableObjectStub,
  request : @core.Any,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("fetch", [request])
    .cast()
  promise.wait()
}

///|
/// Send a fetch request with init options
pub async fn DurableObjectStub::fetch_with_init(
  self : DurableObjectStub,
  request : @core.Any,
  init : @core.Any,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("fetch", [request, init])
    .cast()
  promise.wait()
}

///|
/// Send a fetch request by URL
pub async fn DurableObjectStub::fetch_url(
  self : DurableObjectStub,
  url : String,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("fetch", [@core.any(url)])
    .cast()
  promise.wait()
}

///|
/// Send a fetch request by URL with init options
pub async fn DurableObjectStub::fetch_url_with_init(
  self : DurableObjectStub,
  url : String,
  init : @core.Any,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("fetch", [@core.any(url), init])
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
pub fn DurableObjectState::as_any(self : DurableObjectState) -> @core.Any = "%identity"

///|
/// Wait until a promise completes before confirming writes
pub fn DurableObjectState::wait_until(
  self : DurableObjectState,
  promise : @core.Any,
) -> Unit {
  @core.any(self)._call("waitUntil", [promise]).cast()
}

///|
/// Block concurrent requests until callback completes
pub async fn DurableObjectState::block_concurrency_while(
  self : DurableObjectState,
  callback : @core.Any,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("blockConcurrencyWhile", [callback])
    .cast()
  promise.wait()
}

///|
/// Durable Object Storage
#external
pub type DurableObjectStorage

///|
pub fn DurableObjectStorage::as_any(self : DurableObjectStorage) -> @core.Any = "%identity"

///|
/// Get a value from storage
pub async fn DurableObjectStorage::get(
  self : DurableObjectStorage,
  key : String,
) -> @core.Any? {
  let promise : @core.Promise[@core.Any?] = @core.any(self)
    ._call("get", [@core.any(key)])
    .cast()
  promise.wait()
}

///|
/// Get a value with options
pub async fn DurableObjectStorage::get_with_options(
  self : DurableObjectStorage,
  key : String,
  options : DurableObjectGetOptions,
) -> @core.Any? {
  let promise : @core.Promise[@core.Any?] = @core.any(self)
    ._call("get", [@core.any(key), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Get multiple values from storage
pub async fn DurableObjectStorage::get_multiple(
  self : DurableObjectStorage,
  keys : Array[String],
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("get", [@core.any(keys)])
    .cast()
  promise.wait()
}

///|
/// Get multiple values with options
pub async fn DurableObjectStorage::get_multiple_with_options(
  self : DurableObjectStorage,
  keys : Array[String],
  options : DurableObjectGetOptions,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("get", [@core.any(keys), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Put a value into storage
pub async fn DurableObjectStorage::put(
  self : DurableObjectStorage,
  key : String,
  value : @core.Any,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("put", [@core.any(key), value])
    .cast()
  promise.wait()
}

///|
/// Put a value with options
pub async fn DurableObjectStorage::put_with_options(
  self : DurableObjectStorage,
  key : String,
  value : @core.Any,
  options : DurableObjectPutOptions,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("put", [@core.any(key), value, options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Put multiple values into storage
pub async fn DurableObjectStorage::put_multiple(
  self : DurableObjectStorage,
  entries : @core.Any,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("put", [entries])
    .cast()
  promise.wait()
}

///|
/// Put multiple values with options
pub async fn DurableObjectStorage::put_multiple_with_options(
  self : DurableObjectStorage,
  entries : @core.Any,
  options : DurableObjectPutOptions,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
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
  let promise : @core.Promise[Bool] = @core.any(self)
    ._call("delete", [@core.any(key)])
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
  let promise : @core.Promise[Bool] = @core.any(self)
    ._call("delete", [@core.any(key), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Delete multiple keys from storage
pub async fn DurableObjectStorage::delete_multiple(
  self : DurableObjectStorage,
  keys : Array[String],
) -> Int {
  let promise : @core.Promise[Int] = @core.any(self)
    ._call("delete", [@core.any(keys)])
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
  let promise : @core.Promise[Int] = @core.any(self)
    ._call("delete", [@core.any(keys), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Delete all keys in storage
pub async fn DurableObjectStorage::delete_all(
  self : DurableObjectStorage,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
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
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("deleteAll", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// List keys in storage
pub async fn DurableObjectStorage::list(
  self : DurableObjectStorage,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("list", [])
    .cast()
  promise.wait()
}

///|
/// List keys with options
pub async fn DurableObjectStorage::list_with_options(
  self : DurableObjectStorage,
  options : DurableObjectListOptions,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("list", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Execute a transaction
pub async fn DurableObjectStorage::transaction(
  self : DurableObjectStorage,
  closure : @core.Any,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("transaction", [closure])
    .cast()
  promise.wait()
}

///|
/// Get current alarm time
pub async fn DurableObjectStorage::get_alarm(
  self : DurableObjectStorage,
) -> Int? {
  let promise : @core.Promise[Int?] = @core.any(self)
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
  let promise : @core.Promise[Int?] = @core.any(self)
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
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("setAlarm", [@core.any(scheduled_time)])
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
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("setAlarm", [@core.any(scheduled_time), options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Delete the alarm
pub async fn DurableObjectStorage::delete_alarm(
  self : DurableObjectStorage,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
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
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("deleteAlarm", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Sync storage to disk
pub async fn DurableObjectStorage::sync(self : DurableObjectStorage) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)._call("sync", []).cast()
  promise.wait()
}

///|
/// Options for get operations
pub(all) struct DurableObjectGetOptions {
  allowConcurrency : Bool?
  noCache : Bool?
}

///|
pub fn DurableObjectGetOptions::to_js(
  self : DurableObjectGetOptions,
) -> @core.Any {
  let obj = @core.new_object()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @core.any(v)
  }
  if self.noCache is Some(v) {
    obj["noCache"] = @core.any(v)
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
pub fn DurableObjectPutOptions::to_js(
  self : DurableObjectPutOptions,
) -> @core.Any {
  let obj = @core.new_object()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @core.any(v)
  }
  if self.allowUnconfirmed is Some(v) {
    obj["allowUnconfirmed"] = @core.any(v)
  }
  if self.noCache is Some(v) {
    obj["noCache"] = @core.any(v)
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
pub fn DurableObjectListOptions::to_js(
  self : DurableObjectListOptions,
) -> @core.Any {
  let obj = @core.new_object()
  if self.start is Some(v) {
    obj["start"] = @core.any(v)
  }
  if self.startAfter is Some(v) {
    obj["startAfter"] = @core.any(v)
  }
  if self.end is Some(v) {
    obj["end"] = @core.any(v)
  }
  if self.prefix is Some(v) {
    obj["prefix"] = @core.any(v)
  }
  if self.reverse is Some(v) {
    obj["reverse"] = @core.any(v)
  }
  if self.limit is Some(v) {
    obj["limit"] = @core.any(v)
  }
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @core.any(v)
  }
  if self.noCache is Some(v) {
    obj["noCache"] = @core.any(v)
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
) -> @core.Any {
  let obj = @core.new_object()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @core.any(v)
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
) -> @core.Any {
  let obj = @core.new_object()
  if self.allowConcurrency is Some(v) {
    obj["allowConcurrency"] = @core.any(v)
  }
  if self.allowUnconfirmed is Some(v) {
    obj["allowUnconfirmed"] = @core.any(v)
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
) -> @core.Any = "%identity"

///|
/// Get a value in transaction
pub async fn DurableObjectTransaction::get(
  self : DurableObjectTransaction,
  key : String,
) -> @core.Any? {
  let promise : @core.Promise[@core.Any?] = @core.any(self)
    ._call("get", [@core.any(key)])
    .cast()
  promise.wait()
}

///|
/// Get multiple values in transaction
pub async fn DurableObjectTransaction::get_multiple(
  self : DurableObjectTransaction,
  keys : Array[String],
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("get", [@core.any(keys)])
    .cast()
  promise.wait()
}

///|
/// Put a value in transaction
pub async fn DurableObjectTransaction::put(
  self : DurableObjectTransaction,
  key : String,
  value : @core.Any,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("put", [@core.any(key), value])
    .cast()
  promise.wait()
}

///|
/// Put multiple values in transaction
pub async fn DurableObjectTransaction::put_multiple(
  self : DurableObjectTransaction,
  entries : @core.Any,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
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
  let promise : @core.Promise[Bool] = @core.any(self)
    ._call("delete", [@core.any(key)])
    .cast()
  promise.wait()
}

///|
/// Delete multiple keys in transaction
pub async fn DurableObjectTransaction::delete_multiple(
  self : DurableObjectTransaction,
  keys : Array[String],
) -> Int {
  let promise : @core.Promise[Int] = @core.any(self)
    ._call("delete", [@core.any(keys)])
    .cast()
  promise.wait()
}

///|
/// Delete all keys in transaction
pub async fn DurableObjectTransaction::delete_all(
  self : DurableObjectTransaction,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("deleteAll", [])
    .cast()
  promise.wait()
}

///|
/// List keys in transaction
pub async fn DurableObjectTransaction::list(
  self : DurableObjectTransaction,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("list", [])
    .cast()
  promise.wait()
}

///|
/// List keys with options in transaction
pub async fn DurableObjectTransaction::list_with_options(
  self : DurableObjectTransaction,
  options : DurableObjectListOptions,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = @core.any(self)
    ._call("list", [options.to_js()])
    .cast()
  promise.wait()
}

///|
/// Rollback the transaction
pub fn DurableObjectTransaction::rollback(
  self : DurableObjectTransaction,
) -> Unit {
  @core.any(self)._call("rollback", []).cast()
}

///|
/// Get alarm in transaction
pub async fn DurableObjectTransaction::get_alarm(
  self : DurableObjectTransaction,
) -> Int? {
  let promise : @core.Promise[Int?] = @core.any(self)
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
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("setAlarm", [@core.any(scheduled_time)])
    .cast()
  promise.wait()
}

///|
/// Delete alarm in transaction
pub async fn DurableObjectTransaction::delete_alarm(
  self : DurableObjectTransaction,
) -> Unit {
  let promise : @core.Promise[Unit] = @core.any(self)
    ._call("deleteAlarm", [])
    .cast()
  promise.wait()
}
