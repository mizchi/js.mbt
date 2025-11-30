///| drizzle-orm Schema features (indexes, constraints, relations)
/// https://orm.drizzle.team/docs/indexes-constraints

// ============ PostgreSQL Index Builder ============

///|
/// Create a PostgreSQL index
#alias(pg_index)
pub fn pgIndex(name : String) -> PgIndexBuilder {
  let fn_ = drizzle_pg_core().get("index")
  fn_.call_self([name |> @js.any]) |> @js.identity
}

///|
/// Create a PostgreSQL unique index
#alias(pg_unique_index)
pub fn pgUniqueIndex(name : String) -> PgIndexBuilder {
  let fn_ = drizzle_pg_core().get("uniqueIndex")
  fn_.call_self([name |> @js.any]) |> @js.identity
}

///|
/// PostgreSQL index builder
#external
pub type PgIndexBuilder

///|
pub fn PgIndexBuilder::as_any(self : PgIndexBuilder) -> @js.Any = "%identity"

///|
/// Specify columns for index
pub fn PgIndexBuilder::on(
  self : PgIndexBuilder,
  columns : Array[Column],
) -> PgIndexBuilder {
  self.as_any().call("on", columns.map(fn(c) { c.as_any() })) |> @js.identity
}

///|
/// Add WHERE condition to index
pub fn PgIndexBuilder::filter(
  self : PgIndexBuilder,
  condition : SQL,
) -> PgIndexBuilder {
  self.as_any().call("where", [condition.as_any()]) |> @js.identity
}

///|
/// Build index concurrently (PostgreSQL)
pub fn PgIndexBuilder::concurrently(self : PgIndexBuilder) -> PgIndexBuilder {
  self.as_any().call("concurrently", []) |> @js.identity
}

///|
extern "js" fn ffi_pg_index_using(
  builder : PgIndexBuilder,
  index_type : String,
  columns : @js.Any,
) -> PgIndexBuilder =
  #| (builder, index_type, columns) => builder.using(index_type, ...columns)

///|
/// Specify index method (btree, hash, gist, gin, etc.)
#alias(using_method)
pub fn PgIndexBuilder::usingMethod(
  self : PgIndexBuilder,
  index_method : String,
  columns : Array[@js.Any],
) -> PgIndexBuilder {
  ffi_pg_index_using(self, index_method, @js.from_array(columns))
}

// ============ Composite Primary Key ============

///|
/// Create a composite primary key (PostgreSQL)
#alias(pg_primary_key)
pub fn pgPrimaryKey(columns : Array[Column], name? : String) -> @js.Any {
  let fn_ = drizzle_pg_core().get("primaryKey")
  let opts = @js.Object::new()
  opts.set("columns", @js.from_array(columns.map(fn(c) { c.as_any() })))
  if name is Some(n) {
    opts.set("name", n)
  }
  fn_.call_self([opts.as_any()])
}

///|
/// Create a composite primary key (SQLite)
#alias(sqlite_primary_key)
pub fn sqlitePrimaryKey(columns : Array[Column], name? : String) -> @js.Any {
  let fn_ = drizzle_sqlite_core().get("primaryKey")
  let opts = @js.Object::new()
  opts.set("columns", @js.from_array(columns.map(fn(c) { c.as_any() })))
  if name is Some(n) {
    opts.set("name", n)
  }
  fn_.call_self([opts.as_any()])
}

// ============ Composite Unique Constraint ============

///|
/// Create a composite unique constraint (PostgreSQL)
#alias(pg_unique)
pub fn pgUnique(name? : String) -> UniqueBuilder {
  let fn_ = drizzle_pg_core().get("unique")
  match name {
    Some(n) => fn_.call_self([n |> @js.any]) |> @js.identity
    None => fn_.call_self0() |> @js.identity
  }
}

///|
/// Create a composite unique constraint (SQLite)
#alias(sqlite_unique)
pub fn sqliteUnique(name? : String) -> UniqueBuilder {
  let fn_ = drizzle_sqlite_core().get("unique")
  match name {
    Some(n) => fn_.call_self([n |> @js.any]) |> @js.identity
    None => fn_.call_self0() |> @js.identity
  }
}

///|
/// Unique constraint builder
#external
pub type UniqueBuilder

///|
pub fn UniqueBuilder::as_any(self : UniqueBuilder) -> @js.Any = "%identity"

///|
/// Specify columns for unique constraint
pub fn UniqueBuilder::on(
  self : UniqueBuilder,
  columns : Array[Column],
) -> UniqueBuilder {
  self.as_any().call("on", columns.map(fn(c) { c.as_any() })) |> @js.identity
}

///|
/// NULLS NOT DISTINCT (PostgreSQL 15+)
#alias(nulls_not_distinct)
pub fn UniqueBuilder::nullsNotDistinct(self : UniqueBuilder) -> UniqueBuilder {
  self.as_any().call("nullsNotDistinct", []) |> @js.identity
}

// ============ Foreign Key ============

///|
/// Create a foreign key constraint (PostgreSQL)
#alias(pg_foreign_key)
pub fn pgForeignKey(
  columns : Array[Column],
  foreign_columns : Array[Column],
  name? : String,
) -> @js.Any {
  let fn_ = drizzle_pg_core().get("foreignKey")
  let opts = @js.Object::new()
  opts.set("columns", @js.from_array(columns.map(fn(c) { c.as_any() })))
  opts.set(
    "foreignColumns",
    @js.from_array(foreign_columns.map(fn(c) { c.as_any() })),
  )
  if name is Some(n) {
    opts.set("name", n)
  }
  fn_.call_self([opts.as_any()])
}

///|
/// Create a foreign key constraint (SQLite)
#alias(sqlite_foreign_key)
pub fn sqliteForeignKey(
  columns : Array[Column],
  foreign_columns : Array[Column],
  name? : String,
) -> @js.Any {
  let fn_ = drizzle_sqlite_core().get("foreignKey")
  let opts = @js.Object::new()
  opts.set("columns", @js.from_array(columns.map(fn(c) { c.as_any() })))
  opts.set(
    "foreignColumns",
    @js.from_array(foreign_columns.map(fn(c) { c.as_any() })),
  )
  if name is Some(n) {
    opts.set("name", n)
  }
  fn_.call_self([opts.as_any()])
}

// ============ Check Constraint ============

///|
/// Create a check constraint (PostgreSQL)
#alias(pg_check)
pub fn pgCheck(name : String, condition : SQL) -> @js.Any {
  let fn_ = drizzle_pg_core().get("check")
  fn_.call_self([name |> @js.any, condition.as_any()])
}

///|
/// Create a check constraint (SQLite)
#alias(sqlite_check)
pub fn sqliteCheck(name : String, condition : SQL) -> @js.Any {
  let fn_ = drizzle_sqlite_core().get("check")
  fn_.call_self([name |> @js.any, condition.as_any()])
}

// ============ Column Order Modifiers for Index ============

///|
/// Ascending order for column in index
pub fn Column::asc_(self : Column) -> @js.Any {
  self.call0("asc")
}

///|
/// Descending order for column in index
pub fn Column::desc_(self : Column) -> @js.Any {
  self.call0("desc")
}

///|
/// NULLS FIRST for column in index
#alias(nulls_first)
pub fn Column::nullsFirst(self : Column) -> @js.Any {
  self.call0("nullsFirst")
}

///|
/// NULLS LAST for column in index
#alias(nulls_last)
pub fn Column::nullsLast(self : Column) -> @js.Any {
  self.call0("nullsLast")
}

// ============ Foreign Key Actions ============

///|
/// ON DELETE action
pub(all) enum ForeignKeyAction {
  Cascade
  Restrict
  NoAction
  SetNull
  SetDefault
} derive(Eq, Show)

///|
pub fn ForeignKeyAction::to_string(self : ForeignKeyAction) -> String {
  match self {
    Cascade => "cascade"
    Restrict => "restrict"
    NoAction => "no action"
    SetNull => "set null"
    SetDefault => "set default"
  }
}

///|
/// Set ON DELETE action for column reference
#alias(on_delete)
pub fn Column::onDelete(self : Column, action : ForeignKeyAction) -> Column {
  self.call1("onDelete", @nostd.any(action.to_string())) |> @js.identity
}

///|
/// Set ON UPDATE action for column reference
#alias(on_update)
pub fn Column::onUpdate(self : Column, action : ForeignKeyAction) -> Column {
  self.call1("onUpdate", @nostd.any(action.to_string())) |> @js.identity
}
