// Cloudflare Durable Objects bindings

///|
#external
pub type DurableObjectNamespace

///|
pub impl Js for DurableObjectNamespace

///|
/// Get a Durable Object stub by ID
pub fn DurableObjectNamespace::get(
  self : Self,
  id : DurableObjectId,
) -> DurableObjectStub {
  self.invoke("get", [id.to_js()]) |> unsafe_cast
}

///|
/// Get a Durable Object stub by ID string
pub fn DurableObjectNamespace::get_by_id_string(
  self : Self,
  id : String,
) -> DurableObjectStub {
  self.invoke("get", [id]) |> unsafe_cast
}

///|
/// Get a Durable Object stub by name
pub fn DurableObjectNamespace::get_by_name(
  self : Self,
  name : String,
) -> DurableObjectStub {
  self.invoke("get", [self.id_from_name(name).to_js()]) |> unsafe_cast
}

///|
/// Create a new unique ID
pub fn DurableObjectNamespace::new_unique_id(self : Self) -> DurableObjectId {
  self.invoke("newUniqueId", []) |> unsafe_cast
}

///|
/// Create a new unique ID with options
pub fn DurableObjectNamespace::new_unique_id_with_options(
  self : Self,
  options : DurableObjectIdOptions,
) -> DurableObjectId {
  self.invoke("newUniqueId", [options.to_js()]) |> unsafe_cast
}

///|
/// Create an ID from a name (deterministic)
pub fn DurableObjectNamespace::id_from_name(
  self : Self,
  name : String,
) -> DurableObjectId {
  self.invoke("idFromName", [name]) |> unsafe_cast
}

///|
/// Create an ID from a string
pub fn DurableObjectNamespace::id_from_string(
  self : Self,
  id : String,
) -> DurableObjectId {
  self.invoke("idFromString", [id]) |> unsafe_cast
}

///|
/// Options for creating Durable Object IDs
pub(all) struct DurableObjectIdOptions {
  jurisdiction : String? // "eu" | "fedramp"
}

///|
pub impl Js for DurableObjectIdOptions with to_js(self) {
  let obj = js("{}")
  match self.jurisdiction {
    Some(j) => obj.set("jurisdiction", j)
    None => ()
  }
  obj
}

///|
/// Durable Object ID
#external
pub type DurableObjectId

///|
pub impl Js for DurableObjectId

///|
/// Convert ID to string
pub fn DurableObjectId::to_string(self : Self) -> String {
  self.invoke("toString", []) |> unsafe_cast
}

///|
/// Check if two IDs are equal
pub fn DurableObjectId::equals(self : Self, other : DurableObjectId) -> Bool {
  self.invoke("equals", [other.to_js()]) |> unsafe_cast
}

///|
/// Get ID name (if created from name)
pub fn DurableObjectId::name(self : Self) -> String? {
  unsafe_cast(self.to_js().get("name"))
}

///|
/// Durable Object Stub (client interface)
#external
pub type DurableObjectStub

///|
pub impl Js for DurableObjectStub

///|
/// Get the ID of this stub
pub fn DurableObjectStub::id(self : Self) -> DurableObjectId {
  unsafe_cast(self.to_js().get("id"))
}

///|
/// Get the name of this stub
pub fn DurableObjectStub::name(self : Self) -> String? {
  unsafe_cast(self.to_js().get("name"))
}

///|
/// Send a fetch request to the Durable Object
pub fn DurableObjectStub::fetch(self : Self, request : Val) -> Promise[Val] {
  self.invoke("fetch", [request]) |> unsafe_cast
}

///|
/// Send a fetch request with init options
pub fn DurableObjectStub::fetch_with_init(
  self : Self,
  request : Val,
  init : Val,
) -> Promise[Val] {
  self.invoke("fetch", [request, init]) |> unsafe_cast
}

///|
/// Send a fetch request by URL
pub fn DurableObjectStub::fetch_url(self : Self, url : String) -> Promise[Val] {
  self.invoke("fetch", [url]) |> unsafe_cast
}

///|
/// Send a fetch request by URL with init options
pub fn DurableObjectStub::fetch_url_with_init(
  self : Self,
  url : String,
  init : Val,
) -> Promise[Val] {
  self.invoke("fetch", [url, init]) |> unsafe_cast
}

///|
/// Durable Object State (available inside DO class)
#external
pub type DurableObjectState

///|
pub impl Js for DurableObjectState

///|
/// Get the ID of this Durable Object
pub fn DurableObjectState::id(self : Self) -> DurableObjectId {
  unsafe_cast(self.to_js().get("id"))
}

///|
/// Get the storage interface
pub fn DurableObjectState::storage(self : Self) -> DurableObjectStorage {
  unsafe_cast(self.to_js().get("storage"))
}

///|
/// Wait until a promise completes before confirming writes
pub fn DurableObjectState::wait_until(self : Self, promise : Val) -> Unit {
  self.invoke("waitUntil", [promise]) |> unsafe_cast
}

///|
/// Block concurrent requests until callback completes
pub fn DurableObjectState::block_concurrency_while(
  self : Self,
  callback : Val,
) -> Promise[Unit] {
  self.invoke("blockConcurrencyWhile", [callback]) |> unsafe_cast
}

///|
/// Durable Object Storage
#external
pub type DurableObjectStorage

///|
pub impl Js for DurableObjectStorage

///|
/// Get a value from storage
pub fn DurableObjectStorage::get(self : Self, key : String) -> Promise[Val?] {
  self.invoke("get", [key]) |> unsafe_cast
}

///|
/// Get a value with options
pub fn DurableObjectStorage::get_with_options(
  self : Self,
  key : String,
  options : DurableObjectGetOptions,
) -> Promise[Val?] {
  self.invoke("get", [key, options]) |> unsafe_cast
}

///|
/// Get multiple values from storage
pub fn DurableObjectStorage::get_multiple(
  self : Self,
  keys : Array[String],
) -> Promise[Val] {
  let keys_js = js("[]")
  let mut i = 0
  while i < keys.length() {
    keys_js.invoke("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.invoke("get", [keys_js]) |> unsafe_cast
}

///|
/// Get multiple values with options
pub fn DurableObjectStorage::get_multiple_with_options(
  self : Self,
  keys : Array[String],
  options : DurableObjectGetOptions,
) -> Promise[Val] {
  let keys_js = js("[]")
  let mut i = 0
  while i < keys.length() {
    keys_js.invoke("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.invoke("get", [keys_js, options.to_js()]) |> unsafe_cast
}

///|
/// Put a value into storage
pub fn DurableObjectStorage::put(
  self : Self,
  key : String,
  value : Val,
) -> Promise[Unit] {
  self.invoke("put", [key, value]) |> unsafe_cast
}

///|
/// Put a value with options
pub fn DurableObjectStorage::put_with_options(
  self : Self,
  key : String,
  value : Val,
  options : DurableObjectPutOptions,
) -> Promise[Unit] {
  self.invoke("put", [key, value, options]) |> unsafe_cast
}

///|
/// Put multiple values into storage
pub fn DurableObjectStorage::put_multiple(
  self : Self,
  entries : Val,
) -> Promise[Unit] {
  self.invoke("put", [entries]) |> unsafe_cast
}

///|
/// Put multiple values with options
pub fn DurableObjectStorage::put_multiple_with_options(
  self : Self,
  entries : Val,
  options : DurableObjectPutOptions,
) -> Promise[Unit] {
  self.invoke("put", [entries, options.to_js()]) |> unsafe_cast
}

///|
/// Delete a key from storage
pub fn DurableObjectStorage::delete(self : Self, key : String) -> Promise[Bool] {
  self.invoke("delete", [key]) |> unsafe_cast
}

///|
/// Delete a key with options
pub fn DurableObjectStorage::delete_with_options(
  self : Self,
  key : String,
  options : DurableObjectPutOptions,
) -> Promise[Bool] {
  self.invoke("delete", [key, options]) |> unsafe_cast
}

///|
/// Delete multiple keys from storage
pub fn DurableObjectStorage::delete_multiple(
  self : Self,
  keys : Array[String],
) -> Promise[Int] {
  let keys_js = js("[]")
  let mut i = 0
  while i < keys.length() {
    keys_js.invoke("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.invoke("delete", [keys_js]) |> unsafe_cast
}

///|
/// Delete multiple keys with options
pub fn DurableObjectStorage::delete_multiple_with_options(
  self : Self,
  keys : Array[String],
  options : DurableObjectPutOptions,
) -> Promise[Int] {
  let keys_js = js("[]")
  let mut i = 0
  while i < keys.length() {
    keys_js.invoke("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.invoke("delete", [keys_js, options.to_js()]) |> unsafe_cast
}

///|
/// Delete all keys in storage
pub fn DurableObjectStorage::delete_all(self : Self) -> Promise[Unit] {
  self.invoke("deleteAll", []) |> unsafe_cast
}

///|
/// Delete all keys with options
pub fn DurableObjectStorage::delete_all_with_options(
  self : Self,
  options : DurableObjectPutOptions,
) -> Promise[Unit] {
  self.invoke("deleteAll", [options.to_js()]) |> unsafe_cast
}

///|
/// List keys in storage
pub fn DurableObjectStorage::list(self : Self) -> Promise[Val] {
  self.invoke("list", []) |> unsafe_cast
}

///|
/// List keys with options
pub fn DurableObjectStorage::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> Promise[Val] {
  self.invoke("list", [options.to_js()]) |> unsafe_cast
}

///|
/// Execute a transaction
pub fn DurableObjectStorage::transaction(
  self : Self,
  closure : Val,
) -> Promise[Val] {
  self.invoke("transaction", [closure]) |> unsafe_cast
}

///|
/// Get current alarm time
pub fn DurableObjectStorage::get_alarm(self : Self) -> Promise[Int?] {
  self.invoke("getAlarm", []) |> unsafe_cast
}

///|
/// Get alarm with options
pub fn DurableObjectStorage::get_alarm_with_options(
  self : Self,
  options : DurableObjectGetAlarmOptions,
) -> Promise[Int?] {
  self.invoke("getAlarm", [options.to_js()]) |> unsafe_cast
}

///|
/// Set an alarm
pub fn DurableObjectStorage::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> Promise[Unit] {
  self.invoke("setAlarm", [scheduled_time]) |> unsafe_cast
}

///|
/// Set alarm with options
pub fn DurableObjectStorage::set_alarm_with_options(
  self : Self,
  scheduled_time : Int,
  options : DurableObjectSetAlarmOptions,
) -> Promise[Unit] {
  self.invoke("setAlarm", [scheduled_time, options]) |> unsafe_cast
}

///|
/// Delete the alarm
pub fn DurableObjectStorage::delete_alarm(self : Self) -> Promise[Unit] {
  self.invoke("deleteAlarm", []) |> unsafe_cast
}

///|
/// Delete alarm with options
pub fn DurableObjectStorage::delete_alarm_with_options(
  self : Self,
  options : DurableObjectSetAlarmOptions,
) -> Promise[Unit] {
  self.invoke("deleteAlarm", [options.to_js()]) |> unsafe_cast
}

///|
/// Sync storage to disk
pub fn DurableObjectStorage::sync(self : Self) -> Promise[Unit] {
  self.invoke("sync", []) |> unsafe_cast
}

///|
/// Options for get operations
pub(all) struct DurableObjectGetOptions {
  allow_concurrency : Bool?
  no_cache : Bool?
}

///|
pub impl Js for DurableObjectGetOptions with to_js(self) {
  let obj = js("{}")
  match self.allow_concurrency {
    Some(val) => obj.set("allowConcurrency", val)
    None => ()
  }
  match self.no_cache {
    Some(val) => obj.set("noCache", val)
    None => ()
  }
  obj
}

///|
/// Options for put/delete operations
pub(all) struct DurableObjectPutOptions {
  allow_concurrency : Bool?
  allow_unconfirmed : Bool?
  no_cache : Bool?
}

///|
pub impl Js for DurableObjectPutOptions with to_js(self) {
  let obj = js("{}")
  match self.allow_concurrency {
    Some(val) => obj.set("allowConcurrency", val)
    None => ()
  }
  match self.allow_unconfirmed {
    Some(val) => obj.set("allowUnconfirmed", val)
    None => ()
  }
  match self.no_cache {
    Some(val) => obj.set("noCache", val)
    None => ()
  }
  obj
}

///|
/// Options for list operations
pub(all) struct DurableObjectListOptions {
  start : String?
  start_after : String?
  end : String?
  prefix : String?
  reverse : Bool?
  limit : Int?
  allow_concurrency : Bool?
  no_cache : Bool?
}

///|
pub impl Js for DurableObjectListOptions with to_js(self) {
  let obj = js("{}")
  match self.start {
    Some(val) => obj.set("start", val)
    None => ()
  }
  match self.start_after {
    Some(val) => obj.set("startAfter", val)
    None => ()
  }
  match self.end {
    Some(val) => obj.set("end", val)
    None => ()
  }
  match self.prefix {
    Some(val) => obj.set("prefix", val)
    None => ()
  }
  match self.reverse {
    Some(val) => obj.set("reverse", val)
    None => ()
  }
  match self.limit {
    Some(val) => obj.set("limit", val)
    None => ()
  }
  match self.allow_concurrency {
    Some(val) => obj.set("allowConcurrency", val)
    None => ()
  }
  match self.no_cache {
    Some(val) => obj.set("noCache", val)
    None => ()
  }
  obj
}

///|
/// Options for getAlarm
pub(all) struct DurableObjectGetAlarmOptions {
  allow_concurrency : Bool?
}

///|
pub impl Js for DurableObjectGetAlarmOptions with to_js(self) {
  let obj = js("{}")
  match self.allow_concurrency {
    Some(val) => obj.set("allowConcurrency", val)
    None => ()
  }
  obj
}

///|
/// Options for setAlarm/deleteAlarm
pub(all) struct DurableObjectSetAlarmOptions {
  allow_concurrency : Bool?
  allow_unconfirmed : Bool?
}

///|
pub impl Js for DurableObjectSetAlarmOptions with to_js(self) {
  let obj = js("{}")
  match self.allow_concurrency {
    Some(val) => obj.set("allowConcurrency", val)
    None => ()
  }
  match self.allow_unconfirmed {
    Some(val) => obj.set("allowUnconfirmed", val)
    None => ()
  }
  obj
}

///|
/// Transaction context
#external
pub type DurableObjectTransaction

///|
pub impl Js for DurableObjectTransaction

///|
/// Get a value in transaction
pub fn DurableObjectTransaction::get(
  self : Self,
  key : String,
) -> Promise[Val?] {
  self.invoke("get", [key]) |> unsafe_cast
}

///|
/// Get multiple values in transaction
pub fn DurableObjectTransaction::get_multiple(
  self : Self,
  keys : Array[String],
) -> Promise[Val] {
  let keys_js = js("[]")
  let mut i = 0
  while i < keys.length() {
    keys_js.invoke("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.invoke("get", [keys_js]) |> unsafe_cast
}

///|
/// Put a value in transaction
pub fn DurableObjectTransaction::put(
  self : Self,
  key : String,
  value : Val,
) -> Promise[Unit] {
  self.invoke("put", [key, value]) |> unsafe_cast
}

///|
/// Put multiple values in transaction
pub fn DurableObjectTransaction::put_multiple(
  self : Self,
  entries : Val,
) -> Promise[Unit] {
  self.invoke("put", [entries]) |> unsafe_cast
}

///|
/// Delete a key in transaction
pub fn DurableObjectTransaction::delete(
  self : Self,
  key : String,
) -> Promise[Bool] {
  self.invoke("delete", [key]) |> unsafe_cast
}

///|
/// Delete multiple keys in transaction
pub fn DurableObjectTransaction::delete_multiple(
  self : Self,
  keys : Array[String],
) -> Promise[Int] {
  let keys_js = js("[]")
  let mut i = 0
  while i < keys.length() {
    keys_js.invoke("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.invoke("delete", [keys_js]) |> unsafe_cast
}

///|
/// Delete all keys in transaction
pub fn DurableObjectTransaction::delete_all(self : Self) -> Promise[Unit] {
  self.invoke("deleteAll", []) |> unsafe_cast
}

///|
/// List keys in transaction
pub fn DurableObjectTransaction::list(self : Self) -> Promise[Val] {
  self.invoke("list", []) |> unsafe_cast
}

///|
/// List keys with options in transaction
pub fn DurableObjectTransaction::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> Promise[Val] {
  self.invoke("list", [options.to_js()]) |> unsafe_cast
}

///|
/// Rollback the transaction
pub fn DurableObjectTransaction::rollback(self : Self) -> Unit {
  self.invoke("rollback", []) |> unsafe_cast
}

///|
/// Get alarm in transaction
pub fn DurableObjectTransaction::get_alarm(self : Self) -> Promise[Int?] {
  self.invoke("getAlarm", []) |> unsafe_cast
}

///|
/// Set alarm in transaction
pub fn DurableObjectTransaction::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> Promise[Unit] {
  self.invoke("setAlarm", [scheduled_time]) |> unsafe_cast
}

///|
/// Delete alarm in transaction
pub fn DurableObjectTransaction::delete_alarm(self : Self) -> Promise[Unit] {
  self.invoke("deleteAlarm", []) |> unsafe_cast
}
