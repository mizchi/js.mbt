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

///|
extern "js" fn sqlite_module() -> @nostd.Any =
  #| () => require("node:sqlite")

///|
#external
pub type DatabaseSync

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
  let opts = @nostd.Object::new()
  if open is Some(v) {
    opts["open"] = @nostd.any(v)
  }
  if readOnly is Some(v) {
    opts["readOnly"] = @nostd.any(v)
  }
  if allowExtension is Some(v) {
    opts["allowExtension"] = @nostd.any(v)
  }
  if enableForeignKeyConstraints is Some(v) {
    opts["enableForeignKeyConstraints"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    opts["timeout"] = @nostd.any(v)
  }
  if readBigInts is Some(v) {
    opts["readBigInts"] = @nostd.any(v)
  }
  if returnArrays is Some(v) {
    opts["returnArrays"] = @nostd.any(v)
  }
  if allowBareNamedParameters is Some(v) {
    opts["allowBareNamedParameters"] = @nostd.any(v)
  }
  if allowUnknownNamedParameters is Some(v) {
    opts["allowUnknownNamedParameters"] = @nostd.any(v)
  }
  if defensive is Some(v) {
    opts["defensive"] = @nostd.any(v)
  }
  let cls = sqlite_module()["DatabaseSync"]
  @nostd.new(cls, [@nostd.any(path), opts]).cast()
}

///|
pub fn[T, U] DatabaseSync::aggregate(
  self : DatabaseSync,
  name : String,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
  start? : U,
  step? : (T, U) -> T,
  inverse? : (T, U) -> T,
  result? : (T) -> @nostd.Any,
) -> Unit {
  let opts = @nostd.Object::new()
  if deterministic is Some(v) {
    opts["deterministic"] = @nostd.any(v)
  }
  if directOnly is Some(v) {
    opts["directOnly"] = @nostd.any(v)
  }
  if useBigIntArguments is Some(v) {
    opts["useBigIntArguments"] = @nostd.any(v)
  }
  if varargs is Some(v) {
    opts["varargs"] = @nostd.any(v)
  }
  if start is Some(v) {
    opts["start"] = @nostd.any(v)
  }
  if step is Some(v) {
    opts["step"] = @nostd.any(v)
  }
  if inverse is Some(v) {
    opts["inverse"] = @nostd.any(v)
  }
  if result is Some(v) {
    opts["result"] = @nostd.any(v)
  }
  @nostd.any(self)._call("aggregate", [@nostd.any(name), opts]) |> ignore
}

///|
pub fn DatabaseSync::function(
  self : DatabaseSync,
  name : String,
  func : (Array[@nostd.Any]) -> @nostd.Any,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
) -> Unit {
  let opts = @nostd.Object::new()
  if deterministic is Some(v) {
    opts["deterministic"] = @nostd.any(v)
  }
  if directOnly is Some(v) {
    opts["directOnly"] = @nostd.any(v)
  }
  if useBigIntArguments is Some(v) {
    opts["useBigIntArguments"] = @nostd.any(v)
  }
  if varargs is Some(v) {
    opts["varargs"] = @nostd.any(v)
  }
  @nostd.any(self)._call("function", [@nostd.any(name), @nostd.any(func), opts])
  |> ignore
}

///|
#alias(set_authorizer)
pub fn DatabaseSync::setAuthorizer(
  self : DatabaseSync,
  callback : (Int, String?, String?, String?, String?) -> Int,
) -> Unit {
  @nostd.any(self)._call("setAuthorizer", [@nostd.any(callback)]) |> ignore
}

///|
pub fn DatabaseSync::location(
  self : DatabaseSync,
  db_name? : String,
) -> String? {
  let args : Array[@nostd.Any] = if db_name is Some(name) {
    [@nostd.any(name)]
  } else {
    []
  }
  let result = @nostd.any(self)._call("location", args)
  if @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
#alias(load_extension)
pub fn DatabaseSync::loadExtension(self : DatabaseSync, path : String) -> Unit {
  @nostd.any(self)._call("loadExtension", [@nostd.any(path)]) |> ignore
}

///|
#alias(enable_load_extension)
pub fn DatabaseSync::enableLoadExtension(
  self : DatabaseSync,
  allow : Bool,
) -> Unit {
  @nostd.any(self)._call("enableLoadExtension", [@nostd.any(allow)]) |> ignore
}

///|
#alias(is_open)
pub fn DatabaseSync::isOpen(self : DatabaseSync) -> Bool {
  @nostd.any(self)["isOpen"].cast()
}

///|
#alias(is_transaction)
pub fn DatabaseSync::isTransaction(self : DatabaseSync) -> Bool {
  @nostd.any(self)["isTransaction"].cast()
}

///|
pub fn DatabaseSync::open(self : DatabaseSync) -> Unit {
  @nostd.any(self)._call("open", []) |> ignore
}

///|
pub fn DatabaseSync::close(self : DatabaseSync) -> Unit {
  @nostd.any(self)._call("close", []) |> ignore
}

///|
#alias(create_tag_store)
pub fn DatabaseSync::createTagStore(
  self : DatabaseSync,
  max_size? : Int,
) -> SQLTagStore {
  let args : Array[@nostd.Any] = if max_size is Some(size) {
    [@nostd.any(size)]
  } else {
    []
  }
  @nostd.any(self)._call("createTagStore", args).cast()
}

///|
#alias(create_session)
pub fn DatabaseSync::createSession(
  self : DatabaseSync,
  table? : String,
  db? : String,
) -> Session {
  let opts = @nostd.Object::new()
  if table is Some(v) {
    opts["table"] = @nostd.any(v)
  }
  if db is Some(v) {
    opts["db"] = @nostd.any(v)
  }
  @nostd.any(self)._call("createSession", [opts]).cast()
}

///|
pub fn DatabaseSync::exec(self : DatabaseSync, query : String) -> Unit {
  @nostd.any(self)._call("exec", [@nostd.any(query)]).cast()
}

///|
pub fn DatabaseSync::prepare(
  self : DatabaseSync,
  query : String,
) -> StatementSync {
  @nostd.any(self)._call("prepare", [@nostd.any(query)]).cast()
}

///|
#alias(apply_changeset)
pub fn DatabaseSync::applyChangeset(
  self : DatabaseSync,
  changeset : @typedarray.Uint8Array,
  filter? : (@nostd.Any) -> Bool,
  onConflict? : (@nostd.Any?, @nostd.Any) -> Bool,
) -> Bool {
  let opts = @nostd.Object::new()
  if filter is Some(f) {
    opts["filter"] = @nostd.from_fn1(f)
  }
  if onConflict is Some(oc) {
    opts["onConflict"] = @nostd.from_fn2(oc)
  }
  @nostd.any(self)._call("applyChangeset", [@nostd.any(changeset), opts]).cast()
}

///|
#external
pub type StatementSync

///|
pub fn StatementSync::get_(
  self : StatementSync,
  named_parameters? : Map[String, @nostd.Any],
  anonymous_parameters? : Array[@nostd.Any],
) -> @nostd.Any? {
  let args : Array[@nostd.Any] = []
  if named_parameters is Some(params) {
    let obj = @nostd.Object::new()
    for key, value in params {
      obj[key] = value
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  let result = @nostd.any(self)._call("get", args)
  if @nostd.is_undefined(result) {
    None
  } else {
    Some(result)
  }
}

///|
/// Get column information
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn StatementSync::columns(self : StatementSync) -> Array[@nostd.Any] {
  @nostd.any(self)._call("columns", []).cast()
}

///|
pub fn StatementSync::run(
  self : StatementSync,
  named_parameters? : Map[String, @nostd.Any],
  anonymous_parameters? : Array[@nostd.Any],
) -> StatementResultingChanges {
  let args : Array[@nostd.Any] = []
  if named_parameters is Some(params) {
    let obj = @nostd.Object::new()
    for key, value in params {
      obj[key] = value
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  @nostd.any(self)._call("run", args).cast()
}

///|
pub fn StatementSync::all(
  self : StatementSync,
  named_parameters? : Map[String, @nostd.Any],
  anonymous_parameters? : Array[@nostd.Any],
) -> Array[@nostd.Any] {
  let args : Array[@nostd.Any] = []
  if named_parameters is Some(params) {
    let obj = @nostd.Object::new()
    for key, value in params {
      obj[key] = value
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  @nostd.any(self)._call("all", args).cast()
}

///|
pub fn StatementSync::iterate(
  self : StatementSync,
  named_parameters? : Map[String, @nostd.Any],
  anonymous_parameters? : Array[@nostd.Any],
) -> @js.JsIterator[@nostd.Any] {
  let args : Array[@nostd.Any] = []
  if named_parameters is Some(params) {
    let obj = @nostd.Object::new()
    for key, value in params {
      obj[key] = value
    }
    args.push(obj)
  }
  if anonymous_parameters is Some(params_arr) {
    for param in params_arr {
      args.push(param)
    }
  }
  @nostd.any(self)._call("iterate", args).cast()
}

///|
#alias(expanded_sql)
pub fn StatementSync::expandedSQL(self : StatementSync) -> String {
  @nostd.any(self)["expandedSQL"].cast()
}

///|
#alias(source_sql)
pub fn StatementSync::sourceSQL(self : StatementSync) -> String {
  @nostd.any(self)["sourceSQL"].cast()
}

///|
#alias(set_allow_bare_named_parameters)
pub fn StatementSync::setAllowBareNamedParameters(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @nostd.any(self)._call("setAllowBareNamedParameters", [@nostd.any(enabled)])
  |> ignore
}

///|
#alias(set_allow_unknown_named_parameters)
pub fn StatementSync::setAllowUnknownNamedParameters(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @nostd.any(self)._call("setAllowUnknownNamedParameters", [@nostd.any(enabled)])
  |> ignore
}

///|
#alias(set_return_arrays)
pub fn StatementSync::setReturnArrays(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @nostd.any(self)._call("setReturnArrays", [@nostd.any(enabled)]) |> ignore
}

///|
#alias(set_read_big_ints)
pub fn StatementSync::setReadBigInts(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @nostd.any(self)._call("setReadBigInts", [@nostd.any(enabled)]) |> ignore
}

///|
pub(all) struct StatementResultingChanges {
  changes : Int
  lastInsertRowid : Int
} derive(Show)

///|
#external
pub type Session

///|
pub fn Session::changeset(self : Session) -> @typedarray.Uint8Array {
  @nostd.any(self)._call("changeset", []).cast()
}

///|
pub fn Session::patchset(self : Session) -> @typedarray.Uint8Array {
  @nostd.any(self)._call("patchset", []).cast()
}

///|
pub fn Session::close(self : Session) -> Unit {
  @nostd.any(self)._call("close", []) |> ignore
}

///|
#external
pub type SQLTagStore

///|
pub fn SQLTagStore::capacity(self : SQLTagStore) -> Int {
  @nostd.any(self)["capacity"].cast()
}

///|
pub fn SQLTagStore::size(self : SQLTagStore) -> Int {
  @nostd.any(self)._call("size", []).cast()
}

///|
pub fn SQLTagStore::clear(self : SQLTagStore) -> Unit {
  @nostd.any(self)._call("clear", []) |> ignore
}

///|
pub fn SQLTagStore::db(self : SQLTagStore) -> DatabaseSync {
  @nostd.any(self)["db"].cast()
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
  let opts = @nostd.Object::new()
  if rate is Some(v) {
    opts["rate"] = @nostd.any(v)
  }
  if source is Some(v) {
    opts["source"] = @nostd.any(v)
  }
  if target is Some(v) {
    opts["target"] = @nostd.any(v)
  }
  if progress is Some(f) {
    opts["progress"] = @nostd.from_fn1(f)
  }
  let backup_fn = sqlite_module()["backup"]
  backup_fn._invoke([@nostd.any(source_db), @nostd.any(db_path), opts])
  |> ignore
}

///|
/// SQLite constants accessor
fn get_constants() -> @nostd.Any {
  sqlite_module()["constants"]
}

///|
pub fn sqlite_changeset_data() -> Int {
  get_constants()["SQLITE_CHANGESET_DATA"].cast()
}

///|
pub fn sqlite_changeset_notfound() -> Int {
  get_constants()["SQLITE_CHANGESET_NOTFOUND"].cast()
}

///|
pub fn sqlite_changeset_conflict() -> Int {
  get_constants()["SQLITE_CHANGESET_CONFLICT"].cast()
}

///|
pub fn sqlite_changeset_foreign_key() -> Int {
  get_constants()["SQLITE_CHANGESET_FOREIGN_KEY"].cast()
}

///|
pub fn sqlite_changeset_omit() -> Int {
  get_constants()["SQLITE_CHANGESET_OMIT"].cast()
}

///|
pub fn sqlite_changeset_replace() -> Int {
  get_constants()["SQLITE_CHANGESET_REPLACE"].cast()
}

///|
pub fn sqlite_changeset_abort() -> Int {
  get_constants()["SQLITE_CHANGESET_ABORT"].cast()
}

///|
pub fn sqlite_deny() -> Int {
  get_constants()["SQLITE_DENY"].cast()
}

///|
pub fn sqlite_ignore() -> Int {
  get_constants()["SQLITE_IGNORE"].cast()
}

///|
pub fn sqlite_ok() -> Int {
  get_constants()["SQLITE_OK"].cast()
}

///|
pub fn sqlite_create_index() -> Int {
  get_constants()["SQLITE_CREATE_INDEX"].cast()
}

///|
pub fn sqlite_create_table() -> Int {
  get_constants()["SQLITE_CREATE_TABLE"].cast()
}

///|
pub fn sqlite_create_temp_index() -> Int {
  get_constants()["SQLITE_CREATE_TEMP_INDEX"].cast()
}

///|
pub fn sqlite_create_temp_table() -> Int {
  get_constants()["SQLITE_CREATE_TEMP_TABLE"].cast()
}

///|
pub fn sqlite_create_temp_trigger() -> Int {
  get_constants()["SQLITE_CREATE_TEMP_TRIGGER"].cast()
}

///|
pub fn sqlite_create_temp_view() -> Int {
  get_constants()["SQLITE_CREATE_TEMP_VIEW"].cast()
}

///|
pub fn sqlite_create_trigger() -> Int {
  get_constants()["SQLITE_CREATE_TRIGGER"].cast()
}

///|
pub fn sqlite_create_view() -> Int {
  get_constants()["SQLITE_CREATE_VIEW"].cast()
}

///|
pub fn sqlite_delete() -> Int {
  get_constants()["SQLITE_DELETE"].cast()
}

///|
pub fn sqlite_drop_index() -> Int {
  get_constants()["SQLITE_DROP_INDEX"].cast()
}

///|
pub fn sqlite_drop_table() -> Int {
  get_constants()["SQLITE_DROP_TABLE"].cast()
}

///|
pub fn sqlite_drop_temp_index() -> Int {
  get_constants()["SQLITE_DROP_TEMP_INDEX"].cast()
}

///|
pub fn sqlite_drop_temp_table() -> Int {
  get_constants()["SQLITE_DROP_TEMP_TABLE"].cast()
}

///|
pub fn sqlite_drop_temp_trigger() -> Int {
  get_constants()["SQLITE_DROP_TEMP_TRIGGER"].cast()
}

///|
pub fn sqlite_drop_temp_view() -> Int {
  get_constants()["SQLITE_DROP_TEMP_VIEW"].cast()
}

///|
pub fn sqlite_drop_trigger() -> Int {
  get_constants()["SQLITE_DROP_TRIGGER"].cast()
}

///|
pub fn sqlite_drop_view() -> Int {
  get_constants()["SQLITE_DROP_VIEW"].cast()
}

///|
pub fn sqlite_insert() -> Int {
  get_constants()["SQLITE_INSERT"].cast()
}

///|
pub fn sqlite_pragma() -> Int {
  get_constants()["SQLITE_PRAGMA"].cast()
}

///|
pub fn sqlite_read() -> Int {
  get_constants()["SQLITE_READ"].cast()
}

///|
pub fn sqlite_select() -> Int {
  get_constants()["SQLITE_SELECT"].cast()
}

///|
pub fn sqlite_transaction() -> Int {
  get_constants()["SQLITE_TRANSACTION"].cast()
}

///|
pub fn sqlite_update() -> Int {
  get_constants()["SQLITE_UPDATE"].cast()
}

///|
pub fn sqlite_attach() -> Int {
  get_constants()["SQLITE_ATTACH"].cast()
}

///|
pub fn sqlite_detach() -> Int {
  get_constants()["SQLITE_DETACH"].cast()
}

///|
pub fn sqlite_alter_table() -> Int {
  get_constants()["SQLITE_ALTER_TABLE"].cast()
}

///|
pub fn sqlite_reindex() -> Int {
  get_constants()["SQLITE_REINDEX"].cast()
}

///|
pub fn sqlite_analyze() -> Int {
  get_constants()["SQLITE_ANALYZE"].cast()
}

///|
pub fn sqlite_create_vtable() -> Int {
  get_constants()["SQLITE_CREATE_VTABLE"].cast()
}

///|
pub fn sqlite_drop_vtable() -> Int {
  get_constants()["SQLITE_DROP_VTABLE"].cast()
}

///|
pub fn sqlite_function() -> Int {
  get_constants()["SQLITE_FUNCTION"].cast()
}

///|
pub fn sqlite_savepoint() -> Int {
  get_constants()["SQLITE_SAVEPOINT"].cast()
}

///|
pub fn sqlite_copy() -> Int {
  get_constants()["SQLITE_COPY"].cast()
}

///|
pub fn sqlite_recursive() -> Int {
  get_constants()["SQLITE_RECURSIVE"].cast()
}
