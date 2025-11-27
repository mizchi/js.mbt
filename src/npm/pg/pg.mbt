///| node-postgres (pg) FFI bindings
/// https://node-postgres.com/

///|
/// PostgreSQL Client instance
#external
pub type Client

///|
pub impl @js.JsImpl for Client

///|
/// PostgreSQL Pool instance
#external
pub type Pool

///|
pub impl @js.JsImpl for Pool

///|
/// PoolClient - client acquired from pool
#external
pub type PoolClient

///|
pub impl @js.JsImpl for PoolClient

///|
/// Query results
#external
pub type QueryResult

///|
pub impl @js.JsImpl for QueryResult

// ============ Client ============

///|
extern "js" fn ffi_new_client(config : @js.Any) -> Client =
  #| (config) => new (require("pg").Client)(config)

///|
/// Create a new Client with labeled arguments
#alias(new_client)
pub fn Client::new(
  connection_string? : String,
  user? : String,
  password? : String,
  host? : String,
  port? : Int,
  database? : String,
  ssl? : @js.Any,
  statement_timeout? : Int,
  query_timeout? : Int,
  connection_timeout_millis? : Int,
  application_name? : String,
) -> Client {
  let config = @js.Object::new()
  if connection_string is Some(v) {
    config.set("connectionString", v)
  }
  if user is Some(v) {
    config.set("user", v)
  }
  if password is Some(v) {
    config.set("password", v)
  }
  if host is Some(v) {
    config.set("host", v)
  }
  if port is Some(v) {
    config.set("port", v)
  }
  if database is Some(v) {
    config.set("database", v)
  }
  if ssl is Some(v) {
    config.set("ssl", v)
  }
  if statement_timeout is Some(v) {
    config.set("statement_timeout", v)
  }
  if query_timeout is Some(v) {
    config.set("query_timeout", v)
  }
  if connection_timeout_millis is Some(v) {
    config.set("connectionTimeoutMillis", v)
  }
  if application_name is Some(v) {
    config.set("application_name", v)
  }
  ffi_new_client(config.to_any())
}

///|
extern "js" fn ffi_client_connect(client : Client) -> @js.Promise[Unit] =
  #| (client) => client.connect()

///|
/// Connect to the database
pub async fn Client::connect(self : Client) -> Unit {
  ffi_client_connect(self).wait()
}

///|
extern "js" fn ffi_client_query(
  client : Client,
  sql : String,
  params : Array[@js.Any],
) -> @js.Promise[QueryResult] =
  #| (client, sql, params) => client.query(sql, params)

///|
extern "js" fn ffi_client_query_no_params(
  client : Client,
  sql : String,
) -> @js.Promise[QueryResult] =
  #| (client, sql) => client.query(sql)

///|
/// Execute a query with optional parameters
pub async fn Client::query(
  self : Client,
  sql : String,
  params? : Array[@js.Any] = [],
) -> QueryResult {
  if params.length() == 0 {
    ffi_client_query_no_params(self, sql).wait()
  } else {
    ffi_client_query(self, sql, params).wait()
  }
}

///|
extern "js" fn ffi_client_end(client : Client) -> @js.Promise[Unit] =
  #| (client) => client.end()

///|
/// Close the client connection
pub async fn Client::end(self : Client) -> Unit {
  ffi_client_end(self).wait()
}

///|
/// Close the client connection (sync, returns promise for defer)
#alias(end_sync)
pub fn Client::endSync(self : Client) -> @js.Promise[Unit] {
  ffi_client_end(self)
}

// ============ Pool ============

///|
extern "js" fn ffi_new_pool(config : @js.Any) -> Pool =
  #| (config) => new (require("pg").Pool)(config)

///|
/// Create a new Pool with labeled arguments
#alias(new_pool)
pub fn Pool::new(
  connection_string? : String,
  user? : String,
  password? : String,
  host? : String,
  port? : Int,
  database? : String,
  ssl? : @js.Any,
  max? : Int,
  min? : Int,
  idle_timeout_millis? : Int,
  connection_timeout_millis? : Int,
  max_lifetime_seconds? : Int,
  allow_exit_on_idle? : Bool,
) -> Pool {
  let config = @js.Object::new()
  if connection_string is Some(v) {
    config.set("connectionString", v)
  }
  if user is Some(v) {
    config.set("user", v)
  }
  if password is Some(v) {
    config.set("password", v)
  }
  if host is Some(v) {
    config.set("host", v)
  }
  if port is Some(v) {
    config.set("port", v)
  }
  if database is Some(v) {
    config.set("database", v)
  }
  if ssl is Some(v) {
    config.set("ssl", v)
  }
  if max is Some(v) {
    config.set("max", v)
  }
  if min is Some(v) {
    config.set("min", v)
  }
  if idle_timeout_millis is Some(v) {
    config.set("idleTimeoutMillis", v)
  }
  if connection_timeout_millis is Some(v) {
    config.set("connectionTimeoutMillis", v)
  }
  if max_lifetime_seconds is Some(v) {
    config.set("maxLifetimeSeconds", v)
  }
  if allow_exit_on_idle is Some(v) {
    config.set("allowExitOnIdle", v)
  }
  ffi_new_pool(config.to_any())
}

///|
extern "js" fn ffi_pool_query(
  pool : Pool,
  sql : String,
  params : Array[@js.Any],
) -> @js.Promise[QueryResult] =
  #| (pool, sql, params) => pool.query(sql, params)

///|
extern "js" fn ffi_pool_query_no_params(
  pool : Pool,
  sql : String,
) -> @js.Promise[QueryResult] =
  #| (pool, sql) => pool.query(sql)

///|
/// Execute a query on the pool (uses an available client)
pub async fn Pool::query(
  self : Pool,
  sql : String,
  params? : Array[@js.Any] = [],
) -> QueryResult {
  if params.length() == 0 {
    ffi_pool_query_no_params(self, sql).wait()
  } else {
    ffi_pool_query(self, sql, params).wait()
  }
}

///|
extern "js" fn ffi_pool_connect(pool : Pool) -> @js.Promise[PoolClient] =
  #| (pool) => pool.connect()

///|
/// Acquire a client from the pool
pub async fn Pool::connect(self : Pool) -> PoolClient {
  ffi_pool_connect(self).wait()
}

///|
extern "js" fn ffi_pool_end(pool : Pool) -> @js.Promise[Unit] =
  #| (pool) => pool.end()

///|
/// Close all clients in the pool
pub async fn Pool::end(self : Pool) -> Unit {
  ffi_pool_end(self).wait()
}

///|
/// Close all clients in the pool (sync, returns promise for defer)
#alias(end_sync)
pub fn Pool::endSync(self : Pool) -> @js.Promise[Unit] {
  ffi_pool_end(self)
}

///|
extern "js" fn ffi_pool_total_count(pool : Pool) -> Int =
  #| (pool) => pool.totalCount

///|
/// Get total number of clients in the pool
#alias(total_count)
pub fn Pool::totalCount(self : Pool) -> Int {
  ffi_pool_total_count(self)
}

///|
extern "js" fn ffi_pool_idle_count(pool : Pool) -> Int =
  #| (pool) => pool.idleCount

///|
/// Get number of idle clients in the pool
#alias(idle_count)
pub fn Pool::idleCount(self : Pool) -> Int {
  ffi_pool_idle_count(self)
}

///|
extern "js" fn ffi_pool_waiting_count(pool : Pool) -> Int =
  #| (pool) => pool.waitingCount

///|
/// Get number of queued requests waiting for a client
#alias(waiting_count)
pub fn Pool::waitingCount(self : Pool) -> Int {
  ffi_pool_waiting_count(self)
}

// ============ PoolClient ============

///|
extern "js" fn ffi_pool_client_query(
  client : PoolClient,
  sql : String,
  params : Array[@js.Any],
) -> @js.Promise[QueryResult] =
  #| (client, sql, params) => client.query(sql, params)

///|
extern "js" fn ffi_pool_client_query_no_params(
  client : PoolClient,
  sql : String,
) -> @js.Promise[QueryResult] =
  #| (client, sql) => client.query(sql)

///|
/// Execute a query with optional parameters
pub async fn PoolClient::query(
  self : PoolClient,
  sql : String,
  params? : Array[@js.Any] = [],
) -> QueryResult {
  if params.length() == 0 {
    ffi_pool_client_query_no_params(self, sql).wait()
  } else {
    ffi_pool_client_query(self, sql, params).wait()
  }
}

///|
extern "js" fn ffi_pool_client_release(
  client : PoolClient,
  destroy : Bool,
) -> Unit =
  #| (client, destroy) => client.release(destroy)

///|
/// Release the client back to the pool
/// If destroy is true, the client is disconnected instead of returned
pub fn PoolClient::release(self : PoolClient, destroy? : Bool = false) -> Unit {
  ffi_pool_client_release(self, destroy)
}

// ============ QueryResult ============

///|
extern "js" fn ffi_query_result_rows(result : QueryResult) -> @js.Any =
  #| (result) => result.rows

///|
/// Get rows from query result
pub fn QueryResult::rows(self : QueryResult) -> @js.Any {
  ffi_query_result_rows(self)
}

///|
/// Get rows as typed array
pub fn[T] QueryResult::rows_array(self : QueryResult) -> Array[T] {
  ffi_query_result_rows(self) |> @js.identity
}

///|
extern "js" fn ffi_query_result_row_count(result : QueryResult) -> Int =
  #| (result) => result.rowCount ?? 0

///|
/// Get row count
#alias(row_count)
pub fn QueryResult::rowCount(self : QueryResult) -> Int {
  ffi_query_result_row_count(self)
}

///|
extern "js" fn ffi_query_result_fields(result : QueryResult) -> @js.Any =
  #| (result) => result.fields

///|
/// Get field descriptions
pub fn QueryResult::fields(self : QueryResult) -> @js.Any {
  ffi_query_result_fields(self)
}

///|
extern "js" fn ffi_query_result_command(result : QueryResult) -> String =
  #| (result) => result.command

///|
/// Get command type (INSERT, UPDATE, DELETE, SELECT, etc.)
pub fn QueryResult::command(self : QueryResult) -> String {
  ffi_query_result_command(self)
}
