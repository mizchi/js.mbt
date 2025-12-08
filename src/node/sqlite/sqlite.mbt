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
extern "js" fn sqlite_module() -> @core.Any =
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
  let opts = @core.new_object()
  if open is Some(v) {
    opts["open"] = @core.any(v)
  }
  if readOnly is Some(v) {
    opts["readOnly"] = @core.any(v)
  }
  if allowExtension is Some(v) {
    opts["allowExtension"] = @core.any(v)
  }
  if enableForeignKeyConstraints is Some(v) {
    opts["enableForeignKeyConstraints"] = @core.any(v)
  }
  if timeout is Some(v) {
    opts["timeout"] = @core.any(v)
  }
  if readBigInts is Some(v) {
    opts["readBigInts"] = @core.any(v)
  }
  if returnArrays is Some(v) {
    opts["returnArrays"] = @core.any(v)
  }
  if allowBareNamedParameters is Some(v) {
    opts["allowBareNamedParameters"] = @core.any(v)
  }
  if allowUnknownNamedParameters is Some(v) {
    opts["allowUnknownNamedParameters"] = @core.any(v)
  }
  if defensive is Some(v) {
    opts["defensive"] = @core.any(v)
  }
  let cls = sqlite_module()["DatabaseSync"]
  @core.new(cls, [@core.any(path), opts]).cast()
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
  result? : (T) -> @core.Any,
) -> Unit {
  let opts = @core.new_object()
  if deterministic is Some(v) {
    opts["deterministic"] = @core.any(v)
  }
  if directOnly is Some(v) {
    opts["directOnly"] = @core.any(v)
  }
  if useBigIntArguments is Some(v) {
    opts["useBigIntArguments"] = @core.any(v)
  }
  if varargs is Some(v) {
    opts["varargs"] = @core.any(v)
  }
  if start is Some(v) {
    opts["start"] = @core.any(v)
  }
  if step is Some(v) {
    opts["step"] = @core.any(v)
  }
  if inverse is Some(v) {
    opts["inverse"] = @core.any(v)
  }
  if result is Some(v) {
    opts["result"] = @core.any(v)
  }
  @core.any(self)._call("aggregate", [@core.any(name), opts]) |> ignore
}

///|
pub fn DatabaseSync::function(
  self : DatabaseSync,
  name : String,
  func : (Array[@core.Any]) -> @core.Any,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
) -> Unit {
  let opts = @core.new_object()
  if deterministic is Some(v) {
    opts["deterministic"] = @core.any(v)
  }
  if directOnly is Some(v) {
    opts["directOnly"] = @core.any(v)
  }
  if useBigIntArguments is Some(v) {
    opts["useBigIntArguments"] = @core.any(v)
  }
  if varargs is Some(v) {
    opts["varargs"] = @core.any(v)
  }
  @core.any(self)._call("function", [@core.any(name), @core.any(func), opts])
  |> ignore
}

///|
#alias(set_authorizer)
pub fn DatabaseSync::setAuthorizer(
  self : DatabaseSync,
  callback : (Int, String?, String?, String?, String?) -> Int,
) -> Unit {
  @core.any(self)._call("setAuthorizer", [@core.any(callback)]) |> ignore
}

///|
pub fn DatabaseSync::location(
  self : DatabaseSync,
  db_name? : String,
) -> String? {
  let args : Array[@core.Any] = if db_name is Some(name) {
    [@core.any(name)]
  } else {
    []
  }
  let result = @core.any(self)._call("location", args)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
#alias(load_extension)
pub fn DatabaseSync::loadExtension(self : DatabaseSync, path : String) -> Unit {
  @core.any(self)._call("loadExtension", [@core.any(path)]) |> ignore
}

///|
#alias(enable_load_extension)
pub fn DatabaseSync::enableLoadExtension(
  self : DatabaseSync,
  allow : Bool,
) -> Unit {
  @core.any(self)._call("enableLoadExtension", [@core.any(allow)]) |> ignore
}

///|
#alias(is_open)
pub fn DatabaseSync::isOpen(self : DatabaseSync) -> Bool {
  @core.any(self)["isOpen"].cast()
}

///|
#alias(is_transaction)
pub fn DatabaseSync::isTransaction(self : DatabaseSync) -> Bool {
  @core.any(self)["isTransaction"].cast()
}

///|
pub fn DatabaseSync::open(self : DatabaseSync) -> Unit {
  @core.any(self)._call("open", []) |> ignore
}

///|
pub fn DatabaseSync::close(self : DatabaseSync) -> Unit {
  @core.any(self)._call("close", []) |> ignore
}

///|
#alias(create_tag_store)
pub fn DatabaseSync::createTagStore(
  self : DatabaseSync,
  max_size? : Int,
) -> SQLTagStore {
  let args : Array[@core.Any] = if max_size is Some(size) {
    [@core.any(size)]
  } else {
    []
  }
  @core.any(self)._call("createTagStore", args).cast()
}

///|
#alias(create_session)
pub fn DatabaseSync::createSession(
  self : DatabaseSync,
  table? : String,
  db? : String,
) -> Session {
  let opts = @core.new_object()
  if table is Some(v) {
    opts["table"] = @core.any(v)
  }
  if db is Some(v) {
    opts["db"] = @core.any(v)
  }
  @core.any(self)._call("createSession", [opts]).cast()
}

///|
pub fn DatabaseSync::exec(self : DatabaseSync, query : String) -> Unit {
  @core.any(self)._call("exec", [@core.any(query)]).cast()
}

///|
pub fn DatabaseSync::prepare(
  self : DatabaseSync,
  query : String,
) -> StatementSync {
  @core.any(self)._call("prepare", [@core.any(query)]).cast()
}

///|
#alias(apply_changeset)
pub fn DatabaseSync::applyChangeset(
  self : DatabaseSync,
  changeset : @arraybuffer.Uint8Array,
  filter? : (@core.Any) -> Bool,
  onConflict? : (@core.Any?, @core.Any) -> Bool,
) -> Bool {
  let opts = @core.new_object()
  if filter is Some(f) {
    opts["filter"] = @core.from_fn1(f)
  }
  if onConflict is Some(oc) {
    opts["onConflict"] = @core.from_fn2(oc)
  }
  @core.any(self)._call("applyChangeset", [@core.any(changeset), opts]).cast()
}

///|
#external
pub type StatementSync

///|
pub fn StatementSync::get(
  self : StatementSync,
  named_parameters? : Map[String, @core.Any],
  anonymous_parameters? : Array[@core.Any],
) -> @core.Any? {
  let args : Array[@core.Any] = []
  if named_parameters is Some(params) {
    let obj = @core.new_object()
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
  let result = @core.any(self)._call("get", args)
  if @core.is_undefined(result) {
    None
  } else {
    Some(result)
  }
}

///|
/// Get column information
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn StatementSync::columns(self : StatementSync) -> Array[@core.Any] {
  @core.any(self)._call("columns", []).cast()
}

///|
pub fn StatementSync::run(
  self : StatementSync,
  named_parameters? : Map[String, @core.Any],
  anonymous_parameters? : Array[@core.Any],
) -> StatementResultingChanges {
  let args : Array[@core.Any] = []
  if named_parameters is Some(params) {
    let obj = @core.new_object()
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
  @core.any(self)._call("run", args).cast()
}

///|
pub fn StatementSync::all(
  self : StatementSync,
  named_parameters? : Map[String, @core.Any],
  anonymous_parameters? : Array[@core.Any],
) -> Array[@core.Any] {
  let args : Array[@core.Any] = []
  if named_parameters is Some(params) {
    let obj = @core.new_object()
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
  @core.any(self)._call("all", args).cast()
}

///|
pub fn StatementSync::iterate(
  self : StatementSync,
  named_parameters? : Map[String, @core.Any],
  anonymous_parameters? : Array[@core.Any],
) -> @iterator.JsIterator[@core.Any] {
  let args : Array[@core.Any] = []
  if named_parameters is Some(params) {
    let obj = @core.new_object()
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
  @core.any(self)._call("iterate", args).cast()
}

///|
#alias(expanded_sql)
pub fn StatementSync::expandedSQL(self : StatementSync) -> String {
  @core.any(self)["expandedSQL"].cast()
}

///|
#alias(source_sql)
pub fn StatementSync::sourceSQL(self : StatementSync) -> String {
  @core.any(self)["sourceSQL"].cast()
}

///|
#alias(set_allow_bare_named_parameters)
pub fn StatementSync::setAllowBareNamedParameters(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @core.any(self)._call("setAllowBareNamedParameters", [@core.any(enabled)])
  |> ignore
}

///|
#alias(set_allow_unknown_named_parameters)
pub fn StatementSync::setAllowUnknownNamedParameters(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @core.any(self)._call("setAllowUnknownNamedParameters", [@core.any(enabled)])
  |> ignore
}

///|
#alias(set_return_arrays)
pub fn StatementSync::setReturnArrays(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @core.any(self)._call("setReturnArrays", [@core.any(enabled)]) |> ignore
}

///|
#alias(set_read_big_ints)
pub fn StatementSync::setReadBigInts(
  self : StatementSync,
  enabled : Bool,
) -> Unit {
  @core.any(self)._call("setReadBigInts", [@core.any(enabled)]) |> ignore
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
pub fn Session::changeset(self : Session) -> @arraybuffer.Uint8Array {
  @core.any(self)._call("changeset", []).cast()
}

///|
pub fn Session::patchset(self : Session) -> @arraybuffer.Uint8Array {
  @core.any(self)._call("patchset", []).cast()
}

///|
pub fn Session::close(self : Session) -> Unit {
  @core.any(self)._call("close", []) |> ignore
}

///|
#external
pub type SQLTagStore

///|
pub fn SQLTagStore::capacity(self : SQLTagStore) -> Int {
  @core.any(self)["capacity"].cast()
}

///|
pub fn SQLTagStore::size(self : SQLTagStore) -> Int {
  @core.any(self)._call("size", []).cast()
}

///|
pub fn SQLTagStore::clear(self : SQLTagStore) -> Unit {
  @core.any(self)._call("clear", []) |> ignore
}

///|
pub fn SQLTagStore::db(self : SQLTagStore) -> DatabaseSync {
  @core.any(self)["db"].cast()
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
  let opts = @core.new_object()
  if rate is Some(v) {
    opts["rate"] = @core.any(v)
  }
  if source is Some(v) {
    opts["source"] = @core.any(v)
  }
  if target is Some(v) {
    opts["target"] = @core.any(v)
  }
  if progress is Some(f) {
    opts["progress"] = @core.from_fn1(f)
  }
  let backup_fn = sqlite_module()["backup"]
  backup_fn._invoke([@core.any(source_db), @core.any(db_path), opts]) |> ignore
}

///|
/// SQLite constants accessor
fn get_constants() -> @core.Any {
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
