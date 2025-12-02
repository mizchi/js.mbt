///| node-postgres (pg) FFI bindings
/// https://node-postgres.com/

///|
/// PostgreSQL Client instance
#external
pub type Client

///|
pub extern "js" fn Client::as_any(self : Client) -> @core.Any =
  #| (x) => x

///|
/// PostgreSQL Pool instance
#external
pub type Pool

///|
pub extern "js" fn Pool::as_any(self : Pool) -> @core.Any =
  #| (x) => x

///|
/// PoolClient - client acquired from pool
#external
pub type PoolClient

///|
pub extern "js" fn PoolClient::as_any(self : PoolClient) -> @core.Any =
  #| (x) => x

///|
/// Query results
#external
pub type QueryResult

///|
pub extern "js" fn QueryResult::as_any(self : QueryResult) -> @core.Any =
  #| (x) => x

// ============ Client ============

///|
extern "js" fn ffi_new_client(config : @core.Any) -> Client =
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
  ssl? : @core.Any,
  statement_timeout? : Int,
  query_timeout? : Int,
  connection_timeout_millis? : Int,
  application_name? : String,
) -> Client {
  let config = @core.new_object()
  if connection_string is Some(v) {
    config["connectionString"] = @core.any(v)
  }
  if user is Some(v) {
    config["user"] = @core.any(v)
  }
  if password is Some(v) {
    config["password"] = @core.any(v)
  }
  if host is Some(v) {
    config["host"] = @core.any(v)
  }
  if port is Some(v) {
    config["port"] = @core.any(v)
  }
  if database is Some(v) {
    config["database"] = @core.any(v)
  }
  if ssl is Some(v) {
    config["ssl"] = v
  }
  if statement_timeout is Some(v) {
    config["statement_timeout"] = @core.any(v)
  }
  if query_timeout is Some(v) {
    config["query_timeout"] = @core.any(v)
  }
  if connection_timeout_millis is Some(v) {
    config["connectionTimeoutMillis"] = @core.any(v)
  }
  if application_name is Some(v) {
    config["application_name"] = @core.any(v)
  }
  ffi_new_client(config)
}

///|
extern "js" fn ffi_client_connect(client : Client) -> @core.Promise[Unit] =
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
  params : Array[@core.Any],
) -> @core.Promise[QueryResult] =
  #| (client, sql, params) => client.query(sql, params)

///|
extern "js" fn ffi_client_query_no_params(
  client : Client,
  sql : String,
) -> @core.Promise[QueryResult] =
  #| (client, sql) => client.query(sql)

///|
/// Execute a query with optional parameters
pub async fn Client::query(
  self : Client,
  sql : String,
  params? : Array[@core.Any] = [],
) -> QueryResult {
  if params.length() == 0 {
    ffi_client_query_no_params(self, sql).wait()
  } else {
    ffi_client_query(self, sql, params).wait()
  }
}

///|
extern "js" fn ffi_client_end(client : Client) -> @core.Promise[Unit] =
  #| (client) => client.end()

///|
/// Close the client connection
pub async fn Client::end(self : Client) -> Unit {
  ffi_client_end(self).wait()
}

///|
/// Close the client connection (sync, returns promise for defer)
#alias(end_sync)
pub fn Client::endSync(self : Client) -> @core.Promise[Unit] {
  ffi_client_end(self)
}

// ============ Pool ============

///|
extern "js" fn ffi_new_pool(config : @core.Any) -> Pool =
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
  ssl? : @core.Any,
  max? : Int,
  min? : Int,
  idle_timeout_millis? : Int,
  connection_timeout_millis? : Int,
  max_lifetime_seconds? : Int,
  allow_exit_on_idle? : Bool,
) -> Pool {
  let config = @core.new_object()
  if connection_string is Some(v) {
    config["connectionString"] = @core.any(v)
  }
  if user is Some(v) {
    config["user"] = @core.any(v)
  }
  if password is Some(v) {
    config["password"] = @core.any(v)
  }
  if host is Some(v) {
    config["host"] = @core.any(v)
  }
  if port is Some(v) {
    config["port"] = @core.any(v)
  }
  if database is Some(v) {
    config["database"] = @core.any(v)
  }
  if ssl is Some(v) {
    config["ssl"] = v
  }
  if max is Some(v) {
    config["max"] = @core.any(v)
  }
  if min is Some(v) {
    config["min"] = @core.any(v)
  }
  if idle_timeout_millis is Some(v) {
    config["idleTimeoutMillis"] = @core.any(v)
  }
  if connection_timeout_millis is Some(v) {
    config["connectionTimeoutMillis"] = @core.any(v)
  }
  if max_lifetime_seconds is Some(v) {
    config["maxLifetimeSeconds"] = @core.any(v)
  }
  if allow_exit_on_idle is Some(v) {
    config["allowExitOnIdle"] = @core.any(v)
  }
  ffi_new_pool(config)
}

///|
extern "js" fn ffi_pool_query(
  pool : Pool,
  sql : String,
  params : Array[@core.Any],
) -> @core.Promise[QueryResult] =
  #| (pool, sql, params) => pool.query(sql, params)

///|
extern "js" fn ffi_pool_query_no_params(
  pool : Pool,
  sql : String,
) -> @core.Promise[QueryResult] =
  #| (pool, sql) => pool.query(sql)

///|
/// Execute a query on the pool (uses an available client)
pub async fn Pool::query(
  self : Pool,
  sql : String,
  params? : Array[@core.Any] = [],
) -> QueryResult {
  if params.length() == 0 {
    ffi_pool_query_no_params(self, sql).wait()
  } else {
    ffi_pool_query(self, sql, params).wait()
  }
}

///|
extern "js" fn ffi_pool_connect(pool : Pool) -> @core.Promise[PoolClient] =
  #| (pool) => pool.connect()

///|
/// Acquire a client from the pool
pub async fn Pool::connect(self : Pool) -> PoolClient {
  ffi_pool_connect(self).wait()
}

///|
extern "js" fn ffi_pool_end(pool : Pool) -> @core.Promise[Unit] =
  #| (pool) => pool.end()

///|
/// Close all clients in the pool
pub async fn Pool::end(self : Pool) -> Unit {
  ffi_pool_end(self).wait()
}

///|
/// Close all clients in the pool (sync, returns promise for defer)
#alias(end_sync)
pub fn Pool::endSync(self : Pool) -> @core.Promise[Unit] {
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
  params : Array[@core.Any],
) -> @core.Promise[QueryResult] =
  #| (client, sql, params) => client.query(sql, params)

///|
extern "js" fn ffi_pool_client_query_no_params(
  client : PoolClient,
  sql : String,
) -> @core.Promise[QueryResult] =
  #| (client, sql) => client.query(sql)

///|
/// Execute a query with optional parameters
pub async fn PoolClient::query(
  self : PoolClient,
  sql : String,
  params? : Array[@core.Any] = [],
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
extern "js" fn ffi_query_result_rows(result : QueryResult) -> @core.Any =
  #| (result) => result.rows

///|
/// Get rows from query result
pub fn QueryResult::rows(self : QueryResult) -> @core.Any {
  ffi_query_result_rows(self)
}

///|
/// Get rows as typed array
pub fn[T] QueryResult::rows_array(self : QueryResult) -> Array[T] {
  ffi_query_result_rows(self).cast()
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
extern "js" fn ffi_query_result_fields(result : QueryResult) -> @core.Any =
  #| (result) => result.fields

///|
/// Get field descriptions
pub fn QueryResult::fields(self : QueryResult) -> @core.Any {
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
