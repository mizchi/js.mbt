// Cloudflare Durable Objects bindings

///|
#external
pub type DurableObjectNamespace

///|
pub impl Js for DurableObjectNamespace with to_js(self) {
  self |> js
}

///|
/// Get a Durable Object stub by ID
pub fn DurableObjectNamespace::get(
  self : Self,
  id : DurableObjectId,
) -> DurableObjectStub {
  self.to_js().call_method("get", [id.to_js()]).cast()
}

///|
/// Get a Durable Object stub by ID string
pub fn DurableObjectNamespace::get_by_id_string(
  self : Self,
  id : String,
) -> DurableObjectStub {
  self.to_js().call_method("get", [id]).cast()
}

///|
/// Get a Durable Object stub by name
pub fn DurableObjectNamespace::get_by_name(
  self : Self,
  name : String,
) -> DurableObjectStub {
  self.to_js().call_method("get", [self.id_from_name(name).to_js()]).cast()
}

///|
/// Create a new unique ID
pub fn DurableObjectNamespace::new_unique_id(self : Self) -> DurableObjectId {
  self.to_js().call_method("newUniqueId", []).cast()
}

///|
/// Create a new unique ID with options
pub fn DurableObjectNamespace::new_unique_id_with_options(
  self : Self,
  options : DurableObjectIdOptions,
) -> DurableObjectId {
  self.to_js().call_method("newUniqueId", [options.to_js()]).cast()
}

///|
/// Create an ID from a name (deterministic)
pub fn DurableObjectNamespace::id_from_name(
  self : Self,
  name : String,
) -> DurableObjectId {
  self.to_js().call_method("idFromName", [name]).cast()
}

///|
/// Create an ID from a string
pub fn DurableObjectNamespace::id_from_string(
  self : Self,
  id : String,
) -> DurableObjectId {
  self.to_js().call_method("idFromString", [id]).cast()
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
pub impl Js for DurableObjectId with to_js(self) {
  self |> js
}

///|
/// Convert ID to string
pub fn DurableObjectId::to_string(self : Self) -> String {
  self.to_js().call_method("toString", []).cast()
}

///|
/// Check if two IDs are equal
pub fn DurableObjectId::equals(self : Self, other : DurableObjectId) -> Bool {
  self.to_js().call_method("equals", [other.to_js()]).cast()
}

///|
/// Get ID name (if created from name)
pub fn DurableObjectId::name(self : Self) -> String? {
  self.to_js().get("name").cast()
}

///|
/// Durable Object Stub (client interface)
#external
pub type DurableObjectStub

///|
pub impl Js for DurableObjectStub with to_js(self) {
  self |> js
}

///|
/// Get the ID of this stub
pub fn DurableObjectStub::id(self : Self) -> DurableObjectId {
  self.to_js().get("id").cast()
}

///|
/// Get the name of this stub
pub fn DurableObjectStub::name(self : Self) -> String? {
  self.to_js().get("name").cast()
}

///|
/// Send a fetch request to the Durable Object
pub fn DurableObjectStub::fetch(self : Self, request : Val) -> Promise[Val] {
  self.to_js().call_method("fetch", [request]).cast()
}

///|
/// Send a fetch request with init options
pub fn DurableObjectStub::fetch_with_init(
  self : Self,
  request : Val,
  init : Val,
) -> Promise[Val] {
  self.to_js().call_method("fetch", [request, init]).cast()
}

///|
/// Send a fetch request by URL
pub fn DurableObjectStub::fetch_url(self : Self, url : String) -> Promise[Val] {
  self.to_js().call_method("fetch", [url]).cast()
}

///|
/// Send a fetch request by URL with init options
pub fn DurableObjectStub::fetch_url_with_init(
  self : Self,
  url : String,
  init : Val,
) -> Promise[Val] {
  self.to_js().call_method("fetch", [url, init]).cast()
}

///|
/// Durable Object State (available inside DO class)
#external
pub type DurableObjectState

///|
pub impl Js for DurableObjectState with to_js(self) {
  self |> js
}

///|
/// Get the ID of this Durable Object
pub fn DurableObjectState::id(self : Self) -> DurableObjectId {
  self.to_js().get("id").cast()
}

///|
/// Get the storage interface
pub fn DurableObjectState::storage(self : Self) -> DurableObjectStorage {
  self.to_js().get("storage").cast()
}

///|
/// Wait until a promise completes before confirming writes
pub fn DurableObjectState::wait_until(self : Self, promise : Val) -> Unit {
  self.to_js().call_method("waitUntil", [promise]).cast()
}

///|
/// Block concurrent requests until callback completes
pub fn DurableObjectState::block_concurrency_while(
  self : Self,
  callback : Val,
) -> Promise[Unit] {
  self.to_js().call_method("blockConcurrencyWhile", [callback]).cast()
}

///|
/// Durable Object Storage
#external
pub type DurableObjectStorage

///|
pub impl Js for DurableObjectStorage with to_js(self) {
  self |> js
}

///|
/// Get a value from storage
pub fn DurableObjectStorage::get(self : Self, key : String) -> Promise[Val?] {
  self.to_js().call_method("get", [key]).cast()
}

///|
/// Get a value with options
pub fn DurableObjectStorage::get_with_options(
  self : Self,
  key : String,
  options : DurableObjectGetOptions,
) -> Promise[Val?] {
  self.to_js().call_method("get", [key, options]).cast()
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
    keys_js.call_method("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.to_js().call_method("get", [keys_js]).cast()
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
    keys_js.call_method("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.to_js().call_method("get", [keys_js, options.to_js()]).cast()
}

///|
/// Put a value into storage
pub fn DurableObjectStorage::put(
  self : Self,
  key : String,
  value : Val,
) -> Promise[Unit] {
  self.to_js().call_method("put", [key, value]).cast()
}

///|
/// Put a value with options
pub fn DurableObjectStorage::put_with_options(
  self : Self,
  key : String,
  value : Val,
  options : DurableObjectPutOptions,
) -> Promise[Unit] {
  self.to_js().call_method("put", [key, value, options]).cast()
}

///|
/// Put multiple values into storage
pub fn DurableObjectStorage::put_multiple(
  self : Self,
  entries : Val,
) -> Promise[Unit] {
  self.to_js().call_method("put", [entries]).cast()
}

///|
/// Put multiple values with options
pub fn DurableObjectStorage::put_multiple_with_options(
  self : Self,
  entries : Val,
  options : DurableObjectPutOptions,
) -> Promise[Unit] {
  self.to_js().call_method("put", [entries, options.to_js()]).cast()
}

///|
/// Delete a key from storage
pub fn DurableObjectStorage::delete(self : Self, key : String) -> Promise[Bool] {
  self.to_js().call_method("delete", [key]).cast()
}

///|
/// Delete a key with options
pub fn DurableObjectStorage::delete_with_options(
  self : Self,
  key : String,
  options : DurableObjectPutOptions,
) -> Promise[Bool] {
  self.to_js().call_method("delete", [key, options]).cast()
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
    keys_js.call_method("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.to_js().call_method("delete", [keys_js]).cast()
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
    keys_js.call_method("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.to_js().call_method("delete", [keys_js, options.to_js()]).cast()
}

///|
/// Delete all keys in storage
pub fn DurableObjectStorage::delete_all(self : Self) -> Promise[Unit] {
  self.to_js().call_method("deleteAll", []).cast()
}

///|
/// Delete all keys with options
pub fn DurableObjectStorage::delete_all_with_options(
  self : Self,
  options : DurableObjectPutOptions,
) -> Promise[Unit] {
  self.to_js().call_method("deleteAll", [options.to_js()]).cast()
}

///|
/// List keys in storage
pub fn DurableObjectStorage::list(self : Self) -> Promise[Val] {
  self.to_js().call_method("list", []).cast()
}

///|
/// List keys with options
pub fn DurableObjectStorage::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> Promise[Val] {
  self.to_js().call_method("list", [options.to_js()]).cast()
}

///|
/// Execute a transaction
pub fn DurableObjectStorage::transaction(
  self : Self,
  closure : Val,
) -> Promise[Val] {
  self.to_js().call_method("transaction", [closure]).cast()
}

///|
/// Get current alarm time
pub fn DurableObjectStorage::get_alarm(self : Self) -> Promise[Int?] {
  self.to_js().call_method("getAlarm", []).cast()
}

///|
/// Get alarm with options
pub fn DurableObjectStorage::get_alarm_with_options(
  self : Self,
  options : DurableObjectGetAlarmOptions,
) -> Promise[Int?] {
  self.to_js().call_method("getAlarm", [options.to_js()]).cast()
}

///|
/// Set an alarm
pub fn DurableObjectStorage::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> Promise[Unit] {
  self.to_js().call_method("setAlarm", [scheduled_time]).cast()
}

///|
/// Set alarm with options
pub fn DurableObjectStorage::set_alarm_with_options(
  self : Self,
  scheduled_time : Int,
  options : DurableObjectSetAlarmOptions,
) -> Promise[Unit] {
  self.to_js().call_method("setAlarm", [scheduled_time, options]).cast()
}

///|
/// Delete the alarm
pub fn DurableObjectStorage::delete_alarm(self : Self) -> Promise[Unit] {
  self.to_js().call_method("deleteAlarm", []).cast()
}

///|
/// Delete alarm with options
pub fn DurableObjectStorage::delete_alarm_with_options(
  self : Self,
  options : DurableObjectSetAlarmOptions,
) -> Promise[Unit] {
  self.to_js().call_method("deleteAlarm", [options.to_js()]).cast()
}

///|
/// Sync storage to disk
pub fn DurableObjectStorage::sync(self : Self) -> Promise[Unit] {
  self.to_js().call_method("sync", []).cast()
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
pub impl Js for DurableObjectTransaction with to_js(self) {
  self |> js
}

///|
/// Get a value in transaction
pub fn DurableObjectTransaction::get(
  self : Self,
  key : String,
) -> Promise[Val?] {
  self.to_js().call_method("get", [key]).cast()
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
    keys_js.call_method("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.to_js().call_method("get", [keys_js]).cast()
}

///|
/// Put a value in transaction
pub fn DurableObjectTransaction::put(
  self : Self,
  key : String,
  value : Val,
) -> Promise[Unit] {
  self.to_js().call_method("put", [key, value]).cast()
}

///|
/// Put multiple values in transaction
pub fn DurableObjectTransaction::put_multiple(
  self : Self,
  entries : Val,
) -> Promise[Unit] {
  self.to_js().call_method("put", [entries]).cast()
}

///|
/// Delete a key in transaction
pub fn DurableObjectTransaction::delete(
  self : Self,
  key : String,
) -> Promise[Bool] {
  self.to_js().call_method("delete", [key]).cast()
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
    keys_js.call_method("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.to_js().call_method("delete", [keys_js]).cast()
}

///|
/// Delete all keys in transaction
pub fn DurableObjectTransaction::delete_all(self : Self) -> Promise[Unit] {
  self.to_js().call_method("deleteAll", []).cast()
}

///|
/// List keys in transaction
pub fn DurableObjectTransaction::list(self : Self) -> Promise[Val] {
  self.to_js().call_method("list", []).cast()
}

///|
/// List keys with options in transaction
pub fn DurableObjectTransaction::list_with_options(
  self : Self,
  options : DurableObjectListOptions,
) -> Promise[Val] {
  self.to_js().call_method("list", [options.to_js()]).cast()
}

///|
/// Rollback the transaction
pub fn DurableObjectTransaction::rollback(self : Self) -> Unit {
  self.to_js().call_method("rollback", []).cast()
}

///|
/// Get alarm in transaction
pub fn DurableObjectTransaction::get_alarm(self : Self) -> Promise[Int?] {
  self.to_js().call_method("getAlarm", []).cast()
}

///|
/// Set alarm in transaction
pub fn DurableObjectTransaction::set_alarm(
  self : Self,
  scheduled_time : Int,
) -> Promise[Unit] {
  self.to_js().call_method("setAlarm", [scheduled_time]).cast()
}

///|
/// Delete alarm in transaction
pub fn DurableObjectTransaction::delete_alarm(self : Self) -> Promise[Unit] {
  self.to_js().call_method("deleteAlarm", []).cast()
}
