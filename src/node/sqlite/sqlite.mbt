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
/// query.get_(anonymous_parameters=[1]) |> ignore
/// let _results = query.all()
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
#external
pub type DatabaseSync

///|
pub impl JsImpl for DatabaseSync

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
  let opts = @js.from_entries_option([
    ("open", open.map(x => x)),
    ("readOnly", readOnly.map(x => x)),
    ("allowExtension", allowExtension.map(x => x)),
    ("enableForeignKeyConstraints", enableForeignKeyConstraints.map(x => x)),
    ("timeout", timeout.map(x => x)),
    ("readBigInts", readBigInts.map(x => x)),
    ("returnArrays", returnArrays.map(x => x)),
    ("allowBareNamedParameters", allowBareNamedParameters.map(x => x)),
    ("allowUnknownNamedParameters", allowUnknownNamedParameters.map(x => x)),
    ("defensive", defensive.map(x => x)),
  ])
  let v = @node.require("node:sqlite").get("DatabaseSync")
    |> @js.new_([path, opts])
  unsafe_cast(v)
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
  result? : (T) -> Js,
) -> Unit {
  let opts = @js.from_entries_option([
    ("deterministic", deterministic.map(x => x)),
    ("directOnly", directOnly.map(x => x)),
    ("useBigIntArguments", useBigIntArguments.map(x => x)),
    ("varargs", varargs.map(x => x)),
    ("start", start.map(fn(x) { x |> @js.unsafe_js })),
    ("step", step.map(fn(x) { x |> @js.unsafe_js })),
    ("inverse", inverse.map(fn(x) { x |> @js.unsafe_js })),
    ("result", result.map(fn(x) { x |> @js.unsafe_js })),
  ])
  self.call2("aggregate", name, opts) |> ignore
}

///|
pub fn DatabaseSync::function(
  self : Self,
  name : String,
  func : (Array[Js]) -> Js,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
) -> Unit {
  let opts = @js.from_entries_option_cast([
    ("deterministic", deterministic),
    ("directOnly", directOnly),
    ("useBigIntArguments", useBigIntArguments),
    ("varargs", varargs),
  ])
  self.call("function", [name, func |> unsafe_cast, opts]) |> ignore
}

///|
#alias(set_authorizer)
pub fn DatabaseSync::setAuthorizer(
  self : Self,
  callback : (Int, String?, String?, String?, String?) -> Int,
) -> Unit {
  self.call("setAuthorizer", [callback |> @js.unsafe_js]) |> ignore
}

///|
pub fn DatabaseSync::location(self : Self, db_name? : String) -> String? {
  let args : Array[&JsImpl] = if db_name is Some(name) { [name] } else { [] }
  let result = self.call("location", args)
  if @js.is_null(result) {
    None
  } else {
    Some(unsafe_cast(result))
  }
}

///|
#alias(load_extension)
pub fn DatabaseSync::loadExtension(self : Self, path : String) -> Unit {
  self.call("loadExtension", [path]) |> ignore
}

///|
#alias(enable_load_extension)
pub fn DatabaseSync::enableLoadExtension(self : Self, allow : Bool) -> Unit {
  self.call("enableLoadExtension", [allow]) |> ignore
}

///|
#alias(is_open)
pub fn DatabaseSync::isOpen(self : Self) -> Bool {
  self.get("isOpen") |> unsafe_cast
}

///|
#alias(is_transaction)
pub fn DatabaseSync::isTransaction(self : Self) -> Bool {
  self.get("isTransaction") |> unsafe_cast
}

///|
pub fn DatabaseSync::open(self : Self) -> Unit {
  self.call0("open") |> ignore
}

///|
pub fn DatabaseSync::close(self : Self) -> Unit {
  self.call0("close") |> ignore
}

///|
#alias(create_tag_store)
pub fn DatabaseSync::createTagStore(
  self : Self,
  max_size? : Int,
) -> SQLTagStore {
  let args : Array[&JsImpl] = if max_size is Some(size) { [size] } else { [] }
  self.call("createTagStore", args) |> unsafe_cast
}

///|
#alias(create_session)
pub fn DatabaseSync::createSession(
  self : Self,
  table? : String,
  db? : String,
) -> Session {
  let v = @js.from_entries_option_cast([("table", table), ("db", db)])
  self.call("createSession", [v]) |> unsafe_cast
}

///|
pub fn DatabaseSync::exec(self : Self, query : String) -> Unit {
  self.call("exec", [query]) |> unsafe_cast
}

///|
pub fn DatabaseSync::prepare(self : Self, query : String) -> StatementSync {
  self.call("prepare", [query]) |> unsafe_cast
}

///|
#alias(apply_changeset)
pub fn DatabaseSync::applyChangeset(
  self : Self,
  changeset : Uint8Array,
  filter? : (Js) -> Bool,
  onConflict? : (Js?, Js) -> Bool,
) -> Bool {
  let opts = @js.from_entries_option_cast([
    ("filter", filter.map(fn(f) { f |> @js.from_fn1 })),
    ("onConflict", onConflict.map(fn(oc) { oc |> @js.from_fn2 })),
  ])
  self.call2("applyChangeset", changeset, opts) |> unsafe_cast
}

///|
#external
pub type StatementSync

///|
pub impl JsImpl for StatementSync with to_js(self) {
  self |> unsafe_cast
}

///|
pub fn StatementSync::get_(
  self : Self,
  named_parameters? : Map[String, &JsImpl],
  anonymous_parameters? : Array[&JsImpl],
) -> Js? {
  let args : Array[&JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
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
  let result = self.call("get", args)
  if @js.is_undefined(result) {
    None
  } else {
    Some(result)
  }
}

///|
pub fn StatementSync::columns(self : Self) -> Array[Js] {
  self.call0("columns") |> unsafe_cast
}

///|
pub fn StatementSync::run(
  self : Self,
  named_parameters? : Map[String, &JsImpl],
  anonymous_parameters? : Array[&JsImpl],
) -> StatementResultingChanges {
  let args : Array[&JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
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
  self.call("run", args) |> unsafe_cast
}

///|
pub fn StatementSync::all(
  self : Self,
  named_parameters? : Map[String, &JsImpl],
  anonymous_parameters? : Array[&JsImpl],
) -> Array[Js] {
  let args : Array[&JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
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
  self.call("all", args) |> unsafe_cast
}

///|
pub fn StatementSync::iterate(
  self : Self,
  named_parameters? : Map[String, &JsImpl],
  anonymous_parameters? : Array[&JsImpl],
) -> JsIterator[Js] {
  let args : Array[&JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
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
  self.call("iterate", args) |> unsafe_cast
}

///|
#alias(expanded_sql)
pub fn StatementSync::expandedSQL(self : Self) -> String {
  self.get("expandedSQL") |> unsafe_cast
}

///|
#alias(source_sql)
pub fn StatementSync::sourceSQL(self : Self) -> String {
  self.get("sourceSQL") |> unsafe_cast
}

///|
#alias(set_allow_bare_named_parameters)
pub fn StatementSync::setAllowBareNamedParameters(
  self : Self,
  enabled : Bool,
) -> Unit {
  self.call("setAllowBareNamedParameters", [enabled]) |> ignore
}

///|
#alias(set_allow_unknown_named_parameters)
pub fn StatementSync::setAllowUnknownNamedParameters(
  self : Self,
  enabled : Bool,
) -> Unit {
  self.call("setAllowUnknownNamedParameters", [enabled]) |> ignore
}

///|
#alias(set_return_arrays)
pub fn StatementSync::setReturnArrays(self : Self, enabled : Bool) -> Unit {
  self.call("setReturnArrays", [enabled]) |> ignore
}

///|
#alias(set_read_big_ints)
pub fn StatementSync::setReadBigInts(self : Self, enabled : Bool) -> Unit {
  self.call("setReadBigInts", [enabled]) |> ignore
}

///|
pub(all) struct StatementResultingChanges {
  changes : Int
  lastInsertRowid : Int
} derive(Show)

///|
pub impl JsImpl for StatementResultingChanges

///|
#external
pub type Session

///|
pub impl JsImpl for Session

///|
pub fn Session::changeset(self : Self) -> Uint8Array {
  self.call0("changeset") |> unsafe_cast
}

///|
pub fn Session::patchset(self : Self) -> Uint8Array {
  self.call0("patchset") |> unsafe_cast
}

///|
pub fn Session::close(self : Self) -> Unit {
  self.call0("close") |> ignore
}

///|
#external
pub type SQLTagStore

///|
pub impl JsImpl for SQLTagStore

///|
pub fn SQLTagStore::capacity(self : Self) -> Int {
  self.get("capacity") |> unsafe_cast
}

///|
pub fn SQLTagStore::size(self : Self) -> Int {
  self.call0("size") |> unsafe_cast
}

///|
pub fn SQLTagStore::clear(self : Self) -> Unit {
  self.call0("clear") |> ignore
}

///|
pub fn SQLTagStore::db(self : Self) -> DatabaseSync {
  self.get("db") |> unsafe_cast
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
  let opts = @js.Object::new()
  if rate is Some(v) {
    opts.set("rate", v)
  }
  if source is Some(v) {
    opts.set("source", v)
  }
  if target is Some(v) {
    opts.set("target", v)
  }
  if progress is Some(f) {
    opts.set("progress", f |> @js.from_fn1)
  }
  let backup : Js = @node.require("node:sqlite").get("backup")
  backup.call_self([source_db.to_js(), db_path, opts]) |> ignore
}

///|
/// SQLite constants accessor
fn get_constants() -> Js {
  let sqlite = @node.require("node:sqlite")
  sqlite.get("constants")
}

///|
pub fn sqlite_changeset_data() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CHANGESET_DATA"))
}

///|
pub fn sqlite_changeset_notfound() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CHANGESET_NOTFOUND"))
}

///|
pub fn sqlite_changeset_conflict() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CHANGESET_CONFLICT"))
}

///|
pub fn sqlite_changeset_foreign_key() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CHANGESET_FOREIGN_KEY"))
}

///|
pub fn sqlite_changeset_omit() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CHANGESET_OMIT"))
}

///|
pub fn sqlite_changeset_replace() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CHANGESET_REPLACE"))
}

///|
pub fn sqlite_changeset_abort() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CHANGESET_ABORT"))
}

///|
pub fn sqlite_deny() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DENY"))
}

///|
pub fn sqlite_ignore() -> Int {
  unsafe_cast(get_constants().get("SQLITE_IGNORE"))
}

///|
pub fn sqlite_ok() -> Int {
  unsafe_cast(get_constants().get("SQLITE_OK"))
}

///|
pub fn sqlite_create_index() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_INDEX"))
}

///|
pub fn sqlite_create_table() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_TABLE"))
}

///|
pub fn sqlite_create_temp_index() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_TEMP_INDEX"))
}

///|
pub fn sqlite_create_temp_table() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_TEMP_TABLE"))
}

///|
pub fn sqlite_create_temp_trigger() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_TEMP_TRIGGER"))
}

///|
pub fn sqlite_create_temp_view() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_TEMP_VIEW"))
}

///|
pub fn sqlite_create_trigger() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_TRIGGER"))
}

///|
pub fn sqlite_create_view() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_VIEW"))
}

///|
pub fn sqlite_delete() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DELETE"))
}

///|
pub fn sqlite_drop_index() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_INDEX"))
}

///|
pub fn sqlite_drop_table() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_TABLE"))
}

///|
pub fn sqlite_drop_temp_index() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_TEMP_INDEX"))
}

///|
pub fn sqlite_drop_temp_table() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_TEMP_TABLE"))
}

///|
pub fn sqlite_drop_temp_trigger() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_TEMP_TRIGGER"))
}

///|
pub fn sqlite_drop_temp_view() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_TEMP_VIEW"))
}

///|
pub fn sqlite_drop_trigger() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_TRIGGER"))
}

///|
pub fn sqlite_drop_view() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_VIEW"))
}

///|
pub fn sqlite_insert() -> Int {
  unsafe_cast(get_constants().get("SQLITE_INSERT"))
}

///|
pub fn sqlite_pragma() -> Int {
  unsafe_cast(get_constants().get("SQLITE_PRAGMA"))
}

///|
pub fn sqlite_read() -> Int {
  unsafe_cast(get_constants().get("SQLITE_READ"))
}

///|
pub fn sqlite_select() -> Int {
  unsafe_cast(get_constants().get("SQLITE_SELECT"))
}

///|
pub fn sqlite_transaction() -> Int {
  unsafe_cast(get_constants().get("SQLITE_TRANSACTION"))
}

///|
pub fn sqlite_update() -> Int {
  unsafe_cast(get_constants().get("SQLITE_UPDATE"))
}

///|
pub fn sqlite_attach() -> Int {
  unsafe_cast(get_constants().get("SQLITE_ATTACH"))
}

///|
pub fn sqlite_detach() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DETACH"))
}

///|
pub fn sqlite_alter_table() -> Int {
  unsafe_cast(get_constants().get("SQLITE_ALTER_TABLE"))
}

///|
pub fn sqlite_reindex() -> Int {
  unsafe_cast(get_constants().get("SQLITE_REINDEX"))
}

///|
pub fn sqlite_analyze() -> Int {
  unsafe_cast(get_constants().get("SQLITE_ANALYZE"))
}

///|
pub fn sqlite_create_vtable() -> Int {
  unsafe_cast(get_constants().get("SQLITE_CREATE_VTABLE"))
}

///|
pub fn sqlite_drop_vtable() -> Int {
  unsafe_cast(get_constants().get("SQLITE_DROP_VTABLE"))
}

///|
pub fn sqlite_function() -> Int {
  unsafe_cast(get_constants().get("SQLITE_FUNCTION"))
}

///|
pub fn sqlite_savepoint() -> Int {
  unsafe_cast(get_constants().get("SQLITE_SAVEPOINT"))
}

///|
pub fn sqlite_copy() -> Int {
  unsafe_cast(get_constants().get("SQLITE_COPY"))
}

///|
pub fn sqlite_recursive() -> Int {
  unsafe_cast(get_constants().get("SQLITE_RECURSIVE"))
}
