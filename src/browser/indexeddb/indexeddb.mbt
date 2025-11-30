// https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API
// IndexedDB API bindings for MoonBit

///| IDBRequest - Generic interface for database requests

///|
/// IDBRequest represents an async request to the database
/// T is the type of the result value
pub(all) struct IDBRequest[T] {
  result : T
  error : @js.Nullable[@js.Any]
  source : @js.Any
  readyState : String
}

///|
pub fn[T] IDBRequest::as_any(self : IDBRequest[T]) -> @nostd.Any = "%identity"

///|
pub fn[T] IDBRequest::as_event_target(
  self : IDBRequest[T],
) -> @event.EventTarget = "%identity"

///|
pub impl[T] @js.JsImpl for IDBRequest[T]

///|
pub impl[T] @event.EventTargetImpl for IDBRequest[T]

///|
/// Check if request is pending
pub fn[T] IDBRequest::is_pending(self : IDBRequest[T]) -> Bool {
  self.readyState == "pending"
}

///|
/// Check if request is done
pub fn[T] IDBRequest::is_done(self : IDBRequest[T]) -> Bool {
  self.readyState == "done"
}

///|
/// Cast source to IDBObjectStore
pub fn[T] IDBRequest::source_as_object_store(
  self : IDBRequest[T],
) -> IDBObjectStore[@js.Any] {
  self.source |> @js.identity
}

///|
/// Cast source to IDBIndex
pub fn[T] IDBRequest::source_as_index(
  self : IDBRequest[T],
) -> IDBIndex[@js.Any] {
  self.source |> @js.identity
}

///|
/// Cast source to IDBCursor
pub fn[T, U] IDBRequest::source_as_cursor(self : IDBRequest[T]) -> IDBCursor[U] {
  self.source |> @js.identity
}

///| IDBOpenDBRequest - Request for opening database

///|
/// IDBOpenDBRequest extends IDBRequest for database opening
pub(all) struct IDBOpenDBRequest {
  result : @js.Any
  error : @js.Nullable[@js.Any]
  source : @js.Any
  readyState : String
}

///|
pub fn IDBOpenDBRequest::as_any(self : IDBOpenDBRequest) -> @nostd.Any = "%identity"

///|
pub fn IDBOpenDBRequest::as_event_target(
  self : IDBOpenDBRequest,
) -> @event.EventTarget = "%identity"

///|
pub impl @js.JsImpl for IDBOpenDBRequest

///|
pub impl @event.EventTargetImpl for IDBOpenDBRequest

///| IDBDatabase - Database connection

///|
/// IDBDatabase represents a connection to an IndexedDB database
pub(all) struct IDBDatabase {
  name : String
  version : Int
  objectStoreNames : @js.Any
}

///|
pub fn IDBDatabase::as_any(self : IDBDatabase) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for IDBDatabase

///|
/// Create a transaction for the specified object stores
/// mode: "readonly" (default), "readwrite", or "readwriteflush"
pub fn IDBDatabase::transaction(
  self : Self,
  store_names : Array[String],
  mode? : String,
) -> IDBTransaction[@js.Any] {
  let mode_str = mode.unwrap_or("readonly")
  self.call2("transaction", @js.from_array(store_names), mode_str).cast()
}

///|
/// Create a new object store (only in versionchange transaction)
pub fn IDBDatabase::createObjectStore(
  self : Self,
  name : String,
  keyPath? : String,
  autoIncrement? : Bool,
) -> IDBObjectStore[@js.Any] {
  let options = @js.from_option_map({
    "keyPath": keyPath.map(fn(x) { @js.any(x) }),
    "autoIncrement": autoIncrement.map(fn(x) { @js.any(x) }),
  })
  self.call2("createObjectStore", name, options).cast()
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
/// T is the type of values in the object stores accessed by this transaction
pub(all) struct IDBTransaction[T] {
  db : IDBDatabase
  mode : String
  objectStoreNames : @js.Any
}

///|
pub fn[T] IDBTransaction::as_any(self : IDBTransaction[T]) -> @nostd.Any = "%identity"

///|
pub impl[T] @js.JsImpl for IDBTransaction[T]

///|
/// Get an object store from this transaction
pub fn[T] IDBTransaction::objectStore(
  self : IDBTransaction[T],
  name : String,
) -> IDBObjectStore[T] {
  self.call1("objectStore", name).cast()
}

///|
/// Commit the transaction
pub fn[T] IDBTransaction::commit(self : IDBTransaction[T]) -> Unit {
  self.call0("commit") |> ignore
}

///|
/// Abort the transaction
pub fn[T] IDBTransaction::abort(self : IDBTransaction[T]) -> Unit {
  self.call0("abort") |> ignore
}

///| IDBObjectStore - Object store for data

///|
/// IDBObjectStore represents an object store in the database
/// T is the type of values stored in this object store
pub(all) struct IDBObjectStore[T] {
  name : String
  keyPath : @js.Any
  autoIncrement : Bool
  indexNames : @js.Any
  transaction : IDBTransaction[T]
}

///|
pub fn[T] IDBObjectStore::as_any(self : IDBObjectStore[T]) -> @nostd.Any = "%identity"

///|
pub impl[T] @js.JsImpl for IDBObjectStore[T]

///|
/// Add a new record (fails if key exists)
pub fn[T] IDBObjectStore::add(
  self : IDBObjectStore[T],
  value : T,
  key? : &@js.JsImpl,
) -> IDBRequest[@js.Any] {
  let js_value : @js.Any = value |> @js.identity
  match key {
    Some(k) => self.call2("add", js_value, k.as_any()).cast()
    None => self.call1("add", js_value).cast()
  }
}

///|
/// Put a record (overwrites if key exists)
pub fn[T] IDBObjectStore::put(
  self : IDBObjectStore[T],
  value : T,
  key? : &@js.JsImpl,
) -> IDBRequest[@js.Any] {
  let js_value : @js.Any = value |> @js.identity
  match key {
    Some(k) => self.call2("put", js_value, k.as_any()).cast()
    None => self.call1("put", js_value).cast()
  }
}

///|
/// Get a record by key
pub fn[T] IDBObjectStore::get(
  self : IDBObjectStore[T],
  key : &@js.JsImpl,
) -> IDBRequest[T] {
  self.call1("get", key.as_any()).cast()
}

///|
/// Delete a record by key
pub fn[T] IDBObjectStore::delete(
  self : IDBObjectStore[T],
  key : &@js.JsImpl,
) -> IDBRequest[@js.Any] {
  self.call1("delete", key.as_any()).cast()
}

///|
/// Clear all records from the store
pub fn[T] IDBObjectStore::clear(
  self : IDBObjectStore[T],
) -> IDBRequest[@js.Any] {
  self.call0("clear").cast()
}

///|
/// Get all records (optionally filtered by query)
pub fn[T] IDBObjectStore::getAll(
  self : IDBObjectStore[T],
  query? : &@js.JsImpl,
  count? : Int,
) -> IDBRequest[@js.Any] {
  match (query, count) {
    (Some(q), Some(c)) => self.call2("getAll", q.as_any(), c).cast()
    (Some(q), None) => self.call1("getAll", q.as_any()).cast()
    (None, Some(c)) => self.call2("getAll", @js.undefined(), c).cast()
    (None, None) => self.call0("getAll").cast()
  }
}

///|
/// Get all keys (optionally filtered by query)
pub fn[T] IDBObjectStore::getAllKeys(
  self : IDBObjectStore[T],
  query? : &@js.JsImpl,
  count? : Int,
) -> IDBRequest[@js.Any] {
  match (query, count) {
    (Some(q), Some(c)) => self.call2("getAllKeys", q.as_any(), c).cast()
    (Some(q), None) => self.call1("getAllKeys", q.as_any()).cast()
    (None, Some(c)) => self.call2("getAllKeys", @js.undefined(), c).cast()
    (None, None) => self.call0("getAllKeys").cast()
  }
}

///|
/// Count records (optionally filtered by query)
pub fn[T] IDBObjectStore::count(
  self : IDBObjectStore[T],
  query? : &@js.JsImpl,
) -> IDBRequest[@js.Any] {
  match query {
    Some(q) => self.call1("count", q.as_any()).cast()
    None => self.call0("count").cast()
  }
}

///|
/// Open a cursor to iterate over records
pub fn[T] IDBObjectStore::openCursor(
  self : IDBObjectStore[T],
  query? : &@js.JsImpl,
  direction? : String,
) -> IDBRequest[@js.Any] {
  match (query, direction) {
    (Some(q), Some(d)) => self.call2("openCursor", q.as_any(), d).cast()
    (Some(q), None) => self.call1("openCursor", q.as_any()).cast()
    (None, Some(d)) => self.call2("openCursor", @js.undefined(), d).cast()
    (None, None) => self.call0("openCursor").cast()
  }
}

///|
/// Open a key cursor
pub fn[T] IDBObjectStore::openKeyCursor(
  self : IDBObjectStore[T],
  query? : &@js.JsImpl,
  direction? : String,
) -> IDBRequest[@js.Any] {
  match (query, direction) {
    (Some(q), Some(d)) => self.call2("openKeyCursor", q.as_any(), d).cast()
    (Some(q), None) => self.call1("openKeyCursor", q.as_any()).cast()
    (None, Some(d)) => self.call2("openKeyCursor", @js.undefined(), d).cast()
    (None, None) => self.call0("openKeyCursor").cast()
  }
}

///|
/// Create an index on this object store
pub fn[T] IDBObjectStore::createIndex(
  self : IDBObjectStore[T],
  name : String,
  keyPath : String,
  unique? : Bool,
  multiEntry? : Bool,
) -> IDBIndex[T] {
  let options = @js.from_option_map({
    "unique": unique.map(fn(x) { @js.any(x) }),
    "multiEntry": multiEntry.map(fn(x) { @js.any(x) }),
  })
  self.call("createIndex", [name, keyPath, options]).cast()
}

///|
/// Delete an index from this object store
pub fn[T] IDBObjectStore::deleteIndex(
  self : IDBObjectStore[T],
  name : String,
) -> Unit {
  self.call1("deleteIndex", name) |> ignore
}

///|
/// Get an index by name
pub fn[T] IDBObjectStore::index(
  self : IDBObjectStore[T],
  name : String,
) -> IDBIndex[T] {
  self.call1("index", name).cast()
}

///| IDBIndex - Index for object store

///|
/// IDBIndex represents an index on an object store
/// T is the type of values stored in the associated object store
pub(all) struct IDBIndex[T] {
  name : String
  objectStore : IDBObjectStore[T]
  keyPath : @js.Any
  multiEntry : Bool
  unique : Bool
}

///|
pub fn[T] IDBIndex::as_any(self : IDBIndex[T]) -> @nostd.Any = "%identity"

///|
pub impl[T] @js.JsImpl for IDBIndex[T]

///|
/// Get a record by index key
pub fn[T] IDBIndex::get(self : IDBIndex[T], key : &@js.JsImpl) -> IDBRequest[T] {
  self.call1("get", key.as_any()) |> @js.identity
}

///|
/// Get all records matching the query
pub fn[T] IDBIndex::getAll(
  self : IDBIndex[T],
  query? : &@js.JsImpl,
  count? : Int,
) -> IDBRequest[@js.Any] {
  match (query, count) {
    (Some(q), Some(c)) => self.call2("getAll", q.as_any(), c).cast()
    (Some(q), None) => self.call1("getAll", q.as_any()).cast()
    (None, Some(c)) => self.call2("getAll", @js.undefined(), c).cast()
    (None, None) => self.call0("getAll").cast()
  }
}

///|
/// Get all keys matching the query
pub fn[T] IDBIndex::getAllKeys(
  self : IDBIndex[T],
  query? : &@js.JsImpl,
  count? : Int,
) -> IDBRequest[@js.Any] {
  match (query, count) {
    (Some(q), Some(c)) => self.call2("getAllKeys", q.as_any(), c).cast()
    (Some(q), None) => self.call1("getAllKeys", q.as_any()).cast()
    (None, Some(c)) => self.call2("getAllKeys", @js.undefined(), c).cast()
    (None, None) => self.call0("getAllKeys").cast()
  }
}

///|
/// Count records matching the query
pub fn[T] IDBIndex::count(
  self : IDBIndex[T],
  query? : &@js.JsImpl,
) -> IDBRequest[@js.Any] {
  match query {
    Some(q) => self.call1("count", q.as_any()).cast()
    None => self.call0("count").cast()
  }
}

///|
/// Open a cursor on this index
pub fn[T] IDBIndex::openCursor(
  self : IDBIndex[T],
  query? : &@js.JsImpl,
  direction? : String,
) -> IDBRequest[@js.Any] {
  match (query, direction) {
    (Some(q), Some(d)) => self.call2("openCursor", q.as_any(), d).cast()
    (Some(q), None) => self.call1("openCursor", q.as_any()).cast()
    (None, Some(d)) => self.call2("openCursor", @js.undefined(), d).cast()
    (None, None) => self.call0("openCursor").cast()
  }
}

///|
/// Open a key cursor on this index
pub fn[T] IDBIndex::openKeyCursor(
  self : IDBIndex[T],
  query? : &@js.JsImpl,
  direction? : String,
) -> IDBRequest[@js.Any] {
  match (query, direction) {
    (Some(q), Some(d)) => self.call2("openKeyCursor", q.as_any(), d).cast()
    (Some(q), None) => self.call1("openKeyCursor", q.as_any()).cast()
    (None, Some(d)) => self.call2("openKeyCursor", @js.undefined(), d).cast()
    (None, None) => self.call0("openKeyCursor").cast()
  }
}

///| IDBCursor - Cursor for iterating records

///|
/// IDBCursor represents a cursor for iterating over records
pub(all) struct IDBCursor[T] {
  key : @js.Any
  primaryKey : @js.Any
  direction : String
  source : @js.Any
}

///|
pub fn[T] IDBCursor::as_any(self : IDBCursor[T]) -> @nostd.Any = "%identity"

///|
pub impl[T] @js.JsImpl for IDBCursor[T]

///|
/// Continue to the next record
pub fn[T] IDBCursor::continue_(self : IDBCursor[T], key? : &@js.JsImpl) -> Unit {
  match key {
    Some(k) => self.call1("continue", k.as_any()) |> ignore
    None => self.call0("continue") |> ignore
  }
}

///|
/// Advance the cursor by count records
pub fn[T] IDBCursor::advance(self : IDBCursor[T], count : Int) -> Unit {
  self.call1("advance", count) |> ignore
}

///|
/// Update the current record
pub fn[T] IDBCursor::update(
  self : IDBCursor[T],
  value : T,
) -> IDBRequest[@js.Any] {
  let js_value : @js.Any = value |> @js.identity
  self.call1("update", js_value).cast()
}

///|
/// Delete the current record
pub fn[T] IDBCursor::delete_current(self : IDBCursor[T]) -> IDBRequest[@js.Any] {
  self.call0("delete").cast()
}

///| IDBCursorWithValue - Cursor with current value

///|
/// IDBCursorWithValue extends IDBCursor with value property
/// T is the type of values in the object store
pub(all) struct IDBCursorWithValue[T] {
  key : @js.Any
  primaryKey : @js.Any
  direction : String
  source : @js.Any
  value : T
}

///|
pub fn[T] IDBCursorWithValue::as_any(
  self : IDBCursorWithValue[T],
) -> @nostd.Any = "%identity"

///|
pub impl[T] @js.JsImpl for IDBCursorWithValue[T]

///|
/// Continue to the next record
pub fn[T] IDBCursorWithValue::continue_(
  self : IDBCursorWithValue[T],
  key? : &@js.JsImpl,
) -> Unit {
  match key {
    Some(k) => self.call1("continue", k.as_any()) |> ignore
    None => self.call0("continue") |> ignore
  }
}

///|
/// Advance the cursor by count records
pub fn[T] IDBCursorWithValue::advance(
  self : IDBCursorWithValue[T],
  count : Int,
) -> Unit {
  self.call1("advance", count) |> ignore
}

///|
/// Update the current record
pub fn[T] IDBCursorWithValue::update(
  self : IDBCursorWithValue[T],
  value : T,
) -> IDBRequest[@js.Any] {
  let js_value : @js.Any = value |> @js.identity
  self.call1("update", js_value).cast()
}

///|
/// Delete the current record
pub fn[T] IDBCursorWithValue::delete_current(
  self : IDBCursorWithValue[T],
) -> IDBRequest[@js.Any] {
  self.call0("delete").cast()
}

///| IDBKeyRange - Key range for queries

///|
/// IDBKeyRange represents a range of keys
pub(all) struct IDBKeyRange {
  lower : @js.Any
  upper : @js.Any
  lowerOpen : Bool
  upperOpen : Bool
}

///|
pub fn IDBKeyRange::as_any(self : IDBKeyRange) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for IDBKeyRange

///|
/// Create a key range with both bounds
pub fn IDBKeyRange::bound(
  lower : &@js.JsImpl,
  upper : &@js.JsImpl,
  lowerOpen? : Bool,
  upperOpen? : Bool,
) -> IDBKeyRange {
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call("bound", [
    lower.as_any(),
    upper.as_any(),
    lowerOpen.unwrap_or(false),
    upperOpen.unwrap_or(false),
  ])
  |> @js.identity
}

///|
/// Create a key range with only one value
pub fn IDBKeyRange::only(value : &@js.JsImpl) -> IDBKeyRange {
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call1("only", value.as_any()).cast()
}

///|
/// Create a key range with lower bound
pub fn IDBKeyRange::lowerBound(
  lower : &@js.JsImpl,
  open? : Bool,
) -> IDBKeyRange {
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call2("lowerBound", lower.as_any(), open.unwrap_or(false))
  |> @js.identity
}

///|
/// Create a key range with upper bound
pub fn IDBKeyRange::upperBound(
  upper : &@js.JsImpl,
  open? : Bool,
) -> IDBKeyRange {
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range
  .call2("upperBound", upper.as_any(), open.unwrap_or(false))
  .cast()
}

///|
/// Check if a key is in this range
pub fn IDBKeyRange::includes(self : Self, key : &@js.JsImpl) -> Bool {
  self.call1("includes", key.as_any()).cast()
}

///| IDBFactory - Factory for opening databases

///|
/// Get the indexedDB factory instance from globalThis
pub fn indexedDB() -> @js.Any {
  @js.globalThis().get("indexedDB")
}

///|
/// Open a database connection
pub fn open(name : String, version? : Int) -> IDBOpenDBRequest {
  let idb = indexedDB()
  match version {
    Some(v) => idb.call2("open", name, v).cast()
    None => idb.call1("open", name).cast()
  }
}

///|
/// Delete a database
pub fn deleteDatabase(name : String) -> IDBOpenDBRequest {
  let idb = indexedDB()
  idb.call1("deleteDatabase", name).cast()
}

///|
/// Compare two keys
pub fn cmp(first : &@js.JsImpl, second : &@js.JsImpl) -> Int {
  let idb = indexedDB()
  idb.call2("cmp", first.as_any(), second.as_any()).cast()
}
