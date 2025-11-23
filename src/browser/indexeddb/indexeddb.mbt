// https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API
// IndexedDB API bindings for MoonBit

///| IDBRequest - Generic interface for database requests

///|
/// IDBRequest represents an async request to the database
/// T is the type of the result value
pub(all) struct IDBRequest[T] {
  result : T
  error : @js.Nullable[Js]
  source : Js
  readyState : String
}

///|
pub impl[T] JsImpl for IDBRequest[T]

///|
pub impl[T] EventTargetImpl for IDBRequest[T]

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
) -> IDBObjectStore[Js] {
  self.source |> @js.unsafe_cast
}

///|
/// Cast source to IDBIndex
pub fn[T] IDBRequest::source_as_index(self : IDBRequest[T]) -> IDBIndex[Js] {
  self.source |> @js.unsafe_cast
}

///|
/// Cast source to IDBCursor
pub fn[T, U] IDBRequest::source_as_cursor(self : IDBRequest[T]) -> IDBCursor[U] {
  self.source |> @js.unsafe_cast
}

///| IDBOpenDBRequest - Request for opening database

///|
/// IDBOpenDBRequest extends IDBRequest for database opening
pub(all) struct IDBOpenDBRequest {
  result : Js
  error : @js.Nullable[Js]
  source : Js
  readyState : String
}

///|
pub impl JsImpl for IDBOpenDBRequest

///|
pub impl EventTargetImpl for IDBOpenDBRequest

///| IDBDatabase - Database connection

///|
/// IDBDatabase represents a connection to an IndexedDB database
pub(all) struct IDBDatabase {
  name : String
  version : Int
  objectStoreNames : Js
}

///|
pub impl JsImpl for IDBDatabase

///|
/// Create a transaction for the specified object stores
/// mode: "readonly" (default), "readwrite", or "readwriteflush"
pub fn IDBDatabase::transaction(
  self : Self,
  store_names : Array[String],
  mode? : String,
) -> IDBTransaction[Js] {
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
) -> IDBObjectStore[Js] {
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
/// T is the type of values in the object stores accessed by this transaction
pub(all) struct IDBTransaction[T] {
  db : IDBDatabase
  mode : String
  objectStoreNames : Js
}

///|
pub impl[T] JsImpl for IDBTransaction[T]

///|
/// Get an object store from this transaction
pub fn[T] IDBTransaction::objectStore(
  self : IDBTransaction[T],
  name : String,
) -> IDBObjectStore[T] {
  self.call1("objectStore", name) |> @js.unsafe_cast
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
  keyPath : Js
  autoIncrement : Bool
  indexNames : Js
  transaction : IDBTransaction[T]
}

///|
pub impl[T] JsImpl for IDBObjectStore[T]

///|
/// Add a new record (fails if key exists)
pub fn[T] IDBObjectStore::add(
  self : IDBObjectStore[T],
  value : T,
  key? : &JsImpl,
) -> IDBRequest[Js] {
  let js_value : Js = value |> @js.unsafe_cast
  match key {
    Some(k) => self.call2("add", js_value, k.to_js()) |> @js.unsafe_cast
    None => self.call1("add", js_value) |> @js.unsafe_cast
  }
}

///|
/// Put a record (overwrites if key exists)
pub fn[T] IDBObjectStore::put(
  self : IDBObjectStore[T],
  value : T,
  key? : &JsImpl,
) -> IDBRequest[Js] {
  let js_value : Js = value |> @js.unsafe_cast
  match key {
    Some(k) => self.call2("put", js_value, k.to_js()) |> @js.unsafe_cast
    None => self.call1("put", js_value) |> @js.unsafe_cast
  }
}

///|
/// Get a record by key
pub fn[T] IDBObjectStore::get(
  self : IDBObjectStore[T],
  key : &JsImpl,
) -> IDBRequest[T] {
  self.call1("get", key.to_js()) |> @js.unsafe_cast
}

///|
/// Delete a record by key
pub fn[T] IDBObjectStore::delete(
  self : IDBObjectStore[T],
  key : &JsImpl,
) -> IDBRequest[Js] {
  self.call1("delete", key.to_js()) |> @js.unsafe_cast
}

///|
/// Clear all records from the store
pub fn[T] IDBObjectStore::clear(self : IDBObjectStore[T]) -> IDBRequest[Js] {
  self.call0("clear") |> @js.unsafe_cast
}

///|
/// Get all records (optionally filtered by query)
pub fn[T] IDBObjectStore::getAll(
  self : IDBObjectStore[T],
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest[Js] {
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
pub fn[T] IDBObjectStore::getAllKeys(
  self : IDBObjectStore[T],
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest[Js] {
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
pub fn[T] IDBObjectStore::count(
  self : IDBObjectStore[T],
  query? : &JsImpl,
) -> IDBRequest[Js] {
  match query {
    Some(q) => self.call1("count", q.to_js()) |> @js.unsafe_cast
    None => self.call0("count") |> @js.unsafe_cast
  }
}

///|
/// Open a cursor to iterate over records
pub fn[T] IDBObjectStore::openCursor(
  self : IDBObjectStore[T],
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest[Js] {
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
pub fn[T] IDBObjectStore::openKeyCursor(
  self : IDBObjectStore[T],
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest[Js] {
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
pub fn[T] IDBObjectStore::createIndex(
  self : IDBObjectStore[T],
  name : String,
  keyPath : String,
  unique? : Bool,
  multiEntry? : Bool,
) -> IDBIndex[T] {
  let options = @js.from_entries_option([
    ("unique", unique.map(fn(x) { x })),
    ("multiEntry", multiEntry.map(fn(x) { x })),
  ])
  self.call("createIndex", [name, keyPath, options]) |> @js.unsafe_cast
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
  self.call1("index", name) |> @js.unsafe_cast
}

///| IDBIndex - Index for object store

///|
/// IDBIndex represents an index on an object store
/// T is the type of values stored in the associated object store
pub(all) struct IDBIndex[T] {
  name : String
  objectStore : IDBObjectStore[T]
  keyPath : Js
  multiEntry : Bool
  unique : Bool
}

///|
pub impl[T] JsImpl for IDBIndex[T]

///|
/// Get a record by index key
pub fn[T] IDBIndex::get(self : IDBIndex[T], key : &JsImpl) -> IDBRequest[T] {
  self.call1("get", key.to_js()) |> @js.unsafe_cast
}

///|
/// Get all records matching the query
pub fn[T] IDBIndex::getAll(
  self : IDBIndex[T],
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest[Js] {
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
pub fn[T] IDBIndex::getAllKeys(
  self : IDBIndex[T],
  query? : &JsImpl,
  count? : Int,
) -> IDBRequest[Js] {
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
pub fn[T] IDBIndex::count(
  self : IDBIndex[T],
  query? : &JsImpl,
) -> IDBRequest[Js] {
  match query {
    Some(q) => self.call1("count", q.to_js()) |> @js.unsafe_cast
    None => self.call0("count") |> @js.unsafe_cast
  }
}

///|
/// Open a cursor on this index
pub fn[T] IDBIndex::openCursor(
  self : IDBIndex[T],
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest[Js] {
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
pub fn[T] IDBIndex::openKeyCursor(
  self : IDBIndex[T],
  query? : &JsImpl,
  direction? : String,
) -> IDBRequest[Js] {
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
pub(all) struct IDBCursor[T] {
  key : Js
  primaryKey : Js
  direction : String
  source : Js
}

///|
pub impl[T] JsImpl for IDBCursor[T]

///|
/// Continue to the next record
pub fn[T] IDBCursor::continue_(self : IDBCursor[T], key? : &JsImpl) -> Unit {
  match key {
    Some(k) => self.call1("continue", k.to_js()) |> ignore
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
pub fn[T] IDBCursor::update(self : IDBCursor[T], value : T) -> IDBRequest[Js] {
  let js_value : Js = value |> @js.unsafe_cast
  self.call1("update", js_value) |> @js.unsafe_cast
}

///|
/// Delete the current record
pub fn[T] IDBCursor::delete_current(self : IDBCursor[T]) -> IDBRequest[Js] {
  self.call0("delete") |> @js.unsafe_cast
}

///| IDBCursorWithValue - Cursor with current value

///|
/// IDBCursorWithValue extends IDBCursor with value property
/// T is the type of values in the object store
pub(all) struct IDBCursorWithValue[T] {
  key : Js
  primaryKey : Js
  direction : String
  source : Js
  value : T
}

///|
pub impl[T] JsImpl for IDBCursorWithValue[T]

///|
/// Continue to the next record
pub fn[T] IDBCursorWithValue::continue_(
  self : IDBCursorWithValue[T],
  key? : &JsImpl,
) -> Unit {
  match key {
    Some(k) => self.call1("continue", k.to_js()) |> ignore
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
) -> IDBRequest[Js] {
  let js_value : Js = value |> @js.unsafe_cast
  self.call1("update", js_value) |> @js.unsafe_cast
}

///|
/// Delete the current record
pub fn[T] IDBCursorWithValue::delete_current(
  self : IDBCursorWithValue[T],
) -> IDBRequest[Js] {
  self.call0("delete") |> @js.unsafe_cast
}

///| IDBKeyRange - Key range for queries

///|
/// IDBKeyRange represents a range of keys
pub(all) struct IDBKeyRange {
  lower : Js
  upper : Js
  lowerOpen : Bool
  upperOpen : Bool
}

///|
pub impl JsImpl for IDBKeyRange

///|
/// Create a key range with both bounds
pub fn IDBKeyRange::bound(
  lower : &JsImpl,
  upper : &JsImpl,
  lowerOpen? : Bool,
  upperOpen? : Bool,
) -> IDBKeyRange {
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
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call1("only", value.to_js()) |> @js.unsafe_cast
}

///|
/// Create a key range with lower bound
pub fn IDBKeyRange::lowerBound(lower : &JsImpl, open? : Bool) -> IDBKeyRange {
  let global = @js.globalThis()
  let idb_key_range = global.get("IDBKeyRange")
  idb_key_range.call2("lowerBound", lower.to_js(), open.unwrap_or(false))
  |> @js.unsafe_cast
}

///|
/// Create a key range with upper bound
pub fn IDBKeyRange::upperBound(upper : &JsImpl, open? : Bool) -> IDBKeyRange {
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
/// Get the indexedDB factory instance from globalThis
pub fn indexedDB() -> Js {
  @js.globalThis().get("indexedDB")
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
