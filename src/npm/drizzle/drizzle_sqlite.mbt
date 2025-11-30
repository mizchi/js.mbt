///| drizzle-orm SQLite bindings
/// https://orm.drizzle.team/docs/get-started/sqlite-new

///|
fn drizzle_libsql_module() -> @js.Any {
  @node.require("drizzle-orm/libsql")
}

///|
fn drizzle_better_sqlite3() -> @js.Any {
  @node.require("drizzle-orm/better-sqlite3")
}

///|
fn drizzle_sqlite_core() -> @js.Any {
  @node.require("drizzle-orm/sqlite-core")
}

// ============ SQLite Database Creation ============

///|
/// Create a Drizzle instance for SQLite with libsql (connection string)
pub fn drizzleLibsql(connection_url : String) -> DrizzleDB {
  let drizzle_fn = drizzle_libsql_module().get("drizzle")
  @nostd.any(drizzle_fn)._invoke([@nostd.any(connection_url)]).cast()
}

///|
/// Create a Drizzle instance for SQLite with libsql client
pub fn drizzleLibsqlClient(client : @js.Any) -> DrizzleDB {
  let drizzle_fn = drizzle_libsql_module().get("drizzle")
  let config = @js.Object::new()
  config.set("client", client)
  @nostd.any(drizzle_fn)._invoke([@nostd.any(config)]).cast()
}

///|
/// Create a Drizzle instance for SQLite with better-sqlite3
#alias(drizzle_better_sqlite)
pub fn drizzleBetterSqlite(filename : String) -> DrizzleDB {
  let drizzle_fn = drizzle_better_sqlite3().get("drizzle")
  @nostd.any(drizzle_fn)._invoke([@nostd.any(filename)]).cast()
}

///|
/// Create a Drizzle instance for SQLite with better-sqlite3 database instance
#alias(drizzle_better_sqlite_db)
pub fn drizzleBetterSqliteDb(db : @js.Any) -> DrizzleDB {
  let drizzle_fn = drizzle_better_sqlite3().get("drizzle")
  @nostd.any(drizzle_fn)._invoke([@nostd.any(db)]).cast()
}

// ============ SQLite Schema Definition ============

///|
/// Create a SQLite table
#alias(sqlite_table)
pub fn sqliteTable(name : String, columns : @js.Any) -> Table {
  let fn_ = drizzle_sqlite_core().get("sqliteTable")
  @nostd.any(fn_)._invoke([@nostd.any(name), @nostd.any(columns)]).cast()
}

///|
/// Create a SQLite table from a Map of column definitions
#alias(sqlite_table_from_map)
pub fn sqliteTableFromMap(
  name : String,
  columns : Map[String, Column],
) -> Table {
  let obj = @js.Object::new()
  columns.each(fn(key, col) { obj.set(key, col.as_any()) })
  sqliteTable(name, obj.as_any())
}

///|
/// Create a SQLite table with extra config (indexes, etc.)
#alias(sqlite_table_with_config)
pub fn sqliteTableWithConfig(
  name : String,
  columns : @js.Any,
  extra : (Table) -> @js.Any,
) -> Table {
  let fn_ = drizzle_sqlite_core().get("sqliteTable")
  let extra_fn : @js.Any = @js.from_fn1(fn(t : @js.Any) -> @js.Any {
    extra(@js.identity(t))
  })
  @nostd.any(fn_)
  ._invoke([@nostd.any(name), @nostd.any(columns), @nostd.any(extra_fn)])
  .cast()
}

// ============ SQLite Column Types ============

///|
/// SQLite integer column type (alias for int)
#alias(sqlite_int)
pub fn sqliteInt(name? : String) -> Column {
  let fn_ = drizzle_sqlite_core().get("int")
  match name {
    Some(n) => @nostd.any(fn_)._invoke([@nostd.any(n)]).cast()
    None => @nostd.any(fn_)._invoke([]).cast()
  }
}

///|
/// SQLite integer column type with mode
#alias(sqlite_integer)
pub fn sqliteInteger(name? : String, mode? : String) -> Column {
  let fn_ = drizzle_sqlite_core().get("integer")
  let opts = @js.Object::new()
  if mode is Some(m) {
    opts.set("mode", m)
  }
  match name {
    Some(n) => @nostd.any(fn_)._invoke([@nostd.any(n), @nostd.any(opts)]).cast()
    None => @nostd.any(fn_)._invoke([@nostd.any(opts)]).cast()
  }
}

///|
/// SQLite text column type
#alias(sqlite_text)
pub fn sqliteText(name? : String, mode? : String) -> Column {
  let fn_ = drizzle_sqlite_core().get("text")
  let opts = @js.Object::new()
  if mode is Some(m) {
    opts.set("mode", m)
  }
  match name {
    Some(n) =>
      if mode is Some(_) {
        @nostd.any(fn_)._invoke([@nostd.any(n), @nostd.any(opts)]).cast()
      } else {
        @nostd.any(fn_)._invoke([@nostd.any(n)]).cast()
      }
    None =>
      if mode is Some(_) {
        @nostd.any(fn_)._invoke([@nostd.any(opts)]).cast()
      } else {
        @nostd.any(fn_)._invoke([]).cast()
      }
  }
}

///|
/// SQLite real (floating point) column type
#alias(sqlite_real)
pub fn sqliteReal(name? : String) -> Column {
  let fn_ = drizzle_sqlite_core().get("real")
  match name {
    Some(n) => @nostd.any(fn_)._invoke([@nostd.any(n)]).cast()
    None => @nostd.any(fn_)._invoke([]).cast()
  }
}

///|
/// SQLite blob column type
#alias(sqlite_blob)
pub fn sqliteBlob(name? : String, mode? : String) -> Column {
  let fn_ = drizzle_sqlite_core().get("blob")
  let opts = @js.Object::new()
  if mode is Some(m) {
    opts.set("mode", m)
  }
  match name {
    Some(n) =>
      if mode is Some(_) {
        @nostd.any(fn_)._invoke([@nostd.any(n), @nostd.any(opts)]).cast()
      } else {
        @nostd.any(fn_)._invoke([@nostd.any(n)]).cast()
      }
    None =>
      if mode is Some(_) {
        @nostd.any(fn_)._invoke([@nostd.any(opts)]).cast()
      } else {
        @nostd.any(fn_)._invoke([]).cast()
      }
  }
}

///|
/// SQLite numeric column type
#alias(sqlite_numeric)
pub fn sqliteNumeric(name? : String) -> Column {
  let fn_ = drizzle_sqlite_core().get("numeric")
  match name {
    Some(n) => @nostd.any(fn_)._invoke([@nostd.any(n)]).cast()
    None => @nostd.any(fn_)._invoke([]).cast()
  }
}

// ============ SQLite Column Modifiers ============

///|
/// Set primary key with auto increment for SQLite
#alias(primary_key_auto_increment)
pub fn Column::primaryKeyAutoIncrement(self : Column) -> Column {
  let opts = @js.Object::new()
  opts.set("autoIncrement", true)
  self.call1("primaryKey", @nostd.any(opts.as_any())) |> @js.identity
}

// ============ SQLite Specific Index ============

///|
/// Create a SQLite index
#alias(sqlite_index)
pub fn sqliteIndex(name : String) -> IndexBuilder {
  let fn_ = drizzle_sqlite_core().get("index")
  @nostd.any(fn_)._invoke([@nostd.any(name)]).cast()
}

///|
/// Create a SQLite unique index
#alias(sqlite_unique_index)
pub fn sqliteUniqueIndex(name : String) -> IndexBuilder {
  let fn_ = drizzle_sqlite_core().get("uniqueIndex")
  @nostd.any(fn_)._invoke([@nostd.any(name)]).cast()
}

///|
/// Index builder for SQLite
#external
pub type IndexBuilder

///|
pub fn IndexBuilder::as_any(self : IndexBuilder) -> @js.Any = "%identity"

///|
/// Specify columns for index
pub fn IndexBuilder::on(
  self : IndexBuilder,
  columns : Array[Column],
) -> IndexBuilder {
  @nostd.any(self)._call("on", columns.map(fn(c) { @nostd.any(c) })).cast()
}

///|
/// Add WHERE condition to index
#alias(index_where)
pub fn IndexBuilder::filter(
  self : IndexBuilder,
  condition : SQL,
) -> IndexBuilder {
  @nostd.any(self)._call("where", [@nostd.any(condition)]).cast()
}
