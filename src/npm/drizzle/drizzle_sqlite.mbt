///| drizzle-orm SQLite bindings
/// https://orm.drizzle.team/docs/get-started/sqlite-new

///|
fn drizzle_libsql_module() -> @core.Any {
  @node.require("drizzle-orm/libsql")
}

///|
fn drizzle_better_sqlite3() -> @core.Any {
  @node.require("drizzle-orm/better-sqlite3")
}

///|
fn drizzle_sqlite_core() -> @core.Any {
  @node.require("drizzle-orm/sqlite-core")
}

// ============ SQLite Database Creation ============

///|
/// Create a Drizzle instance for SQLite with libsql (connection string)
pub fn drizzleLibsql(connection_url : String) -> DrizzleDB {
  let drizzle_fn = drizzle_libsql_module()._get("drizzle")
  @core.any(drizzle_fn)._invoke([@core.any(connection_url)]).cast()
}

///|
/// Create a Drizzle instance for SQLite with libsql client
pub fn drizzleLibsqlClient(client : @core.Any) -> DrizzleDB {
  let drizzle_fn = drizzle_libsql_module()._get("drizzle")
  let config = @core.new_object()
  config._set("client", client)
  @core.any(drizzle_fn)._invoke([@core.any(config)]).cast()
}

///|
/// Create a Drizzle instance for SQLite with better-sqlite3
#alias(drizzle_better_sqlite)
pub fn drizzleBetterSqlite(filename : String) -> DrizzleDB {
  let drizzle_fn = drizzle_better_sqlite3()._get("drizzle")
  @core.any(drizzle_fn)._invoke([@core.any(filename)]).cast()
}

///|
/// Create a Drizzle instance for SQLite with better-sqlite3 database instance
#alias(drizzle_better_sqlite_db)
pub fn drizzleBetterSqliteDb(db : @core.Any) -> DrizzleDB {
  let drizzle_fn = drizzle_better_sqlite3()._get("drizzle")
  @core.any(drizzle_fn)._invoke([@core.any(db)]).cast()
}

// ============ SQLite Schema Definition ============

///|
/// Create a SQLite table
#alias(sqlite_table)
pub fn sqliteTable(name : String, columns : @core.Any) -> Table {
  let fn_ = drizzle_sqlite_core()._get("sqliteTable")
  @core.any(fn_)._invoke([@core.any(name), @core.any(columns)]).cast()
}

///|
/// Create a SQLite table from a Map of column definitions
#alias(sqlite_table_from_map)
pub fn sqliteTableFromMap(
  name : String,
  columns : Map[String, Column],
) -> Table {
  let obj = @core.new_object()
  columns.each(fn(key, col) { obj._set(key, col.as_any()) })
  sqliteTable(name, obj)
}

///|
/// Create a SQLite table with extra config (indexes, etc.)
#alias(sqlite_table_with_config)
pub fn sqliteTableWithConfig(
  name : String,
  columns : @core.Any,
  extra : (Table) -> @core.Any,
) -> Table {
  let fn_ = drizzle_sqlite_core()._get("sqliteTable")
  let extra_fn : @core.Any = @js.from_fn1(fn(t : @core.Any) -> @core.Any {
    extra(@core.identity(t))
  })
  @core.any(fn_)
  ._invoke([@core.any(name), @core.any(columns), @core.any(extra_fn)])
  .cast()
}

// ============ SQLite Column Types ============

///|
/// SQLite integer column type (alias for int)
#alias(sqlite_int)
pub fn sqliteInt(name? : String) -> Column {
  let fn_ = drizzle_sqlite_core()._get("int")
  match name {
    Some(n) => @core.any(fn_)._invoke([@core.any(n)]).cast()
    None => @core.any(fn_)._invoke([]).cast()
  }
}

///|
/// SQLite integer column type with mode
#alias(sqlite_integer)
pub fn sqliteInteger(name? : String, mode? : String) -> Column {
  let fn_ = drizzle_sqlite_core()._get("integer")
  let opts = @core.new_object()
  if mode is Some(m) {
    opts._set("mode", m |> @core.any)
  }
  match name {
    Some(n) => @core.any(fn_)._invoke([@core.any(n), @core.any(opts)]).cast()
    None => @core.any(fn_)._invoke([@core.any(opts)]).cast()
  }
}

///|
/// SQLite text column type
#alias(sqlite_text)
pub fn sqliteText(name? : String, mode? : String) -> Column {
  let fn_ = drizzle_sqlite_core()._get("text")
  let opts = @core.new_object()
  if mode is Some(m) {
    opts._set("mode", m |> @core.any)
  }
  match name {
    Some(n) =>
      if mode is Some(_) {
        @core.any(fn_)._invoke([@core.any(n), @core.any(opts)]).cast()
      } else {
        @core.any(fn_)._invoke([@core.any(n)]).cast()
      }
    None =>
      if mode is Some(_) {
        @core.any(fn_)._invoke([@core.any(opts)]).cast()
      } else {
        @core.any(fn_)._invoke([]).cast()
      }
  }
}

///|
/// SQLite real (floating point) column type
#alias(sqlite_real)
pub fn sqliteReal(name? : String) -> Column {
  let fn_ = drizzle_sqlite_core()._get("real")
  match name {
    Some(n) => @core.any(fn_)._invoke([@core.any(n)]).cast()
    None => @core.any(fn_)._invoke([]).cast()
  }
}

///|
/// SQLite blob column type
#alias(sqlite_blob)
pub fn sqliteBlob(name? : String, mode? : String) -> Column {
  let fn_ = drizzle_sqlite_core()._get("blob")
  let opts = @core.new_object()
  if mode is Some(m) {
    opts._set("mode", m |> @core.any)
  }
  match name {
    Some(n) =>
      if mode is Some(_) {
        @core.any(fn_)._invoke([@core.any(n), @core.any(opts)]).cast()
      } else {
        @core.any(fn_)._invoke([@core.any(n)]).cast()
      }
    None =>
      if mode is Some(_) {
        @core.any(fn_)._invoke([@core.any(opts)]).cast()
      } else {
        @core.any(fn_)._invoke([]).cast()
      }
  }
}

///|
/// SQLite numeric column type
#alias(sqlite_numeric)
pub fn sqliteNumeric(name? : String) -> Column {
  let fn_ = drizzle_sqlite_core()._get("numeric")
  match name {
    Some(n) => @core.any(fn_)._invoke([@core.any(n)]).cast()
    None => @core.any(fn_)._invoke([]).cast()
  }
}

// ============ SQLite Column Modifiers ============

///|
/// Set primary key with auto increment for SQLite
#alias(primary_key_auto_increment)
pub fn Column::primaryKeyAutoIncrement(self : Column) -> Column {
  let opts = @core.new_object()
  opts._set("autoIncrement", true |> @core.any)
  self.call1("primaryKey", opts) |> @core.identity
}

// ============ SQLite Specific Index ============

///|
/// Create a SQLite index
#alias(sqlite_index)
pub fn sqliteIndex(name : String) -> IndexBuilder {
  let fn_ = drizzle_sqlite_core()._get("index")
  @core.any(fn_)._invoke([@core.any(name)]).cast()
}

///|
/// Create a SQLite unique index
#alias(sqlite_unique_index)
pub fn sqliteUniqueIndex(name : String) -> IndexBuilder {
  let fn_ = drizzle_sqlite_core()._get("uniqueIndex")
  @core.any(fn_)._invoke([@core.any(name)]).cast()
}

///|
/// Index builder for SQLite
#external
pub type IndexBuilder

///|
pub fn IndexBuilder::as_any(self : IndexBuilder) -> @core.Any = "%identity"

///|
/// Specify columns for index
pub fn IndexBuilder::on(
  self : IndexBuilder,
  columns : Array[Column],
) -> IndexBuilder {
  @core.any(self)._call("on", columns.map(fn(c) { @core.any(c) })).cast()
}

///|
/// Add WHERE condition to index
#alias(index_where)
pub fn IndexBuilder::filter(
  self : IndexBuilder,
  condition : SQL,
) -> IndexBuilder {
  @core.any(self)._call("where", [@core.any(condition)]).cast()
}
