///| npm @duckdb/duckdb-wasm package FFI bindings
/// https://github.com/duckdb/duckdb-wasm
/// https://duckdb.org/
///
/// Note: DuckDB-WASM requires complex async initialization.
/// See https://duckdb.org/docs/api/wasm/instantiation for setup instructions.

///|
/// DuckDB WASM module
#external
pub type DuckDBModule

///|
pub fn DuckDBModule::as_any(self : DuckDBModule) -> @nostd.Any = "%identity"

///|
/// AsyncDuckDB database instance
#external
pub type AsyncDuckDB

///|
pub fn AsyncDuckDB::as_any(self : AsyncDuckDB) -> @nostd.Any = "%identity"

///|
/// AsyncDuckDBConnection
#external
pub type AsyncDuckDBConnection

///|
pub fn AsyncDuckDBConnection::as_any(
  self : AsyncDuckDBConnection,
) -> @nostd.Any = "%identity"

///|
/// Query result
#external
pub type QueryResult

///|
pub fn QueryResult::as_any(self : QueryResult) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_import_duckdb() -> @js.Promise[@js.Any] =
  #| () => import("@duckdb/duckdb-wasm")

///|
/// Import the duckdb-wasm module
#alias(import_module)
pub async fn importModule() -> DuckDBModule {
  ffi_import_duckdb().wait().cast()
}

///|
extern "js" fn ffi_instantiate_node(
  mod : DuckDBModule,
) -> @js.Promise[AsyncDuckDB] =
  #| async (mod) => {
  #|   const path = await import('path');
  #|   const { createRequire } = await import('module');
  #|   const require = createRequire(import.meta.url || 'file://' + process.cwd());
  #|   const DUCKDB_DIST = path.dirname(require.resolve('@duckdb/duckdb-wasm'));
  #|   const bundle = {
  #|     mvp: {
  #|       mainModule: path.join(DUCKDB_DIST, 'duckdb-mvp.wasm'),
  #|       mainWorker: path.join(DUCKDB_DIST, 'duckdb-node-mvp.worker.cjs'),
  #|     },
  #|     eh: {
  #|       mainModule: path.join(DUCKDB_DIST, 'duckdb-eh.wasm'),
  #|       mainWorker: path.join(DUCKDB_DIST, 'duckdb-node-eh.worker.cjs'),
  #|     },
  #|   };
  #|   const logger = new mod.ConsoleLogger(mod.LogLevel.WARNING);
  #|   const worker = await mod.createWorker(bundle.eh.mainWorker);
  #|   const db = new mod.AsyncDuckDB(logger, worker);
  #|   await db.instantiate(bundle.eh.mainModule, bundle.eh.pthreadWorker);
  #|   return db;
  #| }

///|
/// Instantiate DuckDB for Node.js environment
/// This is the recommended way to create a DuckDB instance in Node.js
#alias(instantiate_node)
pub async fn instantiateNode(duckdb_mod : DuckDBModule) -> AsyncDuckDB {
  ffi_instantiate_node(duckdb_mod).wait()
}

///|
extern "js" fn ffi_db_connect(
  db : AsyncDuckDB,
) -> @js.Promise[AsyncDuckDBConnection] =
  #| (db) => db.connect()

///|
/// Create a connection to the database
pub async fn AsyncDuckDB::connect(self : AsyncDuckDB) -> AsyncDuckDBConnection {
  ffi_db_connect(self).wait()
}

///|
extern "js" fn ffi_db_close(db : AsyncDuckDB) -> @js.Promise[Unit] =
  #| (db) => db.terminate()

///|
/// Close the database
pub async fn AsyncDuckDB::close(self : AsyncDuckDB) -> Unit {
  ffi_db_close(self).wait()
}

///|
/// Close the database (sync, for defer)
#alias(close_sync)
pub fn AsyncDuckDB::closeSync(self : AsyncDuckDB) -> @js.Promise[Unit] {
  ffi_db_close(self)
}

///|
extern "js" fn ffi_conn_query(
  conn : AsyncDuckDBConnection,
  sql : String,
) -> @js.Promise[QueryResult] =
  #| (conn, sql) => conn.query(sql)

///|
/// Execute a query
pub async fn AsyncDuckDBConnection::query(
  self : AsyncDuckDBConnection,
  sql : String,
) -> QueryResult {
  ffi_conn_query(self, sql).wait()
}

///|
extern "js" fn ffi_conn_close(
  conn : AsyncDuckDBConnection,
) -> @js.Promise[Unit] =
  #| (conn) => conn.close()

///|
/// Close the connection
pub async fn AsyncDuckDBConnection::close(self : AsyncDuckDBConnection) -> Unit {
  ffi_conn_close(self).wait()
}

///|
/// Close connection (sync, for defer)
#alias(close_sync)
pub fn AsyncDuckDBConnection::closeSync(
  self : AsyncDuckDBConnection,
) -> @js.Promise[Unit] {
  ffi_conn_close(self)
}

///|
/// Get rows as array from query result
pub fn QueryResult::toArray(self : QueryResult) -> @js.Any {
  self.as_any()._call("toArray", []).cast()
}

///|
/// Get number of rows
#alias(num_rows)
pub fn QueryResult::numRows(self : QueryResult) -> Int {
  self.as_any()["numRows"].cast()
}

///|
/// Get number of columns
#alias(num_cols)
pub fn QueryResult::numCols(self : QueryResult) -> Int {
  self.as_any()["numCols"].cast()
}

///|
/// Get schema
pub fn QueryResult::schema(self : QueryResult) -> @js.Any {
  self.as_any()["schema"].cast()
}
