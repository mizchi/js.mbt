///| npm @electric-sql/pglite FFI bindings
/// https://pglite.dev/
/// https://github.com/electric-sql/pglite

///|
/// PGlite database instance
#external
pub type PGlite

///|
pub fn PGlite::as_any(self : PGlite) -> @nostd.Any = "%identity"

///|
/// Transaction handle
#external
pub type Transaction

///|
pub fn Transaction::as_any(self : Transaction) -> @nostd.Any = "%identity"

///|
/// Query results
#external
pub type Results

///|
pub fn Results::as_any(self : Results) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_pglite_create(data_dir : String) -> @js.Promise[PGlite] =
  #| async (dataDir) => {
  #|   const { PGlite } = await import("@electric-sql/pglite");
  #|   return await PGlite.create(dataDir);
  #| }

///|
extern "js" fn ffi_pglite_create_memory() -> @js.Promise[PGlite] =
  #| async () => {
  #|   const { PGlite } = await import("@electric-sql/pglite");
  #|   return await PGlite.create();
  #| }

///|
extern "js" fn ffi_pglite_create_with_options(
  data_dir : String,
  options : @js.Any,
) -> @js.Promise[PGlite] =
  #| async (dataDir, options) => {
  #|   const { PGlite } = await import("@electric-sql/pglite");
  #|   return await PGlite.create(dataDir, options);
  #| }

///|
/// Create an in-memory PGlite database
pub async fn PGlite::create() -> PGlite {
  ffi_pglite_create_memory().wait()
}

///|
/// Create a PGlite database with a data directory
/// Supports: "memory://", "idb://name" (browser), "./path" (node)
#alias(create_with_dir)
pub async fn PGlite::createWithDir(data_dir : String) -> PGlite {
  ffi_pglite_create(data_dir).wait()
}

///|
/// Create a PGlite database with options
#alias(create_with_options)
pub async fn PGlite::createWithOptions(
  data_dir : String,
  debug? : Int,
  relaxed_durability? : Bool,
  username? : String,
  database? : String,
) -> PGlite {
  let opts = @js.Object::new()
  match debug {
    Some(v) => opts.set("debug", v)
    None => ()
  }
  match relaxed_durability {
    Some(v) => opts.set("relaxedDurability", v)
    None => ()
  }
  match username {
    Some(v) => opts.set("username", v)
    None => ()
  }
  match database {
    Some(v) => opts.set("database", v)
    None => ()
  }
  ffi_pglite_create_with_options(data_dir, opts.as_any()).wait()
}

///|
extern "js" fn ffi_query(
  db : PGlite,
  sql : String,
  params : @js.Any,
) -> @js.Promise[Results] =
  #| (db, sql, params) => db.query(sql, params)

///|
extern "js" fn ffi_query_no_params(
  db : PGlite,
  sql : String,
) -> @js.Promise[Results] =
  #| (db, sql) => db.query(sql)

///|
/// Execute a query with parameters
pub async fn PGlite::query(
  self : PGlite,
  sql : String,
  params? : Array[@js.Any] = [],
) -> Results {
  if params.length() == 0 {
    ffi_query_no_params(self, sql).wait()
  } else {
    ffi_query(self, sql, @js.from_array(params)).wait()
  }
}

///|
extern "js" fn ffi_exec(db : PGlite, sql : String) -> @js.Promise[@js.Any] =
  #| (db, sql) => db.exec(sql)

///|
/// Execute multiple SQL statements
pub async fn PGlite::exec(self : PGlite, sql : String) -> @js.Any {
  ffi_exec(self, sql).wait()
}

///|
extern "js" fn ffi_close(db : PGlite) -> @js.Promise[Unit] =
  #| (db) => db.close()

///|
/// Close the database connection (async)
pub async fn PGlite::close(self : PGlite) -> Unit {
  ffi_close(self).wait()
}

///|
/// Close the database connection (sync, returns promise for chaining)
/// Use this for defer statements
#alias(close_sync)
pub fn PGlite::closeSync(self : PGlite) -> @js.Promise[Unit] {
  ffi_close(self)
}

///|
extern "js" fn ffi_transaction(
  db : PGlite,
  callback : (Transaction) -> @js.Promise[@js.Any],
) -> @js.Promise[@js.Any] =
  #| (db, callback) => db.transaction(callback)

///|
extern "js" fn ffi_wrap_async_callback(
  callback : (Transaction) -> Unit,
) -> (Transaction) -> @js.Promise[@js.Any] =
  #| (callback) => async (tx) => { callback(tx); return null; }

///|
/// Run a transaction with a synchronous callback
/// For async operations, use transaction_async
pub async fn PGlite::transaction(
  self : PGlite,
  callback : (Transaction) -> Unit,
) -> @js.Any {
  ffi_transaction(self, ffi_wrap_async_callback(callback)).wait()
}

///|
extern "js" fn ffi_tx_query(
  tx : Transaction,
  sql : String,
  params : @js.Any,
) -> @js.Promise[Results] =
  #| (tx, sql, params) => tx.query(sql, params)

///|
extern "js" fn ffi_tx_query_no_params(
  tx : Transaction,
  sql : String,
) -> @js.Promise[Results] =
  #| (tx, sql) => tx.query(sql)

///|
/// Execute a query within a transaction
pub async fn Transaction::query(
  self : Transaction,
  sql : String,
  params? : Array[@js.Any] = [],
) -> Results {
  if params.length() == 0 {
    ffi_tx_query_no_params(self, sql).wait()
  } else {
    ffi_tx_query(self, sql, @js.from_array(params)).wait()
  }
}

///|
extern "js" fn ffi_tx_rollback(tx : Transaction) -> @js.Promise[Unit] =
  #| (tx) => tx.rollback()

///|
/// Rollback the transaction
pub async fn Transaction::rollback(self : Transaction) -> Unit {
  ffi_tx_rollback(self).wait()
}

///|
/// Get rows from query results
pub fn Results::rows(self : Results) -> @js.Any {
  self.as_any()["rows"].cast()
}

///|
/// Get rows as array
pub fn[T] Results::rows_array(self : Results) -> Array[T] {
  self.as_any()["rows"].cast()
}

///|
/// Get affected row count
#alias(affected_rows)
pub fn Results::affectedRows(self : Results) -> Int {
  let v = self.as_any()["affectedRows"]
  if @nostd.is_undefined(v) {
    0
  } else {
    v.cast()
  }
}

///|
/// Get field descriptions
pub fn Results::fields(self : Results) -> @js.Any {
  self.as_any()["fields"].cast()
}
