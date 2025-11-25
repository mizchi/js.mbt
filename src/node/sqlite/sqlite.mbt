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
pub impl @js.JsImpl for DatabaseSync

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
  let opts = @js.from_option_map({
    "open": open.map(fn(x) { @js.any(x) }),
    "readOnly": readOnly.map(fn(x) { @js.any(x) }),
    "allowExtension": allowExtension.map(fn(x) { @js.any(x) }),
    "enableForeignKeyConstraints": enableForeignKeyConstraints.map(fn(x) {
      @js.any(x)
    }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "readBigInts": readBigInts.map(fn(x) { @js.any(x) }),
    "returnArrays": returnArrays.map(fn(x) { @js.any(x) }),
    "allowBareNamedParameters": allowBareNamedParameters.map(fn(x) {
      @js.any(x)
    }),
    "allowUnknownNamedParameters": allowUnknownNamedParameters.map(fn(x) {
      @js.any(x)
    }),
    "defensive": defensive.map(fn(x) { @js.any(x) }),
  })
  let v = @node.require("node:sqlite").get("DatabaseSync")
    |> @js.new_([path, opts])
  @js.identity(v)
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
  result? : (T) -> @js.Any,
) -> Unit {
  let opts = @js.from_option_map({
    "deterministic": deterministic.map(fn(x) { @js.any(x) }),
    "directOnly": directOnly.map(fn(x) { @js.any(x) }),
    "useBigIntArguments": useBigIntArguments.map(fn(x) { @js.any(x) }),
    "varargs": varargs.map(fn(x) { @js.any(x) }),
    "start": start.map(fn(x) { @js.unsafe_any(x) }),
    "step": step.map(fn(x) { @js.unsafe_any(x) }),
    "inverse": inverse.map(fn(x) { @js.unsafe_any(x) }),
    "result": result.map(fn(x) { @js.unsafe_any(x) }),
  })
  self.call2("aggregate", name, opts) |> ignore
}

///|
pub fn DatabaseSync::function(
  self : Self,
  name : String,
  func : (Array[@js.Any]) -> @js.Any,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
) -> Unit {
  let opts = @js.from_option_map({
    "deterministic": deterministic.map(fn(x) { @js.any(x) }),
    "directOnly": directOnly.map(fn(x) { @js.any(x) }),
    "useBigIntArguments": useBigIntArguments.map(fn(x) { @js.any(x) }),
    "varargs": varargs.map(fn(x) { @js.any(x) }),
  })
  self.call("function", [name, func |> @js.identity, opts]) |> ignore
}

///|
#alias(set_authorizer)
pub fn DatabaseSync::setAuthorizer(
  self : Self,
  callback : (Int, String?, String?, String?, String?) -> Int,
) -> Unit {
  self.call("setAuthorizer", [callback |> @js.unsafe_any]) |> ignore
}

///|
pub fn DatabaseSync::location(self : Self, db_name? : String) -> String? {
  let args : Array[&@js.JsImpl] = if db_name is Some(name) {
    [name]
  } else {
    []
  }
  let result = self.call("location", args)
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
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
  self.get("isOpen").cast()
}

///|
#alias(is_transaction)
pub fn DatabaseSync::isTransaction(self : Self) -> Bool {
  self.get("isTransaction").cast()
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
  let args : Array[&@js.JsImpl] = if max_size is Some(size) {
    [size]
  } else {
    []
  }
  self.call("createTagStore", args).cast()
}

///|
#alias(create_session)
pub fn DatabaseSync::createSession(
  self : Self,
  table? : String,
  db? : String,
) -> Session {
  let v = @js.from_option_map({
    "table": table.map(fn(x) { @js.any(x) }),
    "db": db.map(fn(x) { @js.any(x) }),
  })
  self.call("createSession", [v]).cast()
}

///|
pub fn DatabaseSync::exec(self : Self, query : String) -> Unit {
  self.call("exec", [query]).cast()
}

///|
pub fn DatabaseSync::prepare(self : Self, query : String) -> StatementSync {
  self.call("prepare", [query]).cast()
}

///|
#alias(apply_changeset)
pub fn DatabaseSync::applyChangeset(
  self : Self,
  changeset : @typedarray.Uint8Array,
  filter? : (@js.Any) -> Bool,
  onConflict? : (@js.Any?, @js.Any) -> Bool,
) -> Bool {
  let opts = @js.from_option_map({
    "filter": filter.map(fn(f) { f |> @js.from_fn1 }),
    "onConflict": onConflict.map(fn(oc) { oc |> @js.from_fn2 }),
  })
  self.call2("applyChangeset", changeset, opts) |> @js.identity
}

///|
#external
pub type StatementSync

///|
pub impl @js.JsImpl for StatementSync with to_any(self) {
  self |> @js.identity
}

///|
pub fn StatementSync::get_(
  self : Self,
  named_parameters? : Map[String, &@js.JsImpl],
  anonymous_parameters? : Array[&@js.JsImpl],
) -> @js.Any? {
  let args : Array[&@js.JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
    for key, value in params {
      obj.set(key, value.to_any())
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
/// Get column information
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn StatementSync::columns(self : Self) -> Array[@js.Any] {
  self.call0("columns") |> @js.identity
}

///|
pub fn StatementSync::run(
  self : Self,
  named_parameters? : Map[String, &@js.JsImpl],
  anonymous_parameters? : Array[&@js.JsImpl],
) -> StatementResultingChanges {
  let args : Array[&@js.JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
    for key, value in params {
      obj.set(key, value.to_any())
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  self.call("run", args).cast()
}

///|
pub fn StatementSync::all(
  self : Self,
  named_parameters? : Map[String, &@js.JsImpl],
  anonymous_parameters? : Array[&@js.JsImpl],
) -> Array[@js.Any] {
  let args : Array[&@js.JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
    for key, value in params {
      obj.set(key, value.to_any())
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  self.call("all", args).cast()
}

///|
pub fn StatementSync::iterate(
  self : Self,
  named_parameters? : Map[String, &@js.JsImpl],
  anonymous_parameters? : Array[&@js.JsImpl],
) -> @js.JsIterator[@js.Any] {
  let args : Array[&@js.JsImpl] = []
  if named_parameters is Some(params) {
    let obj = @js.Object::new()
    for key, value in params {
      obj.set(key, value.to_any())
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  self.call("iterate", args).cast()
}

///|
#alias(expanded_sql)
pub fn StatementSync::expandedSQL(self : Self) -> String {
  self.get("expandedSQL").cast()
}

///|
#alias(source_sql)
pub fn StatementSync::sourceSQL(self : Self) -> String {
  self.get("sourceSQL").cast()
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
pub impl @js.JsImpl for StatementResultingChanges

///|
#external
pub type Session

///|
pub impl @js.JsImpl for Session

///|
pub fn Session::changeset(self : Self) -> @typedarray.Uint8Array {
  self.call0("changeset") |> @js.identity
}

///|
pub fn Session::patchset(self : Self) -> @typedarray.Uint8Array {
  self.call0("patchset") |> @js.identity
}

///|
pub fn Session::close(self : Self) -> Unit {
  self.call0("close") |> ignore
}

///|
#external
pub type SQLTagStore

///|
pub impl @js.JsImpl for SQLTagStore

///|
pub fn SQLTagStore::capacity(self : Self) -> Int {
  self.get("capacity").cast()
}

///|
pub fn SQLTagStore::size(self : Self) -> Int {
  self.call0("size") |> @js.identity
}

///|
pub fn SQLTagStore::clear(self : Self) -> Unit {
  self.call0("clear") |> ignore
}

///|
pub fn SQLTagStore::db(self : Self) -> DatabaseSync {
  self.get("db").cast()
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
  let backup : @js.Any = @node.require("node:sqlite").get("backup")
  backup.call_self([source_db.to_any(), db_path, opts]) |> ignore
}

///|
/// SQLite constants accessor
fn get_constants() -> @js.Any {
  let sqlite = @node.require("node:sqlite")
  sqlite.get("constants")
}

///|
pub fn sqlite_changeset_data() -> Int {
  @js.identity(get_constants().get("SQLITE_CHANGESET_DATA"))
}

///|
pub fn sqlite_changeset_notfound() -> Int {
  @js.identity(get_constants().get("SQLITE_CHANGESET_NOTFOUND"))
}

///|
pub fn sqlite_changeset_conflict() -> Int {
  @js.identity(get_constants().get("SQLITE_CHANGESET_CONFLICT"))
}

///|
pub fn sqlite_changeset_foreign_key() -> Int {
  @js.identity(get_constants().get("SQLITE_CHANGESET_FOREIGN_KEY"))
}

///|
pub fn sqlite_changeset_omit() -> Int {
  @js.identity(get_constants().get("SQLITE_CHANGESET_OMIT"))
}

///|
pub fn sqlite_changeset_replace() -> Int {
  @js.identity(get_constants().get("SQLITE_CHANGESET_REPLACE"))
}

///|
pub fn sqlite_changeset_abort() -> Int {
  @js.identity(get_constants().get("SQLITE_CHANGESET_ABORT"))
}

///|
pub fn sqlite_deny() -> Int {
  @js.identity(get_constants().get("SQLITE_DENY"))
}

///|
pub fn sqlite_ignore() -> Int {
  @js.identity(get_constants().get("SQLITE_IGNORE"))
}

///|
pub fn sqlite_ok() -> Int {
  @js.identity(get_constants().get("SQLITE_OK"))
}

///|
pub fn sqlite_create_index() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_INDEX"))
}

///|
pub fn sqlite_create_table() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_TABLE"))
}

///|
pub fn sqlite_create_temp_index() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_TEMP_INDEX"))
}

///|
pub fn sqlite_create_temp_table() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_TEMP_TABLE"))
}

///|
pub fn sqlite_create_temp_trigger() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_TEMP_TRIGGER"))
}

///|
pub fn sqlite_create_temp_view() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_TEMP_VIEW"))
}

///|
pub fn sqlite_create_trigger() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_TRIGGER"))
}

///|
pub fn sqlite_create_view() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_VIEW"))
}

///|
pub fn sqlite_delete() -> Int {
  @js.identity(get_constants().get("SQLITE_DELETE"))
}

///|
pub fn sqlite_drop_index() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_INDEX"))
}

///|
pub fn sqlite_drop_table() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_TABLE"))
}

///|
pub fn sqlite_drop_temp_index() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_TEMP_INDEX"))
}

///|
pub fn sqlite_drop_temp_table() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_TEMP_TABLE"))
}

///|
pub fn sqlite_drop_temp_trigger() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_TEMP_TRIGGER"))
}

///|
pub fn sqlite_drop_temp_view() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_TEMP_VIEW"))
}

///|
pub fn sqlite_drop_trigger() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_TRIGGER"))
}

///|
pub fn sqlite_drop_view() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_VIEW"))
}

///|
pub fn sqlite_insert() -> Int {
  @js.identity(get_constants().get("SQLITE_INSERT"))
}

///|
pub fn sqlite_pragma() -> Int {
  @js.identity(get_constants().get("SQLITE_PRAGMA"))
}

///|
pub fn sqlite_read() -> Int {
  @js.identity(get_constants().get("SQLITE_READ"))
}

///|
pub fn sqlite_select() -> Int {
  @js.identity(get_constants().get("SQLITE_SELECT"))
}

///|
pub fn sqlite_transaction() -> Int {
  @js.identity(get_constants().get("SQLITE_TRANSACTION"))
}

///|
pub fn sqlite_update() -> Int {
  @js.identity(get_constants().get("SQLITE_UPDATE"))
}

///|
pub fn sqlite_attach() -> Int {
  @js.identity(get_constants().get("SQLITE_ATTACH"))
}

///|
pub fn sqlite_detach() -> Int {
  @js.identity(get_constants().get("SQLITE_DETACH"))
}

///|
pub fn sqlite_alter_table() -> Int {
  @js.identity(get_constants().get("SQLITE_ALTER_TABLE"))
}

///|
pub fn sqlite_reindex() -> Int {
  @js.identity(get_constants().get("SQLITE_REINDEX"))
}

///|
pub fn sqlite_analyze() -> Int {
  @js.identity(get_constants().get("SQLITE_ANALYZE"))
}

///|
pub fn sqlite_create_vtable() -> Int {
  @js.identity(get_constants().get("SQLITE_CREATE_VTABLE"))
}

///|
pub fn sqlite_drop_vtable() -> Int {
  @js.identity(get_constants().get("SQLITE_DROP_VTABLE"))
}

///|
pub fn sqlite_function() -> Int {
  @js.identity(get_constants().get("SQLITE_FUNCTION"))
}

///|
pub fn sqlite_savepoint() -> Int {
  @js.identity(get_constants().get("SQLITE_SAVEPOINT"))
}

///|
pub fn sqlite_copy() -> Int {
  @js.identity(get_constants().get("SQLITE_COPY"))
}

///|
pub fn sqlite_recursive() -> Int {
  @js.identity(get_constants().get("SQLITE_RECURSIVE"))
}
