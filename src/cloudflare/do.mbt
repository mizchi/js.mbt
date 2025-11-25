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
  self.call1("get", id).cast()
}

///|
/// Get a Durable Object stub by ID string
pub fn DurableObjectNamespace::get_by_id_string(
  self : Self,
  id : String,
) -> DurableObjectStub {
  self.call1("get", id).cast()
}

///|
/// Get a Durable Object stub by name
pub fn DurableObjectNamespace::get_by_name(
  self : Self,
  name : String,
) -> DurableObjectStub {
  self.call("get", [self.id_from_name(name)]).cast()
}

///|
/// Create a new unique ID
pub fn DurableObjectNamespace::new_unique_id(self : Self) -> DurableObjectId {
  self.call0("newUniqueId").cast()
}

///|
/// Create a new unique ID with options
pub fn DurableObjectNamespace::new_unique_id_with_options(
  self : Self,
  options : DurableObjectIdOptions,
) -> DurableObjectId {
  self.call("newUniqueId", [options]).cast()
}

///|
/// Create an ID from a name (deterministic)
pub fn DurableObjectNamespace::id_from_name(
  self : Self,
  name : String,
) -> DurableObjectId {
  self.call("idFromName", [name]).cast()
}

///|
/// Create an ID from a string
pub fn DurableObjectNamespace::id_from_string(
  self : Self,
  id : String,
) -> DurableObjectId {
  self.call("idFromString", [id]).cast()
}

///|
/// Options for creating Durable Object IDs
pub(all) struct DurableObjectIdOptions {
  jurisdiction : String? // "eu" | "fedramp"
}

///|
pub impl @js.JsImpl for DurableObjectIdOptions with to_any(self) {
  @js.from_option_map({
    "jurisdiction": self.jurisdiction.map(fn(x) { @js.any(x) }),
  })
}

///|
/// Durable Object ID
pub(all) struct DurableObjectId {
  name : String?
}

///|
pub impl @js.JsImpl for DurableObjectId

///|
/// Convert ID to string
pub fn DurableObjectId::to_string(self : Self) -> String {
  self.call0("toString").cast()
}

///|
/// Check if two IDs are equal
pub fn DurableObjectId::equals(self : Self, other : DurableObjectId) -> Bool {
  self.call("equals", [other.to_any()]).cast()
}

///|
/// Durable Object Stub (client interface)
pub(all) struct DurableObjectStub {
  id : DurableObjectId
  name : String?
}

///|
pub impl @js.JsImpl for DurableObjectStub

///|
/// Send a fetch request to the Durable Object
pub fn DurableObjectStub::fetch(
  self : Self,
  request : @js.Any,
) -> @js.Promise[@js.Any] {
  self.call("fetch", [request]).cast()
}

///|
/// Send a fetch request with init options
pub fn DurableObjectStub::fetch_with_init(
  self : Self,
  request : @js.Any,
  init : @js.Any,
) -> @js.Promise[@js.Any] {
  self.call2("fetch", request, init).cast()
}

///|
/// Send a fetch request by URL
pub fn DurableObjectStub::fetch_url(
  self : Self,
  url : String,
) -> @js.Promise[@js.Any] {
  self.call("fetch", [url]).cast()
}

///|
/// Send a fetch request by URL with init options
pub fn DurableObjectStub::fetch_url_with_init(
  self : Self,
  url : String,
  init : @js.Any,
) -> @js.Promise[@js.Any] {
  self.call2("fetch", url, init).cast()
}

///|
/// Durable Object State (available inside DO class)
pub(all) struct DurableObjectState {
  id : DurableObjectId
  storage : DurableObjectStorage
}

///|
pub impl @js.JsImpl for DurableObjectState

///|
/// Wait until a promise completes before confirming writes
pub fn DurableObjectState::wait_until(self : Self, promise : @js.Any) -> Unit {
  self.call("waitUntil", [promise]).cast()
}

///|
/// Block concurrent requests until callback completes
pub fn DurableObjectState::block_concurrency_while(
  self : Self,
  callback : @js.Any,
) -> @js.Promise[Unit] {
  self.call("blockConcurrencyWhile", [callback]).cast()
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
) -> @js.Promise[@js.Any?] {
  self.call("get", [key]).cast()
}

///|
/// Get a value with options
pub fn DurableObjectStorage::get_with_options(
  self : Self,
  key : String,
  options : DurableObjectGetOptions,
) -> @js.Promise[@js.Any?] {
  self.call2("get", key, options).cast()
}

///|
/// Get multiple values from storage
pub fn DurableObjectStorage::get_multiple(
  self : Self,
  keys : Array[String],
) -> @js.Promise[@js.Any] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call("get", [keys_js]).cast()
}

///|
/// Get multiple values with options
pub fn DurableObjectStorage::get_multiple_with_options(
  self : Self,
  keys : Array[String],
  options : DurableObjectGetOptions,
) -> @js.Promise[@js.Any] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call2("get", keys_js, options).cast()
}

///|
/// Put a value into storage
pub fn DurableObjectStorage::put(
  self : Self,
  key : String,
  value : @js.Any,
) -> @js.Promise[Unit] {
  self.call2("put", key, value).cast()
}

///|
/// Put a value with options
pub fn DurableObjectStorage::put_with_options(
  self : Self,
  key : String,
  value : @js.Any,
  options : DurableObjectPutOptions,
) -> @js.Promise[Unit] {
  self.call("put", [key, value, options]).cast()
}

///|
/// Put multiple values into storage
pub fn DurableObjectStorage::put_multiple(
  self : Self,
  entries : @js.Any,
) -> @js.Promise[Unit] {
  self.call("put", [entries]).cast()
}

///|
/// Put multiple values with options
pub fn DurableObjectStorage::put_multiple_with_options(
  self : Self,
  entries : @js.Any,
  options : DurableObjectPutOptions,
) -> @js.Promise[Unit] {
  self.call2("put", entries, options).cast()
}

///|
/// Delete a key from storage
pub fn DurableObjectStorage::delete(
  self : Self,
  key : String,
) -> @js.Promise[Bool] {
  self.call("delete", [key]).cast()
}

///|
/// Delete a key with options
pub fn DurableObjectStorage::delete_with_options(
  self : Self,
  key : String,
  options : DurableObjectPutOptions,
) -> @js.Promise[Bool] {
  self.call2("delete", key, options).cast()
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
  self.call("delete", [keys_js]).cast()
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
  self.call2("delete", keys_js, options).cast()
}

///|
/// Delete all keys in storage
pub fn DurableObjectStorage::delete_all(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAll").cast()
}

///|
/// Delete all keys with options
pub fn DurableObjectStorage::delete_all_with_options(
  self : Self,
  options : DurableObjectPutOptions,
) -> @js.Promise[Unit] {
  self.call1("deleteAll", options).cast()
}

///|
/// List keys in storage
pub fn DurableObjectStorage::list(self : Self) -> @js.Promise[@js.Any] {
  self.call0("list").cast()
}

///|
/// List keys with options
pub fn DurableObjectStorage::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> @js.Promise[@js.Any] {
  self.call1("list", options).cast()
}

///|
/// Execute a transaction
pub fn DurableObjectStorage::transaction(
  self : Self,
  closure : @js.Any,
) -> @js.Promise[@js.Any] {
  self.call1("transaction", closure).cast()
}

///|
/// Get current alarm time
pub fn DurableObjectStorage::get_alarm(self : Self) -> @js.Promise[Int?] {
  self.call0("getAlarm").cast()
}

///|
/// Get alarm with options
pub fn DurableObjectStorage::get_alarm_with_options(
  self : Self,
  options : DurableObjectGetAlarmOptions,
) -> @js.Promise[Int?] {
  self.call1("getAlarm", options).cast()
}

///|
/// Set an alarm
pub fn DurableObjectStorage::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> @js.Promise[Unit] {
  self.call1("setAlarm", scheduled_time).cast()
}

///|
/// Set alarm with options
pub fn DurableObjectStorage::set_alarm_with_options(
  self : Self,
  scheduled_time : Int,
  options : DurableObjectSetAlarmOptions,
) -> @js.Promise[Unit] {
  self.call2("setAlarm", scheduled_time, options).cast()
}

///|
/// Delete the alarm
pub fn DurableObjectStorage::delete_alarm(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAlarm").cast()
}

///|
/// Delete alarm with options
pub fn DurableObjectStorage::delete_alarm_with_options(
  self : Self,
  options : DurableObjectSetAlarmOptions,
) -> @js.Promise[Unit] {
  self.call1("deleteAlarm", options).cast()
}

///|
/// Sync storage to disk
pub fn DurableObjectStorage::sync(self : Self) -> @js.Promise[Unit] {
  self.call0("sync").cast()
}

///|
/// Options for get operations
pub(all) struct DurableObjectGetOptions {
  allowConcurrency : Bool?
  noCache : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectGetOptions with to_any(self) {
  @js.from_option_map({
    "allowConcurrency": self.allowConcurrency.map(fn(x) { @js.any(x) }),
    "noCache": self.noCache.map(fn(x) { @js.any(x) }),
  })
}

///|
/// Options for put/delete operations
pub(all) struct DurableObjectPutOptions {
  allowConcurrency : Bool?
  allowUnconfirmed : Bool?
  noCache : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectPutOptions with to_any(self) {
  @js.from_option_map({
    "allowConcurrency": self.allowConcurrency.map(fn(x) { @js.any(x) }),
    "allowUnconfirmed": self.allowUnconfirmed.map(fn(x) { @js.any(x) }),
    "noCache": self.noCache.map(fn(x) { @js.any(x) }),
  })
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
pub impl @js.JsImpl for DurableObjectListOptions with to_any(self) {
  @js.from_option_map({
    "start": self.start.map(fn(x) { @js.any(x) }),
    "startAfter": self.startAfter.map(fn(x) { @js.any(x) }),
    "end": self.end.map(fn(x) { @js.any(x) }),
    "prefix": self.prefix.map(fn(x) { @js.any(x) }),
    "reverse": self.reverse.map(fn(x) { @js.any(x) }),
    "limit": self.limit.map(fn(x) { @js.any(x) }),
    "allowConcurrency": self.allowConcurrency.map(fn(x) { @js.any(x) }),
    "noCache": self.noCache.map(fn(x) { @js.any(x) }),
  })
}

///|
/// Options for getAlarm
pub(all) struct DurableObjectGetAlarmOptions {
  allowConcurrency : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectGetAlarmOptions with to_any(self) {
  @js.from_option_map({
    "allowConcurrency": self.allowConcurrency.map(fn(x) { @js.any(x) }),
  })
}

///|
/// Options for setAlarm/deleteAlarm
pub(all) struct DurableObjectSetAlarmOptions {
  allowConcurrency : Bool?
  allowUnconfirmed : Bool?
}

///|
pub impl @js.JsImpl for DurableObjectSetAlarmOptions with to_any(self) {
  @js.from_option_map({
    "allowConcurrency": self.allowConcurrency.map(fn(x) { @js.any(x) }),
    "allowUnconfirmed": self.allowUnconfirmed.map(fn(x) { @js.any(x) }),
  })
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
) -> @js.Promise[@js.Any?] {
  self.call("get", [key]).cast()
}

///|
/// Get multiple values in transaction
pub fn DurableObjectTransaction::get_multiple(
  self : Self,
  keys : Array[String],
) -> @js.Promise[@js.Any] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call1("get", keys_js).cast()
}

///|
/// Put a value in transaction
pub fn DurableObjectTransaction::put(
  self : Self,
  key : String,
  value : @js.Any,
) -> @js.Promise[Unit] {
  self.call2("put", key, value).cast()
}

///|
/// Put multiple values in transaction
pub fn DurableObjectTransaction::put_multiple(
  self : Self,
  entries : @js.Any,
) -> @js.Promise[Unit] {
  self.call("put", [entries]).cast()
}

///|
/// Delete a key in transaction
pub fn DurableObjectTransaction::delete(
  self : Self,
  key : String,
) -> @js.Promise[Bool] {
  self.call("delete", [key]).cast()
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
  self.call("delete", [keys_js]).cast()
}

///|
/// Delete all keys in transaction
pub fn DurableObjectTransaction::delete_all(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAll").cast()
}

///|
/// List keys in transaction
pub fn DurableObjectTransaction::list(self : Self) -> @js.Promise[@js.Any] {
  self.call0("list").cast()
}

///|
/// List keys with options in transaction
pub fn DurableObjectTransaction::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> @js.Promise[@js.Any] {
  self.call("list", [options.to_any()]).cast()
}

///|
/// Rollback the transaction
pub fn DurableObjectTransaction::rollback(self : Self) -> Unit {
  self.call0("rollback").cast()
}

///|
/// Get alarm in transaction
pub fn DurableObjectTransaction::get_alarm(self : Self) -> @js.Promise[Int?] {
  self.call0("getAlarm").cast()
}

///|
/// Set alarm in transaction
pub fn DurableObjectTransaction::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> @js.Promise[Unit] {
  self.call("setAlarm", [scheduled_time]).cast()
}

///|
/// Delete alarm in transaction
pub fn DurableObjectTransaction::delete_alarm(self : Self) -> @js.Promise[Unit] {
  self.call0("deleteAlarm").cast()
}
