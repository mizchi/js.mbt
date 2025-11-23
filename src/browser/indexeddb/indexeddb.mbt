// https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API
// IndexedDB API bindings for MoonBit

///| IDBRequest - Generic interface for database requests

///|
/// IDBRequest represents an async request to the database
#external
pub type IDBRequest

///|
pub impl JsImpl for IDBRequest

///|
pub impl EventEmitterImpl for IDBRequest

///|
pub impl EventEmitterImpl for IDBRequest with on(self, name, callback) {
  self.call2("addEventListener", name, @js.from_fn1(callback)) |> ignore
}

///|
/// Get the request result (throws if not done)
pub fn IDBRequest::get_result(self : Self) -> Js {
  self.get("result")
}

///|
/// Get the request error (null if no error)
pub fn IDBRequest::get_error(self : Self) -> Js {
  self.get("error")
}

///|
/// Get the request source
pub fn IDBRequest::get_source(self : Self) -> Js {
  self.get("source")
}

///|
/// Get the readyState
pub fn IDBRequest::get_readyState(self : Self) -> String {
  @js.unsafe_cast(self.get("readyState"))
}

///|
/// Check if request is pending
pub fn IDBRequest::is_pending(self : Self) -> Bool {
  self.get_readyState() == "pending"
}

///|
/// Check if request is done
pub fn IDBRequest::is_done(self : Self) -> Bool {
  self.get_readyState() == "done"
}

///| IDBOpenDBRequest - Request for opening database

///|
/// IDBOpenDBRequest extends IDBRequest for database opening
#external
pub type IDBOpenDBRequest

///|
pub impl JsImpl for IDBOpenDBRequest

///|
pub impl EventEmitterImpl for IDBOpenDBRequest

///|
pub impl EventEmitterImpl for IDBOpenDBRequest with on(self, name, callback) {
  self.call2("addEventListener", name, @js.from_fn1(callback)) |> ignore
}

///|
/// Get the request result
pub fn IDBOpenDBRequest::get_result(self : Self) -> Js {
  self.get("result")
}

///|
/// Get the request error
pub fn IDBOpenDBRequest::get_error(self : Self) -> Js {
  self.get("error")
}

///| IDBDatabase - Database connection

///|
/// IDBDatabase represents a connection to an IndexedDB database
#external
pub type IDBDatabase

///|
pub impl JsImpl for IDBDatabase

///|
pub impl EventEmitterImpl for IDBDatabase

///|
/// Get database name
pub fn IDBDatabase::name(self : Self) -> String {
  @js.unsafe_cast(self.get("name"))
}

///|
/// Get database version
pub fn IDBDatabase::version(self : Self) -> Int {
  @js.unsafe_cast(self.get("version"))
}

///|
/// Get object store names
pub fn IDBDatabase::objectStoreNames(self : Self) -> Js {
  self.get("objectStoreNames")
}

///|
/// Create a transaction for the specified object stores
/// mode: "readonly" (default), "readwrite", or "readwriteflush"
pub fn IDBDatabase::transaction(
  self : Self,
  store_names : Array[String],
  mode? : String,
) -> IDBTransaction {
  let mode_str = mode.unwrap_or("readonly")
  self.call2("transaction", @js.from_array(store_names), mode_str)
  |> @js.unsafe_cast
}

///|
/// Create a new object store (only in versionchange transaction)
pub fn IDBDatabase::createObjectStore(
  self : Self,
  name : String,
  keyPath? : String,
  autoIncrement? : Bool,
) -> IDBObjectStore {
  let options = @js.from_entries_option([
    ("keyPath", keyPath.map(fn(x) { x })),
    ("autoIncrement", autoIncrement.map(fn(x) { x })),
  ])
  self.call2("createObjectStore", name, options) |> @js.unsafe_cast
}

///|
/// Delete an object store (only in versionchange transaction)
pub fn IDBDatabase::deleteObjectStore(self : Self, name : String) -> Unit {
  self.call1("deleteObjectStore", name) |> ignore
}

///|
/// Close the database connection
pub fn IDBDatabase::close(self : Self) -> Unit {
  self.call0("close") |> ignore
}

///| IDBTransaction - Database transaction

///|
/// IDBTransaction represents a database transaction
#external
pub type IDBTransaction

///|
pub impl JsImpl for IDBTransaction

///|
pub impl EventEmitterImpl for IDBTransaction

///|
/// Get transaction mode
pub fn IDBTransaction::mode(self : Self) -> String {
  @js.unsafe_cast(self.get("mode"))
}

///|
/// Get transaction database
pub fn IDBTransaction::db(self : Self) -> IDBDatabase {
  @js.unsafe_cast(self.get("db"))
}

///|
/// Get object store names in this transaction
pub fn IDBTransaction::objectStoreNames(self : Self) -> Js {
  self.get("objectStoreNames")
}

///|
/// Get an object store from this transaction
pub fn IDBTransaction::objectStore(
  self : Self,
  name : String,
) -> IDBObjectStore {
  self.call1("objectStore", name) |> @js.unsafe_cast
}

///|
/// Commit the transaction
pub fn IDBTransaction::commit(self : Self) -> Unit {
  self.call0("commit") |> ignore
}

///|
/// Abort the transaction
pub fn IDBTransaction::abort(self : Self) -> Unit {
  self.call0("abort") |> ignore
}

///| IDBObjectStore - Object store for data

///|
/// IDBObjectStore represents an object store in the database
#external
pub type IDBObjectStore

///|
pub impl JsImpl for IDBObjectStore

///|
/// Get object store name
pub fn IDBObjectStore::name(self : Self) -> String {
  @js.unsafe_cast(self.get("name"))
}

///|
/// Get key path
pub fn IDBObjectStore::keyPath(self : Self) -> Js {
  self.to_js().get("keyPath")
}

///|
/// Get autoIncrement flag
pub fn IDBObjectStore::autoIncrement(self : Self) -> Bool {
  @js.unsafe_cast(self.get("autoIncrement"))
}

///|
/// Get index names
pub fn IDBObjectStore::indexNames(self : Self) -> Js {
  self.to_js().get("indexNames")
}

///|
/// Get transaction
pub fn IDBObjectStore::transaction(self : Self) -> IDBTransaction {
  @js.unsafe_cast(self.get("transaction"))
}

///|
/// Add a new record (fails if key exists)
pub fn IDBObjectStore::add(
  self : Self,
  value : &JsImpl,
  key? : &JsImpl,
) -> IDBRequest {
  match key {
    Some(k) => self.call2("add", value.to_js(), k.to_js()) |> @js.unsafe_cast
    None => self.call1("add", value.to_js()) |> @js.unsafe_cast
  }
}

///|
/// Put a record (overwrites if key exists)
pub fn IDBObjectStore::put(
  self : Self,
  value : &JsImpl,
  key? : &JsImpl,
) -> IDBRequest {
  match key {
    Some(k) => self.call2("put", value.to_js(), k.to_js()) |> @js.unsafe_cast
    None => self.call1("put", value.to_js()) |> @js.unsafe_cast
  }
}

///|
/// Get a record by key
pub fn IDBObjectStore::get(self : Self, key : &JsImpl) -> IDBRequest {
  self.call1("get", key.to_js()) |> @js.unsafe_cast
}

///|
/// Delete a record by key
pub fn IDBObjectStore::delete(self : Self, key : &JsImpl) -> IDBRequest {
  self.call1("delete", key.to_js()) |> @js.unsafe_cast
}

///|
/// Clear all records from the store
pub fn IDBObjectStore::clear(self : Self) -> IDBRequest {
  self.call0("clear") |> @js.unsafe_cast
}

///|
/// Get all records (optionally filtered by query)
pub fn IDBObjectStore::getAll(
  self : Self,
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest {
  match (query, count) {
    (Some(q), Some(c)) => self.call2("getAll", q.to_js(), c) |> @js.unsafe_cast
    (Some(q), None) => self.call1("getAll", q.to_js()) |> @js.unsafe_cast
    (None, Some(c)) =>
      self.call2("getAll", @js.undefined(), c) |> @js.unsafe_cast
    (None, None) => self.call0("getAll") |> @js.unsafe_cast
  }
}

///|
/// Get all keys (optionally filtered by query)
pub fn IDBObjectStore::getAllKeys(
  self : Self,
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest {
  match (query, count) {
    (Some(q), Some(c)) =>
      self.call2("getAllKeys", q.to_js(), c) |> @js.unsafe_cast
    (Some(q), None) => self.call1("getAllKeys", q.to_js()) |> @js.unsafe_cast
    (None, Some(c)) =>
      self.call2("getAllKeys", @js.undefined(), c) |> @js.unsafe_cast
    (None, None) => self.call0("getAllKeys") |> @js.unsafe_cast
  }
}

///|
/// Count records (optionally filtered by query)
pub fn IDBObjectStore::count(self : Self, query? : &JsImpl) -> IDBRequest {
  match query {
    Some(q) => self.call1("count", q.to_js()) |> @js.unsafe_cast
    None => self.call0("count") |> @js.unsafe_cast
  }
}

///|
/// Open a cursor to iterate over records
pub fn IDBObjectStore::openCursor(
  self : Self,
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest {
  match (query, direction) {
    (Some(q), Some(d)) =>
      self.call2("openCursor", q.to_js(), d) |> @js.unsafe_cast
    (Some(q), None) => self.call1("openCursor", q.to_js()) |> @js.unsafe_cast
    (None, Some(d)) =>
      self.call2("openCursor", @js.undefined(), d) |> @js.unsafe_cast
    (None, None) => self.call0("openCursor") |> @js.unsafe_cast
  }
}

///|
/// Open a key cursor
pub fn IDBObjectStore::openKeyCursor(
  self : Self,
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest {
  match (query, direction) {
    (Some(q), Some(d)) =>
      self.call2("openKeyCursor", q.to_js(), d) |> @js.unsafe_cast
    (Some(q), None) => self.call1("openKeyCursor", q.to_js()) |> @js.unsafe_cast
    (None, Some(d)) =>
      self.call2("openKeyCursor", @js.undefined(), d) |> @js.unsafe_cast
    (None, None) => self.call0("openKeyCursor") |> @js.unsafe_cast
  }
}

///|
/// Create an index on this object store
pub fn IDBObjectStore::createIndex(
  self : Self,
  name : String,
  keyPath : String,
  unique? : Bool,
  multiEntry? : Bool,
) -> IDBIndex {
  let options = @js.from_entries_option([
    ("unique", unique.map(fn(x) { x })),
    ("multiEntry", multiEntry.map(fn(x) { x })),
  ])
  self.call("createIndex", [name, keyPath, options]) |> @js.unsafe_cast
}

///|
/// Delete an index from this object store
pub fn IDBObjectStore::deleteIndex(self : Self, name : String) -> Unit {
  self.call1("deleteIndex", name) |> ignore
}

///|
/// Get an index by name
pub fn IDBObjectStore::index(self : Self, name : String) -> IDBIndex {
  self.call1("index", name) |> @js.unsafe_cast
}

///| IDBIndex - Index for object store

///|
/// IDBIndex represents an index on an object store
#external
pub type IDBIndex

///|
pub impl JsImpl for IDBIndex

///|
/// Get index name
pub fn IDBIndex::name(self : Self) -> String {
  @js.unsafe_cast(self.get("name"))
}

///|
/// Get object store
pub fn IDBIndex::objectStore(self : Self) -> IDBObjectStore {
  @js.unsafe_cast(self.get("objectStore"))
}

///|
/// Get key path
pub fn IDBIndex::keyPath(self : Self) -> Js {
  self.to_js().get("keyPath")
}

///|
/// Get multiEntry flag
pub fn IDBIndex::multiEntry(self : Self) -> Bool {
  @js.unsafe_cast(self.get("multiEntry"))
}

///|
/// Get unique flag
pub fn IDBIndex::unique(self : Self) -> Bool {
  @js.unsafe_cast(self.get("unique"))
}

///|
/// Get a record by index key
pub fn IDBIndex::get(self : Self, key : &JsImpl) -> IDBRequest {
  self.call1("get", key.to_js()) |> @js.unsafe_cast
}

///|
/// Get all records matching the query
pub fn IDBIndex::getAll(
  self : Self,
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest {
  match (query, count) {
    (Some(q), Some(c)) => self.call2("getAll", q.to_js(), c) |> @js.unsafe_cast
    (Some(q), None) => self.call1("getAll", q.to_js()) |> @js.unsafe_cast
    (None, Some(c)) =>
      self.call2("getAll", @js.undefined(), c) |> @js.unsafe_cast
    (None, None) => self.call0("getAll") |> @js.unsafe_cast
  }
}

///|
/// Get all keys matching the query
pub fn IDBIndex::getAllKeys(
  self : Self,
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest {
  match (query, count) {
    (Some(q), Some(c)) =>
      self.call2("getAllKeys", q.to_js(), c) |> @js.unsafe_cast
    (Some(q), None) => self.call1("getAllKeys", q.to_js()) |> @js.unsafe_cast
    (None, Some(c)) =>
      self.call2("getAllKeys", @js.undefined(), c) |> @js.unsafe_cast
    (None, None) => self.call0("getAllKeys") |> @js.unsafe_cast
  }
}

///|
/// Count records matching the query
pub fn IDBIndex::count(self : Self, query? : &JsImpl) -> IDBRequest {
  match query {
    Some(q) => self.call1("count", q.to_js()) |> @js.unsafe_cast
    None => self.call0("count") |> @js.unsafe_cast
  }
}

///|
/// Open a cursor on this index
pub fn IDBIndex::openCursor(
  self : Self,
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest {
  match (query, direction) {
    (Some(q), Some(d)) =>
      self.call2("openCursor", q.to_js(), d) |> @js.unsafe_cast
    (Some(q), None) => self.call1("openCursor", q.to_js()) |> @js.unsafe_cast
    (None, Some(d)) =>
      self.call2("openCursor", @js.undefined(), d) |> @js.unsafe_cast
    (None, None) => self.call0("openCursor") |> @js.unsafe_cast
  }
}

///|
/// Open a key cursor on this index
pub fn IDBIndex::openKeyCursor(
  self : Self,
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest {
  match (query, direction) {
    (Some(q), Some(d)) =>
      self.call2("openKeyCursor", q.to_js(), d) |> @js.unsafe_cast
    (Some(q), None) => self.call1("openKeyCursor", q.to_js()) |> @js.unsafe_cast
    (None, Some(d)) =>
      self.call2("openKeyCursor", @js.undefined(), d) |> @js.unsafe_cast
    (None, None) => self.call0("openKeyCursor") |> @js.unsafe_cast
  }
}

///| IDBCursor - Cursor for iterating records

///|
/// IDBCursor represents a cursor for iterating over records
#external
pub type IDBCursor

///|
pub impl JsImpl for IDBCursor

///|
/// Get current key
pub fn IDBCursor::key(self : Self) -> Js {
  self.get("key")
}

///|
/// Get primary key
pub fn IDBCursor::primaryKey(self : Self) -> Js {
  self.get("primaryKey")
}

///|
/// Get direction
pub fn IDBCursor::direction(self : Self) -> String {
  @js.unsafe_cast(self.get("direction"))
}

///|
/// Get source
pub fn IDBCursor::source(self : Self) -> Js {
  self.get("source")
}

///|
/// Continue to the next record
pub fn IDBCursor::continue_(self : Self, key? : &JsImpl) -> Unit {
  match key {
    Some(k) => self.call1("continue", k.to_js()) |> ignore
    None => self.call0("continue") |> ignore
  }
}

///|
/// Advance the cursor by count records
pub fn IDBCursor::advance(self : Self, count : Int) -> Unit {
  self.call1("advance", count) |> ignore
}

///|
/// Update the current record
pub fn IDBCursor::update(self : Self, value : &JsImpl) -> IDBRequest {
  self.call1("update", value.to_js()) |> @js.unsafe_cast
}

///|
/// Delete the current record
pub fn IDBCursor::delete_current(self : Self) -> IDBRequest {
  self.call0("delete") |> @js.unsafe_cast
}

///| IDBCursorWithValue - Cursor with current value

///|
/// IDBCursorWithValue extends IDBCursor with value property
#external
pub type IDBCursorWithValue

///|
pub impl JsImpl for IDBCursorWithValue

///|
/// Get current value
pub fn IDBCursorWithValue::value(self : Self) -> Js {
  self.get("value")
}

///|
/// Get current key
pub fn IDBCursorWithValue::key(self : Self) -> Js {
  self.get("key")
}

///|
/// Get primary key
pub fn IDBCursorWithValue::primaryKey(self : Self) -> Js {
  self.get("primaryKey")
}

///|
/// Get direction
pub fn IDBCursorWithValue::direction(self : Self) -> String {
  @js.unsafe_cast(self.get("direction"))
}

///|
/// Get source
pub fn IDBCursorWithValue::source(self : Self) -> Js {
  self.get("source")
}

///|
/// Continue to the next record
pub fn IDBCursorWithValue::continue_(self : Self, key? : &JsImpl) -> Unit {
  match key {
    Some(k) => self.call1("continue", k.to_js()) |> ignore
    None => self.call0("continue") |> ignore
  }
}

///|
/// Advance the cursor by count records
pub fn IDBCursorWithValue::advance(self : Self, count : Int) -> Unit {
  self.call1("advance", count) |> ignore
}

///|
/// Update the current record
pub fn IDBCursorWithValue::update(self : Self, value : &JsImpl) -> IDBRequest {
  self.call1("update", value.to_js()) |> @js.unsafe_cast
}

///|
/// Delete the current record
pub fn IDBCursorWithValue::delete_current(self : Self) -> IDBRequest {
  self.call0("delete") |> @js.unsafe_cast
}

///| IDBKeyRange - Key range for queries

///|
/// IDBKeyRange represents a range of keys
#external
pub type IDBKeyRange

///|
pub impl JsImpl for IDBKeyRange

///|
/// Get lower bound
pub fn IDBKeyRange::lower(self : Self) -> Js {
  self.get("lower")
}

///|
/// Get upper bound
pub fn IDBKeyRange::upper(self : Self) -> Js {
  self.get("upper")
}

///|
/// Get lowerOpen flag
pub fn IDBKeyRange::lowerOpen(self : Self) -> Bool {
  @js.unsafe_cast(self.get("lowerOpen"))
}

///|
/// Get upperOpen flag
pub fn IDBKeyRange::upperOpen(self : Self) -> Bool {
  @js.unsafe_cast(self.get("upperOpen"))
}

///|
/// Create a key range with both bounds
pub fn IDBKeyRange::bound(
  lower : &JsImpl,
  upper : &JsImpl,
  lowerOpen? : Bool,
  upperOpen? : Bool,
) -> IDBKeyRange {
  indexedDB() |> ignore // Ensure fake-indexeddb is loaded
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call("bound", [
    lower.to_js(),
    upper.to_js(),
    lowerOpen.unwrap_or(false),
    upperOpen.unwrap_or(false),
  ])
  |> @js.unsafe_cast
}

///|
/// Create a key range with only one value
pub fn IDBKeyRange::only(value : &JsImpl) -> IDBKeyRange {
  indexedDB() |> ignore // Ensure fake-indexeddb is loaded
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call1("only", value.to_js()) |> @js.unsafe_cast
}

///|
/// Create a key range with lower bound
pub fn IDBKeyRange::lowerBound(lower : &JsImpl, open? : Bool) -> IDBKeyRange {
  indexedDB() |> ignore // Ensure fake-indexeddb is loaded
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call2("lowerBound", lower.to_js(), open.unwrap_or(false))
  |> @js.unsafe_cast
}

///|
/// Create a key range with upper bound
pub fn IDBKeyRange::upperBound(upper : &JsImpl, open? : Bool) -> IDBKeyRange {
  indexedDB() |> ignore // Ensure fake-indexeddb is loaded
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call2("upperBound", upper.to_js(), open.unwrap_or(false))
  |> @js.unsafe_cast
}

///|
/// Check if a key is in this range
pub fn IDBKeyRange::includes(self : Self, key : &JsImpl) -> Bool {
  self.call1("includes", key.to_js()) |> @js.unsafe_cast
}

///| IDBFactory - Factory for opening databases

///|
/// Get the global indexedDB factory
extern "js" fn ffi_require_fake_indexeddb() -> Js =
  #|() => { require("fake-indexeddb/auto"); return globalThis.indexedDB; }

///|
/// Get the indexedDB factory instance
pub fn indexedDB() -> Js {
  ffi_require_fake_indexeddb()
}

///|
/// Open a database connection
pub fn open(name : String, version? : Int) -> IDBOpenDBRequest {
  let idb = indexedDB()
  match version {
    Some(v) => idb.call2("open", name, v) |> @js.unsafe_cast
    None => idb.call1("open", name) |> @js.unsafe_cast
  }
}

///|
/// Delete a database
pub fn deleteDatabase(name : String) -> IDBOpenDBRequest {
  let idb = indexedDB()
  idb.call1("deleteDatabase", name) |> @js.unsafe_cast
}

///|
/// Compare two keys
pub fn cmp(first : &JsImpl, second : &JsImpl) -> Int {
  let idb = indexedDB()
  idb.call2("cmp", first.to_js(), second.to_js()) |> @js.unsafe_cast
}
