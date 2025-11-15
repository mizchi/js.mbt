///|
/// Node.js SQLite module bindings
///
/// This module provides comprehensive bindings for Node.js's native SQLite support.
/// It allows for synchronous SQLite database operations with type-safe wrappers.
///
/// # Example
///
/// ```
/// let db = DatabaseSync::new(":memory:")
/// db.exec("CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT)")
///
/// let stmt = db.prepare("INSERT INTO users (name) VALUES (?)")
/// stmt.run(anonymous_parameters=["Alice"]) |> ignore
///
/// let query = db.prepare("SELECT * FROM users WHERE id = ?")
/// query.get(anonymous_parameters=[1]) |> ignore
/// let results = query.all()
/// ```
///
/// # Features
///
/// - **DatabaseSync**: Main database connection class
///   - Create in-memory or file-based databases
///   - Execute SQL statements
///   - Prepare parameterized statements
///   - Custom functions and aggregates
///   - Session-based changesets for replication
///   - Authorization callbacks
///
/// - **StatementSync**: Prepared statement execution
///   - Named and anonymous parameter binding
///   - Multiple result retrieval methods (get, all, iterate)
///   - Metadata access
///   - BigInt support
///
/// - **Session**: Track database changes
///   - Generate changesets and patchsets
///   - Apply changes to other databases
///
/// # Note
///
/// This module requires Node.js with SQLite support (Node.js 22.5.0+).
/// SQLite is an experimental feature in Node.js.
///
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @iterator {type JsIterator}

///|
using @arraybuffer {type Uint8Array}

///|
#external
pub type DatabaseSync

///|
pub impl Js for DatabaseSync with to_js(self) {
  self |> js
}

///|
pub fn DatabaseSync::new(
  path : String,
  open? : Bool,
  readOnly? : Bool,
  enableForeignKeyConstraints? : Bool,
  allowExtension? : Bool,
  timeout? : Int,
  readBigInts? : Bool,
  returnArrays? : Bool,
  allowBareNamedParameters? : Bool,
  allowUnknownNamedParameters? : Bool,
  defensive? : Bool,
) -> DatabaseSync {
  let opts = @js.new_empty_object()
  if open is Some(v) {
    opts["open"] = v
  }
  if readOnly is Some(v) {
    opts["readOnly"] = v
  }
  if allowExtension is Some(v) {
    opts["allowExtension"] = v
  }
  if enableForeignKeyConstraints is Some(v) {
    opts["enableForeignKeyConstraints"] = v
  }
  if timeout is Some(v) {
    opts["timeout"] = v
  }
  if readBigInts is Some(v) {
    opts["readBigInts"] = v
  }
  if returnArrays is Some(v) {
    opts["returnArrays"] = v
  }
  if allowBareNamedParameters is Some(v) {
    opts["allowBareNamedParameters"] = v
  }
  if allowUnknownNamedParameters is Some(v) {
    opts["allowUnknownNamedParameters"] = v
  }
  if defensive is Some(v) {
    opts["defensive"] = v
  }
  let v = @node.require("node:sqlite").get("DatabaseSync")
    |> @js.new_([path, opts])
  v.cast()
}

///|
pub fn[T, U] DatabaseSync::aggregate(
  self : Self,
  name : String,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
  start? : U,
  step? : (T, U) -> T,
  inverse? : (T, U) -> T,
  result? : (T) -> Val,
) -> Unit {
  let opts = @js.new_empty_object()
  if deterministic is Some(v) {
    opts["deterministic"] = v
  }
  if directOnly is Some(v) {
    opts["directOnly"] = v
  }
  if useBigIntArguments is Some(v) {
    opts["useBigIntArguments"] = v
  }
  if varargs is Some(v) {
    opts["varargs"] = v
  }
  if start is Some(v) {
    opts["start"] = v |> js
  }
  if step is Some(v) {
    opts["step"] = v |> js
  }
  if inverse is Some(v) {
    opts["inverse"] = v |> js
  }
  if result is Some(v) {
    opts["result"] = v |> js
  }
  self.to_js().invoke("aggregate", [name, opts]) |> ignore
}

///|
pub fn DatabaseSync::function(
  self : Self,
  name : String,
  func : (Array[Val]) -> Val,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
) -> Unit {
  let opts = @js.new_empty_object()
  if deterministic is Some(v) {
    opts["deterministic"] = v
  }
  if directOnly is Some(v) {
    opts["directOnly"] = v
  }
  if useBigIntArguments is Some(v) {
    opts["useBigIntArguments"] = v
  }
  if varargs is Some(v) {
    opts["varargs"] = v
  }
  self.to_js().invoke("function", [name, opts, func |> js]) |> ignore
}

///|
#alias(set_authorizer)
pub fn DatabaseSync::setAuthorizer(
  self : Self,
  callback : (Int, String?, String?, String?, String?) -> Int,
) -> Unit {
  self.to_js().invoke("setAuthorizer", [callback |> js]) |> ignore
}

///|
pub fn DatabaseSync::location(self : Self, db_name? : String) -> String? {
  let args : Array[&Js] = if db_name is Some(name) { [name] } else { [] }
  let result = self.to_js().invoke("location", args)
  if result.is_null() {
    None
  } else {
    Some(result.cast())
  }
}

///|
#alias(load_extension)
pub fn DatabaseSync::loadExtension(self : Self, path : String) -> Unit {
  self.to_js().invoke("loadExtension", [path]) |> ignore
}

///|
#alias(enable_load_extension)
pub fn DatabaseSync::enableLoadExtension(self : Self, allow : Bool) -> Unit {
  self.to_js().invoke("enableLoadExtension", [allow]) |> ignore
}

///|
#alias(is_open)
pub fn DatabaseSync::isOpen(self : Self) -> Bool {
  self.to_js().get("isOpen").cast()
}

///|
#alias(is_transaction)
pub fn DatabaseSync::isTransaction(self : Self) -> Bool {
  self.to_js().get("isTransaction").cast()
}

///|
pub fn DatabaseSync::open(self : Self) -> Unit {
  self.to_js().invoke("open", []) |> ignore
}

///|
pub fn DatabaseSync::close(self : Self) -> Unit {
  self.to_js().invoke("close", []) |> ignore
}

///|
#alias(create_tag_store)
pub fn DatabaseSync::createTagStore(
  self : Self,
  max_size? : Int,
) -> SQLTagStore {
  let args : Array[&Js] = if max_size is Some(size) { [size] } else { [] }
  self.invoke("createTagStore", args) |> unsafe_cast
}

///|
#alias(create_session)
pub fn DatabaseSync::createSession(
  self : Self,
  table? : String,
  db? : String,
) -> Session {
  let v = @js.new_empty_object()
  if table is Some(t) {
    v["table"] = t
  }
  if db is Some(d) {
    v["db"] = d
  }
  self.invoke("createSession", [v]) |> unsafe_cast
}

///|
pub fn DatabaseSync::exec(self : Self, query : String) -> Unit {
  self.invoke("exec", [query]) |> unsafe_cast
}

///|
pub fn DatabaseSync::prepare(self : Self, query : String) -> StatementSync {
  self.invoke("prepare", [query]) |> unsafe_cast
}

///|
#alias(apply_changeset)
pub fn DatabaseSync::applyChangeset(
  self : Self,
  changeset : Uint8Array,
  filter? : (Val) -> Bool,
  onConflict? : (Val, Val) -> Bool,
) -> Bool {
  let opts = @js.new_empty_object()
  if filter is Some(f) {
    opts["filter"] = f |> js
  }
  if onConflict is Some(oc) {
    opts["onConflict"] = oc |> js
  }
  self.invoke("applyChangeset", [changeset, opts]) |> unsafe_cast
}

///|
#external
pub type StatementSync

///|
pub impl Js for StatementSync with to_js(self) {
  self |> unsafe_cast
}

///|
pub fn StatementSync::get(
  self : Self,
  named_parameters? : Map[String, &Js],
  anonymous_parameters? : Array[&Js],
) -> Val? {
  let args : Array[&Js] = []
  if named_parameters is Some(params) {
    let obj = @js.new_empty_object()
    for key, value in params {
      obj.set(key, value.to_js())
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  let result = self.to_js().invoke("get", args)
  if result.is_undefined() {
    None
  } else {
    Some(result)
  }
}

///|
pub fn StatementSync::columns(self : Self) -> Array[Val] {
  self.invoke("columns", []) |> unsafe_cast
}

///|
pub fn StatementSync::run(
  self : Self,
  named_parameters? : Map[String, &Js],
  anonymous_parameters? : Array[&Js],
) -> StatementResultingChanges {
  let args : Array[&Js] = []
  if named_parameters is Some(params) {
    let obj = @js.new_empty_object()
    for key, value in params {
      obj.set(key, value.to_js())
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  self.invoke("run", args) |> unsafe_cast
}

///|
pub fn StatementSync::all(
  self : Self,
  named_parameters? : Map[String, &Js],
  anonymous_parameters? : Array[&Js],
) -> Array[Val] {
  let args : Array[&Js] = []
  if named_parameters is Some(params) {
    let obj = @js.new_empty_object()
    for key, value in params {
      obj.set(key, value.to_js())
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  self.invoke("all", args) |> unsafe_cast
}

///|
pub fn StatementSync::iterate(
  self : Self,
  named_parameters? : Map[String, &Js],
  anonymous_parameters? : Array[&Js],
) -> JsIterator[Val] {
  let args : Array[&Js] = []
  if named_parameters is Some(params) {
    let obj = @js.new_empty_object()
    for key, value in params {
      obj.set(key, value.to_js())
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  self.invoke("iterate", args) |> unsafe_cast
}

///|
#alias(expanded_sql)
pub fn StatementSync::expandedSQL(self : Self) -> String {
  self.to_js().get("expandedSQL").cast()
}

///|
#alias(source_sql)
pub fn StatementSync::sourceSQL(self : Self) -> String {
  self.to_js().get("sourceSQL").cast()
}

///|
#alias(set_allow_bare_named_parameters)
pub fn StatementSync::setAllowBareNamedParameters(
  self : Self,
  enabled : Bool,
) -> Unit {
  self.to_js().invoke("setAllowBareNamedParameters", [enabled]) |> ignore
}

///|
#alias(set_allow_unknown_named_parameters)
pub fn StatementSync::setAllowUnknownNamedParameters(
  self : Self,
  enabled : Bool,
) -> Unit {
  self.to_js().invoke("setAllowUnknownNamedParameters", [enabled]) |> ignore
}

///|
#alias(set_return_arrays)
pub fn StatementSync::setReturnArrays(self : Self, enabled : Bool) -> Unit {
  self.to_js().invoke("setReturnArrays", [enabled]) |> ignore
}

///|
#alias(set_read_big_ints)
pub fn StatementSync::setReadBigInts(self : Self, enabled : Bool) -> Unit {
  self.to_js().invoke("setReadBigInts", [enabled]) |> ignore
}

///|
pub(all) struct StatementResultingChanges {
  changes : Int
  lastInsertRowid : Int
} derive(Show)

///|
pub impl Js for StatementResultingChanges with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type Session

///|
pub impl Js for Session with to_js(self) {
  self |> js
}

///|
pub fn Session::changeset(self : Self) -> Uint8Array {
  self.invoke("changeset", []) |> unsafe_cast
}

///|
pub fn Session::patchset(self : Self) -> Uint8Array {
  self.invoke("patchset", []) |> unsafe_cast
}

///|
pub fn Session::close(self : Self) -> Unit {
  self.to_js().invoke("close", []) |> ignore
}

///|
#external
pub type SQLTagStore

///|
pub impl Js for SQLTagStore with to_js(self) {
  self |> js
}

///|
pub fn SQLTagStore::capacity(self : Self) -> Int {
  self.to_js().get("capacity").cast()
}

///|
pub fn SQLTagStore::size(self : Self) -> Int {
  self.invoke("size", []) |> unsafe_cast
}

///|
pub fn SQLTagStore::clear(self : Self) -> Unit {
  self.to_js().invoke("clear", []) |> ignore
}

///|
pub fn SQLTagStore::db(self : Self) -> DatabaseSync {
  self.to_js().get("db").cast()
}

///|
pub(all) struct BackupProgress {
  remainingPages : Int
  totalPages : Int
}

///|
pub fn backup(
  source_db : DatabaseSync,
  db_path : String,
  rate? : Int,
  source? : String,
  target? : String,
  progress? : (BackupProgress) -> Unit,
) -> Unit {
  let opts = @js.new_empty_object()
  if rate is Some(v) {
    opts["rate"] = v
  }
  if source is Some(v) {
    opts["source"] = v
  }
  if target is Some(v) {
    opts["target"] = v
  }
  if progress is Some(f) {
    opts["progress"] = f |> js
  }
  let backup : Val = @node.require("node:sqlite").get("backup")
  backup.invoke_self([source_db.to_js(), db_path, opts]) |> ignore
}

///|
/// SQLite constants accessor
fn get_constants() -> Val {
  let sqlite = @node.require("node:sqlite")
  sqlite.get("constants")
}

///|
pub fn sqlite_changeset_data() -> Int {
  get_constants().get("SQLITE_CHANGESET_DATA").cast()
}

///|
pub fn sqlite_changeset_notfound() -> Int {
  get_constants().get("SQLITE_CHANGESET_NOTFOUND").cast()
}

///|
pub fn sqlite_changeset_conflict() -> Int {
  get_constants().get("SQLITE_CHANGESET_CONFLICT").cast()
}

///|
pub fn sqlite_changeset_foreign_key() -> Int {
  get_constants().get("SQLITE_CHANGESET_FOREIGN_KEY").cast()
}

///|
pub fn sqlite_changeset_omit() -> Int {
  get_constants().get("SQLITE_CHANGESET_OMIT").cast()
}

///|
pub fn sqlite_changeset_replace() -> Int {
  get_constants().get("SQLITE_CHANGESET_REPLACE").cast()
}

///|
pub fn sqlite_changeset_abort() -> Int {
  get_constants().get("SQLITE_CHANGESET_ABORT").cast()
}

///|
pub fn sqlite_deny() -> Int {
  get_constants().get("SQLITE_DENY").cast()
}

///|
pub fn sqlite_ignore() -> Int {
  get_constants().get("SQLITE_IGNORE").cast()
}

///|
pub fn sqlite_ok() -> Int {
  get_constants().get("SQLITE_OK").cast()
}

///|
pub fn sqlite_create_index() -> Int {
  get_constants().get("SQLITE_CREATE_INDEX").cast()
}

///|
pub fn sqlite_create_table() -> Int {
  get_constants().get("SQLITE_CREATE_TABLE").cast()
}

///|
pub fn sqlite_create_temp_index() -> Int {
  get_constants().get("SQLITE_CREATE_TEMP_INDEX").cast()
}

///|
pub fn sqlite_create_temp_table() -> Int {
  get_constants().get("SQLITE_CREATE_TEMP_TABLE").cast()
}

///|
pub fn sqlite_create_temp_trigger() -> Int {
  get_constants().get("SQLITE_CREATE_TEMP_TRIGGER").cast()
}

///|
pub fn sqlite_create_temp_view() -> Int {
  get_constants().get("SQLITE_CREATE_TEMP_VIEW").cast()
}

///|
pub fn sqlite_create_trigger() -> Int {
  get_constants().get("SQLITE_CREATE_TRIGGER").cast()
}

///|
pub fn sqlite_create_view() -> Int {
  get_constants().get("SQLITE_CREATE_VIEW").cast()
}

///|
pub fn sqlite_delete() -> Int {
  get_constants().get("SQLITE_DELETE").cast()
}

///|
pub fn sqlite_drop_index() -> Int {
  get_constants().get("SQLITE_DROP_INDEX").cast()
}

///|
pub fn sqlite_drop_table() -> Int {
  get_constants().get("SQLITE_DROP_TABLE").cast()
}

///|
pub fn sqlite_drop_temp_index() -> Int {
  get_constants().get("SQLITE_DROP_TEMP_INDEX").cast()
}

///|
pub fn sqlite_drop_temp_table() -> Int {
  get_constants().get("SQLITE_DROP_TEMP_TABLE").cast()
}

///|
pub fn sqlite_drop_temp_trigger() -> Int {
  get_constants().get("SQLITE_DROP_TEMP_TRIGGER").cast()
}

///|
pub fn sqlite_drop_temp_view() -> Int {
  get_constants().get("SQLITE_DROP_TEMP_VIEW").cast()
}

///|
pub fn sqlite_drop_trigger() -> Int {
  get_constants().get("SQLITE_DROP_TRIGGER").cast()
}

///|
pub fn sqlite_drop_view() -> Int {
  get_constants().get("SQLITE_DROP_VIEW").cast()
}

///|
pub fn sqlite_insert() -> Int {
  get_constants().get("SQLITE_INSERT").cast()
}

///|
pub fn sqlite_pragma() -> Int {
  get_constants().get("SQLITE_PRAGMA").cast()
}

///|
pub fn sqlite_read() -> Int {
  get_constants().get("SQLITE_READ").cast()
}

///|
pub fn sqlite_select() -> Int {
  get_constants().get("SQLITE_SELECT").cast()
}

///|
pub fn sqlite_transaction() -> Int {
  get_constants().get("SQLITE_TRANSACTION").cast()
}

///|
pub fn sqlite_update() -> Int {
  get_constants().get("SQLITE_UPDATE").cast()
}

///|
pub fn sqlite_attach() -> Int {
  get_constants().get("SQLITE_ATTACH").cast()
}

///|
pub fn sqlite_detach() -> Int {
  get_constants().get("SQLITE_DETACH").cast()
}

///|
pub fn sqlite_alter_table() -> Int {
  get_constants().get("SQLITE_ALTER_TABLE").cast()
}

///|
pub fn sqlite_reindex() -> Int {
  get_constants().get("SQLITE_REINDEX").cast()
}

///|
pub fn sqlite_analyze() -> Int {
  get_constants().get("SQLITE_ANALYZE").cast()
}

///|
pub fn sqlite_create_vtable() -> Int {
  get_constants().get("SQLITE_CREATE_VTABLE").cast()
}

///|
pub fn sqlite_drop_vtable() -> Int {
  get_constants().get("SQLITE_DROP_VTABLE").cast()
}

///|
pub fn sqlite_function() -> Int {
  get_constants().get("SQLITE_FUNCTION").cast()
}

///|
pub fn sqlite_savepoint() -> Int {
  get_constants().get("SQLITE_SAVEPOINT").cast()
}

///|
pub fn sqlite_copy() -> Int {
  get_constants().get("SQLITE_COPY").cast()
}

///|
pub fn sqlite_recursive() -> Int {
  get_constants().get("SQLITE_RECURSIVE").cast()
}
