///| drizzle-orm Transaction support
/// https://orm.drizzle.team/docs/transactions

///|
/// Transaction context
#external
pub type Transaction

///|
pub fn Transaction::as_any(self : Transaction) -> @core.Any = "%identity"

// ============ Transaction Operations ============

///|
extern "js" fn ffi_transaction(
  db : DrizzleDB,
  callback : (Transaction) -> @js.Promise[@core.Any],
) -> @js.Promise[@core.Any] =
  #| (db, callback) => db.transaction(callback)

///|
extern "js" fn ffi_wrap_tx_callback(
  callback : (Transaction) -> Unit,
) -> (Transaction) -> @js.Promise[@core.Any] =
  #| (callback) => async (tx) => { callback(tx); return null; }

///|
/// Run a transaction with a synchronous callback
pub async fn DrizzleDB::transaction(
  self : DrizzleDB,
  callback : (Transaction) -> Unit,
) -> @core.Any {
  ffi_transaction(self, ffi_wrap_tx_callback(callback)).wait()
}

///|
extern "js" fn ffi_transaction_async(
  db : DrizzleDB,
  callback : (Transaction) -> @js.Promise[@core.Any],
) -> @js.Promise[@core.Any] =
  #| (db, callback) => db.transaction(callback)

///|
/// Run a transaction with an async callback
#alias(transaction_async)
pub async fn DrizzleDB::transactionAsync(
  self : DrizzleDB,
  callback : (Transaction) -> @js.Promise[@core.Any],
) -> @core.Any {
  ffi_transaction_async(self, callback).wait()
}

// ============ PostgreSQL Transaction Options ============

///|
/// PostgreSQL isolation level
pub(all) enum PgIsolationLevel {
  ReadUncommitted
  ReadCommitted
  RepeatableRead
  Serializable
} derive(Eq, Show)

///|
pub fn PgIsolationLevel::to_string(self : PgIsolationLevel) -> String {
  match self {
    ReadUncommitted => "read uncommitted"
    ReadCommitted => "read committed"
    RepeatableRead => "repeatable read"
    Serializable => "serializable"
  }
}

///|
/// PostgreSQL access mode
pub(all) enum PgAccessMode {
  ReadOnly
  ReadWrite
} derive(Eq, Show)

///|
pub fn PgAccessMode::to_string(self : PgAccessMode) -> String {
  match self {
    ReadOnly => "read only"
    ReadWrite => "read write"
  }
}

///|
extern "js" fn ffi_pg_transaction_with_opts(
  db : DrizzleDB,
  callback : (Transaction) -> @js.Promise[@core.Any],
  opts : @core.Any,
) -> @js.Promise[@core.Any] =
  #| (db, callback, opts) => db.transaction(callback, opts)

///|
/// Run a PostgreSQL transaction with options (labeled arguments)
#alias(pg_transaction)
pub async fn DrizzleDB::pgTransaction(
  self : DrizzleDB,
  callback : (Transaction) -> Unit,
  isolation_level? : PgIsolationLevel,
  access_mode? : PgAccessMode,
  deferrable? : Bool,
) -> @core.Any {
  let entries : Array[(String, @core.Any)] = []
  if isolation_level is Some(il) {
    entries.push(("isolationLevel", il.to_string() |> @core.any))
  }
  if access_mode is Some(am) {
    entries.push(("accessMode", am.to_string() |> @core.any))
  }
  if deferrable is Some(d) {
    entries.push(("deferrable", d |> @core.any))
  }
  let opts = @core.from_entries(entries)
  ffi_pg_transaction_with_opts(self, ffi_wrap_tx_callback(callback), opts).wait()
}

// ============ SQLite Transaction Options ============

///|
/// SQLite transaction behavior
pub(all) enum SqliteBehavior {
  Deferred
  Immediate
  Exclusive
} derive(Eq, Show)

///|
pub fn SqliteBehavior::to_string(self : SqliteBehavior) -> String {
  match self {
    Deferred => "deferred"
    Immediate => "immediate"
    Exclusive => "exclusive"
  }
}

///|
extern "js" fn ffi_sqlite_transaction_with_behavior(
  db : DrizzleDB,
  callback : (Transaction) -> @js.Promise[@core.Any],
  behavior : String,
) -> @js.Promise[@core.Any] =
  #| (db, callback, behavior) => db.transaction(callback, { behavior })

///|
/// Run a SQLite transaction with behavior option
#alias(sqlite_transaction)
pub async fn DrizzleDB::sqliteTransaction(
  self : DrizzleDB,
  behavior : SqliteBehavior,
  callback : (Transaction) -> Unit,
) -> @core.Any {
  ffi_sqlite_transaction_with_behavior(
    self,
    ffi_wrap_tx_callback(callback),
    behavior.to_string(),
  ).wait()
}

// ============ Transaction Query Methods ============

///|
extern "js" fn ffi_tx_select(tx : Transaction) -> QueryBuilder =
  #| (tx) => tx.select()

///|
extern "js" fn ffi_tx_select_fields(
  tx : Transaction,
  fields : @core.Any,
) -> QueryBuilder =
  #| (tx, fields) => tx.select(fields)

///|
/// Start a SELECT query within transaction
pub fn Transaction::select(
  self : Transaction,
  fields? : @core.Any,
) -> QueryBuilder {
  match fields {
    Some(f) => ffi_tx_select_fields(self, f)
    None => ffi_tx_select(self)
  }
}

///|
/// Start an INSERT query within transaction
pub extern "js" fn Transaction::insert(
  self : Transaction,
  table : Table,
) -> QueryBuilder =
  #| (tx, table) => tx.insert(table)

///|
/// Start an UPDATE query within transaction
pub extern "js" fn Transaction::update(
  self : Transaction,
  table : Table,
) -> QueryBuilder =
  #| (tx, table) => tx.update(table)

///|
/// Start a DELETE query within transaction
pub extern "js" fn Transaction::delete(
  self : Transaction,
  table : Table,
) -> QueryBuilder =
  #| (tx, table) => tx.delete(table)

///|
/// Rollback the transaction
/// Note: This throws an exception to abort the transaction
pub extern "js" fn Transaction::rollback(self : Transaction) -> Unit =
  #| (tx) => { throw tx.rollback(); }
